/+
+            Copyright 2022 – 2023 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.config.windows;

static if(_WIN32_WINNT >= 0x0601){
	version = SDL_WINDOWS7_SDK;
}
static if(_WIN32_WINNT >= 0x0602){
	version = SDL_WINDOWS8_SDK;
}
static if(_WIN32_WINNT >= 0x0A00){
	version = SDL_WINDOWS10_SDK;
}

version = SDL_AUDIO_DRIVER_WASAPI;
version = SDL_AUDIO_DRIVER_DSOUND;
version = SDL_AUDIO_DRIVER_WINMM;
version = SDL_AUDIO_DRIVER_DISK;
version = SDL_AUDIO_DRIVER_DUMMY;

version = SDL_JOYSTICK_DINPUT;
version = SDL_JOYSTICK_HIDAPI;
version(WinRT){
}else{
	version = SDL_JOYSTICK_RAWINPUT;
}
version = SDL_JOYSTICK_VIRTUAL;
version(SDL_WINDOWS10_SDK){
	version = SDL_JOYSTICK_WGI;
}
version = SDL_JOYSTICK_XINPUT;
version = SDL_HAPTIC_DINPUT;
version = SDL_HAPTIC_XINPUT;

version = SDL_SENSOR_WINDOWS;

version = SDL_LOADSO_WINDOWS;

version = SDL_THREAD_WINDOWS;

version = SDL_TIMER_WINDOWS;

version = SDL_VIDEO_DRIVER_DUMMY;
version = SDL_VIDEO_DRIVER_WINDOWS;

version = SDL_VIDEO_RENDER_D3D;
version(SDL_WINDOWS7_SDK){
	version = SDL_VIDEO_RENDER_D3D11;
}

version = SDL_VIDEO_OPENGL;
version = SDL_VIDEO_OPENGL_WGL;
version = SDL_VIDEO_RENDER_OGL;
version = SDL_VIDEO_RENDER_OGL_ES2;
version = SDL_VIDEO_OPENGL_ES2;
version = SDL_VIDEO_OPENGL_EGL;

version = SDL_VIDEO_VULKAN;

version = SDL_POWER_WINDOWS;

version = SDL_FILESYSTEM_WINDOWS;

version(Win64){
}else{
	version = SDL_ASSEMBLY_ROUTINES;
}
