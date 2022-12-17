/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.syswm;

import bindbc.sdl.config;

import sdl.stdinc: SDL_bool;
import sdl.version_: SDL_version;
import sdl.video: SDL_Window;

alias SDL_SYSWM_TYPE = int;
enum: SDL_SYSWM_TYPE{
	SDL_SYSWM_UNKNOWN,
	SDL_SYSWM_WINDOWS,
	SDL_SYSWM_X11,
	SDL_SYSWM_DIRECTFB,
	SDL_SYSWM_COCOA,
	SDL_SYSWM_UIKIT,
}
static if(sdlSupport >= SDLSupport.v2_0_2)
enum: SDL_SYSWM_TYPE{
	SDL_SYSWM_WAYLAND,
	SDL_SYSWM_MIR,
}
static if(sdlSupport >= SDLSupport.v2_0_3)
enum: SDL_SYSWM_TYPE{
	SDL_SYSWM_WINRT,
}
static if(sdlSupport >= SDLSupport.v2_0_4)
enum: SDL_SYSWM_TYPE{
	SDL_SYSWM_ANDROID,
}
static if(sdlSupport >= SDLSupport.v2_0_5)
enum: SDL_SYSWM_TYPE{
	SDL_SYSWM_VIVANTE,
}
static if(sdlSupport >= SDLSupport.v2_0_6)
enum: SDL_SYSWM_TYPE{
	SDL_SYSWM_OS2,
}
static if(sdlSupport >= SDLSupport.v2_0_12)
enum: SDL_SYSWM_TYPE{
	SDL_SYSWM_HAIKU,
}

version(Windows){
	// I don't want to import core.sys.windows.windows just for these
	version(Win64){
		alias wparam = ulong;
		alias lparam = long;
	}else{
		alias wparam = uint;
		alias lparam = int;
	}
}

struct SDL_SysWMmsg{
	SDL_version version_;
	SDL_SYSWM_TYPE subsystem;
	union msg_{
		version(Windows){
			struct win_{
				void* hwnd;
				uint msg;
				wparam wParam;
				lparam lParam;
			}
			win_ win;
		}else version(OSX){
			struct cocoa_{
				int dummy;
			}
			cocoa_ cocoa;
		}else version(linux){
			struct dfb_{
				void* event;
			}
			dfb_ dfb;
		}
		
		version(Posix){
			struct x11_{
				c_long[24] pad; // sufficient size for any X11 event
			}
			x11_ x11;
		}
		
		static if(sdlSupport >= SDLSupport.v2_0_5){
			struct vivante_{
				int dummy;
			}
			vivante_ vivante;
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
