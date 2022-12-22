/+
+            Copyright 2022 – 2023 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.config.iphoneos;

import bindbc.sdl.config;

version = SDL_AUDIO_DRIVER_COREAUDIO;
version = SDL_AUDIO_DRIVER_DUMMY;

static if(sdlSupport >= SDLSupport.v2_0_4){
	version = SDL_HAPTIC_DUMMY;
}else{
	version = SDL_HAPTIC_DISABLED;
}

static if(sdlSupport >= SDLSupport.v2_0_4){
	version = SDL_JOYSTICK_MFI;
}
static if(sdlSupport >= SDLSupport.v2_0_14){
	version = SDL_JOYSTICK_VIRTUAL;
}else static if(sdlSupport >= SDLSupport.v2_0_12){
	version = SDL_JOYSTICK_HIDAPI;
}

static if(sdlSupport >= SDLSupport.v2_0_9){
	version(TVOS){
		version = SDL_SENSOR_DUMMY;
	}
	version = SDL_SENSOR_COREMOTION;
}

static if(sdlSupport >= SDLSupport.v2_0_5){
	version = SDL_LOADSO_DLOPEN;
}else{
	version = SDL_LOADSO_DISABLED;
}

version = SDL_THREAD_PTHREAD;
version = SDL_THREAD_PTHREAD_RECURSIVE_MUTEX;

version = SDL_TIMER_UNIX;

version = SDL_VIDEO_DRIVER_UIKIT;
version = SDL_VIDEO_DRIVER_DUMMY;

static if(sdlSupport >= SDLSupport.v2_0_4){
	version = SDL_VIDEO_OPENGL_ES2;
}
version = SDL_VIDEO_OPENGL_ES;
version = SDL_VIDEO_RENDER_OGL_ES;
version = SDL_VIDEO_RENDER_OGL_ES2;

static if(sdlSupport >= SDLSupport.v2_0_8){
	//<= 2.0.12
	/* Metal supported on 64-bit devices running iOS 8.0 and tvOS 9.0 and newer */
	//#if !TARGET_OS_SIMULATOR && !TARGET_CPU_ARM && ((__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 90000))
	
	//>= 2.0.14
	/* Metal supported on 64-bit devices running iOS 8.0 and tvOS 9.0 and newer
	Also supported in simulator from iOS 13.0 and tvOS 13.0
	*/
	//#if (TARGET_OS_SIMULATOR && ((__IPHONE_OS_VERSION_MIN_REQUIRED >= 130000) || (__TV_OS_VERSION_MIN_REQUIRED >= 130000))) || (!TARGET_CPU_ARM && ((__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 90000)))
	version = SDL_PLATFORM_SUPPORTS_METAL;
	//#endif

	version(SDL_PLATFORM_SUPPORTS_METAL){
		version = SDL_VIDEO_RENDER_METAL;
		version = SDL_VIDEO_VULKAN;
		static if(sdlSupport >= SDLSupport.v2_0_12){
			version = SDL_VIDEO_METAL;
		}
	}
}else static if(sdlSupport >= SDLSupport.v2_0_6){
	/* Enable Vulkan support on 64-bit devices when an iOS 8+ SDK is used. */
	//#if !TARGET_OS_SIMULATOR && !TARGET_CPU_ARM && defined(__IPHONE_8_0)
	version = SDL_VIDEO_VULKAN;
	//#endif
}

version = SDL_POWER_UIKIT;

version = SDL_IPHONE_KEYBOARD;

static if(sdlSupport < SDLSupport.v2_0_14){
	//yes, this was removed
	enum SDL_IPHONE_MAX_GFORCE = 5.0;
}

static if(sdlSupport >= SDLSupport.v2_0_4){
	version = SDL_IPHONE_LAUNCHSCREEN;
}

static if(sdlSupport >= SDLSupport.v2_0_1){
	version = SDL_FILESYSTEM_COCOA;
}
