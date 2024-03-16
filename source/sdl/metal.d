/+
+            Copyright 2023 – 2024 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.metal;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

import sdl.video;

alias SDL_MetalView = void*;

mixin(joinFnBinds((){
	FnBind[] ret;
	if(sdlSupport >= SDLSupport.v2_0_12){
		FnBind[] add = [
			{q{SDL_MetalView}, q{SDL_Metal_CreateView}, q{SDL_Window* window}},
			{q{void}, q{SDL_Metal_DestroyView}, q{SDL_MetalView view}},
		];
		ret ~= add;
	}
	if(sdlSupport >= SDLSupport.v2_0_14){
		FnBind[] add = [
			{q{void*}, q{SDL_Metal_GetLayer}, q{SDL_MetalView view}},
			{q{void}, q{SDL_Metal_GetDrawableSize}, q{SDL_Window* window, int* w, int* h}},
		];
		ret ~= add;
	}
	return ret;
}()));
