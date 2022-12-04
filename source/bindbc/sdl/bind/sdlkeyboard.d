/+
            Copyright 2022 – 2023 Aya Partridge
          Copyright 2018 - 2022 Michael D. Parker
 Distributed under the Boost Software License, Version 1.0.
     (See accompanying file LICENSE_1_0.txt or copy at
           http://www.boost.org/LICENSE_1_0.txt)
+/
module bindbc.sdl.bind.sdlkeyboard;

import bindbc.sdl.config;
import bindbc.sdl.bind.sdlkeycode: SDL_Keycode, SDL_Keymod;
import bindbc.sdl.bind.sdlrect: SDL_Rect;
import bindbc.sdl.bind.sdlscancode: SDL_Scancode;
import bindbc.sdl.bind.sdlstdinc: SDL_bool;
import bindbc.sdl.bind.sdlvideo: SDL_Window;

struct SDL_Keysym{
	SDL_Scancode scancode;
	SDL_Keycode sym;
	ushort mod;
	uint unused;
}

mixin(joinFnBinds!((){
	string[][] ret;
	ret ~= makeFnBinds!(
		[q{SDL_Window*}, q{SDL_GetKeyboardFocus}, q{}],
		[q{ubyte*}, q{SDL_GetKeyboardState}, q{int* numkeys}],
		[q{SDL_Keymod}, q{SDL_GetModState}, q{}],
		[q{void}, q{SDL_SetModState}, q{SDL_Keymod modstate}],
		[q{SDL_Keycode}, q{SDL_GetKeyFromScancode}, q{SDL_Scancode scancode}],
		[q{SDL_Scancode}, q{SDL_GetScancodeFromKey}, q{SDL_Keycode key}],
		[q{const(char)*}, q{SDL_GetScancodeName}, q{SDL_Scancode scancode}],
		[q{SDL_Scancode}, q{SDL_GetScancodeFromName}, q{const(char)* name}],
		[q{const(char)*}, q{SDL_GetKeyName}, q{SDL_Keycode key}],
		[q{SDL_Keycode}, q{SDL_GetKeyFromName}, q{const(char)* name}],
		[q{void}, q{SDL_StartTextInput}, q{}],
		[q{SDL_bool}, q{SDL_IsTextInputActive}, q{}],
		[q{void}, q{SDL_StopTextInput}, q{}],
		[q{void}, q{SDL_SetTextInputRect}, q{SDL_Rect*}],
		[q{SDL_bool}, q{SDL_HasScreenKeyboardSupport}, q{}],
		[q{SDL_bool}, q{SDL_IsScreenKeyboardShown}, q{SDL_Window* window}],
	);

	static if(sdlSupport == SDLSupport.sdl2022){
		ret ~= makeFnBinds!(
			[q{void}, q{SDL_ClearComposition}, q{}],
			[q{SDL_bool}, q{SDL_IsTextInputShown}, q{}],
		);
	}
	return ret;
}()));
