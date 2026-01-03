/+
+            Copyright 2024 – 2026 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.messagebox;

import bindbc.sdl.config, bindbc.sdl.codegen;

import sdl.video: SDL_Window;

alias SDL_MessageBoxFlags_ = uint;
mixin(makeEnumBind(q{SDL_MessageBoxFlags}, q{SDL_MessageBoxFlags_}, aliases: [q{SDL_MessageBox}], members: (){
	EnumMember[] ret = [
		{{q{error},                 q{SDL_MESSAGEBOX_ERROR}},                    q{0x0000_0010U}},
		{{q{warning},               q{SDL_MESSAGEBOX_WARNING}},                  q{0x0000_0020U}},
		{{q{information},           q{SDL_MESSAGEBOX_INFORMATION}},              q{0x0000_0040U}},
		{{q{buttonsLeftToRight},    q{SDL_MESSAGEBOX_BUTTONS_LEFT_TO_RIGHT}},    q{0x0000_0080U}},
		{{q{buttonsRightToLeft},    q{SDL_MESSAGEBOX_BUTTONS_RIGHT_TO_LEFT}},    q{0x0000_0100U}},
	];
	return ret;
}()));

alias SDL_MessageBoxButtonFlags_ = uint;
mixin(makeEnumBind(q{SDL_MessageBoxButtonFlags}, q{SDL_MessageBoxButtonFlags_}, aliases: [q{SDL_MessageBoxButton}], members: (){
	EnumMember[] ret = [
		{{q{returnKeyDefault},    q{SDL_MESSAGEBOX_BUTTON_RETURNKEY_DEFAULT}},    q{0x0000_0001U}},
		{{q{escapeKeyDefault},    q{SDL_MESSAGEBOX_BUTTON_ESCAPEKEY_DEFAULT}},    q{0x0000_0002U}},
	];
	return ret;
}()));

struct SDL_MessageBoxButtonData{
	SDL_MessageBoxButtonFlags flags;
	int buttonID;
	const(char)* text;
}

struct SDL_MessageBoxColour{
	ubyte r, g, b;
}
alias SDL_MessageBoxColor = SDL_MessageBoxColour;

mixin(makeEnumBind(q{SDL_MessageBoxColourType}, aliases: [q{SDL_MessageBoxColorType}], members: (){
	EnumMember[] ret = [
		{{q{background},          q{SDL_MESSAGEBOX_COLOUR_BACKGROUND}}, aliases: [{c: q{SDL_MESSAGEBOX_COLOR_BACKGROUND}}]},
		{{q{text},                q{SDL_MESSAGEBOX_COLOUR_TEXT}}, aliases: [{c: q{SDL_MESSAGEBOX_COLOR_TEXT}}]},
		{{q{buttonBorder},        q{SDL_MESSAGEBOX_COLOUR_BUTTON_BORDER}}, aliases: [{c: q{SDL_MESSAGEBOX_COLOR_BUTTON_BORDER}}]},
		{{q{buttonBackground},    q{SDL_MESSAGEBOX_COLOUR_BUTTON_BACKGROUND}}, aliases: [{c: q{SDL_MESSAGEBOX_COLOR_BUTTON_BACKGROUND}}]},
		{{q{buttonSelected},      q{SDL_MESSAGEBOX_COLOUR_BUTTON_SELECTED}}, aliases: [{c: q{SDL_MESSAGEBOX_COLOR_BUTTON_SELECTED}}]},
		{{q{count},               q{SDL_MESSAGEBOX_COLOUR_COUNT}}, aliases: [{c: q{SDL_MESSAGEBOX_COLOR_COUNT}}]},
	];
	return ret;
}()));

struct SDL_MessageBoxColourScheme{
	SDL_MessageBoxColour[SDL_MessageBoxColourType.count] colours;
	
	alias colors = colours;
}
alias SDL_MessageBoxColorScheme = SDL_MessageBoxColourScheme;

struct SDL_MessageBoxData{
	SDL_MessageBoxFlags flags;
	SDL_Window* window;
	const(char)* title, message;
	int numButtons;
	const(SDL_MessageBoxButtonData)* buttons;
	const(SDL_MessageBoxColourScheme)* colourScheme;
	
	alias numbuttons = numButtons;
	alias colorScheme = colourScheme;
}

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{bool}, q{SDL_ShowMessageBox}, q{const(SDL_MessageBoxData)* messageBoxData, int* buttonID}},
		{q{bool}, q{SDL_ShowSimpleMessageBox}, q{SDL_MessageBoxFlags_ flags, const(char)* title, const(char)* message, SDL_Window* window}},
	];
	return ret;
}()));
