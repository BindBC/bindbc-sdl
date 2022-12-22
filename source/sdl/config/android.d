/+
+            Copyright 2022 – 2023 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.config.android;

import bindbc.sdl.config;

version = SDL_AUDIO_DRIVER_ANDROID;
static if(sdlSupport >= SDLSupport.v2_0_9){
	version = SDL_AUDIO_DRIVER_OPENSLES;
}
static if(sdlSupport >= SDLSupport.v2_0_18){
	version = SDL_AUDIO_DRIVER_AAUDIO;
}
version = SDL_AUDIO_DRIVER_DUMMY;

version = SDL_JOYSTICK_ANDROID;
static if(sdlSupport >= SDLSupport.v2_0_9){
	version = SDL_JOYSTICK_HIDAPI;
}
static if(sdlSupport >= SDLSupport.v2_0_14){
	version = SDL_JOYSTICK_VIRTUAL;
}
static if(sdlSupport >= SDLSupport.v2_0_6){
	version = SDL_HAPTIC_ANDROID;
}else{
	version = SDL_HAPTIC_DUMMY;
}

static if(sdlSupport >= SDLSupport.v2_0_9){
	version = SDL_SENSOR_ANDROID;
}

version = SDL_LOADSO_DLOPEN;

version = SDL_THREAD_PTHREAD;
version = SDL_THREAD_PTHREAD_RECURSIVE_MUTEX;

version = SDL_TIMER_UNIX;

version = SDL_VIDEO_DRIVER_ANDROID;

version = SDL_VIDEO_OPENGL_ES;
version = SDL_VIDEO_RENDER_OGL_ES;
version = SDL_VIDEO_RENDER_OGL_ES2;

static if(sdlSupport >= SDLSupport.v2_0_4){
	//#if defined(__ARM_ARCH) && __ARM_ARCH < 7
	//#else
	version = SDL_VIDEO_VULKAN;
	//#endif
}

version = SDL_POWER_ANDROID;

static if(sdlSupport >= SDLSupport.v2_0_4){
	version = SDL_FILESYSTEM_ANDROID;
}else static if(sdlSupport >= SDLSupport.v2_0_1){
	version = SDL_FILESYSTEM_DUMMY;
}
