/+
+            Copyright 2022 – 2023 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.config.winrt;

import core.sys.windows.sdkddkver: NTDDI_VERSION, NTDDI_WINBLUE;

version = SDL_AUDIO_DRIVER_WASAPI;
version = SDL_AUDIO_DRIVER_DISK;
version = SDL_AUDIO_DRIVER_DUMMY;

static if(__traits(compiles, WINAPI_FAMILY == WINAPI_FAMILY_PHONE_APP) && WINAPI_FAMILY == WINAPI_FAMILY_PHONE_APP){
	version = SDL_JOYSTICK_DISABLED;
	version = SDL_HAPTIC_DISABLED;
}else{
	version = SDL_JOYSTICK_VIRTUAL;
	version = SDL_JOYSTICK_XINPUT;
	version = SDL_HAPTIC_XINPUT;
}

version = SDL_SENSOR_DUMMY;

version = SDL_LOADSO_WINDOWS;

static if(NTDDI_VERSION >= NTDDI_WINBLUE){
	version = SDL_THREAD_WINDOWS;
}else{
	version = SDL_THREAD_STDCPP;
}

version = SDL_TIMER_WINDOWS;

version = SDL_VIDEO_DRIVER_WINRT;
version = SDL_VIDEO_DRIVER_DUMMY;

version = SDL_VIDEO_OPENGL_ES2;
version = SDL_VIDEO_OPENGL_EGL;

version = SDL_VIDEO_RENDER_D3D11;

version(SDL_VIDEO_OPENGL_ES2){
	version = SDL_VIDEO_RENDER_OGL_ES2;
}

version = SDL_POWER_WINRT;

version(Win64){
}else{
	version = SDL_ASSEMBLY_ROUTINES;
}
