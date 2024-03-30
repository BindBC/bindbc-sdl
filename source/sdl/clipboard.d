/+
+            Copyright 2024 – 2025 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.clipboard;

import bindbc.sdl.config, bindbc.sdl.codegen;

extern(C) nothrow{
	alias SDL_ClipboardDataCallback = const(void)* function(void* userData, const(char)* mimeType, size_t* size);
	alias SDL_ClipboardCleanupCallback = void function(void* userData);
}

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{bool}, q{SDL_SetClipboardText}, q{const(char)* text}},
		{q{char*}, q{SDL_GetClipboardText}, q{}},
		{q{bool}, q{SDL_HasClipboardText}, q{}},
		{q{bool}, q{SDL_SetPrimarySelectionText}, q{const(char)* text}},
		{q{char*}, q{SDL_GetPrimarySelectionText}, q{}},
		{q{bool}, q{SDL_HasPrimarySelectionText}, q{}},
		{q{bool}, q{SDL_SetClipboardData}, q{SDL_ClipboardDataCallback callback, SDL_ClipboardCleanupCallback cleanup, void* userData, const(char)** mimeTypes, size_t numMIMETypes}},
		{q{bool}, q{SDL_ClearClipboardData}, q{}},
		{q{void*}, q{SDL_GetClipboardData}, q{const(char)* mimeType, size_t* size}},
		{q{bool}, q{SDL_HasClipboardData}, q{const(char)* mimeType}},
		{q{char**}, q{SDL_GetClipboardMimeTypes}, q{size_t* numMIMETypes}, aliases: [q{SDL_GetClipboardMIMETypes}]},
	];
	return ret;
}()));
