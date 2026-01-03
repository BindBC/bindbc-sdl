/+
+            Copyright 2024 – 2026 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.cpuinfo;

import bindbc.sdl.config, bindbc.sdl.codegen;

enum{
	SDL_CacheLineSize = 128,
	SDL_CACHELINE_SIZE = SDL_CacheLineSize,
}

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{int}, q{SDL_GetNumLogicalCPUCores}, q{}},
		{q{int}, q{SDL_GetCPUCacheLineSize}, q{}},
		{q{bool}, q{SDL_HasAltiVec}, q{}},
		{q{bool}, q{SDL_HasMMX}, q{}},
		{q{bool}, q{SDL_HasSSE}, q{}},
		{q{bool}, q{SDL_HasSSE2}, q{}},
		{q{bool}, q{SDL_HasSSE3}, q{}},
		{q{bool}, q{SDL_HasSSE41}, q{}},
		{q{bool}, q{SDL_HasSSE42}, q{}},
		{q{bool}, q{SDL_HasAVX}, q{}},
		{q{bool}, q{SDL_HasAVX2}, q{}},
		{q{bool}, q{SDL_HasAVX512F}, q{}},
		{q{bool}, q{SDL_HasARMSIMD}, q{}},
		{q{bool}, q{SDL_HasNEON}, q{}},
		{q{bool}, q{SDL_HasLSX}, q{}},
		{q{bool}, q{SDL_HasLASX}, q{}},
		{q{int}, q{SDL_GetSystemRAM}, q{}},
		{q{size_t}, q{SDL_GetSIMDAlignment}, q{}},
	];
	if(sdlVersion >= Version(3,4,0)){
		FnBind[] add = [
			{q{int}, q{SDL_GetSystemPageSize}, q{}},
		];
		ret ~= add;
	}
	return ret;
}()));
