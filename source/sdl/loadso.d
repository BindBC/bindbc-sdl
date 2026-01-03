/+
+            Copyright 2024 – 2026 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.loadso;

import bindbc.sdl.config, bindbc.sdl.codegen;

import sdl.stdinc: SDL_FunctionPointer;

struct SDL_SharedObject;

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{SDL_SharedObject*}, q{SDL_LoadObject}, q{const(char)* soFile}},
		{q{SDL_FunctionPointer}, q{SDL_LoadFunction}, q{SDL_SharedObject* handle, const(char)* name}},
		{q{void}, q{SDL_UnloadObject}, q{SDL_SharedObject* handle}},
	];
	return ret;
}()));
