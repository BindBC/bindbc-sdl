/+
+            Copyright 2024 – 2025 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.touch;

import bindbc.sdl.config, bindbc.sdl.codegen;

import sdl.mouse;

alias SDL_TouchID = ulong;
alias SDL_FingerID = ulong;

mixin(makeEnumBind(q{SDL_TouchDeviceType}, aliases: [q{SDL_TouchDevice}], members: (){
	EnumMember[] ret = [
		{{q{invalid},             q{SDL_TOUCH_DEVICE_INVALID}}, q{-1}},
		{{q{direct},              q{SDL_TOUCH_DEVICE_DIRECT}}},
		{{q{indirectAbsolute},    q{SDL_TOUCH_DEVICE_INDIRECT_ABSOLUTE}}},
		{{q{indirectRelative},    q{SDL_TOUCH_DEVICE_INDIRECT_RELATIVE}}},
	];
	return ret;
}()));

struct SDL_Finger{
	SDL_FingerID id;
	float x, y, pressure;
}

enum{
	SDL_TouchMouseID = cast(SDL_MouseID)-1,
	SDL_MouseTouchID = cast(SDL_TouchID)-1,
	
	SDL_TOUCH_MOUSEID = SDL_TouchMouseID,
	SDL_MOUSE_TOUCHID = SDL_MouseTouchID,
}

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{SDL_TouchID*}, q{SDL_GetTouchDevices}, q{int* count}},
		{q{const(char)*}, q{SDL_GetTouchDeviceName}, q{SDL_TouchID touchID}},
		{q{SDL_TouchDeviceType}, q{SDL_GetTouchDeviceType}, q{SDL_TouchID touchID}},
		{q{SDL_Finger**}, q{SDL_GetTouchFingers}, q{SDL_TouchID touchID, int* count}},
	];
	return ret;
}()));
