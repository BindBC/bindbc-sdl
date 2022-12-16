/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module bindbc.sdl.bind;

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
	bindbc.sdl.bind.assert_,
	bindbc.sdl.bind.atomic,
	bindbc.sdl.bind.audio,
	bindbc.sdl.bind.blendmode,
	bindbc.sdl.bind.clipboard,
	bindbc.sdl.bind.cpuinfo,
	bindbc.sdl.bind.error,
	bindbc.sdl.bind.events,
	bindbc.sdl.bind.filesystem,
	bindbc.sdl.bind.gamecontroller,
	bindbc.sdl.bind.gesture,
	bindbc.sdl.bind.hidapi,
	bindbc.sdl.bind.haptic,
	bindbc.sdl.bind.hints,
	bindbc.sdl.bind.joystick,
	bindbc.sdl.bind.keyboard,
	bindbc.sdl.bind.keycode,
	bindbc.sdl.bind.loadso,
	bindbc.sdl.bind.log,
	bindbc.sdl.bind.messagebox,
	bindbc.sdl.bind.misc,
	bindbc.sdl.bind.mouse,
	bindbc.sdl.bind.mutex,
	bindbc.sdl.bind.pixels,
	bindbc.sdl.bind.platform,
	bindbc.sdl.bind.power,
	bindbc.sdl.bind.rect,
	bindbc.sdl.bind.render,
	bindbc.sdl.bind.rwops,
	bindbc.sdl.bind.scancode,
	bindbc.sdl.bind.sensor,
	bindbc.sdl.bind.shape,
	bindbc.sdl.bind.stdinc,
	bindbc.sdl.bind.surface,
	bindbc.sdl.bind.system,
	bindbc.sdl.bind.syswm,
	bindbc.sdl.bind.thread,
	bindbc.sdl.bind.timer,
	bindbc.sdl.bind.touch,
	bindbc.sdl.bind.version_,
	bindbc.sdl.bind.video,
	bindbc.sdl.bind.vulkan;
