/+
+            Copyright 2024 – 2026 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.surface;

import bindbc.sdl.config, bindbc.sdl.codegen;

import sdl.blendmode: SDL_BlendMode_;
import sdl.iostream: SDL_IOStream;
import sdl.pixels: SDL_Colour, SDL_Colourspace, SDL_Palette, SDL_PixelFormat, SDL_PixelFormatDetails;
import sdl.properties: SDL_PropertiesID;
import sdl.rect: SDL_Rect;

alias SDL_SurfaceFlags_ = uint;
mixin(makeEnumBind(q{SDL_SurfaceFlags}, members: (){
	EnumMember[] ret = [
		{{q{preAllocated},  q{SDL_SURFACE_PREALLOCATED}},  q{0x0000_0001U}},
		{{q{lockNeeded},    q{SDL_SURFACE_LOCK_NEEDED}},   q{0x0000_0002U}},
		{{q{locked},        q{SDL_SURFACE_LOCKED}},        q{0x0000_0004U}},
		{{q{simdAligned},   q{SDL_SURFACE_SIMD_ALIGNED}},  q{0x0000_0008U}},
	];
	return ret;
}()));

pragma(inline,true)
bool SDL_MUSTLOCK(SDL_Surface s) nothrow @nogc pure @safe =>
	(s.flags & SDL_SurfaceFlags.lockNeeded) == SDL_SurfaceFlags.lockNeeded;

mixin(makeEnumBind(q{SDL_ScaleMode}, members: (){
	EnumMember[] ret;
	if(sdlVersion >= Version(3,2,6)){
		EnumMember add =
			{{q{invalid},    q{SDL_SCALEMODE_INVALID}}, q{-1}};
		ret ~= add;
	}
	{
		EnumMember[] add = [
			{{q{nearest},    q{SDL_SCALEMODE_NEAREST}}},
			{{q{linear},     q{SDL_SCALEMODE_LINEAR}}},
		];
		ret ~= add;
	}
	if(sdlVersion >= Version(3,4,0)){
		EnumMember add =
			{{q{pixelArt},   q{SDL_SCALEMODE_PIXELART}}};
		ret ~= add;
	}
	return ret;
}()));

mixin(makeEnumBind(q{SDL_FlipMode}, aliases: [q{SDL_Flip}], members: (){
	EnumMember[] ret = [
		{{q{none},        q{SDL_FLIP_NONE}}},
		{{q{horizontal},  q{SDL_FLIP_HORIZONTAL}}},
		{{q{vertical},    q{SDL_FLIP_VERTICAL}}},
	];
	if(sdlVersion >= Version(3,4,0)){
		EnumMember add =
			{{q{horizontalAndVertical}, q{SDL_FLIP_HORIZONTAL_AND_VERTICAL}}, q{horizontal | vertical}};
		ret ~= add;
	}
	return ret;
}()));

struct SDL_Surface{
	SDL_SurfaceFlags_ flags;
	SDL_PixelFormat format;
	int w, h, pitch;
	void* pixels;
	int refCount;
	void* reserved;
	
	alias refcount = refCount;
}

mixin(makeEnumBind(q{SDLProp_Surface}, q{const(char)*}, members: (){
	EnumMember[] ret = [
		{{q{sdrWhitePointFloat},       q{SDL_PROP_SURFACE_SDR_WHITE_POINT_FLOAT}},      q{"SDL.surface.SDR_white_point"}},
		{{q{hdrHeadroomFloat},         q{SDL_PROP_SURFACE_HDR_HEADROOM_FLOAT}},         q{"SDL.surface.HDR_headroom"}},
		{{q{toneMapOperatorString},    q{SDL_PROP_SURFACE_TONEMAP_OPERATOR_STRING}},    q{"SDL.surface.tonemap"}},
	];
	if(sdlVersion >= Version(3,2,6)){
		EnumMember[] add = [
			{{q{hotspotXNumber},    q{SDL_PROP_SURFACE_HOTSPOT_X_NUMBER}},    q{"SDL.surface.hotspot.x"}},
			{{q{hotspotYNumber},    q{SDL_PROP_SURFACE_HOTSPOT_Y_NUMBER}},    q{"SDL.surface.hotspot.y"}},
		];
		ret ~= add;
	}
	if(sdlVersion >= Version(3,4,0)){
		EnumMember[] add = [
			{{q{rotationFloat},     q{SDL_PROP_SURFACE_ROTATION_FLOAT}},      q{"SDL.surface.rotation"}},
		];
		ret ~= add;
	}
	return ret;
}()));

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{SDL_Surface*}, q{SDL_CreateSurface}, q{int width, int height, SDL_PixelFormat format}},
		{q{SDL_Surface*}, q{SDL_CreateSurfaceFrom}, q{int width, int height, SDL_PixelFormat format, void* pixels, int pitch}},
		{q{void}, q{SDL_DestroySurface}, q{SDL_Surface* surface}},
		{q{SDL_PropertiesID}, q{SDL_GetSurfaceProperties}, q{SDL_Surface* surface}},
		{q{bool}, q{SDL_SetSurfaceColorspace}, q{SDL_Surface* surface, SDL_Colourspace colourspace}, aliases: [q{SDL_SetSurfaceColourspace}]},
		{q{SDL_Colourspace}, q{SDL_GetSurfaceColorspace}, q{SDL_Surface* surface}, aliases: [q{SDL_GetSurfaceColourspace}]},
		{q{SDL_Palette*}, q{SDL_CreateSurfacePalette}, q{SDL_Surface* surface}},
		{q{bool}, q{SDL_SetSurfacePalette}, q{SDL_Surface* surface, SDL_Palette* palette}},
		{q{SDL_Palette*}, q{SDL_GetSurfacePalette}, q{SDL_Surface* surface}},
		{q{bool}, q{SDL_AddSurfaceAlternateImage}, q{SDL_Surface* surface, SDL_Surface* image}},
		{q{bool}, q{SDL_SurfaceHasAlternateImages}, q{SDL_Surface* surface}},
		{q{SDL_Surface**}, q{SDL_GetSurfaceImages}, q{SDL_Surface* surface, int* count}},
		{q{void}, q{SDL_RemoveSurfaceAlternateImages}, q{SDL_Surface* surface}},
		{q{bool}, q{SDL_LockSurface}, q{SDL_Surface* surface}},
		{q{void}, q{SDL_UnlockSurface}, q{SDL_Surface* surface}},
		{q{SDL_Surface*}, q{SDL_LoadBMP_IO}, q{SDL_IOStream* src, bool closeIO}},
		{q{SDL_Surface*}, q{SDL_LoadBMP}, q{const(char)* file}},
		{q{bool}, q{SDL_SaveBMP_IO}, q{SDL_Surface* surface, SDL_IOStream* dst, bool closeIO}},
		{q{bool}, q{SDL_SaveBMP}, q{SDL_Surface* surface, const(char)* file}},
		{q{bool}, q{SDL_SetSurfaceRLE}, q{SDL_Surface* surface, bool enabled}},
		{q{bool}, q{SDL_SurfaceHasRLE}, q{SDL_Surface* surface}},
		{q{bool}, q{SDL_SetSurfaceColorKey}, q{SDL_Surface* surface, bool enabled, uint key}, aliases: [q{SDL_SetSurfaceColourKey}]},
		{q{bool}, q{SDL_SurfaceHasColorKey}, q{SDL_Surface* surface}, aliases: [q{SDL_SurfaceHasColourKey}]},
		{q{bool}, q{SDL_GetSurfaceColorKey}, q{SDL_Surface* surface, uint* key}, aliases: [q{SDL_GetSurfaceColourKey}]},
		{q{bool}, q{SDL_SetSurfaceColorMod}, q{SDL_Surface* surface, ubyte r, ubyte g, ubyte b}, aliases: [q{SDL_SetSurfaceColourMod}]},
		{q{bool}, q{SDL_GetSurfaceColorMod}, q{SDL_Surface* surface, ubyte* r, ubyte* g, ubyte* b}, aliases: [q{SDL_GetSurfaceColourMod}]},
		{q{bool}, q{SDL_SetSurfaceAlphaMod}, q{SDL_Surface* surface, ubyte alpha}},
		{q{bool}, q{SDL_GetSurfaceAlphaMod}, q{SDL_Surface* surface, ubyte* alpha}},
		{q{bool}, q{SDL_SetSurfaceBlendMode}, q{SDL_Surface* surface, SDL_BlendMode_ blendMode}},
		{q{bool}, q{SDL_GetSurfaceBlendMode}, q{SDL_Surface* surface, SDL_BlendMode_* blendMode}},
		{q{bool}, q{SDL_SetSurfaceClipRect}, q{SDL_Surface* surface, const(SDL_Rect)* rect}},
		{q{bool}, q{SDL_GetSurfaceClipRect}, q{SDL_Surface* surface, SDL_Rect* rect}},
		{q{bool}, q{SDL_FlipSurface}, q{SDL_Surface* surface, SDL_FlipMode flip}},
		{q{SDL_Surface*}, q{SDL_DuplicateSurface}, q{SDL_Surface* surface}},
		{q{SDL_Surface*}, q{SDL_ScaleSurface}, q{SDL_Surface* surface, int width, int height, SDL_ScaleMode scaleMode}},
		{q{SDL_Surface*}, q{SDL_ConvertSurface}, q{SDL_Surface* surface, SDL_PixelFormat format}},
		{q{SDL_Surface*}, q{SDL_ConvertSurfaceAndColorspace}, q{SDL_Surface* surface, SDL_PixelFormat format, SDL_Palette* palette, SDL_Colourspace colourspace, SDL_PropertiesID props}, aliases: [q{SDL_ConvertSurfaceAndColourspace}]},
		{q{bool}, q{SDL_ConvertPixels}, q{int width, int height, SDL_PixelFormat srcFormat, const(void)* src, int srcPitch, SDL_PixelFormat dstFormat, void* dst, int dstPitch}},
		{q{bool}, q{SDL_ConvertPixelsAndColorspace}, q{int width, int height, SDL_PixelFormat srcFormat, SDL_Colourspace srcColourspace, SDL_PropertiesID srcProperties, const(void)* src, int srcPitch, SDL_PixelFormat dstFormat, SDL_Colourspace dstColourspace, SDL_PropertiesID dstProperties, void* dst, int dstPitch}, aliases: [q{SDL_ConvertPixelsAndColourspace}]},
		{q{bool}, q{SDL_PremultiplyAlpha}, q{int width, int height, SDL_PixelFormat srcFormat, const(void)* src, int srcPitch, SDL_PixelFormat dstFormat, void* dst, int dstPitch, bool linear}},
		{q{bool}, q{SDL_PremultiplySurfaceAlpha}, q{SDL_Surface* surface, bool linear}},
		{q{bool}, q{SDL_ClearSurface}, q{SDL_Surface* surface, float r, float g, float b, float a}},
		{q{bool}, q{SDL_FillSurfaceRect}, q{SDL_Surface* dst, const(SDL_Rect)* rect, uint colour}},
		{q{bool}, q{SDL_FillSurfaceRects}, q{SDL_Surface* dst, const(SDL_Rect)* rects, int count, uint colour}},
		{q{bool}, q{SDL_BlitSurface}, q{SDL_Surface* src, const(SDL_Rect)* srcRect, SDL_Surface* dst, const(SDL_Rect)* dstRect}},
		{q{bool}, q{SDL_BlitSurfaceUnchecked}, q{SDL_Surface* src, const(SDL_Rect)* srcRect, SDL_Surface* dst, const(SDL_Rect)* dstRect}},
		{q{bool}, q{SDL_BlitSurfaceScaled}, q{SDL_Surface* src, const(SDL_Rect)* srcRect, SDL_Surface* dst, const(SDL_Rect)* dstRect, SDL_ScaleMode scaleMode}},
		{q{bool}, q{SDL_BlitSurfaceUncheckedScaled}, q{SDL_Surface* src, const(SDL_Rect)* srcRect, SDL_Surface* dst, const(SDL_Rect)* dstRect, SDL_ScaleMode scaleMode}},
		{q{bool}, q{SDL_BlitSurfaceTiled}, q{SDL_Surface* src, const(SDL_Rect)* srcRect, SDL_Surface* dst, const(SDL_Rect)* dstRect}},
		{q{bool}, q{SDL_BlitSurfaceTiledWithScale}, q{SDL_Surface* src, const(SDL_Rect)* srcRect, float scale, SDL_ScaleMode scaleMode, SDL_Surface* dst, const(SDL_Rect)* dstRect}},
		{q{bool}, q{SDL_BlitSurface9Grid}, q{SDL_Surface* src, const(SDL_Rect)* srcRect, int leftWidth, int rightWidth, int topHeight, int bottomHeight, float scale, SDL_ScaleMode scaleMode, SDL_Surface* dst, const(SDL_Rect)* dstRect}},
		{q{uint}, q{SDL_MapSurfaceRGB}, q{SDL_Surface* surface, ubyte r, ubyte g, ubyte b}},
		{q{uint}, q{SDL_MapSurfaceRGBA}, q{SDL_Surface* surface, ubyte r, ubyte g, ubyte b, ubyte a}},
		{q{bool}, q{SDL_ReadSurfacePixel}, q{SDL_Surface* surface, int x, int y, ubyte* r, ubyte* g, ubyte* b, ubyte* a}},
		{q{bool}, q{SDL_ReadSurfacePixelFloat}, q{SDL_Surface* surface, int x, int y, float* r, float* g, float* b, float* a}},
		{q{bool}, q{SDL_WriteSurfacePixel}, q{SDL_Surface* surface, int x, int y, ubyte r, ubyte g, ubyte b, ubyte a}},
		{q{bool}, q{SDL_WriteSurfacePixelFloat}, q{SDL_Surface* surface, int x, int y, float r, float g, float b, float a}},
	];
	if(sdlVersion >= Version(3,2,4)){
		FnBind[] add = [
			{q{bool}, q{SDL_StretchSurface}, q{SDL_Surface* src, const(SDL_Rect)* srcRect, SDL_Surface* dst, const(SDL_Rect)* dstRect, SDL_ScaleMode scaleMode}},
		];
		ret ~= add;
	}
	if(sdlVersion >= Version(3,4,0)){
		FnBind[] add = [
			{q{SDL_Surface*}, q{SDL_LoadSurface_IO}, q{SDL_IOStream* src, bool closeIO}},
			{q{SDL_Surface*}, q{SDL_LoadSurface}, q{const(char)* file}},
			{q{SDL_Surface*}, q{SDL_LoadPNG_IO}, q{SDL_IOStream* src, bool closeIO}},
			{q{SDL_Surface*}, q{SDL_LoadPNG}, q{const(char)* file}},
			{q{bool}, q{SDL_SavePNG_IO}, q{SDL_Surface* surface, SDL_IOStream* dst, bool closeIO}},
			{q{bool}, q{SDL_SavePNG}, q{SDL_Surface* surface, const(char)* file}},
			{q{SDL_Surface*}, q{SDL_RotateSurface}, q{SDL_Surface* surface, float angle}},
		];
		ret ~= add;
	}
	return ret;
}()));
