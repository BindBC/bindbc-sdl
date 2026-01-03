/+
+            Copyright 2025 – 2026 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.asyncio;

import bindbc.sdl.config, bindbc.sdl.codegen;

struct SDL_AsyncIO;

mixin(makeEnumBind(q{SDL_AsyncIOTaskType}, aliases: [q{SDL_AsyncIOTask}], members: (){
	EnumMember[] ret = [
		{{q{read},     q{SDL_ASYNCIO_TASK_READ}}},
		{{q{write},    q{SDL_ASYNCIO_TASK_WRITE}}},
		{{q{close},    q{SDL_ASYNCIO_TASK_CLOSE}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_AsyncIOResult}, members: (){
	EnumMember[] ret = [
		{{q{complete},    q{SDL_ASYNCIO_COMPLETE}}},
		{{q{failure},     q{SDL_ASYNCIO_FAILURE}}},
		{{q{canceled},    q{SDL_ASYNCIO_CANCELED}}},
	];
	return ret;
}()));

struct SDL_AsyncIOOutcome{
	SDL_AsyncIO* asyncIO;
	SDL_AsyncIOTaskType type;
	SDL_AsyncIOResult result;
	void* buffer;
	ulong offset;
	ulong bytesRequested;
	ulong bytesTransferred;
	void* userData;
	
	alias asyncio = asyncIO;
	alias bytes_requested = bytesRequested;
	alias bytes_transferred = bytesTransferred;
	alias userdata = userData;
}

struct SDL_AsyncIOQueue;

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{SDL_AsyncIO*}, q{SDL_AsyncIOFromFile}, q{const(char)* file, const(char)* mode}},
		{q{long}, q{SDL_GetAsyncIOSize}, q{SDL_AsyncIO* asyncIO}},
		{q{bool}, q{SDL_ReadAsyncIO}, q{SDL_AsyncIO* asyncIO, void* ptr, ulong offset, ulong size, SDL_AsyncIOQueue* queue, void* userData}},
		{q{bool}, q{SDL_WriteAsyncIO}, q{SDL_AsyncIO* asyncIO, void* ptr, ulong offset, ulong size, SDL_AsyncIOQueue* queue, void* userData}},
		{q{bool}, q{SDL_CloseAsyncIO}, q{SDL_AsyncIO* asyncIO, bool flush, SDL_AsyncIOQueue* queue, void* userData}},
		{q{SDL_AsyncIOQueue*}, q{SDL_CreateAsyncIOQueue}, q{}},
		{q{void}, q{SDL_DestroyAsyncIOQueue}, q{SDL_AsyncIOQueue* queue}},
		{q{bool}, q{SDL_GetAsyncIOResult}, q{SDL_AsyncIOQueue* queue, SDL_AsyncIOOutcome* outcome}},
		{q{bool}, q{SDL_WaitAsyncIOResult}, q{SDL_AsyncIOQueue* queue, SDL_AsyncIOOutcome* outcome, int timeoutMS}},
		{q{void}, q{SDL_SignalAsyncIOQueue}, q{SDL_AsyncIOQueue* queue}},
		{q{bool}, q{SDL_LoadFileAsync}, q{const(char)* file, SDL_AsyncIOQueue* queue, void* userData}},
	];
	return ret;
}()));
