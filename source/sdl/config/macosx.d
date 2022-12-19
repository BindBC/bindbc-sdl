/+
+            Copyright 2022 – 2023 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.config.macosx;

version = SDL_AUDIO_DRIVER_COREAUDIO;
version = SDL_AUDIO_DRIVER_DISK;
version = SDL_AUDIO_DRIVER_DUMMY;

version = SDL_JOYSTICK_HIDAPI;
version = SDL_JOYSTICK_IOKIT;
version = SDL_JOYSTICK_VIRTUAL;
version = SDL_HAPTIC_IOKIT;

//#if MAC_OS_X_VERSION_MIN_REQUIRED >= 1080 && !defined(__i386__)
version = SDL_JOYSTICK_MFI;
//#endif

version = SDL_SENSOR_DUMMY;

version = SDL_LOADSO_DLOPEN;

version = SDL_THREAD_PTHREAD;
version = SDL_THREAD_PTHREAD_RECURSIVE_MUTEX;

version = SDL_TIMER_UNIX;

version = SDL_VIDEO_DRIVER_COCOA;
version = SDL_VIDEO_DRIVER_DUMMY;
//#undef SDL_VIDEO_DRIVER_X11
enum SDL_VIDEO_DRIVER_X11_DYNAMIC = "/opt/X11/lib/libX11.6.dylib";
enum SDL_VIDEO_DRIVER_X11_DYNAMIC_XEXT = "/opt/X11/lib/libXext.6.dylib";
enum SDL_VIDEO_DRIVER_X11_DYNAMIC_XINERAMA = "/opt/X11/lib/libXinerama.1.dylib";
enum SDL_VIDEO_DRIVER_X11_DYNAMIC_XINPUT2 = "/opt/X11/lib/libXi.6.dylib";
enum SDL_VIDEO_DRIVER_X11_DYNAMIC_XRANDR = "/opt/X11/lib/libXrandr.2.dylib";
enum SDL_VIDEO_DRIVER_X11_DYNAMIC_XSS = "/opt/X11/lib/libXss.1.dylib";
enum SDL_VIDEO_DRIVER_X11_DYNAMIC_XVIDMODE = "/opt/X11/lib/libXxf86vm.1.dylib";
version = SDL_VIDEO_DRIVER_X11_XDBE;
version = SDL_VIDEO_DRIVER_X11_XINERAMA;
version = SDL_VIDEO_DRIVER_X11_XRANDR;
version = SDL_VIDEO_DRIVER_X11_XSCRNSAVER;
version = SDL_VIDEO_DRIVER_X11_XSHAPE;
version = SDL_VIDEO_DRIVER_X11_XVIDMODE;
version = SDL_VIDEO_DRIVER_X11_HAS_XKBKEYCODETOKEYSYM;

//#ifdef MAC_OS_X_VERSION_10_8
version = SDL_VIDEO_DRIVER_X11_XINPUT2;
version = SDL_VIDEO_DRIVER_X11_SUPPORTS_GENERIC_EVENTS;
version = SDL_VIDEO_DRIVER_X11_CONST_PARAM_XEXTADDDISPLAY;
//#endif

version = SDL_VIDEO_RENDER_OGL;

version = SDL_VIDEO_RENDER_OGL_ES2;

/* Metal only supported on 64-bit architectures with 10.11+ */
//#if TARGET_RT_64_BIT && (MAC_OS_X_VERSION_MAX_ALLOWED >= 101100)
version = SDL_PLATFORM_SUPPORTS_METAL;
//#else
//version = SDL_PLATFORM_SUPPORTS_METAL;    0
//#endif

version(SDL_PLATFORM_SUPPORTS_METAL){
	version = SDL_VIDEO_RENDER_METAL;
}

version = SDL_VIDEO_OPENGL;
version = SDL_VIDEO_OPENGL_ES2;
version = SDL_VIDEO_OPENGL_EGL;
version = SDL_VIDEO_OPENGL_CGL;
version = SDL_VIDEO_OPENGL_GLX;

version(SDL_PLATFORM_SUPPORTS_METAL){
	version = SDL_VIDEO_VULKAN;
}

version(SDL_PLATFORM_SUPPORTS_METAL){
	version = SDL_VIDEO_METAL;
}

version = SDL_POWER_MACOSX;

version = SDL_FILESYSTEM_COCOA;
