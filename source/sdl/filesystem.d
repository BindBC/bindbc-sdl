/+
+            Copyright 2024 – 2026 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.filesystem;

import bindbc.sdl.config, bindbc.sdl.codegen;

import sdl.stdinc: SDL_Time;

mixin(makeEnumBind(q{SDL_Folder}, members: (){
	EnumMember[] ret = [
		{{q{home},         q{SDL_FOLDER_HOME}}},
		{{q{desktop},      q{SDL_FOLDER_DESKTOP}}},
		{{q{documents},    q{SDL_FOLDER_DOCUMENTS}}},
		{{q{downloads},    q{SDL_FOLDER_DOWNLOADS}}},
		{{q{music},        q{SDL_FOLDER_MUSIC}}},
		{{q{pictures},     q{SDL_FOLDER_PICTURES}}},
		{{q{publicShare},  q{SDL_FOLDER_PUBLICSHARE}}},
		{{q{savedGames},   q{SDL_FOLDER_SAVEDGAMES}}},
		{{q{screenshots},  q{SDL_FOLDER_SCREENSHOTS}}},
		{{q{templates},    q{SDL_FOLDER_TEMPLATES}}},
		{{q{videos},       q{SDL_FOLDER_VIDEOS}}},
		{{q{count},        q{SDL_FOLDER_COUNT}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_PathType}, members: (){
	EnumMember[] ret = [
		{{q{none},         q{SDL_PATHTYPE_NONE}}},
		{{q{file},         q{SDL_PATHTYPE_FILE}}},
		{{q{directory},    q{SDL_PATHTYPE_DIRECTORY}}},
		{{q{other},        q{SDL_PATHTYPE_OTHER}}}
	];
	return ret;
}()));

struct SDL_PathInfo{
	SDL_PathType type;
	ulong size;
	SDL_Time createTime;
	SDL_Time modifyTime;
	SDL_Time accessTime;
	
	alias create_time = createTime;
	alias modify_time = modifyTime;
	alias access_time = accessTime;
}

alias SDL_GlobFlags_ = uint;
mixin(makeEnumBind(q{SDL_GlobFlags}, q{SDL_GlobFlags_}, aliases: [q{SDL_Glob}], members: (){
	EnumMember[] ret = [
		{{q{caseInsensitive},    q{SDL_GLOB_CASEINSENSITIVE}},    q{1U << 0}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_EnumerationResult}, aliases: [q{SDL_EnumResult}], members: (){
	EnumMember[] ret = [
		{{q{continue_},  q{SDL_ENUM_CONTINUE}}},
		{{q{success},    q{SDL_ENUM_SUCCESS}}},
		{{q{failure},    q{SDL_ENUM_FAILURE}}},
	];
	return ret;
}()));

alias SDL_EnumerateDirectoryCallback = extern(C) SDL_EnumerationResult function(void* userData, const(char)* dirName, const(char)* fname) nothrow;

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{const(char)*}, q{SDL_GetBasePath}, q{}},
		{q{char*}, q{SDL_GetPrefPath}, q{const(char)* org, const(char)* app}},
		{q{const(char)*}, q{SDL_GetUserFolder}, q{SDL_Folder folder}},
		{q{bool}, q{SDL_CreateDirectory}, q{const(char)* path}},
		{q{bool}, q{SDL_EnumerateDirectory}, q{const(char)* path, SDL_EnumerateDirectoryCallback callback, void* userData}},
		{q{bool}, q{SDL_RemovePath}, q{const(char)* path}},
		{q{bool}, q{SDL_RenamePath}, q{const(char)* oldPath, const(char)* newPath}},
		{q{bool}, q{SDL_CopyFile}, q{const(char)* oldPath, const(char)* newPath}},
		{q{bool}, q{SDL_GetPathInfo}, q{const(char)* path, SDL_PathInfo* info}},
		{q{char**}, q{SDL_GlobDirectory}, q{const(char)* path, const(char)* pattern, SDL_GlobFlags_ flags, int* count}},
		{q{char*}, q{SDL_GetCurrentDirectory}, q{}},
	];
	return ret;
}()));
