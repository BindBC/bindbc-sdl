/+
+                Copyright 2023 Aya Partridge
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

alias SDL_main_func = int function(int argc, char** argv);

mixin(joinFnBinds((){
	string[][] ret;
	ret ~= makeFnBinds([
		[q{int}, q{SDL_main}, q{int argc, char** argv}],
		[q{void}, q{SDL_SetMainReady}, q{}],
	]);
	static if(sdlSupport >= SDLSupport.v2_0_2 && (){
		version(Windows)     return true;
		else version(WinGDK) return true;
		else return false;
	}()){
		ret ~= makeFnBinds([
			[q{int}, q{SDL_RegisterApp}, q{const(char)* name, uint style, void* hInst}],
			[q{void}, q{SDL_UnregisterApp}, q{}],
		]);
	}
	version(WinRT){
		static if(sdlSupport >= SDLSupport.v2_0_3){
			ret ~= makeFnBinds([
				[q{int}, q{SDL_WinRTRunApp}, q{SDL_main_func mainFunction, void* reserved}],
			]);
		}
	}
	version(iOS){
		static if(sdlSupport >= SDLSupport.v2_0_10){
			ret ~= makeFnBinds([
				[q{int}, q{SDL_UIKitRunApp}, q{int argc, char** argv, SDL_main_func mainFunction}],
			]);
		}
	}
	version(WinGDK){
		static if(sdlSupport >= SDLSupport.v2_24){
			ret ~= makeFnBinds([
				[q{int}, q{SDL_GDKRunApp}, q{SDL_main_func mainFunction, void* reserved}],
			]);
		}
		static if(sdlSupport >= SDLSupport.v2_28){
			ret ~= makeFnBinds([
				[q{void}, q{SDL_GDKSuspendComplete}, q{}],
			]);
		}
	}
	return ret;
}()));
