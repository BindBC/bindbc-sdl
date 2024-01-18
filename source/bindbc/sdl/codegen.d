/+
+            Copyright 2022 – 2024 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module bindbc.sdl.codegen;

import bindbc.sdl.config: staticBinding;
import bindbc.common.versions;
import bindbc.common.codegen;

mixin(makeFnBindFns(staticBinding, Version(0,1,1)));

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
