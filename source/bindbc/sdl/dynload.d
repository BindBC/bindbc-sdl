/+
            Copyright 2022 – 2023 Aya Partridge
          Copyright 2018 - 2022 Michael D. Parker
 Distributed under the Boost Software License, Version 1.0.
     (See accompanying file LICENSE_1_0.txt or copy at
           http://www.boost.org/LICENSE_1_0.txt)
+/
module bindbc.sdl.dynload;

version(BindBC_Static){}
else version(BindSDL_Static){}
else:

import bindbc.loader;
import bindbc.sdl.config;
import bindbc.sdl.bind;

private{
	SharedLib lib;
	SDLSupport loadedVersion;
}

@nogc nothrow:
void unloadSDL(){
	if(lib != invalidHandle){
		lib.unload();
	}
}

//NOTE: Please use `SDL_GetVersion` instead!
deprecated SDLSupport loadedSDLVersion(){ return loadedVersion; }

bool isSDLLoaded(){
	return lib != invalidHandle;
}

SDLSupport loadSDL(){
	// #1778 prevents me from using static arrays here :(
	version(Windows){
		const(char)[][1] libNames = [
			"SDL2.dll",
		];
	}
	else version(OSX){
		const(char)[][7] libNames = [
			"libSDL2.dylib",
			"/usr/local/lib/libSDL2.dylib",
			"/usr/local/lib/libSDL2/libSDL2.dylib",
			"../Frameworks/SDL2.framework/SDL2",
			"/Library/Frameworks/SDL2.framework/SDL2",
			"/System/Library/Frameworks/SDL2.framework/SDL2",
			"/opt/local/lib/libSDL2.dylib",
		];
	}
	else version(Posix){
		const(char)[][6] libNames = [
			"libSDL2.so",
			"/usr/local/lib/libSDL2.so",
			"libSDL2-2.0.so",
			"/usr/local/lib/libSDL2-2.0.so",
			"libSDL2-2.0.so.0",
			"/usr/local/lib/libSDL2-2.0.so.0",
		];
	}else pragma(msg, "bindbc-sdl is not fully supported on this platform, and therefore might not work!");
	
	SDLSupport ret;
	foreach(name; libNames){
		ret = loadSDL(name.ptr);
		//TODO: keep trying until we get the version we want, otherwise default to the highest one
		if(ret != SDLSupport.noLibrary && ret != SDLSupport.badLibrary) break;
	}
	return ret;
}

SDLSupport loadSDL(const(char)* libName){
	lib = load(libName);
	if(lib == invalidHandle){
		return SDLSupport.noLibrary;
	}
	
	auto errCount = errorCount();
	loadedVersion = SDLSupport.badLibrary;
	
	static foreach(mod; [
		`assert`, `atomic`, `audio`, `blendmode`, `clipboard`, `cpuinfo`,
		`error`, `events`, `filesystem`, `gamecontroller`, `gesture`,
		`haptic`, `hidapi`, `hints`, `joystick`, `keyboard`, `keycode`,
		`loadso`, `log`, `messagebox`, `misc`, `mouse`, `mutex`, `pixels`,
		`platform`, `power`, `rect`, `render`, `rwops`, `scancode`, `sensor`,
		`shape`, `stdinc`, `surface`, `system`, `syswm`, `thread`, `timer`,
		`touch`, `version`, `video`, `vulkan`
	]){
		mixin(`bindbc.sdl.bind.sdl`~mod~`.bindModuleSymbols(lib);`);
	}
	
	if(errCount != errorCount()) return SDLSupport.badLibrary;
	else loadedVersion = sdlSupport; //this is a white lie in order to maintain backwards-compatibility :(
	
	return loadedVersion;
}
