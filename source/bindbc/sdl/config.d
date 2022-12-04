/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module bindbc.sdl.config;

import bindbc.sdl.bind.sdlversion: SDL_version, SDL_MAJOR_VERSION, SDL_MINOR_VERSION, SDL_PATCHLEVEL;

enum SDLSupport: SDL_version{
	noLibrary = SDL_version(0,0,0),
	badLibrary = SDL_version(0,0,255),
	sdl200   = SDL_version(2,0,0),
	sdl201   = SDL_version(2,0,1),
	sdl202   = SDL_version(2,0,2),
	sdl203   = SDL_version(2,0,3),
	sdl204   = SDL_version(2,0,4),
	sdl205   = SDL_version(2,0,5),
	sdl206   = SDL_version(2,0,6),
	sdl207   = SDL_version(2,0,7),
	sdl208   = SDL_version(2,0,8),
	sdl209   = SDL_version(2,0,9),
	sdl2010  = SDL_version(2,0,10),
	sdl2012  = SDL_version(2,0,12),
	sdl2014  = SDL_version(2,0,14),
	sdl2016  = SDL_version(2,0,16),
	sdl2018  = SDL_version(2,0,18),
	sdl2020  = SDL_version(2,0,20),
	sdl2022  = SDL_version(2,0,22),
	sdl2240  = SDL_version(2,24,0),
	sdl2260  = SDL_version(2,26,0),
}

version(BindBC_Static) version = BindSDL_Static;
version(BindSDL_Static) enum staticBinding = true;
else enum staticBinding = false;

enum sdlSupport = (){
	version(SDL_2260)      return SDLSupport.sdl2260;
	else version(SDL_2240) return SDLSupport.sdl2240;
	else version(SDL_2022) return SDLSupport.sdl2022;
	else version(SDL_2020) return SDLSupport.sdl2020;
	else version(SDL_2018) return SDLSupport.sdl2018;
	else version(SDL_2016) return SDLSupport.sdl2016;
	else version(SDL_2014) return SDLSupport.sdl2014;
	else version(SDL_2012) return SDLSupport.sdl2012;
	else version(SDL_2010) return SDLSupport.sdl2010;
	else version(SDL_209)  return SDLSupport.sdl209;
	else version(SDL_208)  return SDLSupport.sdl208;
	else version(SDL_207)  return SDLSupport.sdl207;
	else version(SDL_206)  return SDLSupport.sdl206;
	else version(SDL_205)  return SDLSupport.sdl205;
	else version(SDL_204)  return SDLSupport.sdl204;
	else version(SDL_203)  return SDLSupport.sdl203;
	else version(SDL_202)  return SDLSupport.sdl202;
	else version(SDL_201)  return SDLSupport.sdl201;
	else                   return SDLSupport.sdl200;
}();

enum bindSDLImage = (){
	version(SDL_Image)          return true;
	else version(SDL_Image_200) return true;
	else version(SDL_Image_201) return true;
	else version(SDL_Image_202) return true;
	else version(SDL_Image_203) return true;
	else version(SDL_Image_204) return true;
	else version(SDL_Image_205) return true;
	return false;
}();

enum bindSDLMixer = (){
	version(SDL_Mixer)          return true;
	else version(SDL_Mixer_200) return true;
	else version(SDL_Mixer_201) return true;
	else version(SDL_Mixer_202) return true;
	else version(SDL_Mixer_204) return true;
	else version(SDL_Mixer_260) return true;
	return false;
}();

enum bindSDLNet = (){
	version(SDL_Net)          return true;
	else version(SDL_Net_200) return true;
	else version(SDL_Net_201) return true;
	return false;
}();

enum bindSDLTTF = (){
	version(SDL_TTF)           return true;
	else version(SDL_TTF_2012) return true;
	else version(SDL_TTF_2013) return true;
	else version(SDL_TTF_2014) return true;
	else version(SDL_TTF_2015) return true;
	else version(SDL_TTF_2018) return true;
	return false;
}();

enum expandEnum(EnumType, string fqnEnumType = EnumType.stringof) = (){
	string expandEnum;
	foreach(m;__traits(allMembers, EnumType)){
		expandEnum ~= `alias `~m~` = `~fqnEnumType~`.`~m~`;`;
	}
	return expandEnum;
}();

enum makeFnBinds(fns...) = (){
	string makeFnBinds = `extern(C) @nogc nothrow{`;
	string[] symbols = [];
	static if(staticBinding){
		foreach(fn; fns){
			makeFnBinds ~= "\n\t"~fn[0]~` `~fn[1]~`(`~fn[2]~`);`;
		}
	}else{
		foreach(fn; fns){
			makeFnBinds ~= "\n\talias p"~fn[1]~` = `~fn[0]~` function(`~fn[2]~`);`;
		}
		makeFnBinds ~= "\n}\n\n__gshared {";
		foreach(fn; fns){
			makeFnBinds ~= "\n\tp"~fn[1]~` `~fn[1]~`;`;
			symbols ~= fn[1];
		}
	}
	makeFnBinds ~= "\n}";
	return [makeFnBinds] ~ symbols;
}();

enum joinFnBinds(alias list) = (){
	string joined;
	string[] symbols;
	
	foreach(item; list){
		joined ~= item[0];
		static if(!staticBinding){
			symbols ~= item[1..$];
		}
	}
	
	static if(!staticBinding){
		joined ~= "\n\nimport bindbc.loader: SharedLib, bindSymbol;\nvoid bindModuleSymbols(SharedLib lib) @nogc nothrow{";
		foreach(symbol; symbols){
			joined ~= "\n\tlib.bindSymbol(cast(void**)&"~symbol~`, "`~symbol~`");`;
		}
		joined ~= "\n}";
	}
	return joined;
}();
