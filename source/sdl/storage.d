/+
+            Copyright 2024 – 2026 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.storage;

import bindbc.sdl.config, bindbc.sdl.codegen;

import sdl.filesystem: SDL_EnumerateDirectoryCallback, SDL_GlobFlags_, SDL_PathInfo;
import sdl.properties: SDL_PropertiesID;

struct SDL_StorageInterface{
	uint version_;
	private extern(C) nothrow{
		alias CloseFn = bool function(void* userData);
		alias ReadyFn = bool function(void* userData);
		alias EnumerateFn = bool function(void* userData, const(char)* path, SDL_EnumerateDirectoryCallback callback, void* callbackUserData);
		alias InfoFn = bool function(void* userData, const(char)* path, SDL_PathInfo* info);
		alias ReadFileFn = bool function(void* userData, const(char)* path, void* destination, ulong length);
		alias WriteFileFn = bool function(void* userData, const(char)* path, const(void)* source, ulong length);
		alias MkdirFn = bool function(void* userData, const(char)* path);
		alias RemoveFn = bool function(void* userData, const(char)* path);
		alias RenameFn = bool function(void* userData, const(char)* oldPath, const(char)* newPath);
		alias CopyFn = bool function(void* userData, const(char)* oldPath, const(char)* newPath);
		alias SpaceRemainingFn = ulong function(void* userData);
	}
	CloseFn close;
	ReadyFn ready;
	EnumerateFn enumerate;
	InfoFn info;
	ReadFileFn readFile;
	WriteFileFn writeFile;
	MkdirFn mkDir;
	RemoveFn remove;
	RenameFn rename;
	CopyFn copy;
	SpaceRemainingFn spaceRemaining;
	
	alias read_file = readFile;
	alias write_file = writeFile;
	alias mkdir = mkDir;
	alias space_remaining = spaceRemaining;
}

static assert(
	((void*).sizeof == 4 && SDL_StorageInterface.sizeof == 48) ||
	((void*).sizeof == 8 && SDL_StorageInterface.sizeof == 96)
);

struct SDL_Storage;

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{SDL_Storage*}, q{SDL_OpenTitleStorage}, q{const(char)* override_, SDL_PropertiesID props}},
		{q{SDL_Storage*}, q{SDL_OpenUserStorage}, q{const(char)* org, const(char)* app, SDL_PropertiesID props}},
		{q{SDL_Storage*}, q{SDL_OpenFileStorage}, q{const(char)* path}},
		{q{SDL_Storage*}, q{SDL_OpenStorage}, q{const(SDL_StorageInterface)* iface, void* userData}},
		{q{bool}, q{SDL_CloseStorage}, q{SDL_Storage* storage}},
		{q{bool}, q{SDL_StorageReady}, q{SDL_Storage* storage}},
		{q{bool}, q{SDL_GetStorageFileSize}, q{SDL_Storage* storage, const(char)* path, ulong* length}},
		{q{bool}, q{SDL_ReadStorageFile}, q{SDL_Storage* storage, const(char)* path, void* destination, ulong length}},
		{q{bool}, q{SDL_WriteStorageFile}, q{SDL_Storage* storage, const(char)* path, const(void)* source, ulong length}},
		{q{bool}, q{SDL_CreateStorageDirectory}, q{SDL_Storage* storage, const(char)* path}},
		{q{bool}, q{SDL_EnumerateStorageDirectory}, q{SDL_Storage* storage, const(char)* path, SDL_EnumerateDirectoryCallback callback, void* userData}},
		{q{bool}, q{SDL_RemoveStoragePath}, q{SDL_Storage* storage, const(char)* path}},
		{q{bool}, q{SDL_RenameStoragePath}, q{SDL_Storage* storage, const(char)* oldPath, const(char)* newPath}},
		{q{bool}, q{SDL_CopyStorageFile}, q{SDL_Storage* storage, const(char)* oldPath, const(char)* newPath}},
		{q{bool}, q{SDL_GetStoragePathInfo}, q{SDL_Storage* storage, const(char)* path, SDL_PathInfo* info}},
		{q{ulong}, q{SDL_GetStorageSpaceRemaining}, q{SDL_Storage* storage}},
		{q{char**}, q{SDL_GlobStorageDirectory}, q{SDL_Storage* storage, const(char)* path, const(char)* pattern, SDL_GlobFlags_ flags, int* count}},
	];
	return ret;
}()));
