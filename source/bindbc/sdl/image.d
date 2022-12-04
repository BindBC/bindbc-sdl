/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module bindbc.sdl.image;

import bindbc.sdl.config;
static if(bindSDLImage):

import bindbc.sdl.bind.sdlerror : SDL_GetError, SDL_SetError;
import bindbc.sdl.bind.sdlrender : SDL_Renderer, SDL_Texture;
import bindbc.sdl.bind.sdlrwops : SDL_RWops;
import bindbc.sdl.bind.sdlsurface : SDL_Surface;
import bindbc.sdl.bind.sdlversion : SDL_version, SDL_VERSIONNUM;

alias IMG_SetError = SDL_SetError;
alias IMG_GetError = SDL_GetError;

enum SDLImageSupport {
	noLibrary,
	badLibrary,
	sdlImage200 = 200,
	sdlImage201,
	sdlImage202,
	sdlImage203,
	sdlImage204,
	sdlImage205,
}

enum ubyte SDL_IMAGE_MAJOR_VERSION = 2;
enum ubyte SDL_IMAGE_MINOR_VERSION = 0;


version(SDL_Image_205) {
	enum sdlImageSupport = SDLImageSupport.sdlImage205;
	enum ubyte SDL_IMAGE_PATCHLEVEL = 5;
}
else version(SDL_Image_204) {
	enum sdlImageSupport = SDLImageSupport.sdlImage204;
	enum ubyte SDL_IMAGE_PATCHLEVEL = 4;
}
else version(SDL_Image_203) {
	enum sdlImageSupport = SDLImageSupport.sdlImage203;
	enum ubyte SDL_IMAGE_PATCHLEVEL = 3;
}
else version(SDL_Image_202) {
	enum sdlImageSupport = SDLImageSupport.sdlImage202;
	enum ubyte SDL_IMAGE_PATCHLEVEL = 2;
}
else version(SDL_Image_201) {
	enum sdlImageSupport = SDLImageSupport.sdlImage201;
	enum ubyte SDL_IMAGE_PATCHLEVEL = 1;
}
else {
	enum sdlImageSupport = SDLImageSupport.sdlImage200;
	enum ubyte SDL_IMAGE_PATCHLEVEL = 0;
}

@nogc nothrow void SDL_IMAGE_VERSION(SDL_version* X)
{
	X.major     = SDL_IMAGE_MAJOR_VERSION;
	X.minor     = SDL_IMAGE_MINOR_VERSION;
	X.patch     = SDL_IMAGE_PATCHLEVEL;
}

// These were implemented in SDL_image 2.0.2, but are fine for all versions.
enum SDL_IMAGE_COMPILEDVERSION = SDL_VERSIONNUM!(SDL_IMAGE_MAJOR_VERSION, SDL_IMAGE_MINOR_VERSION, SDL_IMAGE_PATCHLEVEL);
enum SDL_IMAGE_VERSION_ATLEAST(ubyte X, ubyte Y, ubyte Z) = SDL_IMAGE_COMPILEDVERSION >= SDL_VERSIONNUM!(X, Y, Z);

enum {
	IMG_INIT_JPG    = 0x00000001,
	IMG_INIT_PNG    = 0x00000002,
	IMG_INIT_TIF    = 0x00000004,
	IMG_INIT_WEBP   = 0x00000008,
}

mixin(joinFnBinds!((){
	string[][] ret;
	ret ~= makeFnBinds!(
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
	);
	static if(sdlImageSupport >= SDLImageSupport.sdlImage202){
		ret ~= makeFnBinds!(
			[q{int}, q{IMG_isSVG}, q{SDL_RWops* src}],
			[q{SDL_Surface*}, q{IMG_LoadSVG}, q{SDL_RWops* src}],
			[q{int}, q{IMG_SaveJPG}, q{SDL_Surface* surface, const(char)* file, int quality}],
			[q{int}, q{IMG_SaveJPG_RW}, q{SDL_Surface* surface, SDL_RWops* dst, int freedst, int quality}],
		);
	}
	return ret;
}()));

static if(!staticBinding){
	private{
		SharedLib lib;
		SDLImageSupport loadedVersion;
	}
	
	@nogc nothrow:
	void unloadSDLImage(){
		if(lib != invalidHandle) {
			lib.unload();
		}
	}
	
	deprecated SDLImageSupport loadedSDLImageVersion() { return loadedVersion; }
	
	bool isSDLImageLoaded(){ return lib != invalidHandle; }
	
	SDLImageSupport loadSDLImage(){
		version(Windows) {
			const(char)[][1] libNames = ["SDL2_image.dll"];
		}else version(OSX) {
			const(char)[][6] libNames = [
				"libSDL2_image.dylib",
				"/usr/local/lib/libSDL2_image.dylib",
				"../Frameworks/SDL2_image.framework/SDL2_image",
				"/Library/Frameworks/SDL2_image.framework/SDL2_image",
				"/System/Library/Frameworks/SDL2_image.framework/SDL2_image",
				"/opt/local/lib/libSDL2_image.dylib"
			];
		}else version(Posix) {
			const(char)[][6] libNames = [
				"libSDL2_image.so",
				"/usr/local/lib/libSDL2_image.so",
				"libSDL2_image-2.0.so",
				"/usr/local/lib/libSDL2_image-2.0.so",
				"libSDL2_image-2.0.so.0",
				"/usr/local/lib/libSDL2_image-2.0.so.0"
			];
		}else static assert(0, "bindbc-sdl is not yet supported on this platform.");

		SDLImageSupport ret;
		foreach(name; libNames) {
			ret = loadSDLImage(name.ptr);
			if(ret != SDLImageSupport.noLibrary) break;
		}
		return ret;
	}

	SDLImageSupport loadSDLImage(const(char)* libName){
		lib = load(libName);
		if(lib == invalidHandle) {
			return SDLImageSupport.noLibrary;
		}

		auto errCount = errorCount();
		loadedVersion = SDLImageSupport.badLibrary;

		lib.bindSymbol(cast(void**)&IMG_Init,"IMG_Init");
		lib.bindSymbol(cast(void**)&IMG_Quit,"IMG_Quit");
		lib.bindSymbol(cast(void**)&IMG_Linked_Version,"IMG_Linked_Version");
		lib.bindSymbol(cast(void**)&IMG_LoadTyped_RW,"IMG_LoadTyped_RW");
		lib.bindSymbol(cast(void**)&IMG_Load,"IMG_Load");
		lib.bindSymbol(cast(void**)&IMG_Load_RW,"IMG_Load_RW");
		lib.bindSymbol(cast(void**)&IMG_LoadTexture,"IMG_LoadTexture");
		lib.bindSymbol(cast(void**)&IMG_LoadTexture_RW,"IMG_LoadTexture_RW");
		lib.bindSymbol(cast(void**)&IMG_LoadTextureTyped_RW,"IMG_LoadTextureTyped_RW");
		lib.bindSymbol(cast(void**)&IMG_isICO,"IMG_isICO");
		lib.bindSymbol(cast(void**)&IMG_isCUR,"IMG_isCUR");
		lib.bindSymbol(cast(void**)&IMG_isBMP,"IMG_isBMP");
		lib.bindSymbol(cast(void**)&IMG_isGIF,"IMG_isGIF");
		lib.bindSymbol(cast(void**)&IMG_isJPG,"IMG_isJPG");
		lib.bindSymbol(cast(void**)&IMG_isLBM,"IMG_isLBM");
		lib.bindSymbol(cast(void**)&IMG_isPCX,"IMG_isPCX");
		lib.bindSymbol(cast(void**)&IMG_isPNG,"IMG_isPNG");
		lib.bindSymbol(cast(void**)&IMG_isPNM,"IMG_isPNM");
		lib.bindSymbol(cast(void**)&IMG_isTIF,"IMG_isTIF");
		lib.bindSymbol(cast(void**)&IMG_isXCF,"IMG_isXCF");
		lib.bindSymbol(cast(void**)&IMG_isXPM,"IMG_isXPM");
		lib.bindSymbol(cast(void**)&IMG_isXV,"IMG_isXV");
		lib.bindSymbol(cast(void**)&IMG_isWEBP,"IMG_isWEBP");
		lib.bindSymbol(cast(void**)&IMG_LoadICO_RW,"IMG_LoadICO_RW");
		lib.bindSymbol(cast(void**)&IMG_LoadCUR_RW,"IMG_LoadCUR_RW");
		lib.bindSymbol(cast(void**)&IMG_LoadBMP_RW,"IMG_LoadBMP_RW");
		lib.bindSymbol(cast(void**)&IMG_LoadGIF_RW,"IMG_LoadGIF_RW");
		lib.bindSymbol(cast(void**)&IMG_LoadJPG_RW,"IMG_LoadJPG_RW");
		lib.bindSymbol(cast(void**)&IMG_LoadLBM_RW,"IMG_LoadLBM_RW");
		lib.bindSymbol(cast(void**)&IMG_LoadPCX_RW,"IMG_LoadPCX_RW");
		lib.bindSymbol(cast(void**)&IMG_LoadPNG_RW,"IMG_LoadPNG_RW");
		lib.bindSymbol(cast(void**)&IMG_LoadPNM_RW,"IMG_LoadPNM_RW");
		lib.bindSymbol(cast(void**)&IMG_LoadTGA_RW,"IMG_LoadTGA_RW");
		lib.bindSymbol(cast(void**)&IMG_LoadTIF_RW,"IMG_LoadTIF_RW");
		lib.bindSymbol(cast(void**)&IMG_LoadXCF_RW,"IMG_LoadXCF_RW");
		lib.bindSymbol(cast(void**)&IMG_LoadXPM_RW,"IMG_LoadXPM_RW");
		lib.bindSymbol(cast(void**)&IMG_LoadXV_RW,"IMG_LoadXV_RW");
		lib.bindSymbol(cast(void**)&IMG_isXV,"IMG_isXV");
		lib.bindSymbol(cast(void**)&IMG_LoadWEBP_RW,"IMG_LoadWEBP_RW");
		lib.bindSymbol(cast(void**)&IMG_SavePNG,"IMG_SavePNG");
		lib.bindSymbol(cast(void**)&IMG_SavePNG_RW,"IMG_SavePNG_RW");

		if(errorCount() != errCount) return SDLImageSupport.badLibrary;
		else loadedVersion = (sdlImageSupport >= SDLImageSupport.sdlImage201) ? SDLImageSupport.sdlImage201 : SDLImageSupport.sdlImage200;

		static if(sdlImageSupport >= SDLImageSupport.sdlImage202) {
			lib.bindSymbol(cast(void**)&IMG_isSVG,"IMG_isSVG");
			lib.bindSymbol(cast(void**)&IMG_LoadSVG,"IMG_LoadSVG_RW");
			lib.bindSymbol(cast(void**)&IMG_SaveJPG,"IMG_SaveJPG");
			lib.bindSymbol(cast(void**)&IMG_SaveJPG_RW,"IMG_SaveJPG_RW");

			if(errorCount() != errCount) return SDLImageSupport.badLibrary;
			else {
				loadedVersion = (sdlImageSupport >= SDLImageSupport.sdlImage205) ? SDLImageSupport.sdlImage205 : sdlImageSupport;
			}
		}

		return loadedVersion;
	}
}
