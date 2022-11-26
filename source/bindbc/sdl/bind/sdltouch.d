
//          Copyright 2018 - 2022 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdltouch;

import bindbc.sdl.config;

alias SDL_TouchID = long;
alias SDL_FingerID = long;

struct SDL_Finger {
    SDL_FingerID id;
    float x;
    float y;
    float pressure;
}

enum SDL_TOUCH_MOUSEID = cast(uint)-1;

static if(sdlSupport >= SDLSupport.sdl2010) {
    enum SDL_TouchDeviceType {
        SDL_TOUCH_DEVICE_INVALID = -1,
        SDL_TOUCH_DEVICE_DIRECT,
        SDL_TOUCH_DEVICE_INDIRECT_ABSOLUTE,
        SDL_TOUCH_DEVICE_INDIRECT_RELATIVE,
    }
    mixin(expandEnum!SDL_TouchDeviceType);

    enum SDL_MOUSE_TOUCHID = -1L;
}

mixin(makeFnBinds!(
    [q{int}, q{SDL_GetNumTouchDevices}, q{}],
    [q{SDL_TouchID}, q{SDL_GetTouchDevice}, q{int index}],
    [q{int}, q{SDL_GetNumTouchFingers}, q{SDL_TouchID touchID}],
    [q{SDL_Finger*}, q{SDL_GetTouchFinger}, q{SDL_TouchID touchID, int index}],
));

static if(sdlSupport >= SDLSupport.sdl2010) {
    mixin(makeFnBinds!(
        [q{SDL_TouchDeviceType}, q{SDL_GetTouchDeviceType}, q{SDL_TouchID touchID}],
    ));
}
static if(sdlSupport >= SDLSupport.sdl2022) {
    mixin(makeFnBinds!(
        [q{const(char)*}, q{SDL_GetTouchName}, q{int index}],
    ));
}
