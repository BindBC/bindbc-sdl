/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.shape;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

import sdl.pixels: SDL_Color;
import sdl.stdinc: SDL_bool;
import sdl.surface: SDL_Surface;
import sdl.video: SDL_Window, SDL_WindowFlags;

enum{
	SDL_NONSHAPEABLE_WINDOW     = -1,
	SDL_INVALID_SHAPE_ARGUMENT  = -2,
	SDL_WINDOW_LACKS_SHAPE      = -3,
}

alias WindowShapeMode = int;
enum: WindowShapeMode{
	ShapeModeDefault               = 0,
	ShapeModeBinarizeAlpha         = 1,
	ShapeModeReverseBinarizeAlpha  = 2,
	ShapeModeColorKey              = 3,
	
	ShapeModeColourKey             = ShapeModeColorKey,
}

enum SDL_SHAPEMODEALPHA(WindowShapeMode mode) = (mode == ShapeModeDefault || mode == ShapeModeBinarizeAlpha || mode == ShapeModeReverseBinarizeAlpha);

union SDL_WindowShapeParams{
	ubyte binarizationCutoff;
	SDL_Color colorKey;
	alias colourKey = colorKey;
}

struct SDL_WindowShapeMode{
	WindowShapeMode mode;
	SDL_WindowShapeParams parameters;
}

mixin(joinFnBinds((){
	string[][] ret;
	ret ~= makeFnBinds([
		[q{SDL_Window*}, q{SDL_CreateShapedWindow}, q{const(char)* title, uint x, uint y, uint w, uint h, SDL_WindowFlags flags}],
		[q{SDL_bool}, q{SDL_IsShapedWindow}, q{const(SDL_Window)* window}],
		[q{int}, q{SDL_SetWindowShape}, q{SDL_Window* window, SDL_Surface* shape, SDL_WindowShapeMode* shape_mode}],
		[q{int}, q{SDL_GetShapedWindowMode}, q{SDL_Window* window, SDL_WindowShapeMode* shape_mode}],
	]);
	return ret;
}()));
