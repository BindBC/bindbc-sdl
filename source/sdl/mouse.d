/+
+            Copyright 2024 – 2026 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.mouse;

import bindbc.sdl.config, bindbc.sdl.codegen;

import sdl.surface: SDL_Surface;
import sdl.video: SDL_Window;

alias SDL_MouseID = uint;

struct SDL_Cursor;

mixin(makeEnumBind(q{SDL_SystemCursor}, members: (){
	EnumMember[] ret = [
		{{q{default_},      q{SDL_SYSTEM_CURSOR_DEFAULT}}},
		{{q{text},          q{SDL_SYSTEM_CURSOR_TEXT}}},
		{{q{wait},          q{SDL_SYSTEM_CURSOR_WAIT}}},
		{{q{crosshair},     q{SDL_SYSTEM_CURSOR_CROSSHAIR}}},
		{{q{progress},      q{SDL_SYSTEM_CURSOR_PROGRESS}}},
		{{q{nwseResize},    q{SDL_SYSTEM_CURSOR_NWSE_RESIZE}}},
		{{q{neswResize},    q{SDL_SYSTEM_CURSOR_NESW_RESIZE}}},
		{{q{ewResize},      q{SDL_SYSTEM_CURSOR_EW_RESIZE}}},
		{{q{nsResize},      q{SDL_SYSTEM_CURSOR_NS_RESIZE}}},
		{{q{move},          q{SDL_SYSTEM_CURSOR_MOVE}}},
		{{q{notAllowed},    q{SDL_SYSTEM_CURSOR_NOT_ALLOWED}}},
		{{q{pointer},       q{SDL_SYSTEM_CURSOR_POINTER}}},
		{{q{nwResize},      q{SDL_SYSTEM_CURSOR_NW_RESIZE}}},
		{{q{nResize},       q{SDL_SYSTEM_CURSOR_N_RESIZE}}},
		{{q{neResize},      q{SDL_SYSTEM_CURSOR_NE_RESIZE}}},
		{{q{eResize},       q{SDL_SYSTEM_CURSOR_E_RESIZE}}},
		{{q{seResize},      q{SDL_SYSTEM_CURSOR_SE_RESIZE}}},
		{{q{sResize},       q{SDL_SYSTEM_CURSOR_S_RESIZE}}},
		{{q{swResize},      q{SDL_SYSTEM_CURSOR_SW_RESIZE}}},
		{{q{wResize},       q{SDL_SYSTEM_CURSOR_W_RESIZE}}},
		{{q{count},         q{SDL_SYSTEM_CURSOR_COUNT}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_MouseWheelDirection}, aliases: [q{SDL_MouseWheel}], members: (){
	EnumMember[] ret = [
		{{q{normal},   q{SDL_MOUSEWHEEL_NORMAL}}},
		{{q{flipped},  q{SDL_MOUSEWHEEL_FLIPPED}}},
	];
	return ret;
}()));

struct SDL_CursorFrameInfo{
	SDL_Surface* surface;
	uint duration;
}

mixin(makeEnumBind(q{SDL_MouseButton}, q{ubyte}, aliases: [q{SDL_Button}], members: (){
	EnumMember[] ret = [
		{{q{left},    q{SDL_BUTTON_LEFT}},    q{1}},
		{{q{middle},  q{SDL_BUTTON_MIDDLE}},  q{2}},
		{{q{right},   q{SDL_BUTTON_RIGHT}},   q{3}},
		{{q{x1},      q{SDL_BUTTON_X1}},      q{4}},
		{{q{x2},      q{SDL_BUTTON_X2}},      q{5}},
	];
	return ret;
}()));

alias SDL_MouseButtonFlags_ = uint;
mixin(makeEnumBind(q{SDL_MouseButtonFlags}, q{SDL_MouseButtonFlags_}, aliases: [q{SDL_ButtonFlags}], members: (){
	EnumMember[] ret = [
		{{q{left},    q{SDL_BUTTON_LMASK}},   q{SDL_BUTTON_MASK(SDL_MouseButton.left)}},
		{{q{middle},  q{SDL_BUTTON_MMASK}},   q{SDL_BUTTON_MASK(SDL_MouseButton.middle)}},
		{{q{right},   q{SDL_BUTTON_RMASK}},   q{SDL_BUTTON_MASK(SDL_MouseButton.right)}},
		{{q{x1},      q{SDL_BUTTON_X1MASK}},  q{SDL_BUTTON_MASK(SDL_MouseButton.x1)}},
		{{q{x2},      q{SDL_BUTTON_X2MASK}},  q{SDL_BUTTON_MASK(SDL_MouseButton.x2)}},
	];
	return ret;
}()));

alias SDL_MouseMotionTransformCallback = extern(C) void function(void* userData, ulong timestamp, SDL_Window* window, SDL_MouseID mouseID, float* x, float* y) nothrow;

pragma(inline,true)
SDL_MouseButtonFlags SDL_BUTTON_MASK(SDL_MouseButton x) nothrow @nogc pure @safe =>
	cast(SDL_MouseButtonFlags)(1U << (x-1));

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{bool}, q{SDL_HasMouse}, q{}},
		{q{SDL_MouseID*}, q{SDL_GetMice}, q{int* count}},
		{q{const(char)*}, q{SDL_GetMouseNameForID}, q{SDL_MouseID instanceID}},
		{q{SDL_Window*}, q{SDL_GetMouseFocus}, q{}},
		{q{SDL_MouseButtonFlags}, q{SDL_GetMouseState}, q{float* x, float* y}},
		{q{SDL_MouseButtonFlags}, q{SDL_GetGlobalMouseState}, q{float* x, float* y}},
		{q{SDL_MouseButtonFlags}, q{SDL_GetRelativeMouseState}, q{float* x, float* y}},
		{q{void}, q{SDL_WarpMouseInWindow}, q{SDL_Window* window, float x, float y}},
		{q{bool}, q{SDL_WarpMouseGlobal}, q{float x, float y}},
		{q{bool}, q{SDL_SetWindowRelativeMouseMode}, q{SDL_Window* window, bool enabled}},
		{q{bool}, q{SDL_GetWindowRelativeMouseMode}, q{SDL_Window* window}},
		{q{bool}, q{SDL_CaptureMouse}, q{bool enabled}},
		{q{SDL_Cursor*}, q{SDL_CreateCursor}, q{const(ubyte)* data, const(ubyte)* mask, int w, int h, int hotX, int hotY}},
		{q{SDL_Cursor*}, q{SDL_CreateColorCursor}, q{SDL_Surface* surface, int hotX, int hotY}},
		{q{SDL_Cursor*}, q{SDL_CreateSystemCursor}, q{SDL_SystemCursor id}},
		{q{bool}, q{SDL_SetCursor}, q{SDL_Cursor* cursor}},
		{q{SDL_Cursor*}, q{SDL_GetCursor}, q{}},
		{q{SDL_Cursor*}, q{SDL_GetDefaultCursor}, q{}},
		{q{void}, q{SDL_DestroyCursor}, q{SDL_Cursor* cursor}},
		{q{bool}, q{SDL_ShowCursor}, q{}},
		{q{bool}, q{SDL_HideCursor}, q{}},
		{q{bool}, q{SDL_CursorVisible}, q{}},
	];
	if(sdlVersion >= Version(3,4,0)){
		FnBind[] add = [
			{q{bool}, q{SDL_SetRelativeMouseTransform}, q{SDL_MouseMotionTransformCallback callback, void* userData}},
			{q{SDL_Cursor*}, q{SDL_CreateAnimatedCursor}, q{SDL_CursorFrameInfo* frames, int frameCount, int hotX, int hotY}},
		];
		ret ~= add;
	}
	return ret;
}()));
