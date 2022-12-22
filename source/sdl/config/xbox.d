/+
+            Copyright 2022 – 2023 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.config.xbox;

import bindbc.sdl.config;

version = SDL_AUDIO_DRIVER_WASAPI;
version = SDL_AUDIO_DRIVER_DISK;
version = SDL_AUDIO_DRIVER_DUMMY;

version = SDL_JOYSTICK_VIRTUAL;
version = SDL_JOYSTICK_WGI;
version = SDL_JOYSTICK_XINPUT;
version = SDL_HAPTIC_XINPUT;

version = SDL_SENSOR_WINDOWS;

version = SDL_LOADSO_WINDOWS;

version = SDL_THREAD_GENERIC_COND_SUFFIX;
version = SDL_THREAD_WINDOWS;

version = SDL_TIMER_WINDOWS;

version = SDL_VIDEO_DRIVER_DUMMY;
version = SDL_VIDEO_DRIVER_WINDOWS;

version = SDL_VIDEO_RENDER_D3D11;
version = SDL_VIDEO_RENDER_D3D12;

version = SDL_POWER_HARDWIRED;

version = SDL_FILESYSTEM_XBOX;

version = SDL_DISABLE_WINDOWS_IME;
