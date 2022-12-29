/+
+            Copyright 2022 – 2023 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.bits;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

pragma(inline, true) nothrow @nogc pure @safe{
	int SDL_MostSignificantBitIndex32(inout uint x_){
		static immutable uint[] b = [0x2, 0xC, 0xF0, 0xFF00, 0xFFFF0000];
		static immutable int[]  S = [1, 2, 4, 8, 16];
		
		int msbIndex = 0;
		uint x = x_;
		
		if(x == 0) return -1;
		
		foreach_reverse(i; 0..5){
			if(x & b[i]){
				x >>= S[i];
				msbIndex |= S[i];
			}
		}
		
		return msbIndex;
	}
	static if(sdlSupport >= SDLSupport.v2_0_10){
		bool SDL_HasExactlyOneBitSet32(inout uint x){
			return x && !(x & (x - 1));
		}
	}
}

mixin(joinFnBinds((){
	string[][] ret;
	return ret;
}()));
