/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.mouse;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

import sdl.stdinc: SDL_bool;
import sdl.surface: SDL_Surface;
import sdl.video: SDL_Window;

struct SDL_Cursor;

alias SDL_SystemCursor = uint;
enum: SDL_SystemCursor{
	SDL_SYSTEM_CURSOR_ARROW        = 0,
	SDL_SYSTEM_CURSOR_IBEAM        = 1,
	SDL_SYSTEM_CURSOR_WAIT         = 2,
	SDL_SYSTEM_CURSOR_CROSSHAIR    = 3,
	SDL_SYSTEM_CURSOR_WAITARROW    = 4,
	SDL_SYSTEM_CURSOR_SIZENWSE     = 5,
	SDL_SYSTEM_CURSOR_SIZENESW     = 6,
	SDL_SYSTEM_CURSOR_SIZEWE       = 7,
	SDL_SYSTEM_CURSOR_SIZENS       = 8,
	SDL_SYSTEM_CURSOR_SIZEALL      = 9,
	SDL_SYSTEM_CURSOR_NO           = 10,
	SDL_SYSTEM_CURSOR_HAND         = 11,
	SDL_NUM_SYSTEM_CURSORS         = 12,
}

static if(sdlSupport >= SDLSupport.v2_0_4){
	alias SDL_MouseWheelDirection = uint;
	enum: SDL_MouseWheelDirection{
		SDL_MOUSEWHEEL_NORMAL   = 0,
		SDL_MOUSEWHEEL_FLIPPED  = 1,
	}
}

pragma(inline, true) nothrow @nogc pure @safe{
	uint SDL_BUTTON(ubyte x){ return 1 << (x-1); }
}
deprecated("Please use the non-template version instead"){
	enum SDL_BUTTON(ubyte x) = 1 << (x-1);
}
enum: ubyte{
	SDL_BUTTON_LEFT      = 1,
	SDL_BUTTON_MIDDLE    = 2,
	SDL_BUTTON_RIGHT     = 3,
	SDL_BUTTON_X1        = 4,
	SDL_BUTTON_X2        = 5,
	SDL_BUTTON_LMASK     = SDL_BUTTON(SDL_BUTTON_LEFT),
	SDL_BUTTON_MMASK     = SDL_BUTTON(SDL_BUTTON_MIDDLE),
	SDL_BUTTON_RMASK     = SDL_BUTTON(SDL_BUTTON_RIGHT),
	SDL_BUTTON_X1MASK    = SDL_BUTTON(SDL_BUTTON_X1),
	SDL_BUTTON_X2MASK    = SDL_BUTTON(SDL_BUTTON_X2),
}

mixin(joinFnBinds((){
	string[][] ret;
	ret ~= makeFnBinds([
		[q{SDL_Window*}, q{SDL_GetMouseFocus}, q{}],
		[q{uint}, q{SDL_GetMouseState}, q{int* x, int* y}],
		[q{uint}, q{SDL_GetRelativeMouseState}, q{int* x, int* y}],
		[q{void}, q{SDL_WarpMouseInWindow}, q{SDL_Window* window, int x, int y}],
		[q{int}, q{SDL_SetRelativeMouseMode}, q{SDL_bool enabled}],
		[q{SDL_bool}, q{SDL_GetRelativeMouseMode}, q{}],
		[q{SDL_Cursor*}, q{SDL_CreateCursor}, q{const(ubyte)* data, const(ubyte)* mask, int w, int h, int hot_x, int hot_y}],
		[q{SDL_Cursor*}, q{SDL_CreateColorCursor}, q{SDL_Surface* surface, int hot_x, int hot_y}],
		[q{SDL_Cursor*}, q{SDL_CreateSystemCursor}, q{SDL_SystemCursor id}],
		[q{void}, q{SDL_SetCursor}, q{SDL_Cursor* cursor}],
		[q{SDL_Cursor*}, q{SDL_GetCursor}, q{}],
		[q{SDL_Cursor*}, q{SDL_GetDefaultCursor}, q{}],
		[q{void}, q{SDL_FreeCursor}, q{SDL_Cursor* cursor}],
		[q{int}, q{SDL_ShowCursor}, q{int toggle}],
	]);
	static if(sdlSupport >= SDLSupport.v2_0_4){
		ret ~= makeFnBinds([
			[q{int}, q{SDL_CaptureMouse}, q{SDL_bool enabled}],
			[q{uint}, q{SDL_GetGlobalMouseState}, q{int* x, int* y}],
			[q{void}, q{SDL_WarpMouseGlobal}, q{int x, int y}],
		]);
	}
	return ret;
}()));

alias SDL_CreateColourCursor = SDL_CreateColorCursor;
