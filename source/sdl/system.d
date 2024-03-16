/+
+            Copyright 2022 – 2024 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.system;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

import sdl.render;
import sdl.stdinc: SDL_bool;
import sdl.video;

version(Windows) version = Win32_GDK;
version(WinGDK)  version = Win32_GDK;

version(Win32_GDK){
	static if(sdlSupport >= SDLSupport.v2_0_1):
	struct IDirect3DDevice9;
	
	static if(sdlSupport >= SDLSupport.v2_0_4):
	alias SDL_WindowsMessageHook = extern(C) void function(void* userData, void* hWnd, uint message, ulong wParam, long lParam) nothrow;
	
	static if(sdlSupport >= SDLSupport.v2_0_16):
	struct ID3D11Device;
	
	static if(sdlSupport >= SDLSupport.v2_24):
	struct ID3D12Device;
}
version(Android){
	enum: int{
		SDL_ANDROID_EXTERNAL_STORAGE_READ   = 0x01,
		SDL_ANDROID_EXTERNAL_STORAGE_WRITE  = 0x02,
	}
}
version(WinRT){
	static if(sdlSupport >= SDLSupport.v2_0_3):
	alias SDL_WinRT_Path = int;
	enum: SDL_WinRT_Path{
		SDL_WINRT_PATH_INSTALLED_LOCATION,
		SDL_WINRT_PATH_LOCAL_FOLDER,
		SDL_WINRT_PATH_ROAMING_FOLDER,
		SDL_WINRT_PATH_TEMP_FOLDER,
	}
	
	static if(sdlSupport >= SDLSupport.v2_0_8):
	alias SDL_WinRT_DeviceFamily = int;
	enum: SDL_WinRT_DeviceFamily{
		SDL_WINRT_DEVICEFAMILY_UNKNOWN,
		SDL_WINRT_DEVICEFAMILY_DESKTOP,
		SDL_WINRT_DEVICEFAMILY_MOBILE,
		SDL_WINRT_DEVICEFAMILY_XBOX,
	}
}
version(WinGDK){
	static if(sdlSupport >= SDLSupport.v2_24):
	private struct XTaskQueueObject;
	alias XTaskQueueHandle = XTaskQueueObject*;
	private struct XUser;
	alias XUserHandle = XUser*;
}

mixin(joinFnBinds((){
	FnBind[] ret;
	if(sdlSupport >= SDLSupport.v2_0_9){
		FnBind[] add = [
			{q{SDL_bool}, q{SDL_IsTablet}, q{}},
		];
		ret ~= add;
	}
	if(sdlSupport >= SDLSupport.v2_0_12){
		FnBind[] add = [
			{q{void}, q{SDL_OnApplicationWillTerminate}, q{}},
			{q{void}, q{SDL_OnApplicationDidReceiveMemoryWarning}, q{}},
			{q{void}, q{SDL_OnApplicationWillResignActive}, q{}},
			{q{void}, q{SDL_OnApplicationDidEnterBackground}, q{}},
			{q{void}, q{SDL_OnApplicationWillEnterForeground}, q{}},
			{q{void}, q{SDL_OnApplicationDidBecomeActive}, q{}},
		];
		ret ~= add;
	}
	version(Win32_GDK){
		if(sdlSupport >= SDLSupport.v2_0_1){
			FnBind[] add = [
				{q{int}, q{SDL_Direct3D9GetAdapterIndex}, q{int displayIndex}},
				{q{IDirect3DDevice9*}, q{SDL_RenderGetD3D9Device}, q{SDL_Renderer* renderer}},
			];
			ret ~= add;
		}
		if(sdlSupport >= SDLSupport.v2_0_2){
			FnBind[] add = [
				{q{SDL_bool}, q{SDL_DXGIGetOutputInfo}, q{int displayIndex, int* adapterIndex, int* outputIndex}},
			];
			ret ~= add;
		}
		if(sdlSupport >= SDLSupport.v2_0_4){
			FnBind[] add = [
				{q{void}, q{SDL_SetWindowsMessageHook}, q{SDL_WindowsMessageHook callback, void* userData}},
			];
			ret ~= add;
		}
		if(sdlSupport >= SDLSupport.v2_0_16){
			FnBind[] add = [
				{q{void}, q{SDL_RenderGetD3D11Device}, q{SDL_Renderer* renderer}},
			];
			ret ~= add;
		}
	}
	version(linux){
		if(sdlSupport >= SDLSupport.v2_0_9){
			FnBind[] add = [
				{q{int}, q{SDL_LinuxSetThreadPriority}, q{long threadID, int priority}},
			];
			ret ~= add;
		}
		if(sdlSupport >= SDLSupport.v2_0_18){
			FnBind[] add = [
				{q{int}, q{SDL_LinuxSetThreadPriorityAndPolicy}, q{long threadID, int sdlPriority, int schedPolicy}},
			];
			ret ~= add;
		}
	}
	version(iOS){
		{
			FnBind[] add = [
				{q{int}, q{SDL_iPhoneSetAnimationCallback}, q{SDL_Window* window, int interval, void function(void*) callback, void* callbackParam}},
				{q{void}, q{SDL_iPhoneSetEventPump}, q{SDL_bool enabled}},
			];
			ret ~= add;
		}
		if(sdlSupport >= SDLSupport.v2_0_12){
			FnBind[] add = [
				{q{void}, q{SDL_OnApplicationDidChangeStatusBarOrientation}, q{}},
			];
			ret ~= add;
		}
	}
	version(Android){
		{
			FnBind[] add = [
				{q{void*}, q{SDL_AndroidGetJNIEnv}, q{}},
				{q{void*}, q{SDL_AndroidGetActivity}, q{}},
				{q{const(char)*}, q{SDL_AndroidGetInternalStoragePath}, q{}},
				{q{int}, q{SDL_AndroidGetExternalStorageState}, q{}},
				{q{const(char)*}, q{SDL_AndroidGetExternalStoragePath}, q{}},
			];
			ret ~= add;
		}
		if(sdlSupport >= SDLSupport.v2_0_8){
			FnBind[] add = [
				{q{SDL_bool}, q{SDL_IsAndroidTV}, q{}},
			];
			ret ~= add;
		}
		if(sdlSupport >= SDLSupport.v2_0_9){
			FnBind[] add = [
				{q{SDL_bool}, q{SDL_IsChromebook}, q{}},
				{q{SDL_bool}, q{SDL_IsDeXMode}, q{}},
				{q{void}, q{SDL_AndroidBackButton}, q{}},
			];
			ret ~= add;
		}
		if(sdlSupport >= SDLSupport.v2_0_12){
			FnBind[] add = [
				{q{int}, q{SDL_GetAndroidSDKVersion}, q{}},
			];
			ret ~= add;
		}
		if(sdlSupport >= SDLSupport.v2_0_14){
			FnBind[] add = [
				{q{SDL_bool}, q{SDL_AndroidRequestPermission}, q{const(char)* permission}},
			];
			ret ~= add;
		}
		if(sdlSupport >= SDLSupport.v2_0_16){
			FnBind[] add = [
				{q{int}, q{SDL_AndroidShowToast}, q{const(char)* message, int duration, int gravity, int xOffset, int yOffset}},
			];
			ret ~= add;
		}
		if(sdlSupport >= SDLSupport.v2_0_22){
			FnBind[] add = [
				{q{int}, q{SDL_AndroidSendMessage}, q{uint command, int param}},
			];
			ret ~= add;
		}
	}
	version(WinRT){
		if(sdlSupport >= SDLSupport.v2_0_3){
			FnBind[] add = [
				{q{wchar_t*}, q{SDL_WinRTGetFSPathUNICODE}, q{SDL_WinRT_Path pathType}},
				{q{const(char)*}, q{SDL_WinRTGetFSPathUTF8}, q{SDL_WinRT_Path pathType}},
			];
			ret ~= add;
		}
		if(sdlSupport >= SDLSupport.v2_0_8){
			FnBind[] add = [
				{q{SDL_WinRT_DeviceFamily}, q{SDL_WinRTGetDeviceFamily}, q{}},
			];
			ret ~= add;
		}
	}
	version(WinGDK){
		if(sdlSupport >= SDLSupport.v2_24){
			FnBind[] add = [
				{q{int}, q{SDL_GDKGetTaskQueue}, q{XTaskQueueHandle* outTaskQueue}},
			];
			ret ~= add;
		}
		if(sdlSupport >= SDLSupport.v2_30){
			FnBind[] add = [
				{q{int}, q{SDL_GDKGetDefaultUser}, q{XUserHandle* outUserHandle}},
			];
			ret ~= add;
		}
	}
	return ret;
}()));

version(iOS){
	static if(sdlSupport >= SDLSupport.v2_0_4):
	alias SDL_iOSSetAnimationCallback = SDL_iPhoneSetAnimationCallback;
	alias SDL_iOSSetEventPump = SDL_iPhoneSetEventPump;
}
