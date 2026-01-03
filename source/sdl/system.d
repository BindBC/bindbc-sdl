/+
+            Copyright 2024 – 2026 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.system;

import bindbc.sdl.config, bindbc.sdl.codegen;

import sdl.keyboard;
import sdl.video: SDL_DisplayID, SDL_Window;

version(Windows)     version = Microsoft;
else version(GDK)    version = Microsoft;
else version(Cygwin) version = Microsoft;

version(Microsoft){
	struct MSG;
	
	alias SDL_WindowsMessageHook = extern(C) bool function(void* userData, MSG* msg) nothrow;
}

union XEvent;

alias SDL_X11EventHook = extern(C) bool function(void* userData, XEvent* xEvent) nothrow;

version(iOS){
	alias SDL_iOSAnimationCallback = extern(C) void function(void* userData) nothrow;
}

version(Android){
	alias SDL_AndroidExternalStorageState_ = uint;
	mixin(makeEnumBind(q{SDL_AndroidExternalStorageState}, q{SDL_AndroidExternalStorageState_}, aliases: [q{SDL_AndroidExternalStorage}], members: (){
		EnumMember[] ret = [
				{{q{read},     q{SDL_ANDROID_EXTERNAL_STORAGE_READ}},     q{0x01}},
				{{q{write},    q{SDL_ANDROID_EXTERNAL_STORAGE_WRITE}},    q{0x02}},
			];
		return ret;
	}()));
	
	alias SDL_RequestAndroidPermissionCallback = extern(C) void function(void* userData, const(char)* permission, bool granted) nothrow;
}

version(GDK){
	struct XTaskQueueObject;
	alias XTaskQueueHandle = XTaskQueueObject*;
	struct XUser;
	alias XUser = XUserHandle*;
}

mixin(makeEnumBind(q{SDL_Sandbox}, members: (){
	EnumMember[] ret = [
		{{q{none},                q{SDL_SANDBOX_NONE}}, q{0}},
		{{q{unknownContainer},    q{SDL_SANDBOX_UNKNOWN_CONTAINER}}},
		{{q{flatpak},             q{SDL_SANDBOX_FLATPAK}}},
		{{q{snap},                q{SDL_SANDBOX_SNAP}}},
		{{q{macOS},               q{SDL_SANDBOX_MACOS}}},
	];
	return ret;
}()));

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{void}, q{SDL_SetX11EventHook}, q{SDL_X11EventHook callback, void* userData}},
		{q{bool}, q{SDL_IsTablet}, q{}},
		{q{bool}, q{SDL_IsTV}, q{}},
		{q{SDL_Sandbox}, q{SDL_GetSandbox}, q{}},
		{q{void}, q{SDL_OnApplicationWillTerminate}, q{}},
		{q{void}, q{SDL_OnApplicationDidReceiveMemoryWarning}, q{}},
		{q{void}, q{SDL_OnApplicationWillEnterBackground}, q{}},
		{q{void}, q{SDL_OnApplicationDidEnterBackground}, q{}},
		{q{void}, q{SDL_OnApplicationWillEnterForeground}, q{}},
		{q{void}, q{SDL_OnApplicationDidEnterForeground}, q{}},
	];
	version(Microsoft){{
		FnBind[] add = [
			{q{void}, q{SDL_SetWindowsMessageHook}, q{SDL_WindowsMessageHook callback, void* userData}},
		];
		ret ~= add;
	}}
	version(Windows){{
		FnBind[] add = [
			{q{int}, q{SDL_GetDirect3D9AdapterIndex}, q{SDL_DisplayID displayID}},
			{q{bool}, q{SDL_GetDXGIOutputInfo}, q{SDL_DisplayID displayID, int* adapterIndex, int* outputIndex}},
		];
		ret ~= add;
	}}else version(Android){{
		FnBind[] add = [
			{q{void*}, q{SDL_GetAndroidJNIEnv}, q{}},
			{q{void*}, q{SDL_GetAndroidActivity}, q{}},
			{q{int}, q{SDL_GetAndroidSDKVersion}, q{}},
			{q{bool}, q{SDL_IsChromebook}, q{}},
			{q{bool}, q{SDL_IsDeXMode}, q{}},
			{q{void}, q{SDL_SendAndroidBackButton}, q{}},
			{q{const(char)*}, q{SDL_GetAndroidInternalStoragePath}, q{}},
			{q{SDL_AndroidExternalStorageState}, q{SDL_GetAndroidExternalStorageState}, q{}},
			{q{const(char)*}, q{SDL_GetAndroidExternalStoragePath}, q{}},
			{q{const(char)*}, q{SDL_GetAndroidCachePath}, q{}},
			{q{bool}, q{SDL_RequestAndroidPermission}, q{const(char)* permission, SDL_RequestAndroidPermissionCallback cb, void* userData}},
			{q{bool}, q{SDL_ShowAndroidToast}, q{const(char)* message, int duration, int gravity, int xOffset, int yOffset}},
			{q{bool}, q{SDL_SendAndroidMessage}, q{uint command, int param}},
		];
		ret ~= add;
	}}else version(linux){{
		FnBind[] add = [
			{q{bool}, q{SDL_SetLinuxThreadPriority}, q{long threadID, int priority}},
			{q{bool}, q{SDL_SetLinuxThreadPriorityAndPolicy}, q{long threadID, int sdlPriority, int schedPolicy}},
		];
		ret ~= add;
	}}else version(iOS){{
		FnBind[] add = [
			{q{bool}, q{SDL_SetiOSAnimationCallback}, q{SDL_Window* window, int interval, SDL_iOSAnimationCallback callback, void* callbackParam}},
			{q{void}, q{SDL_SetiOSEventPump}, q{bool enabled}},
			{q{void}, q{SDL_OnApplicationDidChangeStatusBarOrientation}, q{}},
		];
		ret ~= add;
	}}
	version(GDK){{
		FnBind[] add = [
			{q{bool}, q{SDL_GetGDKTaskQueue}, q{XTaskQueueHandle* outTaskQueue}},
			{q{bool}, q{SDL_GetGDKDefaultUser}, q{XUserHandle* outUserHandle}},
		];
		ret ~= add;
	}}
	return ret;
}()));
