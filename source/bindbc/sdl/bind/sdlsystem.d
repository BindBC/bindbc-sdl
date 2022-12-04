/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module bindbc.sdl.bind.sdlsystem;

import bindbc.sdl.config;
import bindbc.sdl.bind.sdlrender: SDL_Renderer;
import bindbc.sdl.bind.sdlstdinc: SDL_bool;

version(Android){
	enum: int{
		SDL_ANDROID_EXTERNAL_STORAGE_READ = 0x01,
		SDL_ANDROID_EXTERNAL_STORAGE_WRITE = 0x02,
	}
}

static if(sdlSupport >= SDLSupport.sdl201){
	version(Windows) struct IDirect3DDevice9;
}

static if(sdlSupport >= SDLSupport.sdl204){
	version(Windows){
		extern(C) nothrow alias SDL_WindowsMessageHook = void function(void*,void*,uint,ulong,long);
	}
}


mixin(joinFnBinds!((){
	string[][] ret;
	version(Android){
		ret ~= makeFnBinds!(
			[q{void*}, q{SDL_AndroidGetJNIEnv}, q{}],
			[q{void*}, q{SDL_AndroidGetActivity}, q{}],
			[q{const(char)*}, q{SDL_AndroidGetInternalStoragePath}, q{}],
			[q{int}, q{SDL_AndroidGetExternalStorageState}, q{}],
			[q{const(char)*}, q{SDL_AndroidGetExternalStoragePath}, q{}],
		);

		static if(sdlSupport >= SDLSupport.sdl208){
			ret ~= makeFnBinds!(
				[q{SDL_bool}, q{SDL_IsAndroidTV}, q{}],
			);
		}
		static if(sdlSupport >= SDLSupport.sdl209){
			ret ~= makeFnBinds!(
				[q{SDL_bool}, q{SDL_IsChromebook}, q{}],
				[q{SDL_bool}, q{SDL_IsDeXMode}, q{}],
				[q{void}, q{SDL_AndroidBackButton}, q{}],
			);
		}
		static if(sdlSupport >= SDLSupport.sdl2012){
			ret ~= makeFnBinds!(
				[q{int}, q{SDL_GetAndroidSDKVersion}, q{}],
			);
		}
		static if(sdlSupport >= SDLSupport.sdl2014){
			ret ~= makeFnBinds!(
				[q{SDL_bool}, q{SDL_AndroidRequestPermission}, q{const(char)* permission}],
			);
		}
		static if(sdlSupport >= SDLSupport.sdl2016){
			ret ~= makeFnBinds!(
				[q{int}, q{SDL_AndroidShowToast}, q{const(char)* message, int duration, int gravity, int xoffset, int yoffset}],
			);
		}
		static if(sdlSupport >= SDLSupport.sdl2022){
			ret ~= makeFnBinds!(
				[q{int}, q{SDL_AndroidSendMessage}, q{uint command, int param}],
			);
		}
	}else version(Windows){
		static if(sdlSupport >= SDLSupport.sdl201){
			ret ~= makeFnBinds!(
				[q{int}, q{SDL_Direct3D9GetAdapterIndex}, q{int displayIndex}],
				[q{IDirect3DDevice9*}, q{SDL_RenderGetD3D9Device}, q{SDL_Renderer* renderer}],
			);
		}
		static if(sdlSupport >= SDLSupport.sdl202){
			ret ~= makeFnBinds!(
				[q{SDL_bool}, q{SDL_DXGIGetOutputInfo}, q{int displayIndex, int* adapterIndex, int* outputIndex}],
			);
		}
		static if(sdlSupport >= SDLSupport.sdl204){
			ret ~= makeFnBinds!(
				[q{void}, q{SDL_SetWindowsMessageHook}, q{SDL_WindowsMessageHook callback, void* userdata}],
			);
		}
		static if(sdlSupport >= SDLSupport.sdl2016){
			ret ~= makeFnBinds!(
				[q{void}, q{SDL_RenderGetD3D11Device}, q{SDL_Renderer* renderer}],
			);
		}
	}else version(linux){
		static if(sdlSupport >= SDLSupport.sdl209){
			ret ~= makeFnBinds!(
				[q{int}, q{SDL_LinuxSetThreadPriority}, q{long threadID, int priority}],
			);
		}
		static if(sdlSupport >= SDLSupport.sdl2018){
			ret ~= makeFnBinds!(
				[q{int}, q{SDL_LinuxSetThreadPriorityAndPolicy}, q{long threadID, int sdlPriority, int schedPolicy}],
			);
		}
	}
	return ret;
}()));
