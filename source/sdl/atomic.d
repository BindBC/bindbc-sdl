/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.atomic;

version(SDL_No_Atomics){}
else:

import bindbc.sdl.config;

import sdl.stdinc: SDL_bool;

alias SDL_SpinLock = int;

struct SDL_atomic_t{
	int value;
}

/*
The best way I can see to implement the barrier macros is to depend on
core.atomic.atomicFence. That should be okay even in BetterC mode since
it's a template. I've already got a dependency on DRuntime (e.g. core.stdc.config),
so I'll import it rather than copy/paste it. I'll change it if it somehow
becomes a problem in the future.
*/
import core.atomic: atomicFence;
alias SDL_CompilerBarrier = atomicFence!();
alias SDL_MemoryBarrierRelease = SDL_CompilerBarrier;
alias SDL_MemoryBarrierAcquire = SDL_CompilerBarrier;

pragma(inline, true) nothrow @nogc{
	int SDL_AtomicIncRef(SDL_atomic_t* a){
		return SDL_AtomicAdd(a, 1);
	}

	SDL_bool SDL_AtomicDecRef(SDL_atomic_t* a){
		return cast(SDL_bool)(SDL_AtomicAdd(a, -1) == 1);
	}
}

mixin(joinFnBinds((){
	string[][] ret;
	ret ~= makeFnBinds([
		[q{SDL_bool}, q{SDL_AtomicTryLock}, q{SDL_SpinLock* lock}],
		[q{void}, q{SDL_AtomicLock}, q{SDL_SpinLock* lock}],
		[q{void}, q{SDL_AtomicUnlock}, q{SDL_SpinLock* lock}],
		// Perhaps the following could be replaced with the platform-specific intrinsics for GDC, like
		// the GCC macros in SDL_atomic.h. I'll have to investigate.
		[q{SDL_bool}, q{SDL_AtomicCAS}, q{SDL_atomic_t* a, int oldval, int newval}],
		[q{SDL_bool}, q{SDL_AtomicCASPtr}, q{void** a, void* oldval, void* newval}],
	]);
	static if(sdlSupport >= SDLSupport.v2_0_3){
		ret ~= makeFnBinds([
			[q{int}, q{SDL_AtomicSet}, q{SDL_atomic_t* a, int v}],
			[q{int}, q{SDL_AtomicGet}, q{SDL_atomic_t* a}],
			[q{int}, q{SDL_AtomicAdd}, q{SDL_atomic_t* a, int v}],
			[q{void*}, q{SDL_AtomicSetPtr}, q{void** a, void* v}],
			[q{void*}, q{SDL_AtomicGetPtr}, q{void** a}],
		]);
	}
	return ret;
}()));

static if(sdlSupport < SDLSupport.v2_0_3){
	int SDL_AtomicSet(SDL_atomic_t* a, int v){
		pragma(inline, true);
		int value;
		do{
			value = a.value;
		}while(!SDL_AtomicCAS(a, value, v));
		return value;
	}
	int SDL_AtomicGet(SDL_atomic_t* a){
		pragma(inline, true);
		int value = a.value;
		SDL_CompilerBarrier();
		return value;
	}
	int SDL_AtomicAdd(SDL_atomic_t* a, int v){
		pragma(inline, true);
		int value;
		do{
			value = a.value;
		}while(!SDL_AtomicCAS(a, value, value + v));
		return value;
	}
	void* SDL_AtomicSetPtr(void** a, void* v){
		pragma(inline, true);
		void* value;
		do{
			value = *a;
		}while(!SDL_AtomicCASPtr(a, value, v));
		return value;
	}
	void* SDL_AtomicGetPtr(void** a){
		pragma(inline, true);
		void* value = *a;
		SDL_CompilerBarrier();
		return value;
	}
}
