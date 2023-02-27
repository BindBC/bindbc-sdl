/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.cpuinfo;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

import sdl.stdinc: SDL_bool;

enum SDL_CACHELINE_SIZE = 128;

mixin(joinFnBinds((){
	string[][] ret;
	ret ~= makeFnBinds([
		[q{int}, q{SDL_GetCPUCount}, q{}],
		[q{int}, q{SDL_GetCPUCacheLineSize}, q{}],
		[q{SDL_bool}, q{SDL_HasRDTSC}, q{}],
		[q{SDL_bool}, q{SDL_HasAltiVec}, q{}],
		[q{SDL_bool}, q{SDL_HasMMX}, q{}],
		[q{SDL_bool}, q{SDL_Has3DNow}, q{}],
		[q{SDL_bool}, q{SDL_HasSSE}, q{}],
		[q{SDL_bool}, q{SDL_HasSSE2}, q{}],
		[q{SDL_bool}, q{SDL_HasSSE3}, q{}],
		[q{SDL_bool}, q{SDL_HasSSE41}, q{}],
		[q{SDL_bool}, q{SDL_HasSSE42}, q{}],
	]);
	static if(sdlSupport >= SDLSupport.v2_0_1){
		ret ~= makeFnBinds([
			[q{int}, q{SDL_GetSystemRAM}, q{}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_2){
		ret ~= makeFnBinds([
			[q{SDL_bool}, q{SDL_HasAVX}, q{}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_4){
		ret ~= makeFnBinds([
			[q{SDL_bool}, q{SDL_HasAVX2}, q{}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_6){
		ret ~= makeFnBinds([
			[q{SDL_bool}, q{SDL_HasNEON}, q{}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_9){
		ret ~= makeFnBinds([
			[q{SDL_bool}, q{SDL_HasAVX512F}, q{}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_10){
		ret ~= makeFnBinds([
			[q{size_t}, q{SDL_SIMDGetAlignment}, q{}],
			[q{void*}, q{SDL_SIMDAlloc}, q{const(size_t) len}],
			[q{void}, q{SDL_SIMDFree}, q{void*}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_12){
		ret ~= makeFnBinds([
			[q{SDL_bool}, q{SDL_HasARMSIMD}, q{}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_14){
		ret ~= makeFnBinds([
			[q{void*}, q{SDL_SIMDRealloc}, q{void* mem, const(size_t) len}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_24){
		ret ~= makeFnBinds([
			[q{SDL_bool}, q{SDL_HasLSX}, q{}],
			[q{SDL_bool}, q{SDL_HasLASX}, q{}],
		]);
	}
	return ret;
}()));
