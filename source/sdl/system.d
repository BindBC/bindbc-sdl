/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.system;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

import sdl.render: SDL_Renderer;
import sdl.stdinc: SDL_bool;
import sdl.video: SDL_Window;

version(Windows) version = Win32_GDK;
version(WinGDK)  version = Win32_GDK;

version(Win32_GDK){
	static if(sdlSupport >= SDLSupport.v2_0_1):
	struct IDirect3DDevice9;
	
	static if(sdlSupport >= SDLSupport.v2_0_4):
	alias SDL_WindowsMessageHook = extern(C) void function(void* userdata, void* hWnd, uint message, ulong wParam, long lParam) nothrow;
	
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
}

mixin(joinFnBinds((){
	string[][] ret;
	static if(sdlSupport >= SDLSupport.v2_0_9){
		ret ~= makeFnBinds([
			[q{SDL_bool}, q{SDL_IsTablet}, q{}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_12){
		ret ~= makeFnBinds([
			[q{void}, q{SDL_OnApplicationWillTerminate}, q{}],
			[q{void}, q{SDL_OnApplicationDidReceiveMemoryWarning}, q{}],
			[q{void}, q{SDL_OnApplicationWillResignActive}, q{}],
			[q{void}, q{SDL_OnApplicationDidEnterBackground}, q{}],
			[q{void}, q{SDL_OnApplicationWillEnterForeground}, q{}],
			[q{void}, q{SDL_OnApplicationDidBecomeActive}, q{}],
		]);
	}
	version(Win32_GDK){
		static if(sdlSupport >= SDLSupport.v2_0_1){
			ret ~= makeFnBinds([
				[q{int}, q{SDL_Direct3D9GetAdapterIndex}, q{int displayIndex}],
				[q{IDirect3DDevice9*}, q{SDL_RenderGetD3D9Device}, q{SDL_Renderer* renderer}],
			]);
		}
		static if(sdlSupport >= SDLSupport.v2_0_2){
			ret ~= makeFnBinds([
				[q{SDL_bool}, q{SDL_DXGIGetOutputInfo}, q{int displayIndex, int* adapterIndex, int* outputIndex}],
			]);
		}
		static if(sdlSupport >= SDLSupport.v2_0_4){
			ret ~= makeFnBinds([
				[q{void}, q{SDL_SetWindowsMessageHook}, q{SDL_WindowsMessageHook callback, void* userdata}],
			]);
		}
		static if(sdlSupport >= SDLSupport.v2_0_16){
			ret ~= makeFnBinds([
				[q{void}, q{SDL_RenderGetD3D11Device}, q{SDL_Renderer* renderer}],
			]);
		}
	}
	version(linux){
		static if(sdlSupport >= SDLSupport.v2_0_9){
			ret ~= makeFnBinds([
				[q{int}, q{SDL_LinuxSetThreadPriority}, q{long threadID, int priority}],
			]);
		}
		static if(sdlSupport >= SDLSupport.v2_0_18){
			ret ~= makeFnBinds([
				[q{int}, q{SDL_LinuxSetThreadPriorityAndPolicy}, q{long threadID, int sdlPriority, int schedPolicy}],
			]);
		}
	}
	version(iOS){
		ret ~= makeFnBinds([
			[q{int}, q{SDL_iPhoneSetAnimationCallback}, q{SDL_Window* window, int interval, void function(void*) callback, void* callbackParam}],
			[q{void}, q{SDL_iPhoneSetEventPump}, q{SDL_bool enabled}],
		]);
		static if(sdlSupport >= SDLSupport.v2_0_12){
			ret ~= makeFnBinds([
				[q{void}, q{SDL_OnApplicationDidChangeStatusBarOrientation}, q{}],
			]);
		}
	}
	version(Android){
		ret ~= makeFnBinds([
			[q{void*}, q{SDL_AndroidGetJNIEnv}, q{}],
			[q{void*}, q{SDL_AndroidGetActivity}, q{}],
			[q{const(char)*}, q{SDL_AndroidGetInternalStoragePath}, q{}],
			[q{int}, q{SDL_AndroidGetExternalStorageState}, q{}],
			[q{const(char)*}, q{SDL_AndroidGetExternalStoragePath}, q{}],
		]);
		static if(sdlSupport >= SDLSupport.v2_0_8){
			ret ~= makeFnBinds([
				[q{SDL_bool}, q{SDL_IsAndroidTV}, q{}],
			]);
		}
		static if(sdlSupport >= SDLSupport.v2_0_9){
			ret ~= makeFnBinds([
				[q{SDL_bool}, q{SDL_IsChromebook}, q{}],
				[q{SDL_bool}, q{SDL_IsDeXMode}, q{}],
				[q{void}, q{SDL_AndroidBackButton}, q{}],
			]);
		}
		static if(sdlSupport >= SDLSupport.v2_0_12){
			ret ~= makeFnBinds([
				[q{int}, q{SDL_GetAndroidSDKVersion}, q{}],
			]);
		}
		static if(sdlSupport >= SDLSupport.v2_0_14){
			ret ~= makeFnBinds([
				[q{SDL_bool}, q{SDL_AndroidRequestPermission}, q{const(char)* permission}],
			]);
		}
		static if(sdlSupport >= SDLSupport.v2_0_16){
			ret ~= makeFnBinds([
				[q{int}, q{SDL_AndroidShowToast}, q{const(char)* message, int duration, int gravity, int xoffset, int yoffset}],
			]);
		}
		static if(sdlSupport >= SDLSupport.v2_0_22){
			ret ~= makeFnBinds([
				[q{int}, q{SDL_AndroidSendMessage}, q{uint command, int param}],
			]);
		}
	}
	version(WinRT){
		static if(sdlSupport >= SDLSupport.v2_0_3){
			ret ~= makeFnBinds([
				[q{wchar_t*}, q{SDL_WinRTGetFSPathUNICODE}, q{SDL_WinRT_Path pathType}],
				[q{const(char)*}, q{SDL_WinRTGetFSPathUTF8}, q{SDL_WinRT_Path pathType}],
			]);
		}
		static if(sdlSupport >= SDLSupport.v2_0_8){
			ret ~= makeFnBinds([
				[q{SDL_WinRT_DeviceFamily}, q{SDL_WinRTGetDeviceFamily}, q{}],
			]);
		}
	}
	version(WinGDK){
		static if(sdlSupport >= SDLSupport.v2_24){
			ret ~= makeFnBinds([
				[q{int}, q{SDL_GDKGetTaskQueue}, q{XTaskQueueHandle* outTaskQueue}],
			]);
		}
	}
	return ret;
}()));

version(iOS){
	static if(sdlSupport >= SDLSupport.v2_0_4):
	alias SDL_iOSSetAnimationCallback = SDL_iPhoneSetAnimationCallback;
	alias SDL_iOSSetEventPump = SDL_iPhoneSetEventPump;
}
