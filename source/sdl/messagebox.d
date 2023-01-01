/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.messagebox;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

import sdl.video: SDL_Window;

alias SDL_MessageBoxFlags = uint;
enum: SDL_MessageBoxFlags{
	SDL_MESSAGEBOX_ERROR                  = 0x0000_0010,
	SDL_MESSAGEBOX_WARNING                = 0x0000_0020,
	SDL_MESSAGEBOX_INFORMATION            = 0x0000_0040,
}
static if(sdlSupport >= SDLSupport.v2_0_12)
enum: SDL_MessageBoxFlags{
	SDL_MESSAGEBOX_BUTTONS_LEFT_TO_RIGHT  = 0x0000_0080,
	SDL_MESSAGEBOX_BUTTONS_RIGHT_TO_LEFT  = 0x0000_0100,
}

alias SDL_MessageBoxButtonFlags = uint;
enum: SDL_MessageBoxButtonFlags{
	SDL_MESSAGEBOX_BUTTON_RETURNKEY_DEFAULT  = 0x000_00001,
	SDL_MESSAGEBOX_BUTTON_ESCAPEKEY_DEFAULT  = 0x000_00002,
}

struct SDL_MessageBoxButtonData{
	uint flags;
	int buttonid;
	const(char)* text;
}

struct SDL_MessageBoxColor{
	ubyte r, g, b;
}
alias SDL_MessageBoxColour = SDL_MessageBoxColor;

alias SDL_MessageBoxColorType = uint;
enum: SDL_MessageBoxColorType{
	SDL_MESSAGEBOX_COLOR_BACKGROUND         = 0,
	SDL_MESSAGEBOX_COLOR_TEXT               = 1,
	SDL_MESSAGEBOX_COLOR_BUTTON_BORDER      = 2,
	SDL_MESSAGEBOX_COLOR_BUTTON_BACKGROUND  = 3,
	SDL_MESSAGEBOX_COLOR_BUTTON_SELECTED    = 4,
	SDL_MESSAGEBOX_COLOR_MAX                = 5,
	
	SDL_MESSAGEBOX_COLOUR_BACKGROUND        = SDL_MESSAGEBOX_COLOR_BACKGROUND,
	SDL_MESSAGEBOX_COLOUR_TEXT              = SDL_MESSAGEBOX_COLOR_TEXT,
	SDL_MESSAGEBOX_COLOUR_BUTTON_BORDER     = SDL_MESSAGEBOX_COLOR_BUTTON_BORDER,
	SDL_MESSAGEBOX_COLOUR_BUTTON_BACKGROUND = SDL_MESSAGEBOX_COLOR_BUTTON_BACKGROUND,
	SDL_MESSAGEBOX_COLOUR_BUTTON_SELECTED   = SDL_MESSAGEBOX_COLOR_BUTTON_SELECTED,
	SDL_MESSAGEBOX_COLOUR_MAX               = SDL_MESSAGEBOX_COLOR_MAX,
}
alias SDL_MessageBoxColourType = SDL_MessageBoxColorType;

struct SDL_MessageBoxColorScheme{
	SDL_MessageBoxColor[SDL_MESSAGEBOX_COLOR_MAX] colors;
	alias colours = colors;
}

struct SDL_MessageBoxData{
	SDL_MessageBoxFlags flags;
	SDL_Window* window;
	const(char)* title;
	const(char)* message;
	
	int numbuttons;
	const(SDL_MessageBoxButtonData)* buttons;
	
	const(SDL_MessageBoxColorScheme)* colorScheme;
	alias colourScheme = colorScheme;
}

mixin(joinFnBinds((){
	string[][] ret;
	ret ~= makeFnBinds([
		[q{int}, q{SDL_ShowMessageBox}, q{const(SDL_MessageBoxData)* messageboxdata, int* buttonid}],
		[q{int}, q{SDL_ShowSimpleMessageBox}, q{SDL_MessageBoxFlags flags, const(char)* title, const(char)* messsage, SDL_Window* window}],
	]);
	return ret;
}()));
