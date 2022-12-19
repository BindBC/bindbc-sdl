/+
+            Copyright 2022 – 2023 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.config.iphoneos;

#define SDL_AUDIO_DRIVER_COREAUDIO 1
#define SDL_AUDIO_DRIVER_DUMMY  1

#define SDL_HAPTIC_DUMMY 1

#define SDL_JOYSTICK_MFI 1
#define SDL_JOYSTICK_VIRTUAL    1

#ifdef __TVOS__
#define SDL_SENSOR_DUMMY    1
#else
/* Enable the CoreMotion sensor driver */
#define SDL_SENSOR_COREMOTION   1
#endif

#define SDL_LOADSO_DLOPEN 1

#define SDL_THREAD_PTHREAD  1
#define SDL_THREAD_PTHREAD_RECURSIVE_MUTEX  1

#define SDL_TIMER_UNIX  1

#define SDL_VIDEO_DRIVER_UIKIT  1
#define SDL_VIDEO_DRIVER_DUMMY  1

#define SDL_VIDEO_OPENGL_ES2 1
#define SDL_VIDEO_OPENGL_ES 1
#define SDL_VIDEO_RENDER_OGL_ES 1
#define SDL_VIDEO_RENDER_OGL_ES2    1

/* Metal supported on 64-bit devices running iOS 8.0 and tvOS 9.0 and newer
   Also supported in simulator from iOS 13.0 and tvOS 13.0
 */
//#if (TARGET_OS_SIMULATOR && ((__IPHONE_OS_VERSION_MIN_REQUIRED >= 130000) || (__TV_OS_VERSION_MIN_REQUIRED >= 130000))) || (!TARGET_CPU_ARM && ((__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 90000)))
#define SDL_PLATFORM_SUPPORTS_METAL	1
//#endif

#if SDL_PLATFORM_SUPPORTS_METAL
#define SDL_VIDEO_RENDER_METAL  1
#endif

#if SDL_PLATFORM_SUPPORTS_METAL
#define SDL_VIDEO_VULKAN 1
#endif

#if SDL_PLATFORM_SUPPORTS_METAL
#define SDL_VIDEO_METAL 1
#endif

#define SDL_POWER_UIKIT 1

#define SDL_IPHONE_KEYBOARD 1

#define SDL_IPHONE_LAUNCHSCREEN 1

#define SDL_FILESYSTEM_COCOA   1
