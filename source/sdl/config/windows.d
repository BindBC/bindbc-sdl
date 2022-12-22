/+
+            Copyright 2022 – 2023 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.config.windows;

import bindbc.sdl.config;

static if(sdlSupport >= SDLSupport.v2_0_14){
	import core.sys.windows.w32api: _WIN32_WINNT;
	static if(_WIN32_WINNT >= 0x0601){
		version = SDL_WINDOWS7_SDK;
	}
	static if(_WIN32_WINNT >= 0x0602){
		version = SDL_WINDOWS8_SDK;
	}
	static if(_WIN32_WINNT >= 0x0A00){
		version = SDL_WINDOWS10_SDK;
	}
}

static if(sdlSupport >= SDLSupport.v2_0_6){
	version = SDL_AUDIO_DRIVER_WASAPI;
}else{
	version = SDL_AUDIO_DRIVER_XAUDIO2;
}
version = SDL_AUDIO_DRIVER_DSOUND;
version = SDL_AUDIO_DRIVER_WINMM;
version = SDL_AUDIO_DRIVER_DISK;
version = SDL_AUDIO_DRIVER_DUMMY;

version = SDL_JOYSTICK_DINPUT;
version = SDL_HAPTIC_DINPUT;
static if(sdlSupport >= SDLSupport.v2_0_4){
	version = SDL_JOYSTICK_XINPUT;
	version = SDL_HAPTIC_XINPUT;
}
static if(sdlSupport >= SDLSupport.v2_0_9){
	version = SDL_JOYSTICK_HIDAPI;
}
static if(sdlSupport >= SDLSupport.v2_0_14){
	version(UWP){
		version = SDL_JOYSTICK_RAWINPUT;
	}
	version = SDL_JOYSTICK_VIRTUAL;
	version(SDL_WINDOWS10_SDK){
		version = SDL_JOYSTICK_WGI;
	}
}

static if(sdlSupport >= SDLSupport.v2_0_14){
	version = SDL_SENSOR_WINDOWS;
}else static if(sdlSupport >= SDLSupport.v2_0_9){
	version = SDL_SENSOR_DUMMY;
}

version = SDL_LOADSO_WINDOWS;

version = SDL_THREAD_WINDOWS;
static if(sdlSupport >= SDLSupport.v2_0_16){
	version = SDL_THREAD_GENERIC_COND_SUFFIX;
}

version = SDL_TIMER_WINDOWS;

version = SDL_VIDEO_DRIVER_DUMMY;
version = SDL_VIDEO_DRIVER_WINDOWS;

version = SDL_VIDEO_RENDER_D3D;
static if(sdlSupport >= SDLSupport.v2_0_14){
	version(SDL_WINDOWS7_SDK){
		version = SDL_VIDEO_RENDER_D3D11;
	}
}
static if(sdlSupport >= SDLSupport.v2_24){
	version = SDL_VIDEO_RENDER_D3D12;
}

version = SDL_VIDEO_OPENGL;
version = SDL_VIDEO_OPENGL_WGL;
version = SDL_VIDEO_RENDER_OGL;
static if(sdlSupport >= SDLSupport.v2_0_2){
	version = SDL_VIDEO_RENDER_OGL_ES2;
	version = SDL_VIDEO_OPENGL_ES2;
	version = SDL_VIDEO_OPENGL_EGL;
}

static if(sdlSupport >= SDLSupport.v2_0_6){
	version = SDL_VIDEO_VULKAN;
}

version = SDL_POWER_WINDOWS;

static if(sdlSupport >= SDLSupport.v2_0_1){
	version = SDL_FILESYSTEM_WINDOWS;
}

static if(sdlSupport < SDLSupport.v2_24){
	version(Win64){
	}else{
		version = SDL_ASSEMBLY_ROUTINES;
	}
}
