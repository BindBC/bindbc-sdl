/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.atomic;

version(SDL_No_Atomics){
}else:

import bindbc.sdl.config;
import bindbc.sdl.codegen;

import sdl.stdinc: SDL_bool;

alias SDL_SpinLock = int;

version(GNU) version = ExtAsm; //GDC
version(LDC) version = ExtAsm;

pragma(inline, true) nothrow @nogc{
	void SDL_CompilerBarrier(){
		static if((){
			version(Emscripten)  return false;
			else version(ExtAsm) return true;
			else return false;
		}()){
			asm nothrow @nogc{ "" : : : "memory"; } 
		}else version(DigitalMars){
			asm nothrow @nogc{}
		}else{
			__gshared SDL_SpinLock _tmp = 0;
			SDL_AtomicLock(&_tmp);
			SDL_AtomicUnlock(&_tmp);
		}
		
// 		#if defined(_MSC_VER) && (_MSC_VER > 1200) && !defined(__clang__)
// 		void _ReadWriteBarrier(void);
// 		#pragma intrinsic(_ReadWriteBarrier)
// 		#define SDL_CompilerBarrier()   _ReadWriteBarrier()
// 		#elif (defined(__GNUC__) && !defined(__EMSCRIPTEN__)) || (defined(__SUNPRO_C) && (__SUNPRO_C >= 0x5120))
// 		/* This is correct for all CPUs when using GCC or Solaris Studio 12.1+. */
// 		#define SDL_CompilerBarrier()   __asm__ __volatile__ ("" : : : "memory")
// 		#elif defined(__WATCOMC__)
// 		extern __inline void SDL_CompilerBarrier(void);
// 		#pragma aux SDL_CompilerBarrier = "" parm [] modify exact [];
// 		#else
// 		#define SDL_CompilerBarrier()   \
// 		{ SDL_SpinLock _tmp = 0; SDL_AtomicLock(&_tmp); SDL_AtomicUnlock(&_tmp); }
// 		#endif
	}
	
	void SDL_MemoryBarrierRelease(){
		static if((){
			version(ExtAsm){
				version(PPC)        return true;
				else version(PPC64) return true;
				else return false;
			}else return false;
		}()){
			asm nothrow @nogc{ "lwsync" : : : "memory"; }
		}else static if((){
			version(ExtAsm){
				version(AArch64) return true;
				else return false;
			}else return false;
		}()){
			asm nothrow @nogc{ "dmb ish" : : : "memory"; }
		}else static if((){
			version(ExtAsm){
				version(ARM) return true;
				else return false;
			}else return false;
		}()){
			asm nothrow @nogc{ "" : : : "memory"; }
		}else{
			SDL_CompilerBarrier();
		}
	}
	alias SDL_MemoryBarrierAcquire = SDL_MemoryBarrierRelease;
	
	void SDL_CPUPauseInstruction() pure{ //NOTE: added in 2.24.0
		version(ExtAsm){
			static if((){
				version(X86)         return true;
				else version(X86_64) return true;
				else return false;
			}()){
				asm nothrow @nogc pure{ "rep nop"; }
			}else static if((){
				version(ARM)          return true;
				else version(AArch64) return true;
				else return false;
			}()){
				asm nothrow @nogc pure{ "yield" : : : "memory"; }
			}else static if((){
				version(PPC)        return true;
				else version(PPC64) return true;
				else return false;
			}()){
				asm nothrow @nogc pure{ "or 27,27,27"; }
			}
		}
	}
	
	int SDL_AtomicIncRef(SDL_atomic_t* a){
		return SDL_AtomicAdd(a, 1);
	}
	bool SDL_AtomicDecRef(SDL_atomic_t* a){
		return SDL_AtomicAdd(a, -1) == 1;
	}
	static if(sdlSupport < SDLSupport.v2_0_3){
		int SDL_AtomicSet(SDL_atomic_t* a, int v){
			int value;
			do{
				value = a.value;
			}while(!SDL_AtomicCAS(a, value, v));
			return value;
		}
		int SDL_AtomicGet(SDL_atomic_t* a){
			int value = a.value;
			SDL_CompilerBarrier();
			return value;
		}
		int SDL_AtomicAdd(SDL_atomic_t* a, int v){
			int value;
			do{
				value = a.value;
			}while(!SDL_AtomicCAS(a, value, value + v));
			return value;
		}
		void* SDL_AtomicSetPtr(void** a, void* v){
			void* value;
			do{
				value = *a;
			}while(!SDL_AtomicCASPtr(a, value, v));
			return value;
		}
		void* SDL_AtomicGetPtr(void** a){
			void* value = *a;
			SDL_CompilerBarrier();
			return value;
		}
	}
}

struct SDL_atomic_t{
	int value;
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
	static if(sdlSupport >= SDLSupport.v2_0_6){
		ret ~= makeFnBinds([
			[q{void}, q{SDL_MemoryBarrierReleaseFunction}, q{}],
			[q{void}, q{SDL_MemoryBarrierAcquireFunction}, q{}],
		]);
	}
	return ret;
}()));
