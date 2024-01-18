/+
+            Copyright 2022 – 2024 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.platform;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{const(char)*}, q{SDL_GetPlatform}, q{}},
	];
	return ret;
}()));
