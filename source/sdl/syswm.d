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
	union msg_{
		version(SDL_VIDEO_DRIVER_WINDOWS){
			import core.sys.windows.windef;
			struct Win_{
				HWND hwnd;
				UINT msg;
				WPARAM wParam;
				LPARAM lParam;
			}
			Win_ win;
		}
		version(linux)
			struct X11_{
				XEvent event;
			}
			X11_ x11;
		}
		version(DirectFB){
			struct dfb_{
				DFBEvent event;
			}
			dfb_ dfb;
		}
		version(OSX){
			struct cocoa_{
				int dummy;
			}
			cocoa_ cocoa;
		}
		version(iOS){
			struct uikit_{
				int dummy;
			}
			uikit_ uikit;
		}
		static if(sdlSupport >= SDLSupport.v2_0_5) version(Vivante){
			struct vivante_{
				int dummy;
			}
			vivante_ vivante;
		}
		static if(sdlSupport >= SDLSupport.v2_0_14) version(OS2){
			struct os2_{
				BOOL fFrame;
				HWND hwnd;
				ULONG msg;
				MPARAM mp1;
				MPARAM mp2;
			}
			os2_ os2;
		}
		int dummy;
	}
	msg_ msg;
}

struct SDL_SysWMinfo{
	SDL_version version_;
	SDL_SYSWM_TYPE subsystem;

	union info_{
		version(Windows){
			struct win_{
				void* window;
				static if(sdlSupport >= SDLSupport.v2_0_4)
					void* hdc;
				static if(sdlSupport >= SDLSupport.v2_0_6)
					void* hinstance;
			}
			win_ win;
		}else version(OSX){
			struct cocoa_{
				void* window;
			}
			cocoa_ cocoa;
			
			struct uikit_{
				void *window;
			}
			uikit_ uikit;
		}else version(linux){
			struct dfb_{
				void *dfb;
				void *window;
				void *surface;
			}
			dfb_ dfb;
			
			static if(sdlSupport >= SDLSupport.v2_0_2){
				struct mir_{
					void *connection;
					void *surface;
				}
				mir_ mir;
			}
		}
		version(Posix){
			struct x11_{
				void* display;
				uint window;
			}
			x11_ x11;
			
			static if(sdlSupport >= SDLSupport.v2_0_2){
				struct wl_{
					void *display;
					void *surface;
					void *shell_surface;
				}
				wl_ wl;
			}
		}
		static if(sdlSupport >= SDLSupport.v2_0_4){
			version(Android){
				struct android_{
					void* window;
					void* surface;
				}
				android_ android;
			}
		}
		static if(sdlSupport >= SDLSupport.v2_0_6) ubyte[64] dummy;
		else int dummy;
	}
	info_ info;
}

mixin(joinFnBinds((){
	string[][] ret;
	ret ~= makeFnBinds([
		[q{SDL_bool}, q{SDL_GetWindowWMInfo}, q{SDL_Window* window, SDL_SysWMinfo* info}],
	]);
	return ret;
}()));
