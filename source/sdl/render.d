/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.render;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

import sdl.blendmode: SDL_BlendMode;
import sdl.rect;
import sdl.stdinc: SDL_bool;
import sdl.surface: SDL_Surface;
import sdl.video: SDL_Window;
import sdl.pixels: SDL_Color;

alias SDL_RendererFlags = uint;
enum: SDL_RendererFlags{
	SDL_RENDERER_SOFTWARE       = 0x00000001,
	SDL_RENDERER_ACCELERATED    = 0x00000002,
	SDL_RENDERER_PRESENTVSYNC   = 0x00000004,
	SDL_RENDERER_TARGETTEXTURE  = 0x00000008,
}

struct SDL_RendererInfo{
	const(char)* name;
	SDL_RendererFlags flags;
	uint num_texture_formats;
	uint[16] texture_formats;
	int max_texture_width;
	int max_texture_height;
}

static if(sdlSupport >= SDLSupport.v2_0_18){
	struct SDL_Vertex{
		SDL_FPoint position;
		SDL_Color color;
		alias colour = color;
		SDL_FPoint tex_coord;
	}
}

static if(sdlSupport >= SDLSupport.v2_0_12){
	alias SDL_ScaleMode = int;
	enum: SDL_ScaleMode{
		SDL_ScaleModeNearest,
		SDL_ScaleModeLinear,
		SDL_ScaleModeBest,
	}
}

alias SDL_TextureAccess = int;
enum: SDL_TextureAccess{
	SDL_TEXTUREACCESS_STATIC,
	SDL_TEXTUREACCESS_STREAMING,
	SDL_TEXTUREACCESS_TARGET,
}

alias SDL_TextureModulate = int;
enum: SDL_TextureModulate{
	SDL_TEXTUREMODULATE_NONE   = 0x00000000,
	SDL_TEXTUREMODULATE_COLOR  = 0x00000001,
	SDL_TEXTUREMODULATE_ALPHA  = 0x00000002,
	
	SDL_TEXTUREMODULATE_COLOUR = SDL_TEXTUREMODULATE_COLOR,
}

alias SDL_RendererFlip = int;
enum: SDL_RendererFlip{
	SDL_FLIP_NONE        = 0x00000000,
	SDL_FLIP_HORIZONTAL  = 0x00000001,
	SDL_FLIP_VERTICAL    = 0x00000002,
}

struct SDL_Renderer;

struct SDL_Texture;

mixin(joinFnBinds((){
	string[][] ret;
	ret ~= makeFnBinds([
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
	]);
	static if(sdlSupport >= SDLSupport.v2_0_1){
		ret ~= makeFnBinds([
			[q{int}, q{SDL_UpdateYUVTexture}, q{SDL_Texture* texture ,const(SDL_Rect)* rect, const(ubyte)* Yplane, int Ypitch, const(ubyte)* Uplane, int Upitch, const(ubyte)* Vplane, int Vpitch}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_4){
		ret ~= makeFnBinds([
			[q{SDL_bool}, q{SDL_RenderIsClipEnabled}, q{SDL_Renderer* renderer}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_5){
		ret ~= makeFnBinds([
			[q{SDL_bool}, q{SDL_RenderGetIntegerScale}, q{SDL_Renderer* renderer}],
			[q{int}, q{SDL_RenderSetIntegerScale}, q{SDL_Renderer* renderer,SDL_bool}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_8){
		ret ~= makeFnBinds([
			[q{void*}, q{SDL_RenderGetMetalLayer}, q{SDL_Renderer* renderer}],
			[q{void*}, q{SDL_RenderGetMetalCommandEncoder}, q{SDL_Renderer* renderer}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_10){
		ret ~= makeFnBinds([
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
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_12){
		ret ~= makeFnBinds([
			[q{int}, q{SDL_SetTextureScaleMode}, q{SDL_Texture* texture, SDL_ScaleMode scaleMode}],
			[q{int}, q{SDL_GetTextureScaleMode}, q{SDL_Texture* texture, SDL_ScaleMode* scaleMode}],
			[q{int}, q{SDL_LockTextureToSurface}, q{SDL_Texture* texture, const(SDL_Rect)* rect,SDL_Surface** surface}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_16){
		ret ~= makeFnBinds([
			[q{int}, q{SDL_UpdateNVTexture}, q{SDL_Texture* texture, const(SDL_Rect)* rect, const(ubyte)* Yplane, int Ypitch, const(ubyte)* UVplane, int UVpitch}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_18){
		ret ~= makeFnBinds([
			[q{int}, q{SDL_SetTextureUserData}, q{SDL_Texture* texture, void* userdata}],
			[q{void*}, q{SDL_GetTextureUserData}, q{SDL_Texture* texture}],
			[q{void}, q{SDL_RenderWindowToLogical}, q{SDL_Renderer* renderer, int windowX, int windowY, float* logicalX, float* logicalY}],
			[q{void}, q{SDL_RenderLogicalToWindow}, q{SDL_Renderer* renderer, float logicalX, float logicalY, int* windowX, int* windowY}],
			[q{int}, q{SDL_RenderGeometry}, q{SDL_Renderer* renderer, SDL_Texture* texture, const(SDL_Vertex)* vertices, int num_vertices, const(int)* indices, int num_indices}],
			[q{int}, q{SDL_RenderSetVSync}, q{SDL_Renderer* renderer, int vsync}],
		]);
		static if(sdlSupport >= SDLSupport.v2_0_20){
			ret ~= makeFnBinds([
				[q{int}, q{SDL_RenderGeometryRaw}, q{SDL_Renderer* renderer, SDL_Texture* texture, const(float)* xy, int xy_stride, const(SDL_Color)* color, int color_stride, const(float)* uv, int uv_stride, int num_vertices, const(void)* indices, int num_indices, int size_indices}],
			]);
		}else{
			ret ~= makeFnBinds([
				[q{int}, q{SDL_RenderGeometryRaw}, q{SDL_Renderer* renderer, SDL_Texture* texture, const(float)* xy, int xy_stride, const(int)* color, int color_stride, const(float)* uv, int uv_stride, int num_vertices, const(void)* indices, int num_indices, int size_indices}],
			]);
		}
	}
	static if(sdlSupport >= SDLSupport.v2_0_22){
		ret ~= makeFnBinds([
			[q{SDL_Window*}, q{SDL_RenderGetWindow}, q{SDL_Renderer* renderer}],
		]);
	}
	return ret;
}()));

alias SDL_SetTextureColourMod = SDL_SetTextureColorMod;
alias SDL_GetTextureColourMod = SDL_GetTextureColorMod;
alias SDL_SetRenderDrawColour = SDL_SetRenderDrawColor;
alias SDL_GetRenderDrawColour = SDL_GetRenderDrawColor;
