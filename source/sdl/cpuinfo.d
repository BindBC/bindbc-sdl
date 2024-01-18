/+
+            Copyright 2022 – 2024 Aya Partridge
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
	FnBind[] ret = [
		{q{int}, q{SDL_GetCPUCount}, q{}},
		{q{int}, q{SDL_GetCPUCacheLineSize}, q{}},
		{q{SDL_bool}, q{SDL_HasRDTSC}, q{}},
		{q{SDL_bool}, q{SDL_HasAltiVec}, q{}},
		{q{SDL_bool}, q{SDL_HasMMX}, q{}},
		{q{SDL_bool}, q{SDL_Has3DNow}, q{}},
		{q{SDL_bool}, q{SDL_HasSSE}, q{}},
		{q{SDL_bool}, q{SDL_HasSSE2}, q{}},
		{q{SDL_bool}, q{SDL_HasSSE3}, q{}},
		{q{SDL_bool}, q{SDL_HasSSE41}, q{}},
		{q{SDL_bool}, q{SDL_HasSSE42}, q{}},
	];
	if(sdlSupport >= SDLSupport.v2_0_1){
		FnBind[] add = [
			{q{int}, q{SDL_GetSystemRAM}, q{}},
		];
		ret ~= add;
	}
	if(sdlSupport >= SDLSupport.v2_0_2){
		FnBind[] add = [
			{q{SDL_bool}, q{SDL_HasAVX}, q{}},
		];
		ret ~= add;
	}
	if(sdlSupport >= SDLSupport.v2_0_4){
		FnBind[] add = [
			{q{SDL_bool}, q{SDL_HasAVX2}, q{}},
		];
		ret ~= add;
	}
	if(sdlSupport >= SDLSupport.v2_0_6){
		FnBind[] add = [
			{q{SDL_bool}, q{SDL_HasNEON}, q{}},
		];
		ret ~= add;
	}
	if(sdlSupport >= SDLSupport.v2_0_9){
		FnBind[] add = [
			{q{SDL_bool}, q{SDL_HasAVX512F}, q{}},
		];
		ret ~= add;
	}
	if(sdlSupport >= SDLSupport.v2_0_10){
		FnBind[] add = [
			{q{size_t}, q{SDL_SIMDGetAlignment}, q{}},
			{q{void*}, q{SDL_SIMDAlloc}, q{const(size_t) len}},
			{q{void}, q{SDL_SIMDFree}, q{void*}},
		];
		ret ~= add;
	}
	if(sdlSupport >= SDLSupport.v2_0_12){
		FnBind[] add = [
			{q{SDL_bool}, q{SDL_HasARMSIMD}, q{}},
		];
		ret ~= add;
	}
	if(sdlSupport >= SDLSupport.v2_0_14){
		FnBind[] add = [
			{q{void*}, q{SDL_SIMDRealloc}, q{void* mem, const(size_t) len}},
		];
		ret ~= add;
	}
	if(sdlSupport >= SDLSupport.v2_24){
		FnBind[] add = [
			{q{SDL_bool}, q{SDL_HasLSX}, q{}},
			{q{SDL_bool}, q{SDL_HasLASX}, q{}},
		];
		ret ~= add;
	}
	return ret;
}()));
