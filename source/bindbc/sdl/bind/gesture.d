/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module bindbc.sdl.bind.gesture;

import bindbc.sdl.config;
import bindbc.sdl.bind.touch: SDL_TouchID;
import bindbc.sdl.bind.rwops: SDL_RWops;

alias SDL_GestureID = long;

mixin(joinFnBinds((){
	string[][] ret;
	ret ~= makeFnBinds([
		[q{int}, q{SDL_RecordGesture}, q{SDL_TouchID touchId}],
		[q{int}, q{SDL_SaveAllDollarTemplates}, q{SDL_RWops* dst}],
		[q{int}, q{SDL_SaveDollarTemplate}, q{SDL_GestureID gestureId, SDL_RWops* dst}],
		[q{int}, q{SDL_LoadDollarTemplates}, q{SDL_TouchID touchId,SDL_RWops* src}],
	]);
	return ret;
}()));
