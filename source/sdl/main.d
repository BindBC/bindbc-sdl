/+
+            Copyright 2024 – 2025 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.main;

import bindbc.sdl.config, bindbc.sdl.codegen;

import sdl.events: SDL_Event;
import sdl.init: SDL_AppEvent_func, SDL_AppInit_func, SDL_AppIterate_func, SDL_AppQuit_func, SDL_AppResult;

version(Windows)     version = Microsoft;
else version(GDK)    version = Microsoft;
else version(Cygwin) version = Microsoft;

version(Windows){
	version = MainAvailable;
}else version(GDK){
	version = MainNeeded;
}else version(iOS){
	version = MainNeeded;
}else version(TVOS){
	version = MainNeeded;
}else version(Android){
	version = MainNeeded;
	version = ExportMain;
}else version(Emscripten){
	version = MainAvailable;
}else version(PSP){
	version = MainAvailable;
}else version(PlayStation){
	version = MainAvailable;
	
	enum SDL_PS2_SKIP_IOP_RESET = q{
void reset_IOP();
void reset_IOP(){}
};
}else version(_3DS){
	version = MainAvailable;
}

version(SDL_MainUseCallbacks){
	version(none){
		//platform specific stuff in a future SDL3 version...
	}else{
		version = SDLEntryPoint;
	}
}else{
	version(MainNeeded)         version = SDLEntryPoint;
	else version(MainAvailable) version = SDLEntryPoint;
}

version(ANSI){
}else version = Unicode;

enum makeSDLMain = (string argCountIden=null, string argArrayIden=null, string dynLoad=null, string body=null){
	static if(staticBinding)
		dynLoad = "";
	
	string sdlMain, userMain;
	
	version(SDL_MainUseCallbacks){
		version(none){
			//platform specific stuff in a future SDL3 version...
		}else{
			userMain =
q{extern(C) int SDL_main(int argC, char** argV)
	=> SDL_EnterAppMainCallbacks(argC, argV, &SDL_AppInit, &SDL_AppIterate, &SDL_AppEvent, &SDL_AppQuit);};
		}
	}else{
		string mainIden;
		string mainPfix = q{extern(C) };
		version(SDLEntryPoint){
			mainIden = q{SDL_main};
			version(ExportMain){
				mainPfix ~= q{export };
			}
		}else{
			mainIden = q{main};
		}
		
		userMain = mainPfix ~ q{int } ~ mainIden ~ "(int "~argCountIden~", char** "~argArrayIden~") nothrow{"~body~"}";
	}
	
	version(SDLEntryPoint){
		version(Microsoft){
			sdlMain ~= q{
struct HINSTANCE__;
alias HINSTANCE = HINSTANCE__*;
alias LPSTR = char*;
alias PWSTR = wchar_t*;
};
			static if((){
				version(CRuntime_Microsoft){
					version(GDK) return false;
					else return true;
				}else return false;
			}()){
				version(Unicode){
					sdlMain ~= q{extern(C) int wmain(int argC, wchar_t** wArgV, wchar_t* wEnvP)};
				}else{
					sdlMain ~= q{extern(C) int main(int argC, char* argV)};
				}
				sdlMain ~= '{'~dynLoad~q{
	return SDL_RunApp(0, null, &SDL_main, null);
} ~ "}\n";
			}
			
			version(Unicode){
				sdlMain ~= q{extern(System) int wWinMain(HINSTANCE hInst, HINSTANCE hPrev, PWSTR szCmdLine, int sw)};
			}else{
				sdlMain ~= q{extern(System) int WinMain(HINSTANCE hInst, HINSTANCE hPrev, LPSTR szCmdLine, int sw)};
			}
			sdlMain ~= '{'~dynLoad~q{
	return SDL_RunApp(0, null, &SDL_main, null);
} ~ '}';
			
		}else{
			sdlMain ~= q{extern(C) int main(int argC, char** argV)}~'{'~dynLoad~q{
	return SDL_RunApp(argC, argV, &SDL_main, null);
} ~ '}';
		}
	}
	return userMain ~ sdlMain;
};

alias SDL_main_func = extern(C) int function(int argC, char** argV);

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{void}, q{SDL_SetMainReady}, q{}},
		{q{int}, q{SDL_RunApp}, q{int argC, char** argV, SDL_main_func mainFunction, void* reserved}},
		{q{int}, q{SDL_EnterAppMainCallbacks}, q{int argC, char** argV, SDL_AppInit_func appInit, SDL_AppIterate_func appIter, SDL_AppEvent_func appEvent, SDL_AppQuit_func appQuit}},
		{q{void}, q{SDL_GDKSuspendComplete}, q{}},
	];
	version(Microsoft){{
		FnBind[] add = [
			{q{bool}, q{SDL_RegisterApp}, q{const(char)* name, uint style, void* hInst}},
			{q{void}, q{SDL_UnregisterApp}, q{}},
		];
		ret ~= add;
	}}
	return ret;
}()));
