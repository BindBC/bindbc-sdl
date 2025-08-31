/+
+            Copyright 2022 – 2025 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module bindbc.sdl.config;

public import bindbc.common.types: c_long, c_ulong, c_longlong, c_ulonglong, va_list, wchar_t;
public import bindbc.common.versions: Version;

enum staticBinding = (){
	version(BindBC_Static)       return true;
	else version(BindSDL_Static) return true;
	else return false;
}();

enum cStyleEnums = (){
	version(SDL_C_Enums_Only)         return true;
	else version(BindBC_D_Enums_Only) return false;
	else version(SDL_D_Enums_Only)    return false;
	else return true;
}();

enum dStyleEnums = (){
	version(SDL_D_Enums_Only)         return true;
	else version(BindBC_C_Enums_Only) return false;
	else version(SDL_C_Enums_Only)    return false;
	else return true;
}();

enum sdlVersion = (){
	version(SDL_3_2_18)       return Version(3,2,18);
	else version(SDL_3_2_12)  return Version(3,2,12);
	else version(SDL_3_2_10)  return Version(3,2,10);
	else version(SDL_3_2_6)   return Version(3,2,6);
	else version(SDL_3_2_4)   return Version(3,2,4);
	else                      return Version(3,2,0);
}();

enum sdlImageVersion = (){
	/+version(SDL_Image_3_4)      return Version(3,4,0);
	else+/version(SDL_Image_3_2) return Version(3,2,0);
	else                        return Version.none;
}();

enum sdlMixerVersion = (){
	/+version(SDL_Mixer_3_2)      return Version(3,2,0);
	else+/version(SDL_Mixer_3_0) return Version(3,0,0);
	else                        return Version.none;
}();

enum sdlNetVersion = (){
	/+version(SDL_Net_3_2)      return Version(3,2,0);
	else+/version(SDL_Net_3_0) return Version(3,0,0);
	else                      return Version.none;
}();

enum sdlTTFVersion = (){
	version(SDL_TTF_3_2_2)      return Version(3,2,2);
	else version(SDL_TTF_3_2)   return Version(3,2,0);
	else                        return Version.none;
}();

enum sdlShaderCrossVersion = (){
	/+version(SDL_ShaderCross_3_2)      return Version(3,2,0);
	else+/version(SDL_ShaderCross_3_0) return Version(3,0,0);
	else                              return Version.none;
}();
