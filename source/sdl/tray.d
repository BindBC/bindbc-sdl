/+
+               Copyright 2025 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.tray;

import bindbc.sdl.config, bindbc.sdl.codegen;

import sdl.surface: SDL_Surface;

struct SDL_Tray;

struct SDL_TrayMenu;

struct SDL_TrayEntry;

alias SDL_TrayEntryFlags_ = uint;

mixin(makeEnumBind(q{SDL_TrayEntryFlags}, q{SDL_TrayEntryFlags_}, members: (){
	EnumMember[] ret = [
		{{q{button},      q{SDL_TRAYENTRY_BUTTON}},      q{0x0000_0001U}},
		{{q{checkbox},    q{SDL_TRAYENTRY_CHECKBOX}},    q{0x0000_0002U}},
		{{q{submenu},     q{SDL_TRAYENTRY_SUBMENU}},     q{0x0000_0004U}},
		{{q{disabled},    q{SDL_TRAYENTRY_DISABLED}},    q{0x8000_0000U}},
		{{q{checked},     q{SDL_TRAYENTRY_CHECKED}},     q{0x4000_0000U}},
	];
	return ret;
}()));

alias SDL_TrayCallback = extern(C) void function(void* userData, SDL_TrayEntry* entry) nothrow;

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{SDL_Tray*}, q{SDL_CreateTray}, q{SDL_Surface* icon, const(char)* tooltip}},
		{q{void}, q{SDL_SetTrayIcon}, q{SDL_Tray* tray, SDL_Surface* icon}},
		{q{void}, q{SDL_SetTrayTooltip}, q{SDL_Tray* tray, const(char)* tooltip}},
		{q{SDL_TrayMenu*}, q{SDL_CreateTrayMenu}, q{SDL_Tray* tray}},
		{q{SDL_TrayMenu*}, q{SDL_CreateTraySubmenu}, q{SDL_TrayEntry* entry}},
		{q{SDL_TrayMenu*}, q{SDL_GetTrayMenu}, q{SDL_Tray* tray}},
		{q{SDL_TrayMenu*}, q{SDL_GetTraySubmenu}, q{SDL_TrayEntry* entry}},
		{q{const(SDL_TrayEntry)**}, q{SDL_GetTrayEntries}, q{SDL_TrayMenu* menu, int* size}},
		{q{void}, q{SDL_RemoveTrayEntry}, q{SDL_TrayEntry* entry}},
		{q{SDL_TrayEntry*}, q{SDL_InsertTrayEntryAt}, q{SDL_TrayMenu* menu, int pos, const(char)* label, SDL_TrayEntryFlags flags}},
		{q{void}, q{SDL_SetTrayEntryLabel}, q{SDL_TrayEntry* entry, const(char)* label}},
		{q{const(char)*}, q{SDL_GetTrayEntryLabel}, q{SDL_TrayEntry* entry}},
		{q{void}, q{SDL_SetTrayEntryChecked}, q{SDL_TrayEntry* entry, bool checked}},
		{q{bool}, q{SDL_GetTrayEntryChecked}, q{SDL_TrayEntry* entry}},
		{q{void}, q{SDL_SetTrayEntryEnabled}, q{SDL_TrayEntry* entry, bool enabled}},
		{q{bool}, q{SDL_GetTrayEntryEnabled}, q{SDL_TrayEntry* entry}},
		{q{void}, q{SDL_SetTrayEntryCallback}, q{SDL_TrayEntry* entry, SDL_TrayCallback callback, void* userData}},
		{q{void}, q{SDL_ClickTrayEntry}, q{SDL_TrayEntry* entry}},
		{q{void}, q{SDL_DestroyTray}, q{SDL_Tray* tray}},
		{q{SDL_TrayMenu*}, q{SDL_GetTrayEntryParent}, q{SDL_TrayEntry* entry}},
		{q{SDL_TrayEntry*}, q{SDL_GetTrayMenuParentEntry}, q{SDL_TrayMenu* menu}},
		{q{SDL_Tray*}, q{SDL_GetTrayMenuParentTray}, q{SDL_TrayMenu* menu}},
		{q{void}, q{SDL_UpdateTrays}, q{}},
	];
	return ret;
}()));
