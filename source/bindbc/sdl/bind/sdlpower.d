
//          Copyright 2018 - 2022 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlpower;

import bindbc.sdl.config;

enum SDL_PowerState {
    SDL_POWERSTATE_UNKNOWN,
    SDL_POWERSTATE_ON_BATTERY,
    SDL_POWERSTATE_NO_BATTERY,
    SDL_POWERSTATE_CHARGING,
    SDL_POWERSTATE_CHARGED
}
mixin(expandEnum!SDL_PowerState);

mixin(makeFnBinds!(
    [q{SDL_PowerState}, q{SDL_GetPowerInfo}, q{int* secs, int* pct}],
));
