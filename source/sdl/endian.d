/+
+            Copyright 2022 – 2023 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.endian;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

import sdl.stdinc;

pragma(inline, true) nothrow @nogc pure @safe{
	ushort SDL_Swap16(ushort x){
		return cast(ushort)(
			(x << 8) |
			(x >> 8)
		);
	}
	uint SDL_Swap32(uint x){
		return cast(uint)(
			(x << 24) | ((x << 8) & 0x00FF0000) |
			((x >> 8) & 0x0000FF00) | (x >> 24)
		);
	}
	ulong SDL_Swap64(ulong x){
		uint lo = cast(uint)(x & 0xFFFFFFFF);
		x >>= 32;
		uint hi = cast(uint)(x & 0xFFFFFFFF);
		x = SDL_Swap32(lo);
		x <<= 32;
		x |= SDL_Swap32(hi);
		return x;
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
		ushort SDL_SwapLE16(ushort X){ return X; }
		uint SDL_SwapLE32(uint X){ return X; }
		ulong SDL_SwapLE64(ulong X){ return X; }
		float SDL_SwapFloatLE(float X){ return X; }
		
		ushort SDL_SwapBE16(ushort X){ return SDL_Swap16(X); }
		uint SDL_SwapBE32(uint X){ return SDL_Swap32(X); }
		ulong SDL_SwapBE64(ulong X){ return SDL_Swap64(X); }
		float SDL_SwapFloatBE(float X){ return SDL_SwapFloat(X); }
	}else{
		ushort SDL_SwapLE16(ushort X){ return SDL_Swap16(X); }
		uint SDL_SwapLE32(uint X){ return SDL_Swap32(X); }
		ulong SDL_SwapLE64(ulong X){ return SDL_Swap64(X); }
		float SDL_SwapFloatLE(float X){ return SDL_SwapFloat(X); }
		
		ushort SDL_SwapBE16(ushort X){ return X; }
		uint SDL_SwapBE32(uint X){ return X; }
		ulong SDL_SwapBE64(ulong X){ return X; }
		float SDL_SwapFloatBE(float X){ return X; }
	}
}

mixin(joinFnBinds((){
	string[][] ret;
	return ret;
}()));
