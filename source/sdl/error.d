/+
+            Copyright 2022 – 2024 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.error;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

pragma(inline, true) nothrow @nogc{
	int  SDL_OutOfMemory(){ return SDL_Error(SDL_ENOMEM); }
	int  SDL_Unsupported(){ return SDL_Error(SDL_UNSUPPORTED); }
	void SDL_InvalidParamError(T)(param){ SDL_SetError("Parameter '%s' is invalid", param); }
}

alias SDL_errorcode = uint;
enum: SDL_errorcode{
	SDL_ENOMEM       = 0,
	SDL_EFREAD       = 1,
	SDL_EFWRITE      = 2,
	SDL_EFSEEK       = 3,
	SDL_UNSUPPORTED  = 4,
	SDL_LASTERROR    = 5,
}

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{void}, q{SDL_SetError}, q{const(char)* fmt, ...}},
		{q{const(char)*}, q{SDL_GetError}, q{}},
		{q{void}, q{SDL_ClearError}, q{}},
		{q{int}, q{SDL_Error}, q{SDL_errorcode code}},
	];
	if(sdlSupport >= SDLSupport.v2_0_14){
		FnBind[] add = [
			{q{char*}, q{SDL_GetErrorMsg}, q{char* errStr, int maxLen}},
		];
		ret ~= add;
	}
	return ret;
}()));
