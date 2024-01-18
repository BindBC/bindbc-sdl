/+
+            Copyright 2022 – 2024 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.surface;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

import sdl.blendmode: SDL_BlendMode;
import sdl.rect: SDL_Rect;
import sdl.rwops;
import sdl.pixels: SDL_Palette, SDL_PixelFormat;
import sdl.stdinc: SDL_bool;

enum{
	SDL_SWSURFACE  = 0x0000_0000,
	SDL_PREALLOC   = 0x0000_0001,
	SDL_RLEACCEL   = 0x0000_0002,
	SDL_DONTFREE   = 0x0000_0004,
}

pragma(inline, true) bool SDL_MUSTLOCK(const(SDL_Surface)* s) nothrow @nogc pure{
	return (s.flags & SDL_RLEACCEL) != 0;
}

struct SDL_BlitMap;

struct SDL_Surface{
	int flags;
	SDL_PixelFormat* format;
	int w, h;
	int pitch;
	void* pixels;
	
	void* userdata;
	
	int locked;
	
	static if(sdlSupport >= SDLSupport.v2_0_14){
		void* list_blitmap;
	}else{
		void* lock_data;
	}
	
	SDL_Rect clip_rect;
	
	SDL_BlitMap* map;
	
	int refcount;
}

alias SDL_blit = extern(C) int function(SDL_Surface* src, SDL_Rect* srcRect, SDL_Surface* dst, SDL_Rect* dstRect) nothrow;

static if(sdlSupport >= SDLSupport.v2_0_8){
	alias SDL_YUV_CONVERSION_MODE = int;
	enum: SDL_YUV_CONVERSION_MODE{
		SDL_YUV_CONVERSION_JPEG,
		SDL_YUV_CONVERSION_BT601,
		SDL_YUV_CONVERSION_BT709,
		SDL_YUV_CONVERSION_AUTOMATIC,
	}
}

pragma(inline, true) nothrow @nogc{
	SDL_Surface* SDL_LoadBMP(const(char)* file){
		return SDL_LoadBMP_RW(SDL_RWFromFile(file, "rb"), 1);
	}

	int SDL_SaveBMP(SDL_Surface* surface, const(char)* file){
		return SDL_SaveBMP_RW(surface, SDL_RWFromFile(file, "wb"), 1);
	}
}

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{SDL_Surface*}, q{SDL_CreateRGBSurface}, q{uint flags, int width, int height, int depth, uint rMask, uint gMask, uint bMask, uint aMask}},
		{q{SDL_Surface*}, q{SDL_CreateRGBSurfaceFrom}, q{void* pixels, int width, int height, int depth, int pitch, uint rMask, uint gMask, uint bMask, uint aMask}},
		{q{void}, q{SDL_FreeSurface}, q{SDL_Surface* surface}},
		{q{int}, q{SDL_SetSurfacePalette}, q{SDL_Surface* surface, SDL_Palette* palette}},
		{q{int}, q{SDL_LockSurface}, q{SDL_Surface* surface}},
		{q{int}, q{SDL_UnlockSurface}, q{SDL_Surface* surface}},
		{q{SDL_Surface*}, q{SDL_LoadBMP_RW}, q{SDL_RWops* src, int freeSrc}},
		{q{int}, q{SDL_SaveBMP_RW}, q{SDL_Surface* surface, SDL_RWops* dst, int freeDst}},
		{q{int}, q{SDL_SetSurfaceRLE}, q{SDL_Surface* surface, int flag}},
		{q{int}, q{SDL_SetColorKey}, q{SDL_Surface* surface, int flag, uint key}},
		{q{int}, q{SDL_GetColorKey}, q{SDL_Surface* surface, uint* key}},
		{q{int}, q{SDL_SetSurfaceColorMod}, q{SDL_Surface* surface, ubyte r, ubyte g, ubyte b}},
		{q{int}, q{SDL_GetSurfaceColorMod}, q{SDL_Surface* surface, ubyte* r, ubyte* g, ubyte* b}},
		{q{int}, q{SDL_SetSurfaceAlphaMod}, q{SDL_Surface* surface, ubyte alpha}},
		{q{int}, q{SDL_GetSurfaceAlphaMod}, q{SDL_Surface* surface, ubyte* alpha}},
		{q{int}, q{SDL_SetSurfaceBlendMode}, q{SDL_Surface* surface, SDL_BlendMode blendMode}},
		{q{int}, q{SDL_GetSurfaceBlendMode}, q{SDL_Surface* surface, SDL_BlendMode* blendMode}},
		{q{SDL_bool}, q{SDL_SetClipRect}, q{SDL_Surface* surface, const(SDL_Rect)* rect}},
		{q{void}, q{SDL_GetClipRect}, q{SDL_Surface* surface, SDL_Rect* rect}},
		{q{SDL_Surface*}, q{SDL_ConvertSurface}, q{SDL_Surface* surface, const(SDL_PixelFormat)* fmt, uint flags}},
		{q{SDL_Surface*}, q{SDL_ConvertSurfaceFormat}, q{SDL_Surface* surface, uint pixelFormat, uint flags}},
		{q{int}, q{SDL_ConvertPixels}, q{int width, int height, uint srcFormat, const(void)* src, int srcPitch, uint dstFormat, void* dst, int dstPitch}},
		{q{int}, q{SDL_FillRect}, q{SDL_Surface* surface, const(SDL_Rect)* rect, uint colour}},
		{q{int}, q{SDL_FillRects}, q{SDL_Surface* surface, const(SDL_Rect)* rects, int count, uint colour}},
		{q{int}, q{SDL_UpperBlit}, q{SDL_Surface* src, const(SDL_Rect)* srcrect, SDL_Surface* dst, SDL_Rect* dstRect}},
		{q{int}, q{SDL_LowerBlit}, q{SDL_Surface* src, SDL_Rect* srcRect, SDL_Surface* dst, SDL_Rect* dstRect}},
		{q{int}, q{SDL_SoftStretch}, q{SDL_Surface* src, const(SDL_Rect)* srcRect, SDL_Surface* dst, const(SDL_Rect)* dstRect}},
		{q{int}, q{SDL_UpperBlitScaled}, q{SDL_Surface* src, const(SDL_Rect)* srcRect, SDL_Surface* dst, SDL_Rect* dstRect}},
		{q{int}, q{SDL_LowerBlitScaled}, q{SDL_Surface* src, SDL_Rect* srcRect, SDL_Surface* dst, SDL_Rect* dstRect}},
	];
	if(sdlSupport >= SDLSupport.v2_0_5){
		FnBind[] add = [
			{q{SDL_Surface*}, q{SDL_CreateRGBSurfaceWithFormat}, q{uint flags, int width, int height, int depth, uint format}},
			{q{SDL_Surface*}, q{SDL_CreateRGBSurfaceWithFormatFrom}, q{void* pixels, int width, int height, int depth, int pitch, uint format}},
		];
		ret ~= add;
	}
	if(sdlSupport >= SDLSupport.v2_0_5){
		FnBind[] add = [
			{q{SDL_Surface*}, q{SDL_DuplicateSurface}, q{SDL_Surface* surface}},
		];
		ret ~= add;
	}
	if(sdlSupport >= SDLSupport.v2_0_8){
		FnBind[] add = [
			{q{void}, q{SDL_SetYUVConversionMode}, q{SDL_YUV_CONVERSION_MODE mode}},
			{q{SDL_YUV_CONVERSION_MODE}, q{SDL_GetYUVConversionMode}, q{}},
			{q{SDL_YUV_CONVERSION_MODE}, q{SDL_GetYUVConversionModeForResolution}, q{int width, int height}},
		];
		ret ~= add;
	}
	if(sdlSupport >= SDLSupport.v2_0_9){
		FnBind[] add = [
			{q{SDL_bool}, q{SDL_HasColorKey}, q{SDL_Surface* surface}},
		];
		ret ~= add;
	}
	if(sdlSupport >= SDLSupport.v2_0_16){
		FnBind[] add = [
			{q{int}, q{SDL_SoftStretchLinear}, q{SDL_Surface* src, const(SDL_Rect)* srcRect, SDL_Surface* dst, const(SDL_Rect)* dstRect}},
		];
		ret ~= add;
	}
	if(sdlSupport >= SDLSupport.v2_0_18){
		FnBind[] add = [
			{q{int}, q{SDL_PremultiplyAlpha}, q{int width, int height, uint srcFormat, const(void)* src, int srcPitch, uint dstFormat, void* dst, int dstPitch}},
		];
		ret ~= add;
	}
	return ret;
}()));

alias SDL_SetColourKey = SDL_SetColorKey;
alias SDL_GetColourKey = SDL_GetColorKey;
alias SDL_SetSurfaceColourMod = SDL_SetSurfaceColorMod;
alias SDL_GetSurfaceColourMod = SDL_GetSurfaceColorMod;
alias SDL_BlitSurface = SDL_UpperBlit;
alias SDL_BlitScaled = SDL_UpperBlitScaled;
static if(sdlSupport >= SDLSupport.v2_0_9){
	alias SDL_HasColourKey = SDL_HasColorKey;
}
