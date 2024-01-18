/+
+            Copyright 2023 – 2024 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.main;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

/*
This file is intentionally not included with the rest of BindBC SDL,
since SDL does not do this either. This file is provided in case the
user needs the functions located within it for their application.
Feel free to submit a PR if there is a better way this could be laid out.
*/

alias SDL_main_func = int function(int argC, char** argV);

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{int}, q{SDL_main}, q{int argC, char** argV}},
		{q{void}, q{SDL_SetMainReady}, q{}},
	];
	static if(sdlSupport >= SDLSupport.v2_0_2 && (){
		version(Windows)     return true;
		else version(WinGDK) return true;
		else return false;
	}()){
		FnBind[] add = [
			{q{int}, q{SDL_RegisterApp}, q{const(char)* name, uint style, void* hInst}},
			{q{void}, q{SDL_UnregisterApp}, q{}},
		];
		ret ~= add;
	}
	version(WinRT){
		if(sdlSupport >= SDLSupport.v2_0_3){
			FnBind[] add = [
				{q{int}, q{SDL_WinRTRunApp}, q{SDL_main_func mainFunction, void* reserved}},
			];
			ret ~= add;
		}
	}
	version(iOS){
		if(sdlSupport >= SDLSupport.v2_0_10){
			FnBind[] add = [
				{q{int}, q{SDL_UIKitRunApp}, q{int argC, char** argV, SDL_main_func mainFunction}},
			];
			ret ~= add;
		}
	}
	version(WinGDK){
		if(sdlSupport >= SDLSupport.v2_24){
			FnBind[] add = [
				{q{int}, q{SDL_GDKRunApp}, q{SDL_main_func mainFunction, void* reserved}},
			];
			ret ~= add;
		}
		if(sdlSupport >= SDLSupport.v2_28){
			FnBind[] add = [
				{q{void}, q{SDL_GDKSuspendComplete}, q{}},
			];
			ret ~= add;
		}
	}
	return ret;
}()));
