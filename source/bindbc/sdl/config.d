/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module bindbc.sdl.config;

import bindbc.sdl.bind.version_: SDL_version, SDL_MAJOR_VERSION, SDL_MINOR_VERSION, SDL_PATCHLEVEL;

enum SDLSupport: SDL_version{
	noLibrary   = SDL_version(0,0,0),
	badLibrary  = SDL_version(0,0,255),
	v2_0_0      = SDL_version(2,0,0),
	v2_0_1      = SDL_version(2,0,1),
	v2_0_2      = SDL_version(2,0,2),
	v2_0_3      = SDL_version(2,0,3),
	v2_0_4      = SDL_version(2,0,4),
	v2_0_5      = SDL_version(2,0,5),
	v2_0_6      = SDL_version(2,0,6),
	v2_0_7      = SDL_version(2,0,7),
	v2_0_8      = SDL_version(2,0,8),
	v2_0_9      = SDL_version(2,0,9),
	v2_0_10     = SDL_version(2,0,10),
	v2_0_12     = SDL_version(2,0,12),
	v2_0_14     = SDL_version(2,0,14),
	v2_0_16     = SDL_version(2,0,16),
	v2_0_18     = SDL_version(2,0,18),
	v2_0_20     = SDL_version(2,0,20),
	v2_0_22     = SDL_version(2,0,22),
	v2_24       = SDL_version(2,24,0),
	v2_26       = SDL_version(2,26,0),
	
	deprecated("Please use `v2_0_0` instead")  sdl200  = SDL_version(2,0,0),
	deprecated("Please use `v2_0_1` instead")  sdl201  = SDL_version(2,0,1),
	deprecated("Please use `v2_0_2` instead")  sdl202  = SDL_version(2,0,2),
	deprecated("Please use `v2_0_3` instead")  sdl203  = SDL_version(2,0,3),
	deprecated("Please use `v2_0_4` instead")  sdl204  = SDL_version(2,0,4),
	deprecated("Please use `v2_0_5` instead")  sdl205  = SDL_version(2,0,5),
	deprecated("Please use `v2_0_6` instead")  sdl206  = SDL_version(2,0,6),
	deprecated("Please use `v2_0_7` instead")  sdl207  = SDL_version(2,0,7),
	deprecated("Please use `v2_0_8` instead")  sdl208  = SDL_version(2,0,8),
	deprecated("Please use `v2_0_9` instead")  sdl209  = SDL_version(2,0,9),
	deprecated("Please use `v2_0_10` instead") sdl2010 = SDL_version(2,0,10),
	deprecated("Please use `v2_0_12` instead") sdl2012 = SDL_version(2,0,12),
	deprecated("Please use `v2_0_14` instead") sdl2014 = SDL_version(2,0,14),
	deprecated("Please use `v2_0_16` instead") sdl2016 = SDL_version(2,0,16),
	deprecated("Please use `v2_0_18` instead") sdl2018 = SDL_version(2,0,18),
	deprecated("Please use `v2_0_20` instead") sdl2020 = SDL_version(2,0,20),
	deprecated("Please use `v2_0_22` instead") sdl2022 = SDL_version(2,0,22),
}

enum staticBinding = (){
	version(BindBC_Static)       return true;
	else version(BindSDL_Static) return true;
	else return false;
}();

enum sdlSupport = (){
	version(SDL_2_26)      return SDLSupport.v2_26;
	else version(SDL_2_24) return SDLSupport.v2_24;
	else version(SDL_2022) return SDLSupport.v2_0_22;
	else version(SDL_2020) return SDLSupport.v2_0_20;
	else version(SDL_2018) return SDLSupport.v2_0_18;
	else version(SDL_2016) return SDLSupport.v2_0_16;
	else version(SDL_2014) return SDLSupport.v2_0_14;
	else version(SDL_2012) return SDLSupport.v2_0_12;
	else version(SDL_2010) return SDLSupport.v2_0_10;
	else version(SDL_209)  return SDLSupport.v2_0_9;
	else version(SDL_208)  return SDLSupport.v2_0_8;
	else version(SDL_207)  return SDLSupport.v2_0_7;
	else version(SDL_206)  return SDLSupport.v2_0_6;
	else version(SDL_205)  return SDLSupport.v2_0_5;
	else version(SDL_204)  return SDLSupport.v2_0_4;
	else version(SDL_203)  return SDLSupport.v2_0_3;
	else version(SDL_202)  return SDLSupport.v2_0_2;
	else version(SDL_201)  return SDLSupport.v2_0_1;
	else                   return SDLSupport.v2_0_0;
}();

enum bindSDLImage = (){
	version(SDL_Image){ pragma(msg, "`SDL_Image` is deprecated. If you want the earliest supported version of SDL Image then please use version `SDL_Image_200`, otherwise you can safely remove it from your version list"); return true; }
	else version(SDL_Image_200) return true;
	else version(SDL_Image_201) return true;
	else version(SDL_Image_202) return true;
	else version(SDL_Image_203) return true;
	else version(SDL_Image_204) return true;
	else version(SDL_Image_205) return true;
	else version(SDL_Image_2_6) return true;//static assert(0, "SDL Image not updated for this version yet");
	else return false;
}();

enum bindSDLMixer = (){
	version(SDL_Mixer){ pragma(msg, "`SDL_Mixer` is deprecated. If you want the earliest supported version of SDL Mixer then please use version `SDL_Mixer_200`, otherwise you can safely remove it from your version list"); return true; }
	else version(SDL_Mixer_200) return true;
	else version(SDL_Mixer_201) return true;
	else version(SDL_Mixer_202) return true;
	else version(SDL_Mixer_204) return true;
	else version(SDL_Mixer_260){ pragma(msg, "`SDL_Mixer_260` is deprecated. Please use version `SDL_Mixer_2_6` instead"); return true; }
	else version(SDL_Mixer_2_6) return true;
	else return false;
}();

enum bindSDLNet = (){
	version(SDL_Net){ pragma(msg, "`SDL_Net` is deprecated. If you want the earliest supported version of SDL Net then please use version `SDL_Net_200`, otherwise you can safely remove it from your version list"); return true; }
	else version(SDL_Net_200) return true;
	else version(SDL_Net_201) return true;
	else version(SDL_Net_2_2) return true;
	else return false;
}();

enum bindSDLTTF = (){
	version(SDL_TTF){ pragma(msg, "`SDL_TTF` is deprecated. If you want the earliest supported version of SDL TTF then please use version `SDL_TTF_2012`, otherwise you can safely remove it from your version list"); return true; }
	else version(SDL_TTF_2012) return true;
	else version(SDL_TTF_2013) return true;
	else version(SDL_TTF_2014) return true;
	else version(SDL_TTF_2015) return true;
	else version(SDL_TTF_2018) return true;
	else version(SDL_TTF_2_20) static assert(0, "SDL Image not updated for this version yet");
	else return false;
}();

version(WebAssembly){
	alias c_long  = long;
	alias c_ulong = ulong;
}else{
	public import core.stdc.config: c_long, c_ulong;
}

deprecated("Please update this type to use type aliases!") enum expandEnum(EnumType, string fqnEnumType = EnumType.stringof) = () nothrow pure{
	string expandEnum;
	foreach(m;__traits(allMembers, EnumType)){
		expandEnum ~= `alias `~m~` = `~fqnEnumType~`.`~m~`;`;
	}
	return expandEnum;
}();

/*regex: function decl => makeFnBinds decl
^[ \t]*([A-Za-z0-9_()*]+) (\w+) ?\(([A-Za-z0-9_()*, .=]*)\);
\t\t[q{$1}, q{$2}, q{$3}],
*/
package enum makeFnBinds = (string[3][] fns) nothrow pure{
	string makeFnBinds = ``;
	string[] symbols;
	static if(staticBinding){
		foreach(fn; fns){
			makeFnBinds ~= "\n\t"~fn[0]~` `~fn[1]~`(`~fn[2]~`);`;
		}
	}else{
		foreach(fn; fns){
			makeFnBinds ~= "\n\tprivate "~fn[0]~` function(`~fn[2]~`) _`~fn[1]~`;`;
			if(fn[0] == "void"){
				makeFnBinds ~= "\n\t"~fn[0]~` `~fn[1]~`(`~fn[2]~`){ _`~fn[1]~`(__traits(parameters)); }`;
			}else{
				makeFnBinds ~= "\n\t"~fn[0]~` `~fn[1]~`(`~fn[2]~`){ return _`~fn[1]~`(__traits(parameters)); }`;
			}
			symbols ~= fn[1];
		}
	}
	return [makeFnBinds] ~ symbols;
};

package enum joinFnBinds = (string[][] list) nothrow pure{
	string joined = `extern(C) @nogc nothrow`;
	string[] symbols;
	
	static if(staticBinding){
		joined ~= `{`;
		foreach(item; list){
			joined ~= item[0];
		}
	}else{
		joined ~= " __gshared{";
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

package enum makeDynloadFns = (string name, string[] bindModules) nothrow pure{
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
	
	if(errCount == errorCount()) loadedVersion = sdl`~name~`Support; //this is a white lie in order to maintain backwards-compatibility :(
	return loadedVersion;
}`;
	
	return dynloadFns;
};
