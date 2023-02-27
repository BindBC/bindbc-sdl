/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.vulkan;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

import sdl.stdinc: SDL_bool;
import sdl.video: SDL_Window;

mixin(joinFnBinds((){
	string[][] ret;
	static if(sdlSupport >= SDLSupport.v2_0_6){
		ret ~= makeFnBinds([
			[q{SDL_bool}, q{SDL_Vulkan_CreateSurface}, q{SDL_Window* window, void* instance, void* surface}],
			[q{void}, q{SDL_Vulkan_GetDrawableSize}, q{SDL_Window* window, int* w, int* h}],
			[q{SDL_bool}, q{SDL_Vulkan_GetInstanceExtensions}, q{SDL_Window* window, uint* pCount, const(char)** pNames}],
			[q{void*}, q{SDL_Vulkan_GetVkGetInstanceProcAddr}, q{}],
			[q{int}, q{SDL_Vulkan_LoadLibrary}, q{const(char)* path}],
			[q{void}, q{SDL_Vulkan_UnloadLibrary}, q{}],
		]);
	}
	return ret;
}()));
