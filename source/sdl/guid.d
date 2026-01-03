/+
+            Copyright 2024 – 2026 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.guid;

import bindbc.sdl.config, bindbc.sdl.codegen;

struct SDL_GUID{
	ubyte[16] data;
}

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{void}, q{SDL_GUIDToString}, q{SDL_GUID guid, char* pszGUID, int cbGUID}},
		{q{SDL_GUID}, q{SDL_StringToGUID}, q{const(char)* pchGUID}},
	];
	return ret;
}()));
