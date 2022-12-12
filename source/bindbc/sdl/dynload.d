/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module bindbc.sdl.dynload;

import bindbc.sdl.config;
static if(!staticBinding):

import bindbc.loader;
import bindbc.sdl.bind;

private{
	SharedLib lib;
	SDLSupport loadedVersion;
	enum libNamesCT = (){
		version(Windows){
			return [
				`SDL2_image.dll`,
			];
		}else version(OSX){
			return [
				`libSDL2.dylib`,
				`/usr/lib/libSDL2.dylib`,
				`/usr/local/lib/libSDL2.dylib`,
				`../Frameworks/SDL2.framework/SDL2`,
				`/Library/Frameworks/SDL2.framework/SDL2`,
				`/System/Library/Frameworks/SDL2.framework/SDL2`,
				`/opt/homebrew/lib/libSDL2.dylib`,
			];
		}else version(Posix){
			return [
				`libSDL2.so`,
				`libSDL2-2.0.so`,
				`libSDL2-2.0.so.0`,
			];
		}else static assert(0, "bindbc-sdl does not have library search paths set up for this platform.");
	}();
}

@nogc nothrow:
void unloadSDL(){ if(lib != invalidHandle) lib.unload(); }

deprecated("Please use `SDL_GetVersion` instead") SDLSupport loadedSDLVersion(){ return loadedVersion; }

bool isSDLLoaded(){ return lib != invalidHandle; }

SDLSupport loadSDL(){
	const(char)[][libNamesCT.length] libNames = libNamesCT;
	
	SDLSupport ret;
	foreach(name; libNames){
		ret = loadSDL(name.ptr);
		//TODO: keep trying until we get the version we want, otherwise default to the highest one?
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
		``, `assert`, `atomic`, `audio`, `blendmode`, `clipboard`, `cpuinfo`,
		`error`, `events`, `filesystem`, `gamecontroller`, `gesture`,
		`haptic`, `hidapi`, `hints`, `joystick`, `keyboard`, `keycode`,
		`loadso`, `log`, `messagebox`, `misc`, `mouse`, `mutex`, `pixels`,
		`platform`, `power`, `rect`, `render`, `rwops`, `scancode`, `sensor`,
		`shape`, `stdinc`, `surface`, `system`, `syswm`, `thread`, `timer`,
		`touch`, `version`, `video`, `vulkan`
	]){
		mixin(`bindbc.sdl.bind.sdl`~mod~`.bindModuleSymbols(lib);`);
	}
	
	if(errCount == errorCount()) loadedVersion = sdlSupport; //this is a white lie in order to maintain backwards-compatibility :(
	return loadedVersion;
}
