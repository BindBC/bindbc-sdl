/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.filesystem;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

mixin(joinFnBinds((){
	string[][] ret;
	static if(sdlSupport >= SDLSupport.v2_0_1){
		ret ~= makeFnBinds([
			[q{char*}, q{SDL_GetBasePath}, q{}],
			[q{char*}, q{SDL_GetPrefPath}, q{const(char)* org, const(char)* app}],
		]);
	}
	return ret;
}()));
