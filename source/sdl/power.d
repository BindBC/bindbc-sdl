/+
+            Copyright 2024 – 2026 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.power;

import bindbc.sdl.config, bindbc.sdl.codegen;

mixin(makeEnumBind(q{SDL_PowerState}, members: (){
	EnumMember[] ret = [
		{{q{error},      q{SDL_POWERSTATE_ERROR}},  q{-1}},
		{{q{unknown},    q{SDL_POWERSTATE_UNKNOWN}}},
		{{q{onBattery},  q{SDL_POWERSTATE_ON_BATTERY}}},
		{{q{noBattery},  q{SDL_POWERSTATE_NO_BATTERY}}},
		{{q{charging},   q{SDL_POWERSTATE_CHARGING}}},
		{{q{charged},    q{SDL_POWERSTATE_CHARGED}}},
	];
	return ret;
}()));

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{SDL_PowerState}, q{SDL_GetPowerInfo}, q{int* seconds, int* percent}},
	];
	return ret;
}()));
