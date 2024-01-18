/+
+            Copyright 2022 – 2024 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.timer;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

import sdl.stdinc: SDL_bool;

alias SDL_TimerCallback = extern(C) uint function(uint interval, void* param) nothrow;
alias SDL_TimerID = int;

pragma(inline, true) bool SDL_TICKS_PASSED(uint a, uint b) nothrow @nogc pure @safe{
	return cast(int)(b - a) <= 0;
}

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{uint}, q{SDL_GetTicks}, q{}},
		{q{ulong}, q{SDL_GetPerformanceCounter}, q{}},
		{q{ulong}, q{SDL_GetPerformanceFrequency}, q{}},
		{q{void}, q{SDL_Delay}, q{uint ms}},
		{q{SDL_TimerID}, q{SDL_AddTimer}, q{uint interval, SDL_TimerCallback callback, void* param}},
		{q{SDL_bool}, q{SDL_RemoveTimer}, q{SDL_TimerID id}},
	];
	if(sdlSupport >= SDLSupport.v2_0_18){
		FnBind[] add = [
			{q{ulong}, q{SDL_GetTicks64}, q{}},
		];
		ret ~= add;
	}
	return ret;
}()));
