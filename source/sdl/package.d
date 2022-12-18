/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl;

import bindbc.sdl.config;

enum: uint{
	SDL_INIT_TIMER           = 0x0000_0001,
	SDL_INIT_AUDIO           = 0x0000_0010,
	SDL_INIT_VIDEO           = 0x0000_0020,
	SDL_INIT_JOYSTICK        = 0x0000_0200,
	SDL_INIT_HAPTIC          = 0x0000_1000,
	SDL_INIT_GAMECONTROLLER  = 0x0000_2000,
	SDL_INIT_EVENTS          = 0x0000_4000,
	SDL_INIT_NOPARACHUTE     = 0x0010_0000,
}
static if(sdlSupport >= SDLSupport.v2_0_9){
	enum: uint{
		SDL_INIT_SENSOR      = 0x0000_8000,
		SDL_INIT_EVERYTHING  =
			SDL_INIT_TIMER    | SDL_INIT_AUDIO  | SDL_INIT_VIDEO |
			SDL_INIT_JOYSTICK | SDL_INIT_HAPTIC | SDL_INIT_GAMECONTROLLER |
			SDL_INIT_EVENTS   | SDL_INIT_SENSOR,
	}
}else{
	enum: uint{
		SDL_INIT_EVERYTHING  =
			SDL_INIT_TIMER    | SDL_INIT_AUDIO  | SDL_INIT_VIDEO |
			SDL_INIT_JOYSTICK | SDL_INIT_HAPTIC | SDL_INIT_GAMECONTROLLER |
			SDL_INIT_EVENTS,
	}
}

mixin(joinFnBinds((){
	string[][] ret;
	ret ~= makeFnBinds([
		[q{int}, q{SDL_Init}, q{uint flags}],
		[q{int}, q{SDL_InitSubSystem}, q{uint flags}],
		[q{void}, q{SDL_QuitSubSystem}, q{uint flags}],
		[q{uint}, q{SDL_WasInit}, q{uint flags}],
		[q{void}, q{SDL_Quit}, q{}],
	]);
	return ret;
}()));

public import
	sdl.assert_,
	sdl.atomic,
	sdl.audio,
	sdl.blendmode,
	sdl.clipboard,
	sdl.cpuinfo,
	sdl.endian,
	sdl.error,
	sdl.events,
	sdl.filesystem,
	sdl.gamecontroller,
	sdl.gesture,
	sdl.guid,
	sdl.hidapi,
	sdl.haptic,
	sdl.hints,
	sdl.joystick,
	sdl.keyboard,
	sdl.keycode,
	sdl.loadso,
	sdl.log,
	sdl.messagebox,
	sdl.misc,
	sdl.mouse,
	sdl.mutex,
	sdl.pixels,
	sdl.platform,
	sdl.power,
	sdl.rect,
	sdl.render,
	sdl.rwops,
	sdl.scancode,
	sdl.sensor,
	sdl.shape,
	sdl.stdinc,
	sdl.surface,
	sdl.system,
	sdl.syswm,
	sdl.thread,
	sdl.timer,
	sdl.touch,
	sdl.version_,
	sdl.video,
	sdl.vulkan;

static if(!staticBinding):
import bindbc.loader;

private{
	SharedLib lib;
	SDLSupport loadedVersion; //NOTE: get rid of these in 2.0.0
	enum libNamesCT = (){
		version(Windows){
			return [
				`SDL2_image.dll`,
			];
		}else version(OSX){
			return [
				`libSDL2.dylib`,
// 				`/usr/lib/libSDL2.dylib`,
// 				`/usr/local/lib/libSDL2.dylib`,
// 				`../Frameworks/SDL2.framework/SDL2`,
// 				`/Library/Frameworks/SDL2.framework/SDL2`,
// 				`/System/Library/Frameworks/SDL2.framework/SDL2`,
// 				`/opt/homebrew/lib/libSDL2.dylib`,
			];
		}else version(Posix){
			return [
				`libSDL2.so`,
				`libSDL2-2.0.so`,
				`libSDL2-2.0.so.0`,
// 				`/usr/lib/libSDL2.so`,
// 				`/usr/lib/libSDL2-2.0.so`,
// 				`/usr/lib/libSDL2-2.0.so.0`,
// 				`/usr/local/lib/libSDL2.so`,
// 				`/usr/local/lib/libSDL2-2.0.so`,
// 				`/usr/local/lib/libSDL2-2.0.so.0`,
			];
		}else static assert(0, "bindbc-sdl does not have library search paths set up for this platform.");
	}();
}

@nogc nothrow:
deprecated("Please use `SDL_GetVersion` instead")
	SDLSupport loadedSDLVersion(){ return loadedVersion; }

mixin(makeDynloadFns("", [
	__MODULE__,
	"sdl.assert_",
	"sdl.atomic",
	"sdl.audio",
	"sdl.blendmode",
	"sdl.clipboard",
	"sdl.cpuinfo",
	"sdl.endian",
	"sdl.error",
	"sdl.events",
	"sdl.filesystem",
	"sdl.gamecontroller",
	"sdl.gesture",
	"sdl.guid",
	"sdl.haptic",
	"sdl.hidapi",
	"sdl.hints",
	"sdl.joystick",
	"sdl.keyboard",
	"sdl.keycode",
	"sdl.loadso",
	"sdl.log",
	"sdl.messagebox",
	"sdl.misc",
	"sdl.mouse",
	"sdl.mutex",
	"sdl.pixels",
	"sdl.platform",
	"sdl.power",
	"sdl.rect",
	"sdl.render",
	"sdl.rwops",
	"sdl.scancode",
	"sdl.sensor",
	"sdl.shape",
	"sdl.stdinc",
	"sdl.surface",
	"sdl.system",
	"sdl.syswm",
	"sdl.thread",
	"sdl.timer",
	"sdl.touch",
	"sdl.version_",
	"sdl.video",
	"sdl.vulkan",
]));