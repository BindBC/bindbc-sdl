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



version(Windows){
	static if(sdlSupport >= SDLSupport.v2_0_1):
	struct IDirect3DDevice9;
	
	static if(sdlSupport >= SDLSupport.v2_0_4):
	alias SDL_WindowsMessageHook = extern(C) void function(void* userdata, void* hWnd, uint message, ulong wParam, long lParam) nothrow;
	
	static if(sdlSupport >= SDLSupport.v2_0_16):
	struct ID3D11Device;
	
	static if(sdlSupport >= SDLSupport.v2_24):
	struct ID3D12Device;
}else version(iOS){
	static if(sdlSupport >= SDLSupport.v2_0_4):
	alias SDL_iOSSetAnimationCallback = SDL_iPhoneSetAnimationCallback;
	alias SDL_iOSSetEventPump = SDL_iPhoneSetEventPump;
}else version(Android){
	enum: int{
		SDL_ANDROID_EXTERNAL_STORAGE_READ   = 0x01,
		SDL_ANDROID_EXTERNAL_STORAGE_WRITE  = 0x02,
	}
}

mixin(joinFnBinds((){
	string[][] ret;
	static if(sdlSupport >= SDLSupport.v2_0_9){
		ret ~= makeFnBinds([
			[q{SDL_bool}, q{SDL_IsTablet}, q{}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_12){
			void SDL_OnApplicationWillTerminate();
			void SDL_OnApplicationDidReceiveMemoryWarning();
			void SDL_OnApplicationWillResignActive();
			void SDL_OnApplicationDidEnterBackground();
			void SDL_OnApplicationWillEnterForeground();
			void SDL_OnApplicationDidBecomeActive();
	}
	version(Windows){
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
	}else version(linux){
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
	}else version(iOS){
		ret ~= makeFnBinds([
			[q{int}, q{SDL_iPhoneSetAnimationCallback}, q{SDL_Window* window, int interval, void function(void*) callback, void* callbackParam}],
			[q{void}, q{SDL_iPhoneSetEventPump}, q{SDL_bool enabled}],
		]);
		static if(sdlSupport >= SDLSupport.v2_0_12){
			ret ~= makeFnBinds([
				[q{void}, q{SDL_OnApplicationDidChangeStatusBarOrientation}, q{}],
			]);
		}
	}else version(Android){
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
	return ret;
}()));
