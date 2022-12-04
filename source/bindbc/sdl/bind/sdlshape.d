/+
            Copyright 2022 – 2023 Aya Partridge
          Copyright 2018 - 2022 Michael D. Parker
 Distributed under the Boost Software License, Version 1.0.
     (See accompanying file LICENSE_1_0.txt or copy at
           http://www.boost.org/LICENSE_1_0.txt)
+/
module bindbc.sdl.bind.sdlshape;

import bindbc.sdl.config;
import bindbc.sdl.bind.sdlpixels: SDL_Color;
import bindbc.sdl.bind.sdlstdinc: SDL_bool;
import bindbc.sdl.bind.sdlsurface: SDL_Surface;
import bindbc.sdl.bind.sdlvideo: SDL_Window, SDL_WindowFlags;

enum{
	SDL_NONSHAPEABLE_WINDOW = -1,
	SDL_INVALID_SHAPE_ARGUMENT = -2,
	SDL_WINDOW_LACKS_SHAPE = -3,
}

enum WindowShapeMode{
	ShapeModeDefault,
	ShapeModeBinarizeAlpha,
	ShapeModeReverseBinarizeAlpha,
	ShapeModeColorKey
}
mixin(expandEnum!WindowShapeMode);

enum SDL_SHAPEMODEALPHA(WindowShapeMode mode) = (mode == ShapeModeDefault || mode == ShapeModeBinarizeAlpha || mode == ShapeModeReverseBinarizeAlpha);

union SDL_WindowShapeParams{
	ubyte binarizationCutoff;
	SDL_Color colorKey;
}

struct SDL_WindowShapeMode{
	WindowShapeMode mode;
	SDL_WindowShapeParams parameters;
}

mixin(joinFnBinds!((){
	string[][] ret;
	ret ~= makeFnBinds!(
		[q{SDL_Window*}, q{SDL_CreateShapedWindow}, q{const(char)* title, uint x, uint y, uint w, uint h, SDL_WindowFlags flags}],
		[q{SDL_bool}, q{SDL_IsShapedWindow}, q{const(SDL_Window)* window}],
		[q{int}, q{SDL_SetWindowShape}, q{SDL_Window* window, SDL_Surface* shape, SDL_WindowShapeMode* shape_mode}],
		[q{int}, q{SDL_GetShapedWindowMode}, q{SDL_Window* window, SDL_WindowShapeMode* shape_mode}],
	);
	return ret;
}()));
