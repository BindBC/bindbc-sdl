/+
+            Copyright 2025 – 2026 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl_image;

import bindbc.sdl.config;
static if(sdlImageVersion):
import bindbc.sdl.codegen;

import sdl.iostream: SDL_IOStream;
import sdl.render: SDL_Renderer, SDL_Texture;
import sdl.surface: SDL_Surface;
import sdl.version_: SDL_VERSIONNUM;

enum{
	SDL_Image_MajorVersion = sdlImageVersion.major,
	SDL_Image_MinorVersion = sdlImageVersion.minor,
	SDL_Image_MicroVersion = sdlImageVersion.patch,
	SDL_Image_Version = SDL_VERSIONNUM(SDL_Image_MajorVersion, SDL_Image_MinorVersion, SDL_Image_MicroVersion),
	
	SDL_IMAGE_MAJOR_VERSION = SDL_Image_MajorVersion,
	SDL_IMAGE_MINOR_VERSION = SDL_Image_MinorVersion,
	SDL_IMAGE_PATCHLEVEL = SDL_Image_MicroVersion,
	SDL_IMAGE_VERSION = SDL_Image_Version,
}

pragma(inline, true)
bool SDL_IMAGE_VERSION_ATLEAST(int x, int y, int z) nothrow @nogc pure @safe =>
	(SDL_Image_MajorVersion >= x) &&
	(SDL_Image_MajorVersion >  x || SDL_Image_MinorVersion >= y) &&
	(SDL_Image_MajorVersion >  x || SDL_Image_MinorVersion >  y || SDL_Image_MicroVersion >= z);

struct IMG_Animation{
	int w, h, count;
	SDL_Surface** frames;
	int* delays;
}

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{int}, q{IMG_Version}, q{}},
		{q{SDL_Surface*}, q{IMG_LoadTyped_IO}, q{SDL_IOStream* src, bool closeIO, const(char)* type}},
		{q{SDL_Surface*}, q{IMG_Load}, q{const(char)* file}},
		{q{SDL_Surface*}, q{IMG_Load_IO}, q{SDL_IOStream* src, bool closeIO}},
		{q{SDL_Texture*}, q{IMG_LoadTexture}, q{SDL_Renderer* renderer, const(char)* file}},
		{q{SDL_Texture*}, q{IMG_LoadTexture_IO}, q{SDL_Renderer* renderer, SDL_IOStream* src, bool closeIO}},
		{q{SDL_Texture*}, q{IMG_LoadTextureTyped_IO}, q{SDL_Renderer* renderer, SDL_IOStream* src, bool closeIO, const(char)* type}},
		{q{bool}, q{IMG_isAVIF}, q{SDL_IOStream* src}},
		{q{bool}, q{IMG_isICO}, q{SDL_IOStream* src}},
		{q{bool}, q{IMG_isCUR}, q{SDL_IOStream* src}},
		{q{bool}, q{IMG_isBMP}, q{SDL_IOStream* src}},
		{q{bool}, q{IMG_isGIF}, q{SDL_IOStream* src}},
		{q{bool}, q{IMG_isJPG}, q{SDL_IOStream* src}},
		{q{bool}, q{IMG_isJXL}, q{SDL_IOStream* src}},
		{q{bool}, q{IMG_isLBM}, q{SDL_IOStream* src}},
		{q{bool}, q{IMG_isPCX}, q{SDL_IOStream* src}},
		{q{bool}, q{IMG_isPNG}, q{SDL_IOStream* src}},
		{q{bool}, q{IMG_isPNM}, q{SDL_IOStream* src}},
		{q{bool}, q{IMG_isSVG}, q{SDL_IOStream* src}},
		{q{bool}, q{IMG_isQOI}, q{SDL_IOStream* src}},
		{q{bool}, q{IMG_isTIF}, q{SDL_IOStream* src}},
		{q{bool}, q{IMG_isXCF}, q{SDL_IOStream* src}},
		{q{bool}, q{IMG_isXPM}, q{SDL_IOStream* src}},
		{q{bool}, q{IMG_isXV}, q{SDL_IOStream* src}},
		{q{bool}, q{IMG_isWEBP}, q{SDL_IOStream* src}},
		{q{SDL_Surface*}, q{IMG_LoadAVIF_IO}, q{SDL_IOStream* src}},
		{q{SDL_Surface*}, q{IMG_LoadICO_IO}, q{SDL_IOStream* src}},
		{q{SDL_Surface*}, q{IMG_LoadCUR_IO}, q{SDL_IOStream* src}},
		{q{SDL_Surface*}, q{IMG_LoadBMP_IO}, q{SDL_IOStream* src}},
		{q{SDL_Surface*}, q{IMG_LoadGIF_IO}, q{SDL_IOStream* src}},
		{q{SDL_Surface*}, q{IMG_LoadJPG_IO}, q{SDL_IOStream* src}},
		{q{SDL_Surface*}, q{IMG_LoadJXL_IO}, q{SDL_IOStream* src}},
		{q{SDL_Surface*}, q{IMG_LoadLBM_IO}, q{SDL_IOStream* src}},
		{q{SDL_Surface*}, q{IMG_LoadPCX_IO}, q{SDL_IOStream* src}},
		{q{SDL_Surface*}, q{IMG_LoadPNG_IO}, q{SDL_IOStream* src}},
		{q{SDL_Surface*}, q{IMG_LoadPNM_IO}, q{SDL_IOStream* src}},
		{q{SDL_Surface*}, q{IMG_LoadSVG_IO}, q{SDL_IOStream* src}},
		{q{SDL_Surface*}, q{IMG_LoadQOI_IO}, q{SDL_IOStream* src}},
		{q{SDL_Surface*}, q{IMG_LoadTGA_IO}, q{SDL_IOStream* src}},
		{q{SDL_Surface*}, q{IMG_LoadTIF_IO}, q{SDL_IOStream* src}},
		{q{SDL_Surface*}, q{IMG_LoadXCF_IO}, q{SDL_IOStream* src}},
		{q{SDL_Surface*}, q{IMG_LoadXPM_IO}, q{SDL_IOStream* src}},
		{q{SDL_Surface*}, q{IMG_LoadXV_IO}, q{SDL_IOStream* src}},
		{q{SDL_Surface*}, q{IMG_LoadWEBP_IO}, q{SDL_IOStream* src}},
		{q{SDL_Surface*}, q{IMG_LoadSizedSVG_IO}, q{SDL_IOStream* src, int width, int height}},
		{q{SDL_Surface*}, q{IMG_ReadXPMFromArray}, q{char** xpm}},
		{q{SDL_Surface*}, q{IMG_ReadXPMFromArrayToRGB888}, q{char** xpm}},
		{q{bool}, q{IMG_SaveAVIF}, q{SDL_Surface* surface, const(char)* file, int quality}},
		{q{bool}, q{IMG_SaveAVIF_IO}, q{SDL_Surface* surface, SDL_IOStream* dst, bool closeIO, int quality}},
		{q{bool}, q{IMG_SavePNG}, q{SDL_Surface* surface, const(char)* file}},
		{q{bool}, q{IMG_SavePNG_IO}, q{SDL_Surface* surface, SDL_IOStream* dst, bool closeIO}},
		{q{bool}, q{IMG_SaveJPG}, q{SDL_Surface* surface, const(char)* file, int quality}},
		{q{bool}, q{IMG_SaveJPG_IO}, q{SDL_Surface* surface, SDL_IOStream* dst, bool closeIO, int quality}},
		{q{IMG_Animation*}, q{IMG_LoadAnimation}, q{const(char)* file}},
		{q{IMG_Animation*}, q{IMG_LoadAnimation_IO}, q{SDL_IOStream* src, bool closeIO}},
		{q{IMG_Animation*}, q{IMG_LoadAnimationTyped_IO}, q{SDL_IOStream* src, bool closeIO, const(char)* type}},
		{q{void}, q{IMG_FreeAnimation}, q{IMG_Animation* anim}},
		{q{IMG_Animation*}, q{IMG_LoadGIFAnimation_IO}, q{SDL_IOStream* src}},
		{q{IMG_Animation*}, q{IMG_LoadWEBPAnimation_IO}, q{SDL_IOStream* src}},
	];
	return ret;
}()));

static if(!staticBinding):
import bindbc.loader;

mixin(makeDynloadFns("SDLImage", makeLibPaths(["SDL3_image"]), [__MODULE__]));
