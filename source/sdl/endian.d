/+
+            Copyright 2024 – 2025 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.endian;

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
	}
}

enum{
	SDL_LilEndian = 1234,
	SDL_BigEndian = 4321,
	SDL_ByteOrder = (){
		version(LittleEndian)   return SDL_LilEndian;
		else version(BigEndian) return SDL_BigEndian;
		else static assert(0, "Unsupported endianness");
	}(),
	SDL_FloatWordOrder = SDL_ByteOrder,
	
	SDL_LIL_ENDIAN = SDL_LilEndian,
	SDL_BIG_ENDIAN = SDL_BigEndian,
	SDL_BYTEORDER = SDL_ByteOrder,
	SDL_FLOATWORDORDER = SDL_FloatWordOrder,
}

pragma(inline,true) nothrow @nogc pure @safe{
	ushort SDL_Swap16(ushort x){
		//LDC doesn't like this, and I can't test with GDC easily for now…
		/+version(ExtInlineAsm_X86){
			asm nothrow @nogc pure @trusted{ "xchgb %b0,%h0" : "=q"(x) : "0"(x); }
			return x;
		}else version(ExtInlineAsm_X86_64){
			asm nothrow @nogc pure @trusted{ "xchgb %b0,%h0" : "=Q"(x) : "0"(x); }
			return x;
		}else +/version(ExtInlineAsm_PPC){
			int result;
			asm nothrow @nogc pure @trusted{ "rlwimi %0,%2,8,16,23" : "=&r"(result) : "0"(x >> 8), "r"(x); }
			return cast(ushort)result;
		}else version(InlineAsm_AnyX86){
			asm nothrow @nogc pure @trusted{ xchg AL,AH; }
		}else{
			return cast(ushort)((x << 8) | (x >> 8));
		}
	}
	uint SDL_Swap32(uint x){
		version(ExtInlineAsm_AnyX86){
			asm nothrow @nogc pure @trusted{ "bswap %0" : "=r"(x) : "0"(x); }
			return x;
		}else version(ExtInlineAsm_PPC){
			uint result;
			asm nothrow @nogc pure @trusted{
				"rlwimi %0,%2,24,16,23" : "=&r"(result) : "0"(x>>24),  "r"(x);
				"rlwimi %0,%2,8,8,15"   : "=&r"(result) : "0"(result), "r"(x);
				"rlwimi %0,%2,24,0,7"   : "=&r"(result) : "0"(result), "r"(x);
			}
			return result;
		}else version(InlineAsm_AnyX86){
			asm nothrow @nogc pure @trusted{ bswap EAX; }
		}else{
			return (x << 24) | ((x << 8) & 0x00FF0000) | ((x >> 8) & 0x0000FF00) | (x >> 24);
		}
	}
	ulong SDL_Swap64(ulong x){
		version(ExtInlineAsm_X86){
			union V{
				struct S{ uint a, b; }
				S s;
				ulong u;
			}
			V v = {u: x};
			asm nothrow @nogc pure @trusted{ "bswapl %0 ; bswapl %1 ; xchgl %0,%1" : "=r"(v.s.a), "=r"(v.s.b) : "0" (v.s.a), "1"(v.s.b); }
			return v.u;
		}else version(ExtInlineAsm_X86_64){
			asm nothrow @nogc pure @trusted{ "bswapq %0" : "=r"(x) : "0"(x); }
			return x;
		}else version(ExtInlineAsm_PPC){
			uint result;
			asm nothrow @nogc pure @trusted{
				"rlwimi %0,%2,24,16,23" : "=&r"(result) : "0"(x>>24),  "r"(x);
				"rlwimi %0,%2,8,8,15"   : "=&r"(result) : "0"(result), "r"(x);
				"rlwimi %0,%2,24,0,7"   : "=&r"(result) : "0"(result), "r"(x);
			}
			return result;
		}else version(D_InlineAsm_X86){
			asm nothrow @nogc pure @trusted{ bswap EAX; bswap EDX; xchg EAX,EDX; }
		}else version(D_InlineAsm_X86_64){
			asm nothrow @nogc pure @trusted{ bswap RAX; }
		}else{
			uint lo = cast(uint)( x        & 0xFFFFFFFF);
			uint hi = cast(uint)((x >> 32) & 0xFFFFFFFF);
			return (cast(ulong)SDL_Swap32(lo) << 32) | SDL_Swap32(hi);
		}
	}
	float SDL_SwapFloat(float x){
		union Swapper{
			float f;
			uint ui32;
		}
		Swapper swapper = {f: x};
		swapper.ui32 = SDL_Swap32(swapper.ui32);
		return swapper.f;
	}
	version(LittleEndian){
		ushort SDL_Swap16LE(ushort x)   => x;
		uint   SDL_Swap32LE(uint x)     => x;
		ulong  SDL_Swap64LE(ulong x)    => x;
		float  SDL_SwapFloatLE(float x) => x;
		ushort SDL_Swap16BE(ushort x)   => SDL_Swap16(x);
		uint   SDL_Swap32BE(uint x)     => SDL_Swap32(x);
		ulong  SDL_Swap64BE(ulong x)    => SDL_Swap64(x);
		float  SDL_SwapFloatBE(float x) => SDL_SwapFloat(x);
	}else{
		ushort SDL_Swap16LE(ushort x)   => SDL_Swap16(x);
		uint   SDL_Swap32LE(uint x)     => SDL_Swap32(x);
		ulong  SDL_Swap64LE(ulong x)    => SDL_Swap64(x);
		float  SDL_SwapFloatLE(float x) => SDL_SwapFloat(x);
		ushort SDL_Swap16BE(ushort x)   => x;
		uint   SDL_Swap32BE(uint x)     => x;
		ulong  SDL_Swap64BE(ulong x)    => x;
		float  SDL_SwapFloatBE(float x) => x;
	}
}

mixin(joinFnBinds((){
	FnBind[] ret;
	return ret;
}()));
