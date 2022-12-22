/+
+            Copyright 2022 – 2023 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.config.psp;

import bindbc.sdl.config;

version = LACKS_SYS_MMAN_H;

version = SDL_THREAD_PSP;

static if(sdlSupport >= SDLSupport.v2_0_20){
	version = SDL_TIMER_PSP;
}else{
	version = SDL_TIMERS_PSP;
}

version = SDL_JOYSTICK_PSP;
static if(sdlSupport >= SDLSupport.v2_0_14){
	version = SDL_JOYSTICK_VIRTUAL;
}

version = SDL_AUDIO_DRIVER_PSP;

version = SDL_VIDEO_DRIVER_PSP;

version = SDL_VIDEO_RENDER_PSP;

version = SDL_POWER_PSP;

static if(sdlSupport >= SDLSupport.v2_0_20){
	version = SDL_FILESYSTEM_PSP;
}else static if(sdlSupport >= SDLSupport.v2_0_1){
	version = SDL_FILESYSTEM_DUMMY;
}

version = SDL_HAPTIC_DISABLED;

static if(sdlSupport >= SDLSupport.v2_0_18){
	version = SDL_HIDAPI_DISABLED;
}

version = SDL_LOADSO_DISABLED;
