
//          Copyright 2018 - 2022 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdl;

import bindbc.sdl.config;

enum : uint {
    SDL_INIT_TIMER = 0x00000001,
    SDL_INIT_AUDIO = 0x00000010,
    SDL_INIT_VIDEO = 0x00000020,
    SDL_INIT_JOYSTICK = 0x00000200,
    SDL_INIT_HAPTIC = 0x00001000,
    SDL_INIT_GAMECONTROLLER = 0x00002000,
    SDL_INIT_EVENTS = 0x00004000,
    SDL_INIT_NOPARACHUTE = 0x00100000,
}
static if(sdlSupport >= SDLSupport.sdl209) {
    enum : uint {
        SDL_INIT_SENSOR = 0x00008000,
        SDL_INIT_EVERYTHING =
            SDL_INIT_TIMER    | SDL_INIT_AUDIO  | SDL_INIT_VIDEO |
            SDL_INIT_JOYSTICK | SDL_INIT_HAPTIC | SDL_INIT_GAMECONTROLLER |
            SDL_INIT_EVENTS   | SDL_INIT_SENSOR,
    }
} else {
    enum : uint {
        SDL_INIT_EVERYTHING =
            SDL_INIT_TIMER    | SDL_INIT_AUDIO  | SDL_INIT_VIDEO |
            SDL_INIT_JOYSTICK | SDL_INIT_HAPTIC | SDL_INIT_GAMECONTROLLER |
            SDL_INIT_EVENTS,
    }
}

mixin(makeFnBinds!(
    [q{int},  q{SDL_Init},          q{uint flags}],
    [q{int},  q{SDL_InitSubSystem}, q{uint flags}],
    [q{void}, q{SDL_QuitSubSystem}, q{uint flags}],
    [q{uint}, q{SDL_WasInit},       q{uint flags}],
    [q{void}, q{SDL_Quit},          q{}],
));
