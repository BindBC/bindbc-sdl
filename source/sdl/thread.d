/+
+            Copyright 2024 – 2026 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.thread;

import bindbc.sdl.config, bindbc.sdl.codegen;

import sdl.atomic: SDL_AtomicInt;
import sdl.properties: SDL_PropertiesID;
import sdl.stdinc: SDL_FunctionPointer;

version(Windows)     version = Microsoft;
else version(GDK)    version = Microsoft;
else version(Cygwin) version = Microsoft;

struct SDL_Thread;

alias SDL_ThreadID = ulong;

alias SDL_TLSID = SDL_AtomicInt;

mixin(makeEnumBind(q{SDL_ThreadPriority}, members: (){
	EnumMember[] ret = [
		{{q{low},           q{SDL_THREAD_PRIORITY_LOW}}},
		{{q{normal},        q{SDL_THREAD_PRIORITY_NORMAL}}},
		{{q{high},          q{SDL_THREAD_PRIORITY_HIGH}}},
		{{q{timeCritical},  q{SDL_THREAD_PRIORITY_TIME_CRITICAL}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_ThreadState}, members: (){
	EnumMember[] ret = [
		{{q{unknown},   q{SDL_THREAD_UNKNOWN}}},
		{{q{alive},     q{SDL_THREAD_ALIVE}}},
		{{q{detached},  q{SDL_THREAD_DETACHED}}},
		{{q{complete},  q{SDL_THREAD_COMPLETE}}} 
	];
	return ret;
}()));

alias SDL_ThreadFunction = extern(C) int function(void* data) nothrow;

version(Microsoft){
	private nothrow @nogc{
		alias StartAddressFn = extern(Windows) uint function(void*);
		extern(C){ //TODO: maybe move this out to BindBC-Common?
			size_t _beginthreadex(void*, uint, StartAddressFn, void*, uint, uint*);
			void _endthreadex(uint);
		}
	}
	enum SDL_BeginThreadFunction = &_beginthreadex;
	enum SDL_EndThreadFunction = &_endthreadex;
}else{
	enum SDL_BeginThreadFunction = null;
	enum SDL_EndThreadFunction = null;
}

pragma(inline,true) nothrow @nogc{
	SDL_Thread* SDL_CreateThread(SDL_ThreadFunction fn, const(char)** name, void* data) =>
		SDL_CreateThreadRuntime(fn, name, data, cast(SDL_FunctionPointer)SDL_BeginThreadFunction, cast(SDL_FunctionPointer)SDL_EndThreadFunction);
	SDL_Thread* SDL_CreateThreadWithProperties(SDL_PropertiesID props) =>
		SDL_CreateThreadWithPropertiesRuntime(props, cast(SDL_FunctionPointer)SDL_BeginThreadFunction, cast(SDL_FunctionPointer)SDL_EndThreadFunction);
}

mixin(makeEnumBind(q{SDLProp_ThreadCreate}, q{const(char)*}, members: (){
	EnumMember[] ret = [
		{{q{entryFunctionPointer},    q{SDL_PROP_THREAD_CREATE_ENTRY_FUNCTION_POINTER}},    q{"SDL.thread.create.entry_function"}},
		{{q{nameString},              q{SDL_PROP_THREAD_CREATE_NAME_STRING}},               q{"SDL.thread.create.name"}},
		{{q{userDataPointer},         q{SDL_PROP_THREAD_CREATE_USERDATA_POINTER}},          q{"SDL.thread.create.userdata"}},
		{{q{stackSizeNumber},         q{SDL_PROP_THREAD_CREATE_STACKSIZE_NUMBER}},          q{"SDL.thread.create.stacksize"}},
	];
	return ret;
}()));

alias SDL_TLSDestructorCallback = extern(C) void function(void* value) nothrow;

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{SDL_Thread*}, q{SDL_CreateThreadRuntime}, q{SDL_ThreadFunction fn, const(char)** name, void* data, SDL_FunctionPointer pFnBeginThread, SDL_FunctionPointer pFnEndThread}},
		{q{SDL_Thread*}, q{SDL_CreateThreadWithPropertiesRuntime}, q{SDL_PropertiesID props, SDL_FunctionPointer pFnBeginThread, SDL_FunctionPointer pFnEndThread}},
		{q{const(char)**}, q{SDL_GetThreadName}, q{SDL_Thread* thread}},
		{q{SDL_ThreadID}, q{SDL_GetCurrentThreadID}, q{}},
		{q{SDL_ThreadID}, q{SDL_GetThreadID}, q{SDL_Thread* thread}},
		{q{bool}, q{SDL_SetCurrentThreadPriority}, q{SDL_ThreadPriority priority}},
		{q{void}, q{SDL_WaitThread}, q{SDL_Thread* thread, int* status}},
		{q{SDL_ThreadState}, q{SDL_GetThreadState}, q{SDL_Thread* thread}},
		{q{void}, q{SDL_DetachThread}, q{SDL_Thread* thread}},
		{q{void*}, q{SDL_GetTLS}, q{SDL_TLSID* id}},
		{q{bool}, q{SDL_SetTLS}, q{SDL_TLSID* id, const(void)** value, SDL_TLSDestructorCallback destructor}},
		{q{void}, q{SDL_CleanupTLS}, q{}},
	];
	return ret;
}()));
