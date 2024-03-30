/+
+            Copyright 2024 – 2025 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.keyboard;

import bindbc.sdl.config, bindbc.sdl.codegen;

import sdl.keycode: SDL_KeyCode, SDL_KeyCode_, SDL_KeyMod, SDL_KeyMod_;
import sdl.properties: SDL_PropertiesID;
import sdl.rect: SDL_Rect;
import sdl.scancode: SDL_Scancode;
import sdl.video: SDL_Window;

alias SDL_KeyboardID = uint;

mixin(makeEnumBind(q{SDL_TextInputType}, members: (){
	EnumMember[] ret = [
		{{q{text},                     q{SDL_TEXTINPUT_TYPE_TEXT}}},
		{{q{textName},                 q{SDL_TEXTINPUT_TYPE_TEXT_NAME}}},
		{{q{textEmail},                q{SDL_TEXTINPUT_TYPE_TEXT_EMAIL}}},
		{{q{textUsername},             q{SDL_TEXTINPUT_TYPE_TEXT_USERNAME}}},
		{{q{textPasswordHidden},       q{SDL_TEXTINPUT_TYPE_TEXT_PASSWORD_HIDDEN}}},
		{{q{textPasswordVisible},      q{SDL_TEXTINPUT_TYPE_TEXT_PASSWORD_VISIBLE}}},
		{{q{number},                   q{SDL_TEXTINPUT_TYPE_NUMBER}}},
		{{q{numberPasswordHidden},     q{SDL_TEXTINPUT_TYPE_NUMBER_PASSWORD_HIDDEN}}},
		{{q{numberPasswordVisible},    q{SDL_TEXTINPUT_TYPE_NUMBER_PASSWORD_VISIBLE}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_Capitalisation}, aliases: [q{SDL_Capitalise}, q{SDL_Capitalization}, q{SDL_Capitalize}], members: (){
	EnumMember[] ret = [
		{{q{none},       q{SDL_CAPITALISE_NONE}}, aliases: [{c: q{SDL_CAPITALIZE_NONE}}]},
		{{q{sentences},  q{SDL_CAPITALISE_SENTENCES}}, aliases: [{c: q{SDL_CAPITALIZE_SENTENCES}}]},
		{{q{words},      q{SDL_CAPITALISE_WORDS}}, aliases: [{c: q{SDL_CAPITALIZE_WORDS}}]},
		{{q{letters},    q{SDL_CAPITALISE_LETTERS}}, aliases: [{c: q{SDL_CAPITALIZE_LETTERS}}]},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDLProp_TextInput}, q{const(char)*}, members: (){
	EnumMember[] ret = [
		{{q{typeNumber},                q{SDL_PROP_TEXTINPUT_TYPE_NUMBER}},                 q{"SDL.textinput.type"}},
		{{q{capitalisationNumber},      q{SDL_PROP_TEXTINPUT_CAPITALISATION_NUMBER}},       q{"SDL.textinput.capitalization"}, aliases: [{q{capitalizationNumber}, q{SDL_PROP_TEXTINPUT_CAPITALIZATION_NUMBER}}]},
		{{q{autocorrectBoolean},        q{SDL_PROP_TEXTINPUT_AUTOCORRECT_BOOLEAN}},         q{"SDL.textinput.autocorrect"}},
		{{q{multilineBoolean},          q{SDL_PROP_TEXTINPUT_MULTILINE_BOOLEAN}},           q{"SDL.textinput.multiline"}},
		{{q{androidInputTypeNumber},    q{SDL_PROP_TEXTINPUT_ANDROID_INPUTTYPE_NUMBER}},    q{"SDL.textinput.android.inputtype"}},
	];
	return ret;
}()));

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{bool}, q{SDL_HasKeyboard}, q{}},
		{q{SDL_KeyboardID*}, q{SDL_GetKeyboards}, q{int* count}},
		{q{const(char)*}, q{SDL_GetKeyboardNameForID}, q{SDL_KeyboardID instanceID}},
		{q{SDL_Window*}, q{SDL_GetKeyboardFocus}, q{}},
		{q{const(bool)*}, q{SDL_GetKeyboardState}, q{int* numKeys}},
		{q{void}, q{SDL_ResetKeyboard}, q{}},
		{q{SDL_KeyMod}, q{SDL_GetModState}, q{}},
		{q{void}, q{SDL_SetModState}, q{SDL_KeyMod_ modState}},
		{q{SDL_KeyCode}, q{SDL_GetKeyFromScancode}, q{SDL_Scancode scancode, SDL_KeyMod_ modState, bool keyEvent}},
		{q{SDL_Scancode}, q{SDL_GetScancodeFromKey}, q{SDL_KeyCode_ key, SDL_KeyMod_* modState}},
		{q{bool}, q{SDL_SetScancodeName}, q{SDL_Scancode scancode, const(char)* name}},
		{q{const(char)*}, q{SDL_GetScancodeName}, q{SDL_Scancode scancode}},
		{q{SDL_Scancode}, q{SDL_GetScancodeFromName}, q{const(char)* name}},
		{q{const(char)*}, q{SDL_GetKeyName}, q{SDL_KeyCode_ key}},
		{q{SDL_KeyCode}, q{SDL_GetKeyFromName}, q{const(char)* name}},
		{q{bool}, q{SDL_StartTextInput}, q{SDL_Window* window}},
		{q{bool}, q{SDL_StartTextInputWithProperties}, q{SDL_Window* window, SDL_PropertiesID props}},
		{q{bool}, q{SDL_TextInputActive}, q{SDL_Window* window}},
		{q{bool}, q{SDL_StopTextInput}, q{SDL_Window* window}},
		{q{bool}, q{SDL_ClearComposition}, q{SDL_Window* window}},
		{q{bool}, q{SDL_SetTextInputArea}, q{SDL_Window* window, const(SDL_Rect)* rect, int cursor}},
		{q{bool}, q{SDL_GetTextInputArea}, q{SDL_Window* window, SDL_Rect* rect, int* cursor}},
		{q{bool}, q{SDL_HasScreenKeyboardSupport}, q{}},
		{q{bool}, q{SDL_ScreenKeyboardShown}, q{SDL_Window* window}},
	];
	return ret;
}()));
