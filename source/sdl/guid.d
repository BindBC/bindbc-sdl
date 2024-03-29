/+
+            Copyright 2022 – 2024 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.guid;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

struct SDL_GUID{
	ubyte[16] data;
}

mixin(joinFnBinds((){
	FnBind[] ret;
	if(sdlSupport >= SDLSupport.v2_24){
		FnBind[] add = [
			{q{void}, q{SDL_GUIDToString}, q{SDL_GUID guid, char* pszGUID, int cbGUID}},
			{q{SDL_GUID}, q{SDL_GUIDFromString}, q{const(char)* pchGUID}},
		];
		ret ~= add;
	}
	return ret;
}()));
