/+
+            Copyright 2024 – 2026 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.bits;

import bindbc.sdl.config, bindbc.sdl.codegen;

pragma(inline,true) nothrow @nogc pure @safe{
	int SDL_MostSignificantBitIndex32(uint x){
		const(uint)[5] b = [0x2, 0xC, 0xF0, 0xFF00, 0xFFFF0000U];
		const(int)[5]  s = [1, 2, 4, 8, 16];
		
		int msbIndex = 0;
		int i;
		if(x == 0) return -1;
		
		for(i = 4; i >= 0; i--){
			if(x & b[i]){
				x >>= s[i];
				msbIndex |= s[i];
			}
		}
		return msbIndex;
	}
	
	bool SDL_HasExactlyOneBitSet32(uint x) =>
		x && !(x & (x - 1));
}

mixin(joinFnBinds((){
	FnBind[] ret;
	return ret;
}()));
