/+
            Copyright 2022 – 2023 Aya Partridge
          Copyright 2018 - 2022 Michael D. Parker
 Distributed under the Boost Software License, Version 1.0.
     (See accompanying file LICENSE_1_0.txt or copy at
           http://www.boost.org/LICENSE_1_0.txt)
+/
module bindbc.sdl.bind.sdlstdinc;

import bindbc.sdl.config;

enum SDL_bool{
	SDL_FALSE = 0,
	SDL_TRUE = 1
}

mixin(expandEnum!SDL_bool);

deprecated alias Sint8 = byte;
deprecated alias Uint8 = ubyte;
deprecated alias Sint16 = short;
deprecated alias Uint16 = ushort;
deprecated alias Sint32 = int;
deprecated alias Uint32 = uint;
deprecated alias Sint64 = long;
deprecated alias Uint64 = ulong;

static if(sdlSupport >= SDLSupport.sdl2022){
	enum SDL_FLT_EPSILON = 1.1920928955078125e-07F;
}

enum SDL_FOURCC(char A, char B, char C, char D) =
	((A << 0) | (B << 8) | (C << 16) | (D << 24));

mixin(joinFnBinds!((){
	string[][] ret;
	ret ~= makeFnBinds!(
		[q{void}, q{SDL_free}, q{void* mem}],
	);
	return ret;
}()));
