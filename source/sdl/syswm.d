/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.syswm;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

import sdl.stdinc: SDL_bool;
import sdl.version_: SDL_version;
import sdl.video: SDL_Window;

version(Windows){
	import core.sys.windows.windef: HWND, UINT, WPARAM, LPARAM, HDC, HINSTANCE;
}

alias SDL_SYSWM_TYPE = int;
enum: SDL_SYSWM_TYPE{
	SDL_SYSWM_UNKNOWN     = 0,
	SDL_SYSWM_WINDOWS     = 1,
	SDL_SYSWM_X11         = 2,
	SDL_SYSWM_DIRECTFB    = 3,
	SDL_SYSWM_COCOA       = 4,
	SDL_SYSWM_UIKIT       = 5,
}
static if(sdlSupport >= SDLSupport.v2_0_2)
enum: SDL_SYSWM_TYPE{
	SDL_SYSWM_WAYLAND     = 6,
	SDL_SYSWM_MIR         = 7,
}
static if(sdlSupport >= SDLSupport.v2_0_3)
enum: SDL_SYSWM_TYPE{
	SDL_SYSWM_WINRT       = 8,
}
static if(sdlSupport >= SDLSupport.v2_0_4)
enum: SDL_SYSWM_TYPE{
	SDL_SYSWM_ANDROID     = 9,
}
static if(sdlSupport >= SDLSupport.v2_0_5)
enum: SDL_SYSWM_TYPE{
	SDL_SYSWM_VIVANTE     = 10,
}
static if(sdlSupport >= SDLSupport.v2_0_6)
enum: SDL_SYSWM_TYPE{
	SDL_SYSWM_OS2         = 11,
}
static if(sdlSupport >= SDLSupport.v2_0_12)
enum: SDL_SYSWM_TYPE{
	SDL_SYSWM_HAIKU       = 12,
}
static if(sdlSupport >= SDLSupport.v2_0_16)
enum: SDL_SYSWM_TYPE{
	SDL_SYSWM_KMSDRM      = 13,
}
static if(sdlSupport >= SDLSupport.v2_0_18)
enum: SDL_SYSWM_TYPE{
	SDL_SYSWM_RISCOS      = 14,
}

struct SDL_SysWMmsg{
	SDL_version version_;
	SDL_SYSWM_TYPE subsystem;
	union _Msg{
		version(Windows){
			struct _Win{
				HWND hwnd;
				UINT msg;
				WPARAM wParam;
				LPARAM lParam;
			}
			_Win win;
		}
		version(linux){
			version(SDL_NoX11){}
			else:
			struct _X11{
				//XEvent event;
				int pad1;
				c_long[24] pad2;
			}
			_X11 x11;
		}
		version(DirectFB){
			struct _DFB{
				//DFBEvent event;
				int clazz; //DFBEventClass clazz;
				void* pad;
			}
			_DFB dfb;
		}
		version(OSX){
			struct _Cocoa{
				int dummy;
			}
			_Cocoa cocoa;
		}
		version(iOS){
			struct _UIKit{
				int dummy;
			}
			_UIKit uikit;
		}
		static if(sdlSupport >= SDLSupport.v2_0_5) version(Vivante){
			struct _Vivante{
				int dummy;
			}
			_Vivante vivante;
		}
		static if(sdlSupport >= SDLSupport.v2_0_14) version(OS2){
			struct _OS2{
				c_ulong fFrame; //BOOL fFrame;
				c_ulong hwnd; //HWND hwnd;
				c_ulong msg; //ULONG msg;
				void* mp1; //MPARAM mp1;
				void* mp2; //MPARAM mp2;
			}
			_OS2 os2;
		}
		int dummy;
	}
	_Msg msg;
}

struct SDL_SysWMinfo{
	SDL_version version_;
	SDL_SYSWM_TYPE subsystem;

	union _Info{
		version(Windows){
			struct _Win{
				HWND window;
				static if(sdlSupport >= SDLSupport.v2_0_4):
				HDC hdc;
				static if(sdlSupport >= SDLSupport.v2_0_6):
				HINSTANCE hinstance;
			}
			_Win win;
		}
		version(WinRT){
			struct _WinRT{
				void* window;
			}
			_WinRT winrt;
		}
		version(linux){
			version(SDL_NoX11){}
			else:
			struct _X11{
				void* display;
				uint window;
			}
			_X11 x11;
		}
		version(DirectFB){
			struct _DFB{
				void* dfb;
				void* window;
				void* surface;
			}
			_DFB dfb;
		}
		version(OSX){
			struct _Cocoa{
				void* window;
			}
			_Cocoa cocoa;
		}
		version(iOS){
			struct _UIKit{
				void* window;
				static if(sdlSupport >= SDLSupport.v2_0_4){
					uint framebuffer;
					uint colorbuffer;
					alias colourbuffer = colorbuffer;
					uint resolveFramebuffer;
				}
			}
			_UIKit uikit;
		}
		static if(sdlSupport >= SDLSupport.v2_0_2) version(linux){
			struct _WL{
				void* display;
				void* surface;
				void* shell_surface;
				static if(sdlSupport >= SDLSupport.v2_0_16):
				void* egl_window;
				void* xdg_surface;
				static if(sdlSupport >= SDLSupport.v2_0_18):
				void* xdg_toplevel;
				static if(sdlSupport >= SDLSupport.v2_0_22):
				void* xdg_popup;
				void* xdg_positioner;
			}
			_WL wl;
		}
		static if(sdlSupport >= SDLSupport.v2_0_2) version(Mir){
			struct _Mir{
				void* connection;
				void* surface;
			}
			_Mir mir;
		}
		static if(sdlSupport >= SDLSupport.v2_0_4) version(Android){
			struct _Android{
				void* window;
				void* surface;
			}
			_Android android;
		}
		static if(sdlSupport >= SDLSupport.v2_0_14) version(OS2){
			struct _OS2{
				void* hwnd; //HWND hwnd;
				void* hwndFrame; //HWND hwndFrame;
			}
			_OS2 os2;
		}
		static if(sdlSupport >= SDLSupport.v2_0_5) version(Vivante){
			struct _Vivante{
				void* display;
				void* window;
			}
			_Vivante vivante;
		}
		static if(sdlSupport >= SDLSupport.v2_0_16) version(KMSDRM){
			struct _KMSDRM{
				int dev_index;
				int drm_fd;
				void* gbm_dev;
			}
			_KMSDRM kmsdrm;
		}
		static if(sdlSupport >= SDLSupport.v2_0_6) ubyte[64] dummy;
		else int dummy;
	}
	_Info info;
}

mixin(joinFnBinds((){
	string[][] ret;
	ret ~= makeFnBinds([
		[q{SDL_bool}, q{SDL_GetWindowWMInfo}, q{SDL_Window* window, SDL_SysWMinfo* info}],
	]);
	return ret;
}()));
