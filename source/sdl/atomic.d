/+
+            Copyright 2024 – 2025 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.atomic;

import bindbc.sdl.config, bindbc.sdl.codegen;

version(D_InlineAsm_X86_64)   version = InlineAsm_AnyX86;
else version(D_InlineAsm_X86) version = InlineAsm_AnyX86;

version(GNU_InlineAsm) version = ExtInlineAsm;
else version(LDC)      version = ExtInlineAsm;

version(ExtInlineAsm){
	version(X86){
		version = ExtInlineAsm_X86;
		version = ExtInlineAsm_AnyX86;
	}else version(X86_64){
		version = ExtInlineAsm_X86_64;
		version = ExtInlineAsm_AnyX86;
	}else version(PPC){
		version = ExtInlineAsm_PPC;
		version = ExtInlineAsm_AnyPPC;
	}else version(PPC64){
		version = ExtInlineAsm_AnyPPC;
	}else version(ARM){
		version = ExtInlineAsm_ARM;
		version = ExtInlineAsm_AnyARM;
	}else version(AArch64){
		version = ExtInlineAsm_AArch64;
		version = ExtInlineAsm_AnyARM;
	}else version(RISCV64){
		version = ExtInlineAsm_RISCV64;
	}
}

alias SDL_SpinLock = int;

enum SDL_CompilerBarrier = (){
	static if(__traits(compiles, {import core.atomic: atomicFence;})){
		return q{{ import core.atomic: atomicFence; core.atomic.atomicFence(); }};
	}else{
		return q{{ SDL_SpinLock _tmp = 0; SDL_LockSpinlock(&_tmp); SDL_UnlockSpinlock(&_tmp); }};
	}
}();

enum SDL_MemoryBarrierRelease = (){
	version(ExtInlineAsm_PPC){
		return q{asm nothrow @nogc pure @trusted{ "lwsync" : : : "memory"; }};
	}else version(ExtInlineAsm_AArch64){
		return q{asm nothrow @nogc pure @trusted{ "dmb ish" : : : "memory"; }};
	}else version(ExtInlineAsm_AnyARM){
		version(ARM_Thumb){
			return q{SDL_MemoryBarrierReleaseFunction();};
		}else{
			return q{asm nothrow @nogc pure @trusted{ "" : : : "memory"; }};
		}
	}else{
		return q{mixin(SDL_CompilerBarrier);};
	}
}();

enum SDL_MemoryBarrierAcquire = (){
	version(ExtInlineAsm_PPC){
		return q{asm nothrow @nogc pure @trusted{ "lwsync" : : : "memory"; }};
	}else version(ExtInlineAsm_AArch64){
		return q{asm nothrow @nogc pure @trusted{ "dmb ish" : : : "memory"; }};
	}else version(ExtInlineAsm_AnyARM){
		version(ARM_Thumb){
			return q{SDL_MemoryBarrierAcquireFunction();};
		}else{
			return q{asm nothrow @nogc pure @trusted{ "" : : : "memory"; }};
		}
	}else{
		return q{mixin(SDL_CompilerBarrier);};
	}
}();

enum SDL_CPUPauseInstruction = (){
	version(ExtInlineAsm_AnyX86){
		return q{asm nothrow @nogc pure @trusted{ "pause"; }};
	}else version(InlineAsm_AnyX86){
		return q{asm nothrow @nogc pure @trusted{ rep; nop; }};
	}else version(ExtInlineAsm_AnyARM){
		return q{asm nothrow @nogc pure @trusted{ "yield" : : : "memory"; }};
	}else version(ExtInlineAsm_AnyPPC){
		return q{asm nothrow @nogc pure @trusted{ "or 27,27,27"; }};
	}else version(ExtInlineAsm_RISCV64){
		return q{asm nothrow @nogc pure @trusted{ ".insn i 0x0F, 0, x0, x0, 0x010"; }};
	}else{
		return q{{}};
	}
}();

struct SDL_AtomicInt{
	int value;
}

pragma(inline,true) nothrow @nogc{
	int  SDL_AtomicIncRef(SDL_AtomicInt* a) => SDL_AddAtomicInt(a,  1);
	bool SDL_AtomicDecRef(SDL_AtomicInt* a) => SDL_AddAtomicInt(a, -1) == 1;
}

struct SDL_AtomicU32{
	uint value;
}

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{bool}, q{SDL_TryLockSpinlock}, q{SDL_SpinLock* lock}},
		{q{void}, q{SDL_LockSpinlock}, q{SDL_SpinLock* lock}},
		{q{void}, q{SDL_UnlockSpinlock}, q{SDL_SpinLock* lock}},
		{q{void}, q{SDL_MemoryBarrierReleaseFunction}, q{}},
		{q{void}, q{SDL_MemoryBarrierAcquireFunction}, q{}},
		{q{bool}, q{SDL_CompareAndSwapAtomicInt}, q{SDL_AtomicInt* a, int oldVal, int newVal}},
		{q{int}, q{SDL_SetAtomicInt}, q{SDL_AtomicInt* a, int v}},
		{q{int}, q{SDL_GetAtomicInt}, q{SDL_AtomicInt* a}},
		{q{int}, q{SDL_AddAtomicInt}, q{SDL_AtomicInt* a, int v}},
		{q{bool}, q{SDL_CompareAndSwapAtomicU32}, q{SDL_AtomicU32* a, uint oldVal, uint newVal}},
		{q{uint}, q{SDL_SetAtomicU32}, q{SDL_AtomicU32* a, uint v}},
		{q{uint}, q{SDL_GetAtomicU32}, q{SDL_AtomicU32* a}},
		{q{bool}, q{SDL_CompareAndSwapAtomicPointer}, q{void** a, void* oldVal, void* newVal}},
		{q{void*}, q{SDL_SetAtomicPointer}, q{void** a, void* v}},
		{q{void*}, q{SDL_GetAtomicPointer}, q{void** a}},
	];
	return ret;
}()));
