/+
+            Copyright 2022 – 2024 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.locale;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

static if(sdlSupport >= SDLSupport.v2_0_14){
	struct SDL_Locale{
		const(char)* language;
		const(char)* country;
	}
}

mixin(joinFnBinds((){
	FnBind[] ret;
	if(sdlSupport >= SDLSupport.v2_0_14){
		FnBind[] add = [
			{q{SDL_Locale*}, q{SDL_GetPreferredLocales}, q{}},
		];
		ret ~= add;
	}
	return ret;
}()));
