/+
+            Copyright 2024 – 2026 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.pen;

import bindbc.sdl.config, bindbc.sdl.codegen;

import sdl.mouse: SDL_MouseID;
import sdl.touch: SDL_TouchID;

alias SDL_PenID = uint;

enum{
	SDL_PenMouseID = cast(SDL_MouseID)-2,
	SDL_PenTouchID = cast(SDL_TouchID)-2,
	
	SDL_PEN_MOUSEID = SDL_PenMouseID,
	SDL_PEN_TOUCHID = SDL_PenTouchID,
}

alias SDL_PenInputFlags_ = uint;
mixin(makeEnumBind(q{SDL_PenInputFlags}, q{SDL_PenInputFlags_}, aliases: [q{SDL_PenInput}], members: (){
	EnumMember[] ret = [
		{{q{down},             q{SDL_PEN_INPUT_DOWN}},          q{1U <<  0}},
		{{q{button1},          q{SDL_PEN_INPUT_BUTTON_1}},      q{1U <<  1}},
		{{q{button2},          q{SDL_PEN_INPUT_BUTTON_2}},      q{1U <<  2}},
		{{q{button3},          q{SDL_PEN_INPUT_BUTTON_3}},      q{1U <<  3}},
		{{q{button4},          q{SDL_PEN_INPUT_BUTTON_4}},      q{1U <<  4}},
		{{q{button5},          q{SDL_PEN_INPUT_BUTTON_5}},      q{1U <<  5}},
		{{q{eraserTip},        q{SDL_PEN_INPUT_ERASER_TIP}},    q{1U << 30}},
	];
	if(sdlVersion >= Version(3,4,0)){
		EnumMember[] add = [
			{{q{inProximity},  q{SDL_PEN_INPUT_IN_PROXIMITY}},  q{1U << 31}},
		];
		ret ~= add;
	}
	return ret;
}()));

mixin(makeEnumBind(q{SDL_PenAxis}, members: (){
	EnumMember[] ret = [
		{{q{pressure},              q{SDL_PEN_AXIS_PRESSURE}}},
		{{q{xTilt},                 q{SDL_PEN_AXIS_XTILT}}},
		{{q{yTilt},                 q{SDL_PEN_AXIS_YTILT}}},
		{{q{distance},              q{SDL_PEN_AXIS_DISTANCE}}},
		{{q{rotation},              q{SDL_PEN_AXIS_ROTATION}}},
		{{q{slider},                q{SDL_PEN_AXIS_SLIDER}}},
		{{q{tangentialPressure},    q{SDL_PEN_AXIS_TANGENTIAL_PRESSURE}}},
		{{q{count},                 q{SDL_PEN_AXIS_COUNT}}},
	];
	return ret;
}()));

static if(sdlVersion >= Version(3,4,0))
mixin(makeEnumBind(q{SDL_PenDeviceType}, members: (){
	EnumMember[] ret = [
		{{q{invalid},   q{SDL_PEN_DEVICE_TYPE_INVALID}}, q{-1}},
		{{q{unknown},   q{SDL_PEN_DEVICE_TYPE_UNKNOWN}}},
		{{q{direct},    q{SDL_PEN_DEVICE_TYPE_DIRECT}}},
		{{q{indirect},  q{SDL_PEN_DEVICE_TYPE_INDIRECT}}},
	];
	return ret;
}()));

mixin(joinFnBinds((){
	FnBind[] ret;
	if(sdlVersion >= Version(3,4,0)){
		FnBind add =
			{q{SDL_PenDeviceType}, q{SDL_GetPenDeviceType}, q{SDL_PenID instanceID}};
		ret ~= add;
	}
	return ret;
}()));
