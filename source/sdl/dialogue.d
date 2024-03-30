/+
+            Copyright 2024 – 2025 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.dialogue;

import bindbc.sdl.config, bindbc.sdl.codegen;

import sdl.properties: SDL_PropertiesID;
import sdl.video: SDL_Window;

struct SDL_DialogueFileFilter{
	const(char)* name;
	const(char)* pattern;
}
alias SDL_DialogFileFilter = SDL_DialogueFileFilter;

alias SDL_DialogueFileCallback = extern(C) void function(void* userData, const(char*)* fileList, int filter) nothrow;
alias SDL_DialogFileCallback = SDL_DialogueFileCallback;

mixin(makeEnumBind(q{SDL_FileDialogueType}, aliases: [q{SDL_FileDialogue}, q{SDL_FileDialog}, q{SDL_FileDialogType}], members: (){
	EnumMember[] ret = [
		{{q{openFile},      q{SDL_FILEDIALOG_OPENFILE}}},
		{{q{saveFile},      q{SDL_FILEDIALOG_SAVEFILE}}},
		{{q{openFolder},    q{SDL_FILEDIALOG_OPENFOLDER}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDLProp_FileDialogue}, q{const(char)*}, aliases: [q{SDLProp_FileDialog}], members: (){
	EnumMember[] ret = [
		{{q{filtersPointer},    q{SDL_PROP_FILE_DIALOG_FILTERS_POINTER}},    q{"SDL.filedialog.filters"}},
		{{q{nFiltersNumber},    q{SDL_PROP_FILE_DIALOG_NFILTERS_NUMBER}},    q{"SDL.filedialog.nfilters"}},
		{{q{windowPointer},     q{SDL_PROP_FILE_DIALOG_WINDOW_POINTER}},     q{"SDL.filedialog.window"}},
		{{q{locationString},    q{SDL_PROP_FILE_DIALOG_LOCATION_STRING}},    q{"SDL.filedialog.location"}},
		{{q{manyBoolean},       q{SDL_PROP_FILE_DIALOG_MANY_BOOLEAN}},       q{"SDL.filedialog.many"}},
		{{q{titleString},       q{SDL_PROP_FILE_DIALOG_TITLE_STRING}},       q{"SDL.filedialog.title"}},
		{{q{acceptString},      q{SDL_PROP_FILE_DIALOG_ACCEPT_STRING}},      q{"SDL.filedialog.accept"}},
		{{q{cancelString},      q{SDL_PROP_FILE_DIALOG_CANCEL_STRING}},      q{"SDL.filedialog.cancel"}},
	];
	return ret;
}()));

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{void}, q{SDL_ShowOpenFileDialog}, q{SDL_DialogueFileCallback callback, void* userData, SDL_Window* window, const(SDL_DialogueFileFilter)* filters, int nFilters, const(char)* defaultLocation, bool allowMany}, aliases: [q{SDL_ShowOpenFileDialogue}]},
		{q{void}, q{SDL_ShowSaveFileDialog}, q{SDL_DialogueFileCallback callback, void* userData, SDL_Window* window, const(SDL_DialogueFileFilter)* filters, int nFilters, const(char)* defaultLocation}, aliases: [q{SDL_ShowSaveFileDialogue}]},
		{q{void}, q{SDL_ShowOpenFolderDialog}, q{SDL_DialogueFileCallback callback, void* userData, SDL_Window* window, const(char)* defaultLocation, bool allowMany}, aliases: [q{SDL_ShowOpenFolderDialogue}]},
		{q{void}, q{SDL_ShowFileDialogWithProperties}, q{SDL_FileDialogueType type, SDL_DialogueFileCallback callback, void* userData, SDL_PropertiesID props}},
	];
	return ret;
}()));
