/+
+            Copyright 2022 – 2024 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.assert_;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

alias SDL_assert_state = uint;
enum: SDL_assert_state{
	SDL_ASSERTION_RETRY          = 0,
	SDL_ASSERTION_BREAK          = 1,
	SDL_ASSERTION_ABORT          = 2,
	SDL_ASSERTION_IGNORE         = 3,
	SDL_ASSERTION_ALWAYS_IGNORE  = 4,
}
alias SDL_AssertState = SDL_assert_state;

struct SDL_assert_data{
	int always_ignore;
	uint trigger_count;
	const(char)* condition;
	const(char)* filename;
	int linenum;
	const(char)* function_;
	const(SDL_assert_data)* next;
}
alias SDL_AssertData = SDL_assert_data;

extern(C) nothrow alias SDL_AssertionHandler = SDL_AssertState function(const(SDL_AssertData)* data, void* userData);

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{void}, q{SDL_SetAssertionHandler}, q{SDL_AssertionHandler handler, void* userData}},
		{q{const(SDL_assert_data)*}, q{SDL_GetAssertionReport}, q{}},
		{q{void}, q{SDL_ResetAssertionReport}, q{}},
	];
	if(sdlSupport >= SDLSupport.v2_0_2){
		FnBind[] add = [
			{q{SDL_AssertionHandler}, q{SDL_GetAssertionHandler}, q{void** pUserData}},
			{q{SDL_AssertionHandler}, q{SDL_GetDefaultAssertionHandler}, q{}},
		];
		ret ~= add;
	}
	return ret;
}()));
