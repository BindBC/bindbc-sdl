/+
+            Copyright 2022 – 2023 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.config.ngage;

import bindbc.sdl.config;

version = SDL_THREAD_NGAGE;

version = SDL_TIMER_NGAGE;

version = SDL_VIDEO_DRIVER_NGAGE;

version = SDL_AUDIO_DRIVER_DUMMY;

version = SDL_JOYSTICK_DISABLED;

version = SDL_HAPTIC_DISABLED;

version = SDL_HIDAPI_DISABLED;

version = SDL_SENSOR_DISABLED;

version = SDL_LOADSO_DISABLED;

version = SDL_FILESYSTEM_DUMMY;
