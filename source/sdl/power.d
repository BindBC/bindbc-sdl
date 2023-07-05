/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.power;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

alias SDL_PowerState = int;
enum: SDL_PowerState{
	SDL_POWERSTATE_UNKNOWN,
	SDL_POWERSTATE_ON_BATTERY,
	SDL_POWERSTATE_NO_BATTERY,
	SDL_POWERSTATE_CHARGING,
	SDL_POWERSTATE_CHARGED,
}

mixin(joinFnBinds((){
	string[][] ret;
	ret ~= makeFnBinds([
		[q{SDL_PowerState}, q{SDL_GetPowerInfo}, q{int* seconds, int* percent}],
	]);
	return ret;
}()));
