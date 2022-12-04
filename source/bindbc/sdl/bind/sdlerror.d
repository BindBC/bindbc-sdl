/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module bindbc.sdl.bind.sdlerror;

import bindbc.sdl.config;

mixin(joinFnBinds!((){
	string[][] ret;
	ret ~= makeFnBinds!(
		[q{void}, q{SDL_SetError}, q{const(char)* fmt, ...}],
		[q{const(char)*}, q{SDL_GetError}, q{}],
		[q{void}, q{SDL_ClearError}, q{}],
	);
	return ret;
}()));
