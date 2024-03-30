/+
+            Copyright 2024 – 2025 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.locale;

import bindbc.sdl.config, bindbc.sdl.codegen;

struct SDL_Locale{
	const(char)* language, country;
}

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{SDL_Locale**}, q{SDL_GetPreferredLocales}, q{int* count}},
	];
	return ret;
}()));
