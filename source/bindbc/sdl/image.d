/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module bindbc.sdl.image;

import bindbc.sdl.config;
// static if(bindSDLImage):

import bindbc.sdl.bind.sdlerror: SDL_GetError, SDL_SetError;
import bindbc.sdl.bind.sdlrender: SDL_Renderer, SDL_Texture;
import bindbc.sdl.bind.sdlrwops: SDL_RWops;
import bindbc.sdl.bind.sdlsurface: SDL_Surface;
import bindbc.sdl.bind.sdlversion: SDL_version, SDL_VERSIONNUM;

alias IMG_SetError = SDL_SetError;
alias IMG_GetError = SDL_GetError;

enum SDLImageSupport: SDL_version{
	noLibrary    = SDL_version(0,0,0),
	badLibrary   = SDL_version(0,0,255),
	sdlImage200  = SDL_version(2,0,0),
	sdlImage201  = SDL_version(2,0,1),
	sdlImage202  = SDL_version(2,0,2),
	sdlImage203  = SDL_version(2,0,3),
	sdlImage204  = SDL_version(2,0,4),
	sdlImage205  = SDL_version(2,0,5),
	sdlImage260  = SDL_version(2,6,0),
}

enum sdlImageSupport = (){
	version(SDL_Image_260)      return SDLImageSupport.sdlImage260;
	else version(SDL_Image_205) return SDLImageSupport.sdlImage205;
	else version(SDL_Image_204) return SDLImageSupport.sdlImage204;
	else version(SDL_Image_203) return SDLImageSupport.sdlImage203;
	else version(SDL_Image_202) return SDLImageSupport.sdlImage202;
	else version(SDL_Image_201) return SDLImageSupport.sdlImage201;
	else                        return SDLImageSupport.sdlImage200;
}();

enum SDL_IMAGE_MAJOR_VERSION = sdlImageSupport.major;
enum SDL_IMAGE_MINOR_VERSION = sdlImageSupport.minor;
enum SDL_IMAGE_PATCHLEVEL    = sdlImageSupport.patch;

void SDL_IMAGE_VERSION(SDL_version* X) @nogc nothrow pure{
	pragma(inline, true);
	X.major = SDL_IMAGE_MAJOR_VERSION;
	X.minor = SDL_IMAGE_MINOR_VERSION;
	X.patch = SDL_IMAGE_PATCHLEVEL;
}

deprecated("Please use SDL_IMAGE_VERSION_ATLEAST or SDL_IMAGE_VERSION instead.") enum SDL_IMAGE_COMPILEDVERSION = SDL_VERSIONNUM!(SDL_IMAGE_MAJOR_VERSION, SDL_IMAGE_MINOR_VERSION, SDL_IMAGE_PATCHLEVEL);
enum SDL_IMAGE_VERSION_ATLEAST(ubyte X, ubyte Y, ubyte Z) = SDL_IMAGE_COMPILEDVERSION >= SDL_VERSIONNUM!(X, Y, Z);

enum{
	IMG_INIT_JPG   = 0x0000_0001,
	IMG_INIT_PNG   = 0x0000_0002,
	IMG_INIT_TIF   = 0x0000_0004,
	IMG_INIT_WEBP  = 0x0000_0008,
}

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
	static if(sdlImageSupport >= SDLImageSupport.sdlImage202){
		ret ~= makeFnBinds([
			[q{int}, q{IMG_isSVG}, q{SDL_RWops* src}],
			[q{SDL_Surface*}, q{IMG_LoadSVG}, q{SDL_RWops* src}],
			[q{int}, q{IMG_SaveJPG}, q{SDL_Surface* surface, const(char)* file, int quality}],
			[q{int}, q{IMG_SaveJPG_RW}, q{SDL_Surface* surface, SDL_RWops* dst, int freedst, int quality}],
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
				`/usr/local/lib/libSDL2_image.dylib`,
				`../Frameworks/SDL2_image.framework/SDL2_image`,
				`/Library/Frameworks/SDL2_image.framework/SDL2_image`,
				`/System/Library/Frameworks/SDL2_image.framework/SDL2_image`,
				`/opt/local/lib/libSDL2_image.dylib`,
			];
		}else version(Posix){
			return [
				`libSDL2_image.so`,
				`libSDL2_image-2.0.so`,
				`libSDL2_image-2.0.so.0`,
				`/usr/lib/libSDL2_image.so`,
				`/usr/lib/libSDL2_image-2.0.so`,
				`/usr/lib/libSDL2_image-2.0.so.0`,
				`/usr/local/lib/libSDL2_image.so`,
				`/usr/local/lib/libSDL2_image-2.0.so`,
				`/usr/local/lib/libSDL2_image-2.0.so.0`,
			];
		}else static assert(0, "bindbc-sdl image does not have library search paths set up for this platform.");
	}();
}

@nogc nothrow:
void unloadSDLImage(){ if(lib != invalidHandle) lib.unload(); }

deprecated("Please use `IMG_Linked_Version` instead") SDLImageSupport loadedSDLImageVersion() { return loadedVersion; }

bool isSDLImageLoaded(){ return lib != invalidHandle; }

SDLImageSupport loadSDLImage(){
	const(char)[][libNamesCT.length] libNames = libNamesCT;

	SDLImageSupport ret;
	foreach(name; libNames){
		ret = loadSDLImage(name.ptr);
		if(ret != SDLImageSupport.noLibrary) return ret;
	}
	return ret;
}

SDLImageSupport loadSDLImage(const(char)* libName){
	lib = load(libName);
	if(lib == invalidHandle){
		return SDLImageSupport.noLibrary;
	}
	
	auto errCount = errorCount();
	loadedVersion = SDLImageSupport.badLibrary;
	
	bindModuleSymbols(lib);
	
	if(errCount == errorCount()) loadedVersion = sdlImageSupport;
	return loadedVersion;
}

