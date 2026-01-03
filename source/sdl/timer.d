/+
+            Copyright 2024 – 2026 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.timer;

import bindbc.sdl.config, bindbc.sdl.codegen;

enum{
	SDL_MSPerSecond  = 1_000,
	SDL_USPerSecond  = 1_000_000,
	SDL_NSPerSecond  = 1_000_000_000L,
	SDL_NSPerMS      = 1_000_000,
	SDL_NSPerUS      = 1_000,
	
	SDL_MS_PER_SECOND = SDL_MSPerSecond,
	SDL_US_PER_SECOND = SDL_USPerSecond,
	SDL_NS_PER_SECOND = SDL_NSPerSecond,
	SDL_NS_PER_MS = SDL_NSPerMS,
	SDL_NS_PER_US = SDL_NSPerUS,
}

pragma(inline,true) nothrow @nogc pure @safe{
	ulong SDL_SECONDS_TO_NS(ulong s)  => cast(ulong)s * SDL_NSPerSecond;
	ulong SDL_NS_TO_SECONDS(ulong ns) => ns / SDL_NSPerSecond;
	ulong SDL_MS_TO_NS(ulong ms)      => cast(ulong)ms * SDL_NSPerMS;
	ulong SDL_NS_TO_MS(ulong ns)      => ns / SDL_NSPerMS;
	ulong SDL_US_TO_NS(ulong us)      => cast(ulong)us * SDL_NSPerUS;
	ulong SDL_NS_TO_US(ulong ns)      => ns / SDL_NSPerUS;
}

alias SDL_TimerID = uint;

extern(C) nothrow{
	alias SDL_TimerCallback = uint function(void* userData, SDL_TimerID timerID, uint interval);
	alias SDL_NSTimerCallback = ulong function(void* userData, SDL_TimerID timerID, ulong interval);
}

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{ulong}, q{SDL_GetTicks}, q{}},
		{q{ulong}, q{SDL_GetTicksNS}, q{}},
		{q{ulong}, q{SDL_GetPerformanceCounter}, q{}},
		{q{ulong}, q{SDL_GetPerformanceFrequency}, q{}},
		{q{void}, q{SDL_Delay}, q{uint ms}},
		{q{void}, q{SDL_DelayNS}, q{ulong ns}},
		{q{void}, q{SDL_DelayPrecise}, q{ulong ns}},
		{q{SDL_TimerID}, q{SDL_AddTimer}, q{uint interval, SDL_TimerCallback callback, void* userData}},
		{q{SDL_TimerID}, q{SDL_AddTimerNS}, q{ulong interval, SDL_NSTimerCallback callback, void* userData}},
		{q{bool}, q{SDL_RemoveTimer}, q{SDL_TimerID id}},
	];
	return ret;
}()));
