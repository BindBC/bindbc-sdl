/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module bindbc.sdl.bind.sdlmisc;

import bindbc.sdl.config;

mixin(joinFnBinds!((){
	string[][] ret;
	static if(sdlSupport >= SDLSupport.sdl2014){
		ret ~= makeFnBinds!(
			[q{int}, q{SDL_OpenURL}, q{const(char)* url}],
		);
	}
	return ret;
}()));
