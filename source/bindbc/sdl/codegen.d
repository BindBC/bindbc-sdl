/+
+            Copyright 2022 – 2023 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module bindbc.sdl.codegen;

import bindbc.sdl.config: staticBinding;

/*regex: function decl => makeFnBinds decl
^[ \t]*([A-Za-z0-9_()*\[\]]+) (\w+) ?\(([A-Za-z0-9_()*, .=\[\]]*)\);
\t\t[q{$1}, q{$2}, q{$3}],
*/
enum makeFnBinds = (string[3][] fns) nothrow pure @safe{
	string makeFnBinds = ``;
	string[] symbols;
	static if(staticBinding){
		foreach(fn; fns){
			makeFnBinds ~= "\n\t"~fn[0]~` `~fn[1]~`(`~fn[2]~`);`;
		}
	}else{
		foreach(fn; fns){
			if(fn[2].length > 3 && fn[2][$-3..$] == "..."){
				//version(WebAssembly){
					makeFnBinds ~= "\n\t private "~fn[0]~` function(`~fn[2]~`) _`~fn[1]~`;`;
					makeFnBinds ~= "\n\t alias "~fn[1]~` = _`~fn[1]~`;`;
				/+}else{
					size_t lastCommaPos = size_t.max; //a guaranteed fail if it's never found
					string params = "";
					bool capture = false;
					bool firstArg = true;
					foreach_reverse(i, c; fn[2]){
						if(capture){
							if(c == ' '){
								capture = false;
							}else{
								params = c ~ params;
							}
						}else if(c == ','){
							capture = true;
							if(!firstArg){
								params = ", " ~ params;
							}else{
								lastCommaPos = i;
								firstArg = false;
							}
						}
					}
					string namedParams = fn[2][0..lastCommaPos];
					makeFnBinds ~= "\n\tprivate "~fn[0]~` function(`~namedParams~`, void* argPtr) _`~fn[1]~`;`;
					if(fn[0] == "void"){
						makeFnBinds ~= "\n\textern(D) "~fn[0]~` `~fn[1]~`(`~fn[2]~`){ _`~fn[1]~`(`~params~`, _argptr); }`;
					}else{
						makeFnBinds ~= "\n\textern(D) "~fn[0]~` `~fn[1]~`(`~fn[2]~`){ return _`~fn[1]~`(`~params~`, _argptr); }`;
					}
				}+/
			}else{
				makeFnBinds ~= "\n\tprivate "~fn[0]~` function(`~fn[2]~`) _`~fn[1]~`;`;
				if(fn[0] == "void"){
					makeFnBinds ~= "\n\t"~fn[0]~` `~fn[1]~`(`~fn[2]~`){ _`~fn[1]~`(__traits(parameters)); }`;
				}else{
					makeFnBinds ~= "\n\t"~fn[0]~` `~fn[1]~`(`~fn[2]~`){ return _`~fn[1]~`(__traits(parameters)); }`;
				}
			}
			symbols ~= fn[1];
		}
	}
	return [makeFnBinds] ~ symbols;
};

enum joinFnBinds = (string[][] list) nothrow pure @safe{
	string joined = `extern(C) @nogc nothrow`;
	string[] symbols;
	
	static if(staticBinding){
		joined ~= `{`;
		foreach(item; list){
			joined ~= item[0];
		}
	}else{
		joined ~= ` __gshared{`;
		foreach(item; list){
			joined ~= item[0];
			symbols ~= item[1..$];
		}
	}
	joined ~= "\n}";
	
	static if(!staticBinding){
		joined ~= "\n\nimport bindbc.loader: SharedLib, bindSymbol;\nvoid bindModuleSymbols(SharedLib lib) @nogc nothrow{";
		foreach(symbol; symbols){
			joined ~= "\n\tlib.bindSymbol(cast(void**)&_"~symbol~`, "`~symbol~`");`;
			//joined ~= "\n\tassert("~symbol~` != null);`;
		}
		joined ~= "\n}";
	}
	
	return joined;
};

enum makeDynloadFns = (string name, string[] bindModules) nothrow pure @safe{
	string dynloadFns = `
void unloadSDL`~name~`(){ if(lib != invalidHandle) lib.unload(); }

bool isSDL`~name~`Loaded(){ return lib != invalidHandle; }

SDL`~name~`Support loadSDL`~name~`(){
	const(char)[][libNamesCT.length] libNames = libNamesCT;
	
	SDL`~name~`Support ret;
	foreach(name; libNames){
		ret = loadSDL`~name~`(name.ptr);
		//TODO: keep trying until we get the version we want, otherwise default to the highest one?
		if(ret != SDL`~name~`Support.noLibrary && ret != SDL`~name~`Support.badLibrary) break;
	}
	return ret;
}

SDL`~name~`Support loadSDL`~name~`(const(char)* libName){
	lib = bindbc.loader.load(libName);
	if(lib == invalidHandle){
		return SDL`~name~`Support.noLibrary;
	}
	
	auto errCount = errorCount();
	loadedVersion = SDL`~name~`Support.badLibrary;
`;
	
	foreach(mod; bindModules){
		dynloadFns ~= "\n\t"~mod~".bindModuleSymbols(lib);";
	}
	
	dynloadFns ~= `
	
	if(errCount == errorCount()) loadedVersion = sdl`~name~`Support; //this is a white-lie in order to maintain backwards-compatibility :(
	return loadedVersion;
}`;
	
	return dynloadFns;
};
