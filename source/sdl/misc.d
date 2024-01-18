/+
+            Copyright 2022 – 2024 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.misc;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

mixin(joinFnBinds((){
	FnBind[] ret;
	if(sdlSupport >= SDLSupport.v2_0_14){
		FnBind[] add = [
			{q{int}, q{SDL_OpenURL}, q{const(char)* url}},
		];
		ret ~= add;
	}
	return ret;
}()));
