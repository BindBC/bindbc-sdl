/+
+            Copyright 2022 – 2023 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.config.emscripten;

import bindbc.sdl.config;

version = SDL_CPUINFO_DISABLED;
version = SDL_HAPTIC_DISABLED;
version = SDL_HIDAPI_DISABLED;
version(Emscripten_Pthreads){
}else{
	version = SDL_THREADS_DISABLED;
}

version = SDL_AUDIO_DRIVER_DISK;
version = SDL_AUDIO_DRIVER_DUMMY;
version = SDL_AUDIO_DRIVER_EMSCRIPTEN;

version = SDL_JOYSTICK_EMSCRIPTEN;

version = SDL_SENSOR_DUMMY;

version = SDL_LOADSO_DLOPEN;

version(Emscripten_Pthreads){
	version = SDL_THREAD_PTHREAD;
	static if(sdlSupport >= SDLSupport.v2_0_22){
		version = SDL_THREAD_PTHREAD_RECURSIVE_MUTEX;
	}
}

version = SDL_TIMER_UNIX;

version = SDL_VIDEO_DRIVER_EMSCRIPTEN;

version = SDL_VIDEO_RENDER_OGL_ES2;

version = SDL_VIDEO_OPENGL_ES2;
version = SDL_VIDEO_OPENGL_EGL;

version = SDL_POWER_EMSCRIPTEN;

version = SDL_FILESYSTEM_EMSCRIPTEN;
