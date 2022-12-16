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
	"bindbc.sdl.bind",
	"bindbc.sdl.bind.assert_",
	"bindbc.sdl.bind.atomic",
	"bindbc.sdl.bind.audio",
	"bindbc.sdl.bind.blendmode",
	"bindbc.sdl.bind.clipboard",
	"bindbc.sdl.bind.cpuinfo",
	"bindbc.sdl.bind.error",
	"bindbc.sdl.bind.events",
	"bindbc.sdl.bind.filesystem",
	"bindbc.sdl.bind.gamecontroller",
	"bindbc.sdl.bind.gesture",
	"bindbc.sdl.bind.haptic",
	"bindbc.sdl.bind.hidapi",
	"bindbc.sdl.bind.hints",
	"bindbc.sdl.bind.joystick",
	"bindbc.sdl.bind.keyboard",
	"bindbc.sdl.bind.keycode",
	"bindbc.sdl.bind.loadso",
	"bindbc.sdl.bind.log",
	"bindbc.sdl.bind.messagebox",
	"bindbc.sdl.bind.misc",
	"bindbc.sdl.bind.mouse",
	"bindbc.sdl.bind.mutex",
	"bindbc.sdl.bind.pixels",
	"bindbc.sdl.bind.platform",
	"bindbc.sdl.bind.power",
	"bindbc.sdl.bind.rect",
	"bindbc.sdl.bind.render",
	"bindbc.sdl.bind.rwops",
	"bindbc.sdl.bind.scancode",
	"bindbc.sdl.bind.sensor",
	"bindbc.sdl.bind.shape",
	"bindbc.sdl.bind.stdinc",
	"bindbc.sdl.bind.surface",
	"bindbc.sdl.bind.system",
	"bindbc.sdl.bind.syswm",
	"bindbc.sdl.bind.thread",
	"bindbc.sdl.bind.timer",
	"bindbc.sdl.bind.touch",
	"bindbc.sdl.bind.version_",
	"bindbc.sdl.bind.video",
	"bindbc.sdl.bind.vulkan",
]));
