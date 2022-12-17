/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.thread;

import bindbc.sdl.config;

struct SDL_Thread;
alias SDL_threadID = c_ulong;
alias SDL_TLSID = uint;

alias SDL_ThreadPriority = int;
enum: SDL_ThreadPriority{
	SDL_THREAD_PRIORITY_LOW            = 0,
	SDL_THREAD_PRIORITY_NORMAL         = 1,
	SDL_THREAD_PRIORITY_HIGH           = 2,
}
static if(sdlSupport >= SDLSupport.v2_0_9)
enum: SDL_ThreadPriority{
	SDL_THREAD_PRIORITY_TIME_CRITICAL  = 3,
};

extern(C) nothrow{
	alias SDL_ThreadFunction = int function(void*);
	alias TLSDestructor = void function(void*);
}

version(Windows){
	/*
	On Windows, SDL_CreateThread/WithStackSize require the _beginthreadex/_endthreadex of
	the caller's process when using the DLL. As best as I can tell, this will be okay even
	when statically linking. If it does break, I'll need to add a new version identifier
	when BindBC_Static is specified in order to distingiuish between linking with the
	DLL's import library and statically linking with SDL.
	*/
	private{
		import core.stdc.stdint: uintptr_t;
		
		extern(Windows) alias btex_fptr = uint function(void*);
		extern(C) @nogc nothrow{
			uintptr_t _beginthreadex(void*,uint,btex_fptr,void*,uint,uint*);
			void _endthreadex(uint);
			
			alias pfnSDL_CurrentBeginThread = uintptr_t function(void*,uint,btex_fptr,void*,uint,uint*);
			alias pfnSDL_CurrentEndThread = void function(uint);
		}
	}
	
	pragma(inline, true) @nogc nothrow{
		SDL_Thread* SDL_CreateThreadImpl(SDL_ThreadFunction fn, const(char)* name, void* data){
			return SDL_CreateThread(fn, name, data, &_beginthreadex, &_endthreadex);
		}
		
		static if(sdlSupport >= SDLSupport.v2_0_9){
			SDL_Thread* SDL_CreateThreadWithStackSizeImpl(SDL_ThreadFunction fn, const(char)* name, const(size_t) stackSize, void* data){
				return SDL_CreateThreadWithStackSize(fn, name, stackSize, data, &_beginthreadex, &_endthreadex);
			}
		}
	}
}

mixin(joinFnBinds((){
	string[][] ret;
	version(Windows){
		ret ~= makeFnBinds([
			[q{SDL_Thread*}, q{SDL_CreateThread}, q{SDL_ThreadFunction fn, const(char)* name, void* data, pfnSDL_CurrentBeginThread pfnBeginThread, pfnSDL_CurrentEndThread pfnEndThread}],
		]);
	}else{
		ret ~= makeFnBinds([
			[q{SDL_Thread*}, q{SDL_CreateThread}, q{SDL_ThreadFunction fn, const(char)* name, void* data}],
		]);
	}
	ret ~= makeFnBinds([
		[q{const(char)*}, q{SDL_GetThreadName}, q{SDL_Thread* thread}],
		[q{SDL_threadID}, q{SDL_ThreadID}, q{}],
		[q{SDL_threadID}, q{SDL_GetThreadID}, q{SDL_Thread* thread}],
		[q{int}, q{SDL_SetThreadPriority}, q{SDL_ThreadPriority priority}],
		[q{void}, q{SDL_WaitThread}, q{SDL_Thread* thread, int* status}],
		[q{SDL_TLSID}, q{SDL_TLSCreate}, q{}],
		[q{void*}, q{SDL_TLSGet}, q{SDL_TLSID id}],
		[q{int}, q{SDL_TLSSet}, q{SDL_TLSID id,const(void)* value, TLSDestructor destructor}],
	]);
	static if(sdlSupport >= SDLSupport.v2_0_2){
		ret ~= makeFnBinds([
			[q{void}, q{SDL_DetachThread}, q{SDL_Thread* thread}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_9){
		version(Windows){
			ret ~= makeFnBinds([
				[q{SDL_Thread*}, q{SDL_CreateThreadWithStackSize}, q{SDL_ThreadFunction fn, const(char)* name, const(size_t) stacksize, void* data, pfnSDL_CurrentBeginThread pfnBeginThread, pfnSDL_CurrentEndThread pfnEndThread}],
			]);
		}else{
			ret ~= makeFnBinds([
				[q{SDL_Thread*}, q{SDL_CreateThreadWithStackSize}, q{SDL_ThreadFunction fn, const(char)* name, const(size_t) stacksize, void* data}],
			]);
		}
	}
	static if(sdlSupport >= SDLSupport.v2_0_16){
		ret ~= makeFnBinds([
			[q{void}, q{SDL_TLSCleanup}, q{}],
		]);
	}
	return ret;
}()));
