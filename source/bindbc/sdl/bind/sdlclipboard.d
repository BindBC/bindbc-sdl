/+
            Copyright 2022 – 2023 Aya Partridge
          Copyright 2018 - 2022 Michael D. Parker
 Distributed under the Boost Software License, Version 1.0.
     (See accompanying file LICENSE_1_0.txt or copy at
           http://www.boost.org/LICENSE_1_0.txt)
+/
module bindbc.sdl.bind.sdlclipboard;

import bindbc.sdl.config;
import bindbc.sdl.bind.sdlstdinc: SDL_bool;

mixin(joinFnBinds!((){
	string[][] ret;
	ret ~= makeFnBinds!(
		[q{int}, q{SDL_SetClipboardText}, q{const(char)* text}],
		[q{char*}, q{SDL_GetClipboardText}, q{}],
		[q{SDL_bool}, q{SDL_HasClipboardText}, q{}],
	);
	return ret;
}()));
