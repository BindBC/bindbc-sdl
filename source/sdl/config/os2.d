/+
+            Copyright 2022 – 2023 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.config.os2;

version = SDL_AUDIO_DRIVER_DUMMY;
version = SDL_AUDIO_DRIVER_DISK;
version = SDL_AUDIO_DRIVER_OS2;

version = SDL_POWER_DISABLED;
version = SDL_JOYSTICK_DISABLED;
version = SDL_HAPTIC_DISABLED;

version = SDL_SENSOR_DUMMY;
version = SDL_VIDEO_DRIVER_DUMMY;
version = SDL_VIDEO_DRIVER_OS2;

version = SDL_THREAD_OS2;
version = SDL_LOADSO_OS2;
version = SDL_TIMER_OS2;
version = SDL_FILESYSTEM_OS2;

version = SDL_ASSEMBLY_ROUTINES;

enum SDL_LIBSAMPLERATE_DYNAMIC = "SAMPRATE.DLL";
