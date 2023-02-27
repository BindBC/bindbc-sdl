/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.loadso;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

mixin(joinFnBinds((){
	string[][] ret;
	ret ~= makeFnBinds([
		[q{void*}, q{SDL_LoadObject}, q{const(char)* sofile}],
		[q{void*}, q{SDL_LoadFunction}, q{void* handle,const(char*) name}],
		[q{void}, q{SDL_UnloadObject}, q{void* handle}],
	]);
	return ret;
}()));
