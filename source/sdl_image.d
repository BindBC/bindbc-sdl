/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl_image;

import bindbc.sdl.config;
static if(bindSDLImage):
import bindbc.sdl.codegen;

import sdl.error: SDL_GetError, SDL_SetError;
import sdl.render: SDL_Renderer, SDL_Texture;
import sdl.rwops: SDL_RWops;
import sdl.surface: SDL_Surface;
import sdl.version_: SDL_version;

enum SDLImageSupport: SDL_version{
	noLibrary   = SDL_version(0,0,0),
	badLibrary  = SDL_version(0,0,255),
	v2_0_0      = SDL_version(2,0,0),
	v2_0_1      = SDL_version(2,0,1),
	v2_0_2      = SDL_version(2,0,2),
	v2_0_3      = SDL_version(2,0,3),
	v2_0_4      = SDL_version(2,0,4),
	v2_0_5      = SDL_version(2,0,5),
	v2_6        = SDL_version(2,6,0),
	
	deprecated("Please use `v2_0_0` instead") sdlImage200 = SDL_version(2,0,0),
	deprecated("Please use `v2_0_1` instead") sdlImage201 = SDL_version(2,0,1),
	deprecated("Please use `v2_0_2` instead") sdlImage202 = SDL_version(2,0,2),
	deprecated("Please use `v2_0_3` instead") sdlImage203 = SDL_version(2,0,3),
	deprecated("Please use `v2_0_4` instead") sdlImage204 = SDL_version(2,0,4),
	deprecated("Please use `v2_0_5` instead") sdlImage205 = SDL_version(2,0,5),
}

enum sdlImageSupport = (){
	version(SDL_Image_2_6)      return SDLImageSupport.v2_6;
	else version(SDL_Image_205) return SDLImageSupport.v2_0_5;
	else version(SDL_Image_204) return SDLImageSupport.v2_0_4;
	else version(SDL_Image_203) return SDLImageSupport.v2_0_3;
	else version(SDL_Image_202) return SDLImageSupport.v2_0_2;
	else version(SDL_Image_201) return SDLImageSupport.v2_0_1;
	else                        return SDLImageSupport.v2_0_0;
}();

enum SDL_IMAGE_MAJOR_VERSION = sdlImageSupport.major;
enum SDL_IMAGE_MINOR_VERSION = sdlImageSupport.minor;
enum SDL_IMAGE_PATCHLEVEL    = sdlImageSupport.patch;

pragma(inline, true) void SDL_IMAGE_VERSION(SDL_version* X) @nogc nothrow pure @safe{
	X.major = SDL_IMAGE_MAJOR_VERSION;
	X.minor = SDL_IMAGE_MINOR_VERSION;
	X.patch = SDL_IMAGE_PATCHLEVEL;
}

deprecated("Please use SDL_IMAGE_VERSION_ATLEAST or SDL_IMAGE_VERSION instead")
	enum SDL_IMAGE_COMPILEDVERSION = SDL_version(SDL_IMAGE_MAJOR_VERSION, SDL_IMAGE_MINOR_VERSION, SDL_IMAGE_PATCHLEVEL);

pragma(inline, true) @nogc nothrow{
	bool SDL_IMAGE_VERSION_ATLEAST(ubyte X, ubyte Y, ubyte Z){ return SDL_version(SDL_IMAGE_MAJOR_VERSION, SDL_IMAGE_MINOR_VERSION, SDL_IMAGE_PATCHLEVEL) >= SDL_version(X, Y, Z); }
}
deprecated("Please use the non-template variant instead"){
	enum SDL_IMAGE_VERSION_ATLEAST(ubyte X, ubyte Y, ubyte Z) = SDL_version(SDL_IMAGE_MAJOR_VERSION, SDL_IMAGE_MINOR_VERSION, SDL_IMAGE_PATCHLEVEL) >= SDL_version(X, Y, Z);
}

alias IMG_InitFlags = int;
enum: IMG_InitFlags{
	IMG_INIT_JPG   = 0x0000_0001,
	IMG_INIT_PNG   = 0x0000_0002,
	IMG_INIT_TIF   = 0x0000_0004,
	IMG_INIT_WEBP  = 0x0000_0008,
}
static if(sdlImageSupport >= SDLImageSupport.v2_6)
enum: IMG_InitFlags{
	IMG_INIT_JXL   = 0x0000_0010,
	IMG_INIT_AVIF  = 0x0000_0020,
}

static if(sdlImageSupport >= SDLImageSupport.v2_6){
	struct IMG_Animation{
		int w, h;
		int count;
		SDL_Surface** frames;
		int* delays;
	}
}

alias IMG_SetError = SDL_SetError;

alias IMG_GetError = SDL_GetError;

mixin(joinFnBinds((){
	string[][] ret;
	ret ~= makeFnBinds([
		[q{int}, q{IMG_Init}, q{int flags}],
		[q{int}, q{IMG_Quit}, q{}],
		[q{const(SDL_version)*}, q{IMG_Linked_Version}, q{}],
		[q{SDL_Surface*}, q{IMG_LoadTyped_RW}, q{SDL_RWops* src, int freesrc, const(char)* type}],
		[q{SDL_Surface*}, q{IMG_Load}, q{const(char)* file}],
		[q{SDL_Surface*}, q{IMG_Load_RW}, q{SDL_RWops* src, int freesrc}],
		
		[q{SDL_Texture*}, q{IMG_LoadTexture}, q{SDL_Renderer* renderer, const(char)* file}],
		[q{SDL_Texture*}, q{IMG_LoadTexture_RW}, q{SDL_Renderer* renderer, SDL_RWops* src, int freesrc}],
		[q{SDL_Texture*}, q{IMG_LoadTextureTyped_RW}, q{SDL_Renderer* renderer, SDL_RWops* src, int freesrc, const(char)* type}],
		
		[q{int}, q{IMG_isICO}, q{SDL_RWops* src}],
		[q{int}, q{IMG_isCUR}, q{SDL_RWops* src}],
		[q{int}, q{IMG_isBMP}, q{SDL_RWops* src}],
		[q{int}, q{IMG_isGIF}, q{SDL_RWops* src}],
		[q{int}, q{IMG_isJPG}, q{SDL_RWops* src}],
		[q{int}, q{IMG_isLBM}, q{SDL_RWops* src}],
		[q{int}, q{IMG_isPCX}, q{SDL_RWops* src}],
		[q{int}, q{IMG_isPNG}, q{SDL_RWops* src}],
		[q{int}, q{IMG_isPNM}, q{SDL_RWops* src}],
		[q{int}, q{IMG_isTIF}, q{SDL_RWops* src}],
		[q{int}, q{IMG_isXCF}, q{SDL_RWops* src}],
		[q{int}, q{IMG_isXPM}, q{SDL_RWops* src}],
		[q{int}, q{IMG_isXV}, q{SDL_RWops* src}],
		[q{int}, q{IMG_isWEBP}, q{SDL_RWops* src}],
		
		[q{SDL_Surface*}, q{IMG_LoadICO_RW}, q{SDL_RWops* src}],
		[q{SDL_Surface*}, q{IMG_LoadCUR_RW}, q{SDL_RWops* src}],
		[q{SDL_Surface*}, q{IMG_LoadBMP_RW}, q{SDL_RWops* src}],
		[q{SDL_Surface*}, q{IMG_LoadGIF_RW}, q{SDL_RWops* src}],
		[q{SDL_Surface*}, q{IMG_LoadJPG_RW}, q{SDL_RWops* src}],
		[q{SDL_Surface*}, q{IMG_LoadLBM_RW}, q{SDL_RWops* src}],
		[q{SDL_Surface*}, q{IMG_LoadPCX_RW}, q{SDL_RWops* src}],
		[q{SDL_Surface*}, q{IMG_LoadPNG_RW}, q{SDL_RWops* src}],
		[q{SDL_Surface*}, q{IMG_LoadPNM_RW}, q{SDL_RWops* src}],
		[q{SDL_Surface*}, q{IMG_LoadTGA_RW}, q{SDL_RWops* src}],
		[q{SDL_Surface*}, q{IMG_LoadTIF_RW}, q{SDL_RWops* src}],
		[q{SDL_Surface*}, q{IMG_LoadXCF_RW}, q{SDL_RWops* src}],
		[q{SDL_Surface*}, q{IMG_LoadXPM_RW}, q{SDL_RWops* src}],
		[q{SDL_Surface*}, q{IMG_LoadXV_RW}, q{SDL_RWops* src}],
		[q{SDL_Surface*}, q{IMG_LoadWEBP_RW}, q{SDL_RWops* src}],
		
		[q{SDL_Surface*}, q{IMG_ReadXPMFromArray}, q{char** xpm}],
		
		[q{int}, q{IMG_SavePNG}, q{SDL_Surface* surface, const(char)* file}],
		[q{int}, q{IMG_SavePNG_RW}, q{SDL_Surface* surface, SDL_RWops* dst, int freedst}],
	]);
	static if(sdlImageSupport >= SDLImageSupport.v2_0_2){
		ret ~= makeFnBinds([
			[q{int}, q{IMG_isSVG}, q{SDL_RWops* src}],
			[q{SDL_Surface*}, q{IMG_LoadSVG_RW}, q{SDL_RWops* src}],
			[q{int}, q{IMG_SaveJPG}, q{SDL_Surface* surface, const(char)* file, int quality}],
			[q{int}, q{IMG_SaveJPG_RW}, q{SDL_Surface* surface, SDL_RWops* dst, int freedst, int quality}],
		]);
	}
	static if(sdlImageSupport >= SDLImageSupport.v2_6){
		ret ~= makeFnBinds([
			[q{int}, q{IMG_isAVIF}, q{SDL_RWops* src}],
			[q{int}, q{IMG_isJXL}, q{SDL_RWops* src}],
			[q{int}, q{IMG_isQOI}, q{SDL_RWops* src}],
			
			[q{SDL_Surface*}, q{IMG_LoadAVIF_RW}, q{SDL_RWops* src}],
			[q{SDL_Surface*}, q{IMG_LoadJXL_RW}, q{SDL_RWops* src}],
			[q{SDL_Surface*}, q{IMG_LoadQOI_RW}, q{SDL_RWops* src}],
			
			[q{SDL_Surface*}, q{IMG_LoadSizedSVG_RW}, q{SDL_RWops* src, int width, int height}],
			[q{SDL_Surface*}, q{IMG_ReadXPMFromArrayToRGB888}, q{char** xpm}],
			[q{IMG_Animation*}, q{IMG_LoadAnimation}, q{const(char)* file}],
			[q{IMG_Animation*}, q{IMG_LoadAnimation_RW}, q{SDL_RWops* src, int freesrc}],
			[q{IMG_Animation*}, q{IMG_LoadAnimationTyped_RW}, q{SDL_RWops* src, int freesrc, const(char)* type}],
			[q{void}, q{IMG_FreeAnimation}, q{IMG_Animation* anim}],
			[q{IMG_Animation*}, q{IMG_LoadGIFAnimation_RW}, q{SDL_RWops* src}],
		]);
	}
	return ret;
}()));

static if(!staticBinding):
import bindbc.loader;

private{
	SharedLib lib;
	SDLImageSupport loadedVersion;
	enum libNamesCT = (){
		version(Windows){
			return [
				`SDL2_image.dll`,
			];
		}else version(OSX){
			return [
				`libSDL2_image.dylib`,
				`/opt/homebrew/lib/libSDL2_image.dylib`,
				`SDL2_image`,
				`/Library/Frameworks/SDL2_image.framework/SDL2_image`,
				`/System/Library/Frameworks/SDL2_image.framework/SDL2_image`,
			];
		}else version(Posix){
			return [
				`libSDL2_image.so`,
				`libSDL2_image-2.0.so`,
				`libSDL2_image-2.0.so.0`,
			];
		}else static assert(0, "BindBC-SDL_image does not have library search paths set up for this platform");
	}();
}

@nogc nothrow:
deprecated("Please use `IMG_Linked_Version` instead")
	SDLImageSupport loadedSDLImageVersion(){ return loadedVersion; }

mixin(bindbc.sdl.codegen.makeDynloadFns("Image", [__MODULE__]));
