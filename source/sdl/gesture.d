/+
+            Copyright 2022 – 2024 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.gesture;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

import sdl.touch: SDL_TouchID;
import sdl.rwops: SDL_RWops;

alias SDL_GestureID = long;

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{int}, q{SDL_RecordGesture}, q{SDL_TouchID touchID}},
		{q{int}, q{SDL_SaveAllDollarTemplates}, q{SDL_RWops* dst}},
		{q{int}, q{SDL_SaveDollarTemplate}, q{SDL_GestureID gestureID, SDL_RWops* dst}},
		{q{int}, q{SDL_LoadDollarTemplates}, q{SDL_TouchID touchID, SDL_RWops* src}},
	];
	return ret;
}()));
