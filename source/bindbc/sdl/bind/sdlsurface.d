
//          Copyright 2018 - 2022 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlsurface;

import bindbc.sdl.config;
import bindbc.sdl.bind.sdlblendmode : SDL_BlendMode;
import bindbc.sdl.bind.sdlrect : SDL_Rect;
import bindbc.sdl.bind.sdlrwops;
import bindbc.sdl.bind.sdlpixels : SDL_Palette, SDL_PixelFormat;
import bindbc.sdl.bind.sdlstdinc : SDL_bool;

enum {
    SDL_SWSURFACE = 0,
    SDL_PREALLOC = 0x00000001,
    SDL_RLEACCEL = 0x00000002,
    SDL_DONTFREE = 0x00000004,
}

@nogc nothrow pure
bool SDL_MUSTLOCK(const(SDL_Surface)* S)
{
    pragma(inline, true);
    return (S.flags & SDL_RLEACCEL) != 0;
}

struct SDL_BlitMap;
struct SDL_Surface {
    int flags;
    SDL_PixelFormat* format;
    int w, h;
    int pitch;
    void* pixels;
    void* userdata;
    int locked;
    void* lock_data;
    SDL_Rect clip_rect;
    SDL_BlitMap* map;
    int refcount;
}

extern(C) nothrow alias SDL_blit = int function(SDL_Surface* src, SDL_Rect* srcrect, SDL_Surface* dst, SDL_Rect* dstrect);

@nogc nothrow {
    SDL_Surface* SDL_LoadBMP(const(char)* file) {
        pragma(inline, true);
        return SDL_LoadBMP_RW(SDL_RWFromFile(file,"rb"),1);
    }

    int SDL_SaveBMP(SDL_Surface* surface,const(char)* file) {
        pragma(inline, true);
        return SDL_SaveBMP_RW(surface,SDL_RWFromFile(file,"wb"),1);
    }
}

static if(sdlSupport >= SDLSupport.sdl208) {
    enum SDL_YUV_CONVERSION_MODE {
        SDL_YUV_CONVERSION_JPEG,
        SDL_YUV_CONVERSION_BT601,
        SDL_YUV_CONVERSION_BT709,
        SDL_YUV_CONVERSION_AUTOMATIC,
    }
    mixin(expandEnum!SDL_YUV_CONVERSION_MODE);
}

mixin(makeFnBinds!(
    [q{SDL_Surface*}, q{SDL_CreateRGBSurface}, q{uint flags, int width, int height, int depth, uint Rmask, uint Gmask, uint Bmask, uint Amask}],
    [q{SDL_Surface*}, q{SDL_CreateRGBSurfaceFrom}, q{void* pixels, int width, int height, int depth, int pitch, uint Rmask, uint Gmask, uint Bmask, uint Amask}],
    [q{void}, q{SDL_FreeSurface}, q{SDL_Surface* surface}],
    [q{int}, q{SDL_SetSurfacePalette}, q{SDL_Surface* surface, SDL_Palette* palette}],
    [q{int}, q{SDL_LockSurface}, q{SDL_Surface* surface}],
    [q{int}, q{SDL_UnlockSurface}, q{SDL_Surface* surface}],
    [q{SDL_Surface*}, q{SDL_LoadBMP_RW}, q{SDL_RWops* src, int freesrc}],
    [q{int}, q{SDL_SaveBMP_RW}, q{SDL_Surface* surface, SDL_RWops* dst, int freedst}],
    [q{int}, q{SDL_SetSurfaceRLE}, q{SDL_Surface* surface, int flag}],
    [q{int}, q{SDL_SetColorKey}, q{SDL_Surface* surface, int flag, uint key}],
    [q{int}, q{SDL_GetColorKey}, q{SDL_Surface* surface, uint* key}],
    [q{int}, q{SDL_SetSurfaceColorMod}, q{SDL_Surface* surface, ubyte r, ubyte g, ubyte b}],
    [q{int}, q{SDL_GetSurfaceColorMod}, q{SDL_Surface* surface, ubyte* r, ubyte* g, ubyte* b}],
    [q{int}, q{SDL_SetSurfaceAlphaMod}, q{SDL_Surface* surface, ubyte alpha}],
    [q{int}, q{SDL_GetSurfaceAlphaMod}, q{SDL_Surface* surface, ubyte* alpha}],
    [q{int}, q{SDL_SetSurfaceBlendMode}, q{SDL_Surface* surface, SDL_BlendMode blendMode}],
    [q{int}, q{SDL_GetSurfaceBlendMode}, q{SDL_Surface* surface, SDL_BlendMode* blendMode}],
    [q{SDL_bool}, q{SDL_SetClipRect}, q{SDL_Surface* surface, const(SDL_Rect)* rect}],
    [q{void}, q{SDL_GetClipRect}, q{SDL_Surface* surface, SDL_Rect* rect}],
    [q{SDL_Surface*}, q{SDL_ConvertSurface}, q{SDL_Surface* surface, const(SDL_PixelFormat)* fmt, uint flags}],
    [q{SDL_Surface*}, q{SDL_ConvertSurfaceFormat}, q{SDL_Surface* surface,uint pixel_format, uint flags}],
    [q{int}, q{SDL_ConvertPixels}, q{int width, int height, uint src_format, const(void)* src, int src_pitch, uint dst_format, void* dst, int dst_pitch}],
    [q{int}, q{SDL_FillRect}, q{SDL_Surface* surface, const(SDL_Rect)* rect, uint color}],
    [q{int}, q{SDL_FillRects}, q{SDL_Surface* surface, const(SDL_Rect)* rects, int count, uint color}],
    [q{int}, q{SDL_UpperBlit}, q{SDL_Surface* src, const(SDL_Rect)* srcrect, SDL_Surface* dst, SDL_Rect* dstrect}],
    [q{int}, q{SDL_LowerBlit}, q{SDL_Surface* src, SDL_Rect* srcrect, SDL_Surface* dst, SDL_Rect* dstrect}],
    [q{int}, q{SDL_SoftStretch}, q{SDL_Surface* src, const(SDL_Rect)* srcrect, SDL_Surface* dst, const(SDL_Rect)* dstrect}],
    [q{int}, q{SDL_UpperBlitScaled}, q{SDL_Surface* src, const(SDL_Rect)* srcrect, SDL_Surface* dst, SDL_Rect* dstrect}],
    [q{int}, q{SDL_LowerBlitScaled}, q{SDL_Surface* src, SDL_Rect* srcrect, SDL_Surface* dst, SDL_Rect* dstrect}],
));

alias SDL_BlitSurface = SDL_UpperBlit;
alias SDL_BlitScaled = SDL_UpperBlitScaled;

static if(sdlSupport >= SDLSupport.sdl205) {
    mixin(makeFnBinds!(
        [q{SDL_Surface*}, q{SDL_CreateRGBSurfaceWithFormat}, q{uint flags, int width, int height, int depth, uint format}],
        [q{SDL_Surface*}, q{SDL_CreateRGBSurfaceWithFormatFrom}, q{void* pixels, int width, int height, int depth, int pitch, uint format}],
    ));
}
static if(sdlSupport >= SDLSupport.sdl205) {
    mixin(makeFnBinds!(
        [q{SDL_Surface*}, q{SDL_DuplicateSurface}, q{SDL_Surface* surface}],
    ));
}
static if(sdlSupport >= SDLSupport.sdl208) {
    mixin(makeFnBinds!(
        [q{void}, q{SDL_SetYUVConversionMode}, q{SDL_YUV_CONVERSION_MODE mode}],
        [q{SDL_YUV_CONVERSION_MODE}, q{SDL_GetYUVConversionMode}, q{}],
        [q{SDL_YUV_CONVERSION_MODE}, q{SDL_GetYUVConversionModeForResolution}, q{int width, int height}],
    ));
}
static if(sdlSupport >= SDLSupport.sdl209) {
    mixin(makeFnBinds!(
        [q{SDL_bool}, q{SDL_HasColorKey}, q{SDL_Surface* surface}],
    ));
}
static if(sdlSupport >= SDLSupport.sdl2016) {
    mixin(makeFnBinds!(
        [q{int}, q{SDL_SoftStretchLinear}, q{SDL_Surface* src, const(SDL_Rect)* srcrect, SDL_Surface* dst, const(SDL_Rect)* dstrect}],
    ));
}
static if(sdlSupport >= SDLSupport.sdl2018) {
    mixin(makeFnBinds!(
        [q{int}, q{SDL_PremultiplyAlpha}, q{int width, int height, uint src_format, const(void)* src, int src_pitch, uint dst_format, void* dst, int dst_pitch}],
    ));
}
