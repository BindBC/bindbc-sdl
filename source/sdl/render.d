/+
+            Copyright 2024 – 2025 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.render;

import bindbc.sdl.config, bindbc.sdl.codegen;

import sdl.blendmode: SDL_BlendMode_;
import sdl.events: SDL_Event;
import sdl.pixels: SDL_FColour, SDL_PixelFormat;
import sdl.properties: SDL_PropertiesID;
import sdl.rect: SDL_FRect, SDL_FPoint, SDL_Rect;
import sdl.surface: SDL_FlipMode, SDL_ScaleMode, SDL_Surface;
import sdl.video: SDL_Window, SDL_WindowFlags_;

enum{
	SDL_SoftwareRenderer = "software",
	SDL_SOFTWARE_RENDERER = SDL_SoftwareRenderer,
}

struct SDL_Vertex{
	SDL_FPoint position;
	SDL_FColour colour;
	SDL_FPoint texCoord;
	
	alias color = colour;
	alias tex_coord = texCoord;
}

mixin(makeEnumBind(q{SDL_TextureAccess}, members: (){
	EnumMember[] ret = [
		{{q{static_},    q{SDL_TEXTUREACCESS_STATIC}}},
		{{q{streaming},  q{SDL_TEXTUREACCESS_STREAMING}}},
		{{q{target},     q{SDL_TEXTUREACCESS_TARGET}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_RendererLogicalPresentation}, aliases: [q{SDL_LogicalPresentation}], members: (){
	EnumMember[] ret = [
		{{q{disabled},      q{SDL_LOGICAL_PRESENTATION_DISABLED}}},
		{{q{stretch},       q{SDL_LOGICAL_PRESENTATION_STRETCH}}},
		{{q{letterbox},     q{SDL_LOGICAL_PRESENTATION_LETTERBOX}}},
		{{q{overscan},      q{SDL_LOGICAL_PRESENTATION_OVERSCAN}}},
		{{q{integerScale},  q{SDL_LOGICAL_PRESENTATION_INTEGER_SCALE}}},
	];
	return ret;
}()));

struct SDL_Renderer;

struct SDL_Texture{
	SDL_PixelFormat format;
	int w, h;
	int refCount;
	
	alias refcount = refCount;
}

mixin(makeEnumBind(q{SDLProp_RendererCreate}, q{const(char)*}, members: (){
	EnumMember[] ret = [
		{{q{nameString},                              q{SDL_PROP_RENDERER_CREATE_NAME_STRING}},                                  q{"SDL.renderer.create.name"}},
		{{q{windowPointer},                           q{SDL_PROP_RENDERER_CREATE_WINDOW_POINTER}},                               q{"SDL.renderer.create.window"}},
		{{q{surfacePointer},                          q{SDL_PROP_RENDERER_CREATE_SURFACE_POINTER}},                              q{"SDL.renderer.create.surface"}},
		{{q{outputColourspaceNumber},                 q{SDL_PROP_RENDERER_CREATE_OUTPUT_COLOURSPACE_NUMBER}},                    q{"SDL.renderer.create.output_colorspace"}, aliases: [{q{outputColorspaceNumber}, q{SDL_PROP_RENDERER_CREATE_OUTPUT_COLORSPACE_NUMBER}}]},
		{{q{presentVSyncNumber},                      q{SDL_PROP_RENDERER_CREATE_PRESENT_VSYNC_NUMBER}},                         q{"SDL.renderer.create.present_vsync"}},
		{{q{vulkanInstancePointer},                   q{SDL_PROP_RENDERER_CREATE_VULKAN_INSTANCE_POINTER}},                      q{"SDL.renderer.create.vulkan.instance"}},
		{{q{vulkanSurfaceNumber},                     q{SDL_PROP_RENDERER_CREATE_VULKAN_SURFACE_NUMBER}},                        q{"SDL.renderer.create.vulkan.surface"}},
		{{q{vulkanPhysicalDevicePointer},             q{SDL_PROP_RENDERER_CREATE_VULKAN_PHYSICAL_DEVICE_POINTER}},               q{"SDL.renderer.create.vulkan.physical_device"}},
		{{q{vulkanDevicePointer},                     q{SDL_PROP_RENDERER_CREATE_VULKAN_DEVICE_POINTER}},                        q{"SDL.renderer.create.vulkan.device"}},
		{{q{vulkanGraphicsQueueFamilyIndexNumber},    q{SDL_PROP_RENDERER_CREATE_VULKAN_GRAPHICS_QUEUE_FAMILY_INDEX_NUMBER}},    q{"SDL.renderer.create.vulkan.graphics_queue_family_index"}},
		{{q{vulkanPresentQueueFamilyIndexNumber},     q{SDL_PROP_RENDERER_CREATE_VULKAN_PRESENT_QUEUE_FAMILY_INDEX_NUMBER}},     q{"SDL.renderer.create.vulkan.present_queue_family_index"}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDLProp_Renderer}, q{const(char)*}, members: (){
	EnumMember[] ret = [
		{{q{nameString},                              q{SDL_PROP_RENDERER_NAME_STRING}},                                  q{"SDL.renderer.name"}},
		{{q{windowPointer},                           q{SDL_PROP_RENDERER_WINDOW_POINTER}},                               q{"SDL.renderer.window"}},
		{{q{surfacePointer},                          q{SDL_PROP_RENDERER_SURFACE_POINTER}},                              q{"SDL.renderer.surface"}},
		{{q{vsyncNumber},                             q{SDL_PROP_RENDERER_VSYNC_NUMBER}},                                 q{"SDL.renderer.vsync"}},
		{{q{maxTextureSizeNumber},                    q{SDL_PROP_RENDERER_MAX_TEXTURE_SIZE_NUMBER}},                      q{"SDL.renderer.max_texture_size"}},
		{{q{textureFormatsPointer},                   q{SDL_PROP_RENDERER_TEXTURE_FORMATS_POINTER}},                      q{"SDL.renderer.texture_formats"}},
		{{q{outputColourspaceNumber},                 q{SDL_PROP_RENDERER_OUTPUT_COLOURSPACE_NUMBER}},                    q{"SDL.renderer.output_colorspace"}, aliases: [{q{outputColorspaceNumber}, q{SDL_PROP_RENDERER_OUTPUT_COLORSPACE_NUMBER}}]},
		{{q{hdrEnabledBoolean},                       q{SDL_PROP_RENDERER_HDR_ENABLED_BOOLEAN}},                          q{"SDL.renderer.HDR_enabled"}},
		{{q{sdrWhitePointFloat},                      q{SDL_PROP_RENDERER_SDR_WHITE_POINT_FLOAT}},                        q{"SDL.renderer.SDR_white_point"}},
		{{q{hdrHeadroomFloat},                        q{SDL_PROP_RENDERER_HDR_HEADROOM_FLOAT}},                           q{"SDL.renderer.HDR_headroom"}},
		{{q{d3d9DevicePointer},                       q{SDL_PROP_RENDERER_D3D9_DEVICE_POINTER}},                          q{"SDL.renderer.d3d9.device"}},
		{{q{d3d11DevicePointer},                      q{SDL_PROP_RENDERER_D3D11_DEVICE_POINTER}},                         q{"SDL.renderer.d3d11.device"}},
		{{q{d3d11SwapchainPointer},                   q{SDL_PROP_RENDERER_D3D11_SWAPCHAIN_POINTER}},                      q{"SDL.renderer.d3d11.swap_chain"}},
		{{q{d3d12DevicePointer},                      q{SDL_PROP_RENDERER_D3D12_DEVICE_POINTER}},                         q{"SDL.renderer.d3d12.device"}},
		{{q{d3d12SwapchainPointer},                   q{SDL_PROP_RENDERER_D3D12_SWAPCHAIN_POINTER}},                      q{"SDL.renderer.d3d12.swap_chain"}},
		{{q{d3d12CommandQueuePointer},                q{SDL_PROP_RENDERER_D3D12_COMMAND_QUEUE_POINTER}},                  q{"SDL.renderer.d3d12.command_queue"}},
		{{q{vulkanInstancePointer},                   q{SDL_PROP_RENDERER_VULKAN_INSTANCE_POINTER}},                      q{"SDL.renderer.vulkan.instance"}},
		{{q{vulkanSurfaceNumber},                     q{SDL_PROP_RENDERER_VULKAN_SURFACE_NUMBER}},                        q{"SDL.renderer.vulkan.surface"}},
		{{q{vulkanPhysicalDevicePointer},             q{SDL_PROP_RENDERER_VULKAN_PHYSICAL_DEVICE_POINTER}},               q{"SDL.renderer.vulkan.physical_device"}},
		{{q{vulkanDevicePointer},                     q{SDL_PROP_RENDERER_VULKAN_DEVICE_POINTER}},                        q{"SDL.renderer.vulkan.device"}},
		{{q{vulkanGraphicsQueueFamilyIndexNumber},    q{SDL_PROP_RENDERER_VULKAN_GRAPHICS_QUEUE_FAMILY_INDEX_NUMBER}},    q{"SDL.renderer.vulkan.graphics_queue_family_index"}},
		{{q{vulkanPresentQueueFamilyIndexNumber},     q{SDL_PROP_RENDERER_VULKAN_PRESENT_QUEUE_FAMILY_INDEX_NUMBER}},     q{"SDL.renderer.vulkan.present_queue_family_index"}},
		{{q{vulkanSwapchainImageCountNumber},         q{SDL_PROP_RENDERER_VULKAN_SWAPCHAIN_IMAGE_COUNT_NUMBER}},          q{"SDL.renderer.vulkan.swapchain_image_count"}},
		{{q{gpuDevicePointer},                        q{SDL_PROP_RENDERER_GPU_DEVICE_POINTER}},                           q{"SDL.renderer.gpu.device"}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDLProp_TextureCreate}, q{const(char)*}, members: (){
	EnumMember[] ret = [
		{{q{colourspaceNumber},           q{SDL_PROP_TEXTURE_CREATE_COLOURSPACE_NUMBER}},             q{"SDL.texture.create.colorspace"}, aliases: [{q{colorspaceNumber}, q{SDL_PROP_TEXTURE_CREATE_COLORSPACE_NUMBER}}]},
		{{q{formatNumber},                q{SDL_PROP_TEXTURE_CREATE_FORMAT_NUMBER}},                  q{"SDL.texture.create.format"}},
		{{q{accessNumber},                q{SDL_PROP_TEXTURE_CREATE_ACCESS_NUMBER}},                  q{"SDL.texture.create.access"}},
		{{q{widthNumber},                 q{SDL_PROP_TEXTURE_CREATE_WIDTH_NUMBER}},                   q{"SDL.texture.create.width"}},
		{{q{heightNumber},                q{SDL_PROP_TEXTURE_CREATE_HEIGHT_NUMBER}},                  q{"SDL.texture.create.height"}},
		{{q{sdrWhitePointFloat},          q{SDL_PROP_TEXTURE_CREATE_SDR_WHITE_POINT_FLOAT}},          q{"SDL.texture.create.SDR_white_point"}},
		{{q{hdrHeadroomFloat},            q{SDL_PROP_TEXTURE_CREATE_HDR_HEADROOM_FLOAT}},             q{"SDL.texture.create.HDR_headroom"}},
		{{q{d3d11TexturePointer},         q{SDL_PROP_TEXTURE_CREATE_D3D11_TEXTURE_POINTER}},          q{"SDL.texture.create.d3d11.texture"}},
		{{q{d3d11TextureUPointer},        q{SDL_PROP_TEXTURE_CREATE_D3D11_TEXTURE_U_POINTER}},        q{"SDL.texture.create.d3d11.texture_u"}},
		{{q{d3d11TextureVPointer},        q{SDL_PROP_TEXTURE_CREATE_D3D11_TEXTURE_V_POINTER}},        q{"SDL.texture.create.d3d11.texture_v"}},
		{{q{d3d12TexturePointer},         q{SDL_PROP_TEXTURE_CREATE_D3D12_TEXTURE_POINTER}},          q{"SDL.texture.create.d3d12.texture"}},
		{{q{d3d12TextureUPointer},        q{SDL_PROP_TEXTURE_CREATE_D3D12_TEXTURE_U_POINTER}},        q{"SDL.texture.create.d3d12.texture_u"}},
		{{q{d3d12TextureVPointer},        q{SDL_PROP_TEXTURE_CREATE_D3D12_TEXTURE_V_POINTER}},        q{"SDL.texture.create.d3d12.texture_v"}},
		{{q{metalPixelBufferPointer},     q{SDL_PROP_TEXTURE_CREATE_METAL_PIXELBUFFER_POINTER}},      q{"SDL.texture.create.metal.pixelbuffer"}},
		{{q{openGLTextureNumber},         q{SDL_PROP_TEXTURE_CREATE_OPENGL_TEXTURE_NUMBER}},          q{"SDL.texture.create.opengl.texture"}},
		{{q{openGLTextureUVNumber},       q{SDL_PROP_TEXTURE_CREATE_OPENGL_TEXTURE_UV_NUMBER}},       q{"SDL.texture.create.opengl.texture_uv"}},
		{{q{openGLTextureUNumber},        q{SDL_PROP_TEXTURE_CREATE_OPENGL_TEXTURE_U_NUMBER}},        q{"SDL.texture.create.opengl.texture_u"}},
		{{q{openGLTextureVNumber},        q{SDL_PROP_TEXTURE_CREATE_OPENGL_TEXTURE_V_NUMBER}},        q{"SDL.texture.create.opengl.texture_v"}},
		{{q{openGLES2TextureNumber},      q{SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_NUMBER}},       q{"SDL.texture.create.opengles2.texture"}},
		{{q{openGLES2TextureUVNumber},    q{SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_UV_NUMBER}},    q{"SDL.texture.create.opengles2.texture_uv"}},
		{{q{openGLES2TextureUNumber},     q{SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_U_NUMBER}},     q{"SDL.texture.create.opengles2.texture_u"}},
		{{q{openGLES2TextureVNumber},     q{SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_V_NUMBER}},     q{"SDL.texture.create.opengles2.texture_v"}},
		{{q{vulkanTextureNumber},         q{SDL_PROP_TEXTURE_CREATE_VULKAN_TEXTURE_NUMBER}},          q{"SDL.texture.create.vulkan.texture"}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDLProp_Texture}, q{const(char)*}, members: (){
	EnumMember[] ret = [
		{{q{colourspaceNumber},               q{SDL_PROP_TEXTURE_COLOURSPACE_NUMBER}},                 q{"SDL.texture.colorspace"}, aliases: [{q{colorspaceNumber}, q{SDL_PROP_TEXTURE_COLORSPACE_NUMBER}}]},
		{{q{formatNumber},                    q{SDL_PROP_TEXTURE_FORMAT_NUMBER}},                      q{"SDL.texture.format"}},
		{{q{accessNumber},                    q{SDL_PROP_TEXTURE_ACCESS_NUMBER}},                      q{"SDL.texture.access"}},
		{{q{widthNumber},                     q{SDL_PROP_TEXTURE_WIDTH_NUMBER}},                       q{"SDL.texture.width"}},
		{{q{heightNumber},                    q{SDL_PROP_TEXTURE_HEIGHT_NUMBER}},                      q{"SDL.texture.height"}},
		{{q{sdrWhitePointFloat},              q{SDL_PROP_TEXTURE_SDR_WHITE_POINT_FLOAT}},              q{"SDL.texture.SDR_white_point"}},
		{{q{hdrHeadroomFloat},                q{SDL_PROP_TEXTURE_HDR_HEADROOM_FLOAT}},                 q{"SDL.texture.HDR_headroom"}},
		{{q{d3d11TexturePointer},             q{SDL_PROP_TEXTURE_D3D11_TEXTURE_POINTER}},              q{"SDL.texture.d3d11.texture"}},
		{{q{d3d11TextureUPointer},            q{SDL_PROP_TEXTURE_D3D11_TEXTURE_U_POINTER}},            q{"SDL.texture.d3d11.texture_u"}},
		{{q{d3d11TextureVPointer},            q{SDL_PROP_TEXTURE_D3D11_TEXTURE_V_POINTER}},            q{"SDL.texture.d3d11.texture_v"}},
		{{q{d3d12TexturePointer},             q{SDL_PROP_TEXTURE_D3D12_TEXTURE_POINTER}},              q{"SDL.texture.d3d12.texture"}},
		{{q{d3d12TextureUPointer},            q{SDL_PROP_TEXTURE_D3D12_TEXTURE_U_POINTER}},            q{"SDL.texture.d3d12.texture_u"}},
		{{q{d3d12TextureVPointer},            q{SDL_PROP_TEXTURE_D3D12_TEXTURE_V_POINTER}},            q{"SDL.texture.d3d12.texture_v"}},
		{{q{openGLTextureNumber},             q{SDL_PROP_TEXTURE_OPENGL_TEXTURE_NUMBER}},              q{"SDL.texture.opengl.texture"}},
		{{q{openGLTextureUVNumber},           q{SDL_PROP_TEXTURE_OPENGL_TEXTURE_UV_NUMBER}},           q{"SDL.texture.opengl.texture_uv"}},
		{{q{openGLTextureUNumber},            q{SDL_PROP_TEXTURE_OPENGL_TEXTURE_U_NUMBER}},            q{"SDL.texture.opengl.texture_u"}},
		{{q{openGLTextureVNumber},            q{SDL_PROP_TEXTURE_OPENGL_TEXTURE_V_NUMBER}},            q{"SDL.texture.opengl.texture_v"}},
		{{q{openGLTextureTargetNumber},       q{SDL_PROP_TEXTURE_OPENGL_TEXTURE_TARGET_NUMBER}},       q{"SDL.texture.opengl.target"}},
		{{q{openGLTexWFloat},                 q{SDL_PROP_TEXTURE_OPENGL_TEX_W_FLOAT}},                 q{"SDL.texture.opengl.tex_w"}},
		{{q{openGLTexHFloat},                 q{SDL_PROP_TEXTURE_OPENGL_TEX_H_FLOAT}},                 q{"SDL.texture.opengl.tex_h"}},
		{{q{openGLES2TextureNumber},          q{SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_NUMBER}},           q{"SDL.texture.opengles2.texture"}},
		{{q{openGLES2TextureUVNumber},        q{SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_UV_NUMBER}},        q{"SDL.texture.opengles2.texture_uv"}},
		{{q{openGLES2TextureUNumber},         q{SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_U_NUMBER}},         q{"SDL.texture.opengles2.texture_u"}},
		{{q{openGLES2TextureVNumber},         q{SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_V_NUMBER}},         q{"SDL.texture.opengles2.texture_v"}},
		{{q{openGLES2TextureTargetNumber},    q{SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_TARGET_NUMBER}},    q{"SDL.texture.opengles2.target"}},
		{{q{vulkanTextureNumber},             q{SDL_PROP_TEXTURE_VULKAN_TEXTURE_NUMBER}},              q{"SDL.texture.vulkan.texture"}},
	];
	return ret;
}()));

alias SDL_RendererVSync_ = int;
mixin(makeEnumBind(q{SDL_RendererVSync}, q{SDL_RendererVSync_}, members: (){
	EnumMember[] ret = [
		{{q{disabled},    q{SDL_RENDERER_VSYNC_DISABLED}},    q{ 0}},
		{{q{adaptive},    q{SDL_RENDERER_VSYNC_ADAPTIVE}},    q{-1}},
	];
	return ret;
}()));

enum{
	SDL_DebugTextFontCharacterSize = 8,
	SDL_DEBUG_TEXT_FONT_CHARACTER_SIZE = SDL_DebugTextFontCharacterSize,
}

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{int}, q{SDL_GetNumRenderDrivers}, q{}},
		{q{const(char)*}, q{SDL_GetRenderDriver}, q{int index}},
		{q{bool}, q{SDL_CreateWindowAndRenderer}, q{const(char)* title, int width, int height, SDL_WindowFlags_ windowFlags, SDL_Window** window, SDL_Renderer** renderer}},
		{q{SDL_Renderer*}, q{SDL_CreateRenderer}, q{SDL_Window* window, const(char)* name}},
		{q{SDL_Renderer*}, q{SDL_CreateRendererWithProperties}, q{SDL_PropertiesID props}},
		{q{SDL_Renderer*}, q{SDL_CreateSoftwareRenderer}, q{SDL_Surface* surface}},
		{q{SDL_Renderer*}, q{SDL_GetRenderer}, q{SDL_Window* window}},
		{q{SDL_Window*}, q{SDL_GetRenderWindow}, q{SDL_Renderer* renderer}},
		{q{const(char)*}, q{SDL_GetRendererName}, q{SDL_Renderer* renderer}},
		{q{SDL_PropertiesID}, q{SDL_GetRendererProperties}, q{SDL_Renderer* renderer}},
		{q{bool}, q{SDL_GetRenderOutputSize}, q{SDL_Renderer* renderer, int* w, int* h}},
		{q{bool}, q{SDL_GetCurrentRenderOutputSize}, q{SDL_Renderer* renderer, int* w, int* h}},
		{q{SDL_Texture*}, q{SDL_CreateTexture}, q{SDL_Renderer* renderer, SDL_PixelFormat format, SDL_TextureAccess access, int w, int h}},
		{q{SDL_Texture*}, q{SDL_CreateTextureFromSurface}, q{SDL_Renderer* renderer, SDL_Surface* surface}},
		{q{SDL_Texture*}, q{SDL_CreateTextureWithProperties}, q{SDL_Renderer* renderer, SDL_PropertiesID props}},
		{q{SDL_PropertiesID}, q{SDL_GetTextureProperties}, q{SDL_Texture* texture}},
		{q{SDL_Renderer*}, q{SDL_GetRendererFromTexture}, q{SDL_Texture* texture}},
		{q{bool}, q{SDL_GetTextureSize}, q{SDL_Texture* texture, float* w, float* h}},
		{q{bool}, q{SDL_SetTextureColorMod}, q{SDL_Texture* texture, ubyte r, ubyte g, ubyte b}, aliases: [q{SDL_SetTextureColourMod}]},
		{q{bool}, q{SDL_SetTextureColorModFloat}, q{SDL_Texture* texture, float r, float g, float b}, aliases: [q{SDL_SetTextureColourModFloat}]},
		{q{bool}, q{SDL_GetTextureColorMod}, q{SDL_Texture* texture, ubyte* r, ubyte* g, ubyte* b}, aliases: [q{SDL_GetTextureColourMod}]},
		{q{bool}, q{SDL_GetTextureColorModFloat}, q{SDL_Texture* texture, float* r, float* g, float* b}, aliases: [q{SDL_GetTextureColourModFloat}]},
		{q{bool}, q{SDL_SetTextureAlphaMod}, q{SDL_Texture* texture, ubyte alpha}},
		{q{bool}, q{SDL_SetTextureAlphaModFloat}, q{SDL_Texture* texture, float alpha}},
		{q{bool}, q{SDL_GetTextureAlphaMod}, q{SDL_Texture* texture, ubyte* alpha}},
		{q{bool}, q{SDL_GetTextureAlphaModFloat}, q{SDL_Texture* texture, float* alpha}},
		{q{bool}, q{SDL_SetTextureBlendMode}, q{SDL_Texture* texture, SDL_BlendMode_ blendMode}},
		{q{bool}, q{SDL_GetTextureBlendMode}, q{SDL_Texture* texture, SDL_BlendMode_* blendMode}},
		{q{bool}, q{SDL_SetTextureScaleMode}, q{SDL_Texture* texture, SDL_ScaleMode scaleMode}},
		{q{bool}, q{SDL_GetTextureScaleMode}, q{SDL_Texture* texture, SDL_ScaleMode* scaleMode}},
		{q{bool}, q{SDL_UpdateTexture}, q{SDL_Texture* texture, const(SDL_Rect)* rect, const(void)* pixels, int pitch}},
		{q{bool}, q{SDL_UpdateYUVTexture}, q{SDL_Texture* texture, const(SDL_Rect)* rect, const(ubyte)* yPlane, int yPitch, const(ubyte)* uPlane, int uPitch, const(ubyte)* vPlane, int vPitch}},
		{q{bool}, q{SDL_UpdateNVTexture}, q{SDL_Texture* texture, const(SDL_Rect)* rect, const(ubyte)* yPlane, int yPitch, const(ubyte)* uvPlane, int uvPitch}},
		{q{bool}, q{SDL_LockTexture}, q{SDL_Texture* texture, const(SDL_Rect)* rect, void** pixels, int* pitch}},
		{q{bool}, q{SDL_LockTextureToSurface}, q{SDL_Texture* texture, const(SDL_Rect)* rect, SDL_Surface** surface}},
		{q{void}, q{SDL_UnlockTexture}, q{SDL_Texture* texture}},
		{q{bool}, q{SDL_SetRenderTarget}, q{SDL_Renderer* renderer, SDL_Texture* texture}},
		{q{SDL_Texture*}, q{SDL_GetRenderTarget}, q{SDL_Renderer* renderer}},
		{q{bool}, q{SDL_SetRenderLogicalPresentation}, q{SDL_Renderer* renderer, int w, int h, SDL_RendererLogicalPresentation mode}},
		{q{bool}, q{SDL_GetRenderLogicalPresentation}, q{SDL_Renderer* renderer, int* w, int* h, SDL_RendererLogicalPresentation* mode}},
		{q{bool}, q{SDL_GetRenderLogicalPresentationRect}, q{SDL_Renderer* renderer, SDL_FRect* rect}},
		{q{bool}, q{SDL_RenderCoordinatesFromWindow}, q{SDL_Renderer* renderer, float windowX, float windowY, float* x, float* y}},
		{q{bool}, q{SDL_RenderCoordinatesToWindow}, q{SDL_Renderer* renderer, float x, float y, float* windowX, float* windowY}},
		{q{bool}, q{SDL_ConvertEventToRenderCoordinates}, q{SDL_Renderer* renderer, SDL_Event* event}},
		{q{bool}, q{SDL_SetRenderViewport}, q{SDL_Renderer* renderer, const(SDL_Rect)* rect}},
		{q{bool}, q{SDL_GetRenderViewport}, q{SDL_Renderer* renderer, SDL_Rect* rect}},
		{q{bool}, q{SDL_RenderViewportSet}, q{SDL_Renderer* renderer}},
		{q{bool}, q{SDL_GetRenderSafeArea}, q{SDL_Renderer* renderer, SDL_Rect* rect}},
		{q{bool}, q{SDL_SetRenderClipRect}, q{SDL_Renderer* renderer, const(SDL_Rect)* rect}},
		{q{bool}, q{SDL_GetRenderClipRect}, q{SDL_Renderer* renderer, SDL_Rect* rect}},
		{q{bool}, q{SDL_RenderClipEnabled}, q{SDL_Renderer* renderer}},
		{q{bool}, q{SDL_SetRenderScale}, q{SDL_Renderer* renderer, float scaleX, float scaleY}},
		{q{bool}, q{SDL_GetRenderScale}, q{SDL_Renderer* renderer, float* scaleX, float* scaleY}},
		{q{bool}, q{SDL_SetRenderDrawColor}, q{SDL_Renderer* renderer, ubyte r, ubyte g, ubyte b, ubyte a}, aliases: [q{SDL_SetRenderDrawColour}]},
		{q{bool}, q{SDL_SetRenderDrawColorFloat}, q{SDL_Renderer* renderer, float r, float g, float b, float a}, aliases: [q{SDL_SetRenderDrawColourFloat}]},
		{q{bool}, q{SDL_GetRenderDrawColor}, q{SDL_Renderer* renderer, ubyte* r, ubyte* g, ubyte* b, ubyte* a}, aliases: [q{SDL_GetRenderDrawColour}]},
		{q{bool}, q{SDL_GetRenderDrawColorFloat}, q{SDL_Renderer* renderer, float* r, float* g, float* b, float* a}, aliases: [q{SDL_GetRenderDrawColourFloat}]},
		{q{bool}, q{SDL_SetRenderColorScale}, q{SDL_Renderer* renderer, float scale}, aliases: [q{SDL_SetRenderColourScale}]},
		{q{bool}, q{SDL_GetRenderColorScale}, q{SDL_Renderer* renderer, float* scale}, aliases: [q{SDL_GetRenderColourScale}]},
		{q{bool}, q{SDL_SetRenderDrawBlendMode}, q{SDL_Renderer* renderer, SDL_BlendMode_ blendMode}},
		{q{bool}, q{SDL_GetRenderDrawBlendMode}, q{SDL_Renderer* renderer, SDL_BlendMode_* blendMode}},
		{q{bool}, q{SDL_RenderClear}, q{SDL_Renderer* renderer}},
		{q{bool}, q{SDL_RenderPoint}, q{SDL_Renderer* renderer, float x, float y}},
		{q{bool}, q{SDL_RenderPoints}, q{SDL_Renderer* renderer, const(SDL_FPoint)* points, int count}},
		{q{bool}, q{SDL_RenderLine}, q{SDL_Renderer* renderer, float x1, float y1, float x2, float y2}},
		{q{bool}, q{SDL_RenderLines}, q{SDL_Renderer* renderer, const(SDL_FPoint)* points, int count}},
		{q{bool}, q{SDL_RenderRect}, q{SDL_Renderer* renderer, const(SDL_FRect)* rect}},
		{q{bool}, q{SDL_RenderRects}, q{SDL_Renderer* renderer, const(SDL_FRect)* rects, int count}},
		{q{bool}, q{SDL_RenderFillRect}, q{SDL_Renderer* renderer, const(SDL_FRect)* rect}},
		{q{bool}, q{SDL_RenderFillRects}, q{SDL_Renderer* renderer, const(SDL_FRect)* rects, int count}},
		{q{bool}, q{SDL_RenderTexture}, q{SDL_Renderer* renderer, SDL_Texture* texture, const(SDL_FRect)* srcRect, const(SDL_FRect)* dstRect}},
		{q{bool}, q{SDL_RenderTextureRotated}, q{SDL_Renderer* renderer, SDL_Texture* texture, const(SDL_FRect)* srcRect, const(SDL_FRect)* dstRect, double angle, const(SDL_FPoint)* centre, SDL_FlipMode flip}},
		{q{bool}, q{SDL_RenderTextureAffine}, q{SDL_Renderer* renderer, SDL_Texture* texture, const(SDL_FRect)* srcRect, const(SDL_FPoint)* origin, const(SDL_FPoint)* right, const(SDL_FPoint)* down}},
		{q{bool}, q{SDL_RenderTextureTiled}, q{SDL_Renderer* renderer, SDL_Texture* texture, const(SDL_FRect)* srcRect, float scale, const(SDL_FRect)* dstRect}},
		{q{bool}, q{SDL_RenderTexture9Grid}, q{SDL_Renderer* renderer, SDL_Texture* texture, const(SDL_FRect)* srcRect, float leftWidth, float rightWidth, float topHeight, float bottomHeight, float scale, const(SDL_FRect)* dstRect}},
		{q{bool}, q{SDL_RenderGeometry}, q{SDL_Renderer* renderer, SDL_Texture* texture, const(SDL_Vertex)* vertices, int numVertices, const(int)* indices, int numIndices}},
		{q{bool}, q{SDL_RenderGeometryRaw}, q{SDL_Renderer* renderer, SDL_Texture* texture, const(float)* xy, int xyStride, const(SDL_FColour)* colour, int colourStride, const(float)* uv, int uvStride, int numVertices, const(void)* indices, int numIndices, int sizeIndices}},
		{q{SDL_Surface*}, q{SDL_RenderReadPixels}, q{SDL_Renderer* renderer, const(SDL_Rect)* rect}},
		{q{bool}, q{SDL_RenderPresent}, q{SDL_Renderer* renderer}},
		{q{void}, q{SDL_DestroyTexture}, q{SDL_Texture* texture}},
		{q{void}, q{SDL_DestroyRenderer}, q{SDL_Renderer* renderer}},
		{q{bool}, q{SDL_FlushRenderer}, q{SDL_Renderer* renderer}},
		{q{void*}, q{SDL_GetRenderMetalLayer}, q{SDL_Renderer* renderer}},
		{q{void*}, q{SDL_GetRenderMetalCommandEncoder}, q{SDL_Renderer* renderer}},
		{q{bool}, q{SDL_AddVulkanRenderSemaphores}, q{SDL_Renderer* renderer, uint waitStageMask, long waitSemaphore, long signalSemaphore}},
		{q{bool}, q{SDL_SetRenderVSync}, q{SDL_Renderer* renderer, SDL_RendererVSync_ vsync}},
		{q{bool}, q{SDL_GetRenderVSync}, q{SDL_Renderer* renderer, SDL_RendererVSync_* vsync}},
		{q{bool}, q{SDL_RenderDebugText}, q{SDL_Renderer* renderer, float x, float y, const(char)* str}},
		{q{bool}, q{SDL_RenderDebugTextFormat}, q{SDL_Renderer* renderer, float x, float y, const(char)* fmt, ...}},
	];
	return ret;
}()));
