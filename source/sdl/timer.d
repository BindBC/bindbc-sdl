/+
+            Copyright 2022 – 2023 Aya Partridge
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

// This was added to SDL 2.0.1 as a macro, but it's
// useful & has no dependency on the library version,
// so it's here for 2.0.0 as well.
pragma(inline, true) bool SDL_TICKS_PASSED(uint A, uint B) @nogc nothrow pure @safe{
	return cast(int)(B - A) <= 0;
}

mixin(joinFnBinds((){
	string[][] ret;
	ret ~= makeFnBinds([
		[q{uint}, q{SDL_GetTicks}, q{}],
		[q{ulong}, q{SDL_GetPerformanceCounter}, q{}],
		[q{ulong}, q{SDL_GetPerformanceFrequency}, q{}],
		[q{void}, q{SDL_Delay}, q{uint ms}],
		[q{SDL_TimerID}, q{SDL_AddTimer}, q{uint interval, SDL_TimerCallback callback, void* param}],
		[q{SDL_bool}, q{SDL_RemoveTimer}, q{SDL_TimerID id}],
	]);
	static if(sdlSupport >= SDLSupport.v2_0_18){
		ret ~= makeFnBinds([
			[q{ulong}, q{SDL_GetTicks64}, q{}],
		]);
	}
	return ret;
}()));
