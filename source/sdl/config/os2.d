/+
+            Copyright 2022 – 2023 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.config.os2;

import bindbc.sdl.config;

version = SDL_AUDIO_DRIVER_DUMMY;
version = SDL_AUDIO_DRIVER_DISK;
static if(sdlSupport >= SDLSupport.v2_0_14){
	version = SDL_AUDIO_DRIVER_OS2;
}

version = SDL_POWER_DISABLED;
static if(sdlSupport >= SDLSupport.v2_0_18){
	version = SDL_JOYSTICK_OS2;
	version = SDL_HIDAPI_DISABLED;
}else{
	version = SDL_JOYSTICK_DISABLED;
}
version = SDL_HAPTIC_DISABLED;

version = SDL_SENSOR_DUMMY;
version = SDL_VIDEO_DRIVER_DUMMY;
static if(sdlSupport >= SDLSupport.v2_0_14){
	version = SDL_VIDEO_DRIVER_OS2;
}

static if(sdlSupport >= SDLSupport.v2_0_14){
	version = SDL_THREAD_OS2;
	version = SDL_LOADSO_OS2;
	version = SDL_TIMER_OS2;
	version = SDL_FILESYSTEM_OS2;
}else{
	version = SDL_LOADSO_DISABLED;
	version = SDL_THREADS_DISABLED;
	version = SDL_TIMERS_DISABLED;
	version = SDL_FILESYSTEM_DUMMY;
}

static if(sdlSupport < SDLSupport.v2_24){
	version = SDL_ASSEMBLY_ROUTINES;
}

static if(sdlSupport >= SDLSupport.v2_0_14){
	enum SDL_LIBSAMPLERATE_DYNAMIC = "SAMPRATE.DLL";
}
