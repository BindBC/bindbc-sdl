
//          Copyright 2018 - 2022 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlrender;

import bindbc.sdl.config;
import bindbc.sdl.bind.sdlblendmode : SDL_BlendMode;
import bindbc.sdl.bind.sdlrect;
import bindbc.sdl.bind.sdlstdinc : SDL_bool;
import bindbc.sdl.bind.sdlsurface : SDL_Surface;
import bindbc.sdl.bind.sdlvideo : SDL_Window;
import bindbc.sdl.bind.sdlpixels : SDL_Color;

enum : uint {
    SDL_RENDERER_SOFTWARE = 0x00000001,
    SDL_RENDERER_ACCELERATED = 0x00000002,
    SDL_RENDERER_PRESENTVSYNC = 0x00000004,
    SDL_RENDERER_TARGETTEXTURE = 0x00000008,
}
alias SDL_RendererFlags = uint;

struct SDL_RendererInfo {
    const(char)* name;
    SDL_RendererFlags flags;
    uint num_texture_formats;
    uint[16] texture_formats;
    int max_texture_width;
    int max_texture_height;
}

static if(sdlSupport >= SDLSupport.sdl2012) {
    enum SDL_ScaleMode {
        SDL_ScaleModeNearest,
        SDL_ScaleModeLinear,
        SDL_ScaleModeBest,
    }
    mixin(expandEnum!SDL_ScaleMode);
}

static if(sdlSupport >= SDLSupport.sdl2018) {
    struct SDL_Vertex {
        SDL_FPoint position;
        SDL_Color color;
        SDL_FPoint tex_coord;
    }
}

enum SDL_TextureAccess {
    SDL_TEXTUREACCESS_STATIC,
    SDL_TEXTUREACCESS_STREAMING,
    SDL_TEXTUREACCESS_TARGET,
}
mixin(expandEnum!SDL_TextureAccess);

enum SDL_TextureModulate {
    SDL_TEXTUREMODULATE_NONE = 0x00000000,
    SDL_TEXTUREMODULATE_COLOR = 0x00000001,
    SDL_TEXTUREMODULATE_ALPHA = 0x00000002
}
mixin(expandEnum!SDL_TextureModulate);

enum SDL_RendererFlip {
    SDL_FLIP_NONE = 0x00000000,
    SDL_FLIP_HORIZONTAL = 0x00000001,
    SDL_FLIP_VERTICAL = 0x00000002,
}
mixin(expandEnum!SDL_RendererFlip);

struct SDL_Renderer;
struct SDL_Texture;

mixin(makeFnBinds!(
    [q{int}, q{SDL_GetNumRenderDrivers}, q{}],
    [q{int}, q{SDL_GetRenderDriverInfo}, q{int index, SDL_RendererInfo* info}],
    [q{int}, q{SDL_CreateWindowAndRenderer}, q{int width, int height, uint window_flags, SDL_Window** window, SDL_Renderer** renderer}],
    [q{SDL_Renderer*}, q{SDL_CreateRenderer}, q{SDL_Window* window, int index, SDL_RendererFlags flags}],
    [q{SDL_Renderer*}, q{SDL_CreateSoftwareRenderer}, q{SDL_Surface* surface}],
    [q{SDL_Renderer*}, q{SDL_GetRenderer}, q{SDL_Window* window}],
    [q{int}, q{SDL_GetRendererInfo}, q{SDL_Renderer* renderer, SDL_RendererInfo* info}],
    [q{int}, q{SDL_GetRendererOutputSize}, q{SDL_Renderer* renderer, int* w, int* h}],
    [q{SDL_Texture*}, q{SDL_CreateTexture}, q{SDL_Renderer* renderer, uint format, SDL_TextureAccess access, int w, int h}],
    [q{SDL_Texture*}, q{SDL_CreateTextureFromSurface}, q{SDL_Renderer* renderer, SDL_Surface* surface}],
    [q{int}, q{SDL_QueryTexture}, q{SDL_Texture* texture, uint* format, SDL_TextureAccess* access, int* w, int* h}],
    [q{int}, q{SDL_SetTextureColorMod}, q{SDL_Texture* texture, ubyte r, ubyte g, ubyte b}],
    [q{int}, q{SDL_GetTextureColorMod}, q{SDL_Texture* texture, ubyte* r, ubyte* g, ubyte* b}],
    [q{int}, q{SDL_SetTextureAlphaMod}, q{SDL_Texture* texture, ubyte alpha}],
    [q{int}, q{SDL_GetTextureAlphaMod}, q{SDL_Texture* texture, ubyte* alpha}],
    [q{int}, q{SDL_SetTextureBlendMode}, q{SDL_Texture* texture, SDL_BlendMode blendMode}],
    [q{int}, q{SDL_GetTextureBlendMode}, q{SDL_Texture* texture, SDL_BlendMode* blendMode}],
    [q{int}, q{SDL_UpdateTexture}, q{SDL_Texture* texture, const(SDL_Rect)* rect, const(void)* pixels, int pitch}],
    [q{int}, q{SDL_LockTexture}, q{SDL_Texture* texture, const(SDL_Rect)* rect, void** pixels, int* pitch}],
    [q{void}, q{SDL_UnlockTexture}, q{SDL_Texture* texture}],
    [q{SDL_bool}, q{SDL_RenderTargetSupported}, q{SDL_Renderer* renderer}],
    [q{int}, q{SDL_SetRenderTarget}, q{SDL_Renderer* renderer, SDL_Texture* texture}],
    [q{SDL_Texture*}, q{SDL_GetRenderTarget}, q{SDL_Renderer* renderer}],
    [q{int}, q{SDL_RenderSetClipRect}, q{SDL_Renderer* renderer, const(SDL_Rect)* rect}],
    [q{void}, q{SDL_RenderGetClipRect}, q{SDL_Renderer* renderer, SDL_Rect* rect}],
    [q{int}, q{SDL_RenderSetLogicalSize}, q{SDL_Renderer* renderer, int w, int h}],
    [q{void}, q{SDL_RenderGetLogicalSize}, q{SDL_Renderer* renderer, int* w, int* h}],
    [q{int}, q{SDL_RenderSetViewport}, q{SDL_Renderer* renderer, const(SDL_Rect)* rect}],
    [q{void}, q{SDL_RenderGetViewport}, q{SDL_Renderer* renderer, SDL_Rect* rect}],
    [q{int}, q{SDL_RenderSetScale}, q{SDL_Renderer* renderer, float scaleX, float scaleY}],
    [q{int}, q{SDL_RenderGetScale}, q{SDL_Renderer* renderer, float* scaleX, float* scaleY}],
    [q{int}, q{SDL_SetRenderDrawColor}, q{SDL_Renderer* renderer, ubyte r, ubyte g, ubyte b, ubyte a}],
    [q{int}, q{SDL_GetRenderDrawColor}, q{SDL_Renderer* renderer, ubyte* r, ubyte* g, ubyte* b, ubyte* a}],
    [q{int}, q{SDL_SetRenderDrawBlendMode}, q{SDL_Renderer* renderer, SDL_BlendMode blendMode}],
    [q{int}, q{SDL_GetRenderDrawBlendMode}, q{SDL_Renderer* renderer, SDL_BlendMode* blendMode}],
    [q{int}, q{SDL_RenderClear}, q{SDL_Renderer* renderer}],
    [q{int}, q{SDL_RenderDrawPoint}, q{SDL_Renderer* renderer, int x, int y}],
    [q{int}, q{SDL_RenderDrawPoints}, q{SDL_Renderer* renderer, const(SDL_Point)* points, int count}],
    [q{int}, q{SDL_RenderDrawLine}, q{SDL_Renderer* renderer, int x1, int y1, int x2, int y2}],
    [q{int}, q{SDL_RenderDrawLines}, q{SDL_Renderer* renderer, const(SDL_Point)* points, int count}],
    [q{int}, q{SDL_RenderDrawRect}, q{SDL_Renderer* renderer, const(SDL_Rect)* rect}],
    [q{int}, q{SDL_RenderDrawRects}, q{SDL_Renderer* renderer, const(SDL_Rect)* rects, int count}],
    [q{int}, q{SDL_RenderFillRect}, q{SDL_Renderer* renderer, const(SDL_Rect)* rect}],
    [q{int}, q{SDL_RenderFillRects}, q{SDL_Renderer* renderer, const(SDL_Rect)* rects, int count}],
    [q{int}, q{SDL_RenderCopy}, q{SDL_Renderer* renderer, SDL_Texture* texture, const(SDL_Rect)* srcrect, const(SDL_Rect)* dstrect}],
    [q{int}, q{SDL_RenderCopyEx}, q{SDL_Renderer* renderer, SDL_Texture* texture, const(SDL_Rect)* srcrect, const(SDL_Rect)* dstrect, const(double) angle, const(SDL_Point)* center, const(SDL_RendererFlip) flip}],
    [q{int}, q{SDL_RenderReadPixels}, q{SDL_Renderer* renderer, const(SDL_Rect)* rect,uint,void*,int}],
    [q{void}, q{SDL_RenderPresent}, q{SDL_Renderer* renderer}],
    [q{void}, q{SDL_DestroyTexture}, q{SDL_Texture* texture}],
    [q{void}, q{SDL_DestroyRenderer}, q{SDL_Renderer* renderer}],
    [q{int}, q{SDL_GL_BindTexture}, q{SDL_Texture* texture, float* texw, float* texh}],
    [q{int}, q{SDL_GL_UnbindTexture}, q{SDL_Texture* texture}],
));

static if(sdlSupport >= SDLSupport.sdl201) {
    mixin(makeFnBinds!(
        [q{int}, q{SDL_UpdateYUVTexture}, q{SDL_Texture* texture ,const(SDL_Rect)* rect, const(ubyte)* Yplane, int Ypitch, const(ubyte)* Uplane, int Upitch, const(ubyte)* Vplane, int Vpitch}],
    ));
}
static if(sdlSupport >= SDLSupport.sdl204) {
    mixin(makeFnBinds!(
        [q{SDL_bool}, q{SDL_RenderIsClipEnabled}, q{SDL_Renderer* renderer}],
    ));
}
static if(sdlSupport >= SDLSupport.sdl205) {
    mixin(makeFnBinds!(
        [q{SDL_bool}, q{SDL_RenderGetIntegerScale}, q{SDL_Renderer* renderer}],
        [q{int}, q{SDL_RenderSetIntegerScale}, q{SDL_Renderer* renderer,SDL_bool}],
    ));
}
static if(sdlSupport >= SDLSupport.sdl208) {
    mixin(makeFnBinds!(
        [q{void*}, q{SDL_RenderGetMetalLayer}, q{SDL_Renderer* renderer}],
        [q{void*}, q{SDL_RenderGetMetalCommandEncoder}, q{SDL_Renderer* renderer}],
    ));
}
static if(sdlSupport >= SDLSupport.sdl2010) {
    mixin(makeFnBinds!(
        [q{int}, q{SDL_RenderDrawPointF}, q{SDL_Renderer* renderer, float x, float y}],
        [q{int}, q{SDL_RenderDrawPointsF}, q{SDL_Renderer* renderer, const(SDL_FPoint)* points, int count}],
        [q{int}, q{SDL_RenderDrawLineF}, q{SDL_Renderer* renderer, float x1, float y1, float x2, float y2}],
        [q{int}, q{SDL_RenderDrawLinesF}, q{SDL_Renderer* renderer, const(SDL_FPoint)* points, int count}],
        [q{int}, q{SDL_RenderDrawRectF}, q{SDL_Renderer* renderer, const(SDL_FRect)* rect}],
        [q{int}, q{SDL_RenderDrawRectsF}, q{SDL_Renderer* renderer, const(SDL_FRect)* rects, int count}],
        [q{int}, q{SDL_RenderFillRectF}, q{SDL_Renderer* renderer, const(SDL_FRect)* rect}],
        [q{int}, q{SDL_RenderFillRectsF}, q{SDL_Renderer* renderer, const(SDL_FRect)* rects, int count}],
        [q{int}, q{SDL_RenderCopyF}, q{SDL_Renderer* renderer, SDL_Texture* texture, const(SDL_Rect)* srcrect, const(SDL_FRect)* dstrect}],
        [q{int}, q{SDL_RenderCopyExF}, q{SDL_Renderer* renderer, SDL_Texture* texture, const(SDL_Rect)* srcrect, const(SDL_FRect)* dstrect, const(double) angle, const(SDL_FPoint)* center, const(SDL_RendererFlip) flip}],
        [q{int}, q{SDL_RenderFlush}, q{SDL_Renderer* renderer}],
    ));
}
static if(sdlSupport >= SDLSupport.sdl2012) {
    mixin(makeFnBinds!(
        [q{int}, q{SDL_SetTextureScaleMode}, q{SDL_Texture* texture, SDL_ScaleMode scaleMode}],
        [q{int}, q{SDL_GetTextureScaleMode}, q{SDL_Texture* texture, SDL_ScaleMode* scaleMode}],
        [q{int}, q{SDL_LockTextureToSurface}, q{SDL_Texture* texture, const(SDL_Rect)* rect,SDL_Surface** surface}],
    ));
}
static if(sdlSupport >= SDLSupport.sdl2016) {
    mixin(makeFnBinds!(
        [q{int}, q{SDL_UpdateNVTexture}, q{SDL_Texture* texture, const(SDL_Rect)* rect, const(ubyte)* Yplane, int Ypitch, const(ubyte)* UVplane, int UVpitch}],
    ));
}
static if(sdlSupport >= SDLSupport.sdl2018) {
    mixin(makeFnBinds!(
        [q{int}, q{SDL_SetTextureUserData}, q{SDL_Texture* texture, void* userdata}],
        [q{void*}, q{SDL_GetTextureUserData}, q{SDL_Texture* texture}],
        [q{void}, q{SDL_RenderWindowToLogical}, q{SDL_Renderer* renderer, int windowX, int windowY, float* logicalX, float* logicalY}],
        [q{void}, q{SDL_RenderLogicalToWindow}, q{SDL_Renderer* renderer, float logicalX, float logicalY, int* windowX, int* windowY}],
        [q{int}, q{SDL_RenderGeometry}, q{SDL_Renderer* renderer, SDL_Texture* texture, const(SDL_Vertex)* vertices, int num_vertices, const(int)* indices, int num_indices}],
        [q{int}, q{SDL_RenderSetVSync}, q{SDL_Renderer* renderer, int vsync}],
    ));
}
static if(sdlSupport < SDLSupport.sdl2020) {
    mixin(makeFnBinds!(
        [q{int}, q{SDL_RenderGeometryRaw}, q{SDL_Renderer* renderer, SDL_Texture* texture, const(float)* xy, int xy_stride, const(int)* color, int color_stride, const(float)* uv, int uv_stride, int num_vertices, const(void)* indices, int num_indices, int size_indices}],
    ));
} else {
    mixin(makeFnBinds!(
        [q{int}, q{SDL_RenderGeometryRaw}, q{SDL_Renderer* renderer, SDL_Texture* texture, const(float)* xy, int xy_stride, const(SDL_Color)* color, int color_stride, const(float)* uv, int uv_stride, int num_vertices, const(void)* indices, int num_indices, int size_indices}],
    ));
}
static if(sdlSupport >= SDLSupport.sdl2022) {
    mixin(makeFnBinds!(
        [q{SDL_Window*}, q{SDL_RenderGetWindow}, q{SDL_Renderer* renderer}],
    ));
}
