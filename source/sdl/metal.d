/+
+            Copyright 2024 – 2025 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.metal;

import bindbc.sdl.config, bindbc.sdl.codegen;

import sdl.video;

alias SDL_MetalView = void*;

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{SDL_MetalView}, q{SDL_Metal_CreateView}, q{SDL_Window* window}},
		{q{void}, q{SDL_Metal_DestroyView}, q{SDL_MetalView view}},
		{q{void*}, q{SDL_Metal_GetLayer}, q{SDL_MetalView view}},
	];
	return ret;
}()));
