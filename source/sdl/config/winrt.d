/+
+            Copyright 2022 – 2023 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.config.winrt;

import bindbc.sdl.config;
static if(sdlSupport >= SDLSupport.v2_0_4){
	import core.sys.windows.sdkddkver: NTDDI_VERSION, NTDDI_WINBLUE;
	enum NTDDI_WIN10 = 0x0A000000;
}

static if(sdlSupport >= SDLSupport.v2_0_8){
	version = SDL_AUDIO_DRIVER_WASAPI;
}else{
	version = SDL_AUDIO_DRIVER_XAUDIO2;
}
version = SDL_AUDIO_DRIVER_DISK;
version = SDL_AUDIO_DRIVER_DUMMY;

static if(sdlSupport < SDLSupport.v2_0_4){
	version = SDL_HAPTIC_DISABLED;
}

static if(__traits(compiles, WINAPI_FAMILY == WINAPI_FAMILY_PHONE_APP) && WINAPI_FAMILY == WINAPI_FAMILY_PHONE_APP){
	version = SDL_JOYSTICK_DISABLED;
	static if(sdlSupport >= SDLSupport.v2_0_4){
		version = SDL_HAPTIC_DISABLED;
	}
}else{
	static if(sdlSupport >= SDLSupport.v2_0_18 && NTDDI_VERSION >= NTDDI_WIN10){
		version = SDL_JOYSTICK_WGI;
		version = SDL_HAPTIC_DISABLED;
	}else{
		version = SDL_JOYSTICK_XINPUT;
		static if(sdlSupport >= SDLSupport.v2_0_4){
			version = SDL_HAPTIC_XINPUT;
		}
	}
	static if(sdlSupport >= SDLSupport.v2_0_14){
		version = SDL_JOYSTICK_VIRTUAL;
	}
}

static if(sdlSupport >= SDLSupport.v2_0_9){
	version = SDL_SENSOR_DUMMY;
}

version = SDL_LOADSO_WINDOWS;

static if(sdlSupport >= SDLSupport.v2_0_4){
	static if(NTDDI_VERSION >= NTDDI_WINBLUE){
		version = SDL_THREAD_WINDOWS;
		static if(sdlSupport >= SDLSupport.v2_0_16){
			version = SDL_THREAD_GENERIC_COND_SUFFIX;
		}
	}else{
		version = SDL_THREAD_STDCPP;
	}
}else{
	version = SDL_THREAD_WINDOWS;
	
	version = SDL_THREAD_STDCPP;
}

version = SDL_TIMER_WINDOWS;

version = SDL_VIDEO_DRIVER_WINRT;
version = SDL_VIDEO_DRIVER_DUMMY;

static if(sdlSupport >= SDLSupport.v2_0_4 || (__traits(compiles, WINAPI_FAMILY != WINAPI_FAMILY_PHONE_APP) && WINAPI_FAMILY != WINAPI_FAMILY_PHONE_APP)){
	//was conditional in 2.0.3, but made unconditional in 2.0.4
	version = SDL_VIDEO_OPENGL_ES2;
	version = SDL_VIDEO_OPENGL_EGL;
}

version = SDL_VIDEO_RENDER_D3D11;

version(SDL_VIDEO_OPENGL_ES2){
	version = SDL_VIDEO_RENDER_OGL_ES2;
}

version = SDL_POWER_WINRT;

static if(sdlSupport < SDLSupport.v2_24){
	version(Win64){
	}else{
		version = SDL_ASSEMBLY_ROUTINES;
	}
}
