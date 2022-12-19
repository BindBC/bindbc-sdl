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

alias SDL_MessageBoxFlags = int;
enum: SDL_MessageBoxFlags{
	SDL_MESSAGEBOX_ERROR                  = 0x00000010,
	SDL_MESSAGEBOX_WARNING                = 0x00000020,
	SDL_MESSAGEBOX_INFORMATION            = 0x00000040,
}
static if(sdlSupport >= SDLSupport.v2_0_12)
enum: SDL_MessageBoxFlags{
	SDL_MESSAGEBOX_BUTTONS_LEFT_TO_RIGHT  = 0x00000080,
	SDL_MESSAGEBOX_BUTTONS_RIGHT_TO_LEFT  = 0x00000100,
}

alias SDL_MessageBoxButtonFlags = int;
enum: SDL_MessageBoxButtonFlags{
	SDL_MESSAGEBOX_BUTTON_RETURNKEY_DEFAULT  = 0x00000001,
	SDL_MESSAGEBOX_BUTTON_ESCAPEKEY_DEFAULT  = 0x00000002,
}

struct SDL_MessageBoxButtonData{
	uint flags;
	int buttonid;
	const(char)* text;
}

struct SDL_MessageBoxColor{
	ubyte r, g, b;
}

alias SDL_MessageBoxColorType = int;
enum: SDL_MessageBoxColorType{
	SDL_MESSAGEBOX_COLOR_BACKGROUND,
	SDL_MESSAGEBOX_COLOR_TEXT,
	SDL_MESSAGEBOX_COLOR_BUTTON_BORDER,
	SDL_MESSAGEBOX_COLOR_BUTTON_BACKGROUND,
	SDL_MESSAGEBOX_COLOR_BUTTON_SELECTED,
	SDL_MESSAGEBOX_COLOR_MAX,
}

struct SDL_MessageBoxColorScheme{
	SDL_MessageBoxColor[SDL_MESSAGEBOX_COLOR_MAX] colors;
}

struct SDL_MessageBoxData{
	uint flags;
	SDL_Window* window;
	const(char)* title;
	const(char)* message;
	int numbuttons;
	const(SDL_MessageBoxButtonData)* buttons;
	const(SDL_MessageBoxColorScheme)* colorScheme;
}

mixin(joinFnBinds((){
	string[][] ret;
	ret ~= makeFnBinds([
		[q{int}, q{SDL_ShowMessageBox}, q{const(SDL_MessageBoxData)* messageboxdata, int* buttonid}],
		[q{int}, q{SDL_ShowSimpleMessageBox}, q{uint flags, const(char)* title, const(char)* messsage, SDL_Window* window}],
	]);
	return ret;
}()));
