/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module bindbc.sdl.config;

import sdl.version_: SDL_version, SDL_MAJOR_VERSION, SDL_MINOR_VERSION, SDL_PATCHLEVEL;

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
	v2_28       = SDL_version(2,28,0),
	
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
	version(SDL_2_28)      return SDLSupport.v2_28;
	else version(SDL_2_26) return SDLSupport.v2_26;
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
	else version(SDL_Image_2_6) return true;
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
	else version(SDL_TTF_2_20) return true;
	else return false;
}();

//NOTE: everything below here will be moved to BindBC-Common in the future

version(WebAssembly){
	alias c_long  = long;
	alias c_ulong = ulong;
	
	alias va_list = void*;
}else{
	public import core.stdc.config: c_long, c_ulong;
	public import core.stdc.stdarg: va_list;
}

static if((){
	version(Posix)     return true;
	else version(WASI) return true;
	else return false;
}()){
	alias wchar_t = dchar;
}else static if((){
	version(Windows)    return true;
	else version(WinRT) return true;
	else return false;
}()){
	alias wchar_t = wchar;
}else static assert(0, "`sizeof(wchar_t)` is not known on this platform. Please add it to bindbc/sdl/config.d");

deprecated("This template will be moved to another library in the future") enum expandEnum(EnumType, string fqnEnumType = EnumType.stringof) = () nothrow pure @safe{
	string expandEnum;
	foreach(m;__traits(allMembers, EnumType)){
		expandEnum ~= `alias `~m~` = `~fqnEnumType~`.`~m~`;`;
	}
	return expandEnum;
}();
