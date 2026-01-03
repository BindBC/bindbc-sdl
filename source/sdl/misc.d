/+
+            Copyright 2024 – 2026 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.misc;

import bindbc.sdl.config, bindbc.sdl.codegen;

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{bool}, q{SDL_OpenURL}, q{const(char)* url}},
	];
	return ret;
}()));
