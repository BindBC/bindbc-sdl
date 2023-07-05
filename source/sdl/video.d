/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.video;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

import sdl.rect: SDL_Rect;
import sdl.stdinc: SDL_bool;
import sdl.surface: SDL_Surface;

struct SDL_DisplayMode{
	uint format;
	int w;
	int h;
	int refresh_rate;
	void* driverdata;
}

struct SDL_Window;

alias SDL_WindowFlags = uint;
enum: SDL_WindowFlags{
	SDL_WINDOW_FULLSCREEN          = 0x0000_0001,
	SDL_WINDOW_OPENGL              = 0x0000_0002,
	SDL_WINDOW_SHOWN               = 0x0000_0004,
	SDL_WINDOW_HIDDEN              = 0x0000_0008,
	SDL_WINDOW_BORDERLESS          = 0x0000_0010,
	SDL_WINDOW_RESIZABLE           = 0x0000_0020,
	SDL_WINDOW_MINIMIZED           = 0x0000_0040,
	SDL_WINDOW_MAXIMIZED           = 0x0000_0080,
	SDL_WINDOW_INPUT_GRABBED       = 0x0000_0100,
	SDL_WINDOW_INPUT_FOCUS         = 0x0000_0200,
	SDL_WINDOW_MOUSE_FOCUS         = 0x0000_0400,
	SDL_WINDOW_FULLSCREEN_DESKTOP  = 0x0000_1000 | SDL_WINDOW_FULLSCREEN,
	SDL_WINDOW_FOREIGN             = 0x0000_0800,
}
static if(sdlSupport >= SDLSupport.v2_0_1)
enum: SDL_WindowFlags{
	SDL_WINDOW_ALLOW_HIGHDPI       = 0x0000_2000,
}
static if(sdlSupport >= SDLSupport.v2_0_4)
enum: SDL_WindowFlags{
	SDL_WINDOW_MOUSE_CAPTURE       = 0x0000_4000,
}
static if(sdlSupport >= SDLSupport.v2_0_5)
enum: SDL_WindowFlags{
	SDL_WINDOW_ALWAYS_ON_TOP       = 0x0000_8000,
	SDL_WINDOW_SKIP_TASKBAR        = 0x0001_0000,
	SDL_WINDOW_UTILITY             = 0x0002_0000,
	SDL_WINDOW_TOOLTIP             = 0x0004_0000,
	SDL_WINDOW_POPUP_MENU          = 0x0008_0000,
}
static if(sdlSupport >= SDLSupport.v2_0_6)
enum: SDL_WindowFlags{
	SDL_WINDOW_VULKAN              = 0x1000_0000,
}
static if(sdlSupport >= SDLSupport.v2_0_6)
enum: SDL_WindowFlags{
	SDL_WINDOW_METAL               = 0x2000_0000,
}
static if(sdlSupport >= SDLSupport.v2_0_16)
enum: SDL_WindowFlags{
	SDL_WINDOW_MOUSE_GRABBED       = SDL_WINDOW_INPUT_GRABBED,
	SDL_WINDOW_KEYBOARD_GRABBED    = 0x0010_0000,
}

enum: uint{
	SDL_WINDOWPOS_UNDEFINED_MASK = 0x1FFF0000,
	SDL_WINDOWPOS_UNDEFINED = SDL_WINDOWPOS_UNDEFINED_DISPLAY(0),
	SDL_WINDOWPOS_CENTERED_MASK = 0x2FFF0000,
	SDL_WINDOWPOS_CENTERED = SDL_WINDOWPOS_CENTERED_DISPLAY(0),
}

pragma(inline, true) @nogc nothrow pure @safe{
	uint SDL_WINDOWPOS_UNDEFINED_DISPLAY(uint x){ return SDL_WINDOWPOS_UNDEFINED_MASK | x; }
	uint SDL_WINDOWPOS_ISUNDEFINED(uint x){ return (x & 0xFFFF0000) == SDL_WINDOWPOS_UNDEFINED_MASK; }
	uint SDL_WINDOWPOS_CENTERED_DISPLAY(uint x){ return SDL_WINDOWPOS_CENTERED_MASK | x; }
	uint SDL_WINDOWPOS_ISCENTERED(uint x){ return (x & 0xFFFF0000) == SDL_WINDOWPOS_CENTERED_MASK; }
}

alias SDL_WindowEventID = ubyte;
enum: SDL_WindowEventID{
	SDL_WINDOWEVENT_NONE             = 0,
	SDL_WINDOWEVENT_SHOWN            = 1,
	SDL_WINDOWEVENT_HIDDEN           = 2,
	SDL_WINDOWEVENT_EXPOSED          = 3,
	SDL_WINDOWEVENT_MOVED            = 4,
	SDL_WINDOWEVENT_RESIZED          = 5,
	SDL_WINDOWEVENT_SIZE_CHANGED     = 6,
	SDL_WINDOWEVENT_MINIMIZED        = 7,
	SDL_WINDOWEVENT_MAXIMIZED        = 8,
	SDL_WINDOWEVENT_RESTORED         = 9,
	SDL_WINDOWEVENT_ENTER            = 10,
	SDL_WINDOWEVENT_LEAVE            = 11,
	SDL_WINDOWEVENT_FOCUS_GAINED     = 12,
	SDL_WINDOWEVENT_FOCUS_LOST       = 13,
	SDL_WINDOWEVENT_CLOSE            = 14,
}
static if(sdlSupport >= SDLSupport.v2_0_5)
enum: SDL_WindowEventID{
	SDL_WINDOWEVENT_TAKE_FOCUS       = 15,
	SDL_WINDOWEVENT_HIT_TEST         = 16,
}
static if(sdlSupport >= SDLSupport.v2_0_18)
enum: SDL_WindowEventID{
	SDL_WINDOWEVENT_ICCPROF_CHANGED  = 17,
	SDL_WINDOWEVENT_DISPLAY_CHANGED  = 18,
}

static if(sdlSupport >= SDLSupport.v2_0_9){
	alias SDL_DisplayEventID = int;
	enum: SDL_DisplayEventID{
		SDL_DISPLAYEVENT_NONE          = 0,
		SDL_DISPLAYEVENT_ORIENTATION   = 1,
	}
	static if(sdlSupport >= SDLSupport.v2_0_14)
	enum: SDL_DisplayEventID{
		SDL_DISPLAYEVENT_CONNECTED     = 2,
		SDL_DISPLAYEVENT_DISCONNECTED  = 3,
	}
	static if(sdlSupport >= SDLSupport.v2_28)
	enum: SDL_DisplayEventID{
		SDL_DISPLAYEVENT_MOVED         = 4,
	}
}

static if(sdlSupport >= SDLSupport.v2_0_9){
	alias SDL_DisplayOrientation = int;
	enum: SDL_DisplayOrientation{
		SDL_ORIENTATION_UNKNOWN            = 0,
		SDL_ORIENTATION_LANDSCAPE          = 1,
		SDL_ORIENTATION_LANDSCAPE_FLIPPED  = 2,
		SDL_ORIENTATION_PORTRAIT           = 3,
		SDL_ORIENTATION_PORTRAIT_FLIPPED   = 4,
	}
}

static if(sdlSupport >= SDLSupport.v2_0_16){
	alias SDL_FlashOperation = int;
	enum: SDL_FlashOperation{
		SDL_FLASH_CANCEL         = 0,
		SDL_FLASH_BRIEFLY        = 1,
		SDL_FLASH_UNTIL_FOCUSED  = 2,
	}
}

alias SDL_GLContext = void*;

alias SDL_GLattr = int;
enum: SDL_GLattr{
	SDL_GL_RED_SIZE                    = 0,
	SDL_GL_GREEN_SIZE                  = 1,
	SDL_GL_BLUE_SIZE                   = 2,
	SDL_GL_ALPHA_SIZE                  = 3,
	SDL_GL_BUFFER_SIZE                 = 4,
	SDL_GL_DOUBLEBUFFER                = 5,
	SDL_GL_DEPTH_SIZE                  = 6,
	SDL_GL_STENCIL_SIZE                = 7,
	SDL_GL_ACCUM_RED_SIZE              = 8,
	SDL_GL_ACCUM_GREEN_SIZE            = 9,
	SDL_GL_ACCUM_BLUE_SIZE             = 10,
	SDL_GL_ACCUM_ALPHA_SIZE            = 11,
	SDL_GL_STEREO                      = 12,
	SDL_GL_MULTISAMPLEBUFFERS          = 13,
	SDL_GL_MULTISAMPLESAMPLES          = 14,
	SDL_GL_ACCELERATED_VISUAL          = 15,
	SDL_GL_RETAINED_BACKING            = 16,
	SDL_GL_CONTEXT_MAJOR_VERSION       = 17,
	SDL_GL_CONTEXT_MINOR_VERSION       = 18,
	SDL_GL_CONTEXT_EGL                 = 19,
	SDL_GL_CONTEXT_FLAGS               = 20,
	SDL_GL_CONTEXT_PROFILE_MASK        = 21,
	SDL_GL_SHARE_WITH_CURRENT_CONTEXT  = 22,
}
static if(sdlSupport >= SDLSupport.v2_0_1)
enum: SDL_GLattr{
	SDL_GL_FRAMEBUFFER_SRGB_CAPABLE    = 23,
}
static if(sdlSupport >= SDLSupport.v2_0_4)
enum: SDL_GLattr{
	deprecated("Please use `SDL_GL_CONTEXT_RELEASE_BEHAVIOR` instead") SDL_GL_RELEASE_BEHAVIOR = 24, //NOTE: this name was a typo to begin with
	SDL_GL_CONTEXT_RELEASE_BEHAVIOR    = 24,
}
static if(sdlSupport >= SDLSupport.v2_0_6)
enum: SDL_GLattr{
	SDL_GL_CONTEXT_RESET_NOTIFICATION  = 25,
	SDL_GL_CONTEXT_NO_ERROR            = 26,
}
static if(sdlSupport >= SDLSupport.v2_0_6)
enum: SDL_GLattr{
	SDL_GL_FLOATBUFFERS                = 27,
}

alias SDL_GLprofile = int;
enum: SDL_GLprofile{
	SDL_GL_CONTEXT_PROFILE_CORE             = 0x0001,
	SDL_GL_CONTEXT_PROFILE_COMPATIBILITY    = 0x0002,
	SDL_GL_CONTEXT_PROFILE_ES               = 0x0004,
}

alias SDL_GLcontextFlag = int;
enum: SDL_GLcontextFlag{
	SDL_GL_CONTEXT_DEBUG_FLAG                 = 0x0001,
	SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG    = 0x0002,
	SDL_GL_CONTEXT_ROBUST_ACCESS_FLAG         = 0x0004,
	SDL_GL_CONTEXT_RESET_ISOLATION_FLAG       = 0x0008,
}

static if(sdlSupport >= SDLSupport.v2_0_4){
	alias SDL_GLcontextReleaseFlag = int;
	enum: SDL_GLcontextReleaseFlag{
		SDL_GL_CONTEXT_RELEASE_BEHAVIOR_NONE     = 0x0000,
		SDL_GL_CONTEXT_RELEASE_BEHAVIOR_FLUSH    = 0x0001,
	}
	
	alias SDL_HitTestResult = int;
	enum: SDL_HitTestResult{
		SDL_HITTEST_NORMAL              = 0,
		SDL_HITTEST_DRAGGABLE           = 1,
		SDL_HITTEST_RESIZE_TOPLEFT      = 2,
		SDL_HITTEST_RESIZE_TOP          = 3,
		SDL_HITTEST_RESIZE_TOPRIGHT     = 4,
		SDL_HITTEST_RESIZE_RIGHT        = 5,
		SDL_HITTEST_RESIZE_BOTTOMRIGHT  = 6,
		SDL_HITTEST_RESIZE_BOTTOM       = 7,
		SDL_HITTEST_RESIZE_BOTTOMLEFT   = 8,
		SDL_HITTEST_RESIZE_LEFT         = 9,
	}
	
	import sdl.rect: SDL_Point;
	alias SDL_HitTest = extern(C) SDL_HitTestResult function(SDL_Window* win, const(SDL_Point)* area, void* data) nothrow;
}

static if(sdlSupport >= SDLSupport.v2_0_6){
	alias SDL_GLContextResetNotification = int;
	enum: SDL_GLContextResetNotification{
		SDL_GL_CONTEXT_RESET_NO_NOTIFICATION    = 0x0000,
		SDL_GL_CONTEXT_RESET_LOSE_CONTEXT       = 0x0001,
	}
}

mixin(joinFnBinds((){
	string[][] ret;
	ret ~= makeFnBinds([
		[q{int}, q{SDL_GetNumVideoDrivers}, q{}],
		[q{const(char)*}, q{SDL_GetVideoDriver}, q{int index}],
		[q{int}, q{SDL_VideoInit}, q{const(char)* driver_name}],
		[q{void}, q{SDL_VideoQuit}, q{}],
		[q{const(char)*}, q{SDL_GetCurrentVideoDriver}, q{}],
		[q{int}, q{SDL_GetNumVideoDisplays}, q{}],
		[q{const(char)*}, q{SDL_GetDisplayName}, q{int displayIndex}],
		[q{int}, q{SDL_GetDisplayBounds}, q{int displayIndex, SDL_Rect* rect}],
		[q{int}, q{SDL_GetNumDisplayModes}, q{int displayIndex}],
		[q{int}, q{SDL_GetDisplayMode}, q{int displayIndex, int modeIndex, SDL_DisplayMode* mode}],
		[q{int}, q{SDL_GetDesktopDisplayMode}, q{int displayIndex, SDL_DisplayMode* mode}],
		[q{int}, q{SDL_GetCurrentDisplayMode}, q{int displayIndex, SDL_DisplayMode* mode}],
		[q{SDL_DisplayMode*}, q{SDL_GetClosestDisplayMode}, q{int displayIndex, const(SDL_DisplayMode)* mode, SDL_DisplayMode* closest}],
		[q{int}, q{SDL_GetWindowDisplayIndex}, q{SDL_Window* window}],
		[q{int}, q{SDL_SetWindowDisplayMode}, q{SDL_Window* window, const(SDL_DisplayMode)* mode}],
		[q{int}, q{SDL_GetWindowDisplayMode}, q{SDL_Window* window, SDL_DisplayMode* mode}],
		[q{uint}, q{SDL_GetWindowPixelFormat}, q{SDL_Window* window}],
		[q{SDL_Window*}, q{SDL_CreateWindow}, q{const(char)* title, int x, int y, int w, int h, SDL_WindowFlags flags}],
		[q{SDL_Window*}, q{SDL_CreateWindowFrom}, q{const(void)* data}],
		[q{uint}, q{SDL_GetWindowID}, q{SDL_Window* window}],
		[q{SDL_Window*}, q{SDL_GetWindowFromID}, q{uint id}],
		[q{SDL_WindowFlags}, q{SDL_GetWindowFlags}, q{SDL_Window* window}],
		[q{void}, q{SDL_SetWindowTitle}, q{SDL_Window* window, const(char)* title}],
		[q{const(char)*}, q{SDL_GetWindowTitle}, q{SDL_Window* window}],
		[q{void}, q{SDL_SetWindowIcon}, q{SDL_Window* window, SDL_Surface* icon}],
		[q{void*}, q{SDL_SetWindowData}, q{SDL_Window* window, const(char)* name, void* userdata}],
		[q{void*}, q{SDL_GetWindowData}, q{SDL_Window* window, const(char)* name}],
		[q{void}, q{SDL_SetWindowPosition}, q{SDL_Window* window, int x, int y}],
		[q{void}, q{SDL_GetWindowPosition}, q{SDL_Window* window, int* x, int* y}],
		[q{void}, q{SDL_SetWindowSize}, q{SDL_Window* window, int w, int h}],
		[q{void}, q{SDL_GetWindowSize}, q{SDL_Window* window, int* w, int* h}],
		[q{void}, q{SDL_SetWindowMinimumSize}, q{SDL_Window* window, int min_w, int min_h}],
		[q{void}, q{SDL_GetWindowMinimumSize}, q{SDL_Window* window, int* w, int* h}],
		[q{void}, q{SDL_SetWindowMaximumSize}, q{SDL_Window* window, int max_w, int max_h}],
		[q{void}, q{SDL_GetWindowMaximumSize}, q{SDL_Window* window, int* w, int* h}],
		[q{void}, q{SDL_SetWindowBordered}, q{SDL_Window* window, SDL_bool bordered}],
		[q{void}, q{SDL_ShowWindow}, q{SDL_Window* window}],
		[q{void}, q{SDL_HideWindow}, q{SDL_Window* window}],
		[q{void}, q{SDL_RaiseWindow}, q{SDL_Window* window}],
		[q{void}, q{SDL_MaximizeWindow}, q{SDL_Window* window}],
		[q{void}, q{SDL_MinimizeWindow}, q{SDL_Window* window}],
		[q{void}, q{SDL_RestoreWindow}, q{SDL_Window* window}],
		[q{int}, q{SDL_SetWindowFullscreen}, q{SDL_Window* window, SDL_WindowFlags flags}],
		[q{SDL_Surface*}, q{SDL_GetWindowSurface}, q{SDL_Window* window}],
		[q{int}, q{SDL_UpdateWindowSurface}, q{SDL_Window* window}],
		[q{int}, q{SDL_UpdateWindowSurfaceRects}, q{SDL_Window* window, SDL_Rect* rects, int numrects}],
		[q{void}, q{SDL_SetWindowGrab}, q{SDL_Window* window, SDL_bool grabbed}],
		[q{SDL_bool}, q{SDL_GetWindowGrab}, q{SDL_Window* window}],
		[q{int}, q{SDL_SetWindowBrightness}, q{SDL_Window* window, float brightness}],
		[q{float}, q{SDL_GetWindowBrightness}, q{SDL_Window* window}],
		[q{int}, q{SDL_SetWindowGammaRamp}, q{SDL_Window* window, const(ushort)* red, const(ushort)* green, const(ushort)* blue}],
		[q{int}, q{SDL_GetWindowGammaRamp}, q{SDL_Window* window, ushort* red, ushort* green, ushort* blue}],
		[q{void}, q{SDL_DestroyWindow}, q{SDL_Window* window}],
		[q{SDL_bool}, q{SDL_IsScreenSaverEnabled}, q{}],
		[q{void}, q{SDL_EnableScreenSaver}, q{}],
		[q{void}, q{SDL_DisableScreenSaver}, q{}],
		[q{int}, q{SDL_GL_LoadLibrary}, q{const(char)* path}],
		[q{void*}, q{SDL_GL_GetProcAddress}, q{const(char)* proc}],
		[q{void}, q{SDL_GL_UnloadLibrary}, q{}],
		[q{SDL_bool}, q{SDL_GL_ExtensionSupported}, q{const(char)* extension}],
		[q{int}, q{SDL_GL_SetAttribute}, q{SDL_GLattr attr, int value}],
		[q{int}, q{SDL_GL_GetAttribute}, q{SDL_GLattr attr, int* value}],
		[q{SDL_GLContext}, q{SDL_GL_CreateContext}, q{SDL_Window* window}],
		[q{int}, q{SDL_GL_MakeCurrent}, q{SDL_Window* window, SDL_GLContext context}],
		[q{SDL_Window*}, q{SDL_GL_GetCurrentWindow}, q{}],
		[q{SDL_GLContext}, q{SDL_GL_GetCurrentContext}, q{}],
		[q{int}, q{SDL_GL_SetSwapInterval}, q{int interval}],
		[q{int}, q{SDL_GL_GetSwapInterval}, q{}],
		[q{void}, q{SDL_GL_SwapWindow}, q{SDL_Window* window}],
		[q{void}, q{SDL_GL_DeleteContext}, q{SDL_GLContext context}],
	]);
	static if(sdlSupport >= SDLSupport.v2_0_1){
		ret ~= makeFnBinds([
			[q{void}, q{SDL_GL_GetDrawableSize}, q{SDL_Window* window, int* w, int* h}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_2){
		ret ~= makeFnBinds([
			[q{void}, q{SDL_GL_ResetAttributes}, q{}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_4){
		ret ~= makeFnBinds([
			[q{int}, q{SDL_GetDisplayDPI}, q{int displayIndex, float* ddpi, float* hdpi, float* vdpi}],
			[q{SDL_Window*}, q{SDL_GetGrabbedWindow}, q{}],
			[q{int}, q{SDL_SetWindowHitTest}, q{SDL_Window* window, SDL_HitTest callback, void* callback_data}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_5){
		ret ~= makeFnBinds([
			[q{int}, q{SDL_GetDisplayUsableBounds}, q{int displayIndex, SDL_Rect* rect}],
			[q{int}, q{SDL_GetWindowBordersSize}, q{SDL_Window* window, int* top, int* left, int* bottom, int* right}],
			[q{int}, q{SDL_GetWindowOpacity}, q{SDL_Window* window, float* opacity}],
			[q{int}, q{SDL_SetWindowInputFocus}, q{SDL_Window* window}],
			[q{int}, q{SDL_SetWindowModalFor}, q{SDL_Window* modal_window, SDL_Window* parent_window}],
			[q{int}, q{SDL_SetWindowOpacity}, q{SDL_Window* window, float opacity}],
			[q{void}, q{SDL_SetWindowResizable}, q{SDL_Window* window, SDL_bool resizable}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_9){
		ret ~= makeFnBinds([
			[q{SDL_DisplayOrientation}, q{SDL_GetDisplayOrientation}, q{int displayIndex}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_16){
		ret ~= makeFnBinds([
			[q{int}, q{SDL_FlashWindow}, q{SDL_Window* window, SDL_FlashOperation operation}],
			[q{void}, q{SDL_SetWindowAlwaysOnTop}, q{SDL_Window* window, SDL_bool on_top}],
			[q{void}, q{SDL_SetWindowKeyboardGrab}, q{SDL_Window* window, SDL_bool grabbed}],
			[q{SDL_bool}, q{SDL_GetWindowKeyboardGrab}, q{SDL_Window * window}],
			[q{void}, q{SDL_SetWindowMouseGrab}, q{SDL_Window* window, SDL_bool grabbed}],
			[q{SDL_bool}, q{SDL_GetWindowMouseGrab}, q{SDL_Window* window}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_18){
		ret ~= makeFnBinds([
			[q{void*}, q{SDL_GetWindowICCProfile}, q{SDL_Window* window, size_t* size}],
			[q{int}, q{SDL_SetWindowMouseRect}, q{SDL_Window* window, const(SDL_Rect)* rect}],
			[q{const(SDL_Rect)*}, q{SDL_GetWindowMouseRect}, q{SDL_Window* window}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_24){
		ret ~= makeFnBinds([
			[q{int}, q{SDL_GetPointDisplayIndex}, q{const(SDL_Point)* point}],
			[q{int}, q{SDL_GetRectDisplayIndex}, q{const(SDL_Rect)* rect}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_26){
		ret ~= makeFnBinds([
			[q{void}, q{SDL_GetWindowSizeInPixels}, q{SDL_Window* window, int* w, int* h}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_28){
		ret ~= makeFnBinds([
			[q{SDL_bool}, q{SDL_HasWindowSurface}, q{SDL_Window* window}],
			[q{int}, q{SDL_DestroyWindowSurface}, q{SDL_Window* window}],
		]);
	}
	return ret;
}()));
