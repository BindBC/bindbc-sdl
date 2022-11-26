
//          Copyright 2018 - 2022 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlgamecontroller;

import bindbc.sdl.config;

import bindbc.sdl.bind.sdljoystick,
       bindbc.sdl.bind.sdlrwops,
       bindbc.sdl.bind.sdlsensor;
import bindbc.sdl.bind.sdlstdinc : SDL_bool;

struct SDL_GameController;

static if(sdlSupport >= SDLSupport.sdl2016) {
    enum SDL_GameControllerType {
        SDL_CONTROLLER_TYPE_UNKNOWN = 0,
        SDL_CONTROLLER_TYPE_XBOX360,
        SDL_CONTROLLER_TYPE_XBOXONE,
        SDL_CONTROLLER_TYPE_PS3,
        SDL_CONTROLLER_TYPE_PS4,
        SDL_CONTROLLER_TYPE_NINTENDO_SWITCH_PRO,
        SDL_CONTROLLER_TYPE_VIRTUAL,
        SDL_CONTROLLER_TYPE_PS5,
        SDL_CONTROLLER_TYPE_AMAZON_LUNA,
        SDL_CONTROLLER_TYPE_GOOGLE_STADIA
    }
    mixin(expandEnum!SDL_GameControllerType);
}
else static if(sdlSupport >= SDLSupport.sdl2014) {
    enum SDL_GameControllerType {
        SDL_CONTROLLER_TYPE_UNKNOWN = 0,
        SDL_CONTROLLER_TYPE_XBOX360,
        SDL_CONTROLLER_TYPE_XBOXONE,
        SDL_CONTROLLER_TYPE_PS3,
        SDL_CONTROLLER_TYPE_PS4,
        SDL_CONTROLLER_TYPE_NINTENDO_SWITCH_PRO,
        SDL_CONTROLLER_TYPE_VIRTUAL,
        SDL_CONTROLLER_TYPE_PS5
    }
    mixin(expandEnum!SDL_GameControllerType);
}
else static if(sdlSupport >= SDLSupport.sdl2012) {
    enum SDL_GameControllerType {
        SDL_CONTROLLER_TYPE_UNKNOWN = 0,
        SDL_CONTROLLER_TYPE_XBOX360,
        SDL_CONTROLLER_TYPE_XBOXONE,
        SDL_CONTROLLER_TYPE_PS3,
        SDL_CONTROLLER_TYPE_PS4,
        SDL_CONTROLLER_TYPE_NINTENDO_SWITCH_PRO,
    }
    mixin(expandEnum!SDL_GameControllerType);
}

enum SDL_GameControllerBindType {
    SDL_CONTROLLER_BINDTYPE_NONE = 0,
    SDL_CONTROLLER_BINDTYPE_BUTTON,
    SDL_CONTROLLER_BINDTYPE_AXIS,
    SDL_CONTROLLER_BINDTYPE_HAT,
}
mixin(expandEnum!SDL_GameControllerBindType);

struct SDL_GameControllerButtonBind {
    SDL_GameControllerBindType bindType;
    union value {
        int button;
        int axis;
        struct hat {
            int hat;
            int hat_mask;
        }
    }
    alias button = value.button;
    alias axis = value.axis;
    alias hat = value.hat;
}

enum SDL_GameControllerAxis {
    SDL_CONTROLLER_AXIS_INVALID = -1,
    SDL_CONTROLLER_AXIS_LEFTX,
    SDL_CONTROLLER_AXIS_LEFTY,
    SDL_CONTROLLER_AXIS_RIGHTX,
    SDL_CONTROLLER_AXIS_RIGHTY,
    SDL_CONTROLLER_AXIS_TRIGGERLEFT,
    SDL_CONTROLLER_AXIS_TRIGGERRIGHT,
    SDL_CONTROLLER_AXIS_MAX
}
mixin(expandEnum!SDL_GameControllerAxis);

static if(sdlSupport >= SDLSupport.sdl2014) {
    enum SDL_GameControllerButton {
        SDL_CONTROLLER_BUTTON_INVALID = -1,
        SDL_CONTROLLER_BUTTON_A,
        SDL_CONTROLLER_BUTTON_B,
        SDL_CONTROLLER_BUTTON_X,
        SDL_CONTROLLER_BUTTON_Y,
        SDL_CONTROLLER_BUTTON_BACK,
        SDL_CONTROLLER_BUTTON_GUIDE,
        SDL_CONTROLLER_BUTTON_START,
        SDL_CONTROLLER_BUTTON_LEFTSTICK,
        SDL_CONTROLLER_BUTTON_RIGHTSTICK,
        SDL_CONTROLLER_BUTTON_LEFTSHOULDER,
        SDL_CONTROLLER_BUTTON_RIGHTSHOULDER,
        SDL_CONTROLLER_BUTTON_DPAD_UP,
        SDL_CONTROLLER_BUTTON_DPAD_DOWN,
        SDL_CONTROLLER_BUTTON_DPAD_LEFT,
        SDL_CONTROLLER_BUTTON_DPAD_RIGHT,
        SDL_CONTROLLER_BUTTON_MISC1,
        SDL_CONTROLLER_BUTTON_PADDLE1,
        SDL_CONTROLLER_BUTTON_PADDLE2,
        SDL_CONTROLLER_BUTTON_PADDLE3,
        SDL_CONTROLLER_BUTTON_PADDLE4,
        SDL_CONTROLLER_BUTTON_TOUCHPAD,
        SDL_CONTROLLER_BUTTON_MAX,
    }
}
else {
    enum SDL_GameControllerButton {
        SDL_CONTROLLER_BUTTON_INVALID = -1,
        SDL_CONTROLLER_BUTTON_A,
        SDL_CONTROLLER_BUTTON_B,
        SDL_CONTROLLER_BUTTON_X,
        SDL_CONTROLLER_BUTTON_Y,
        SDL_CONTROLLER_BUTTON_BACK,
        SDL_CONTROLLER_BUTTON_GUIDE,
        SDL_CONTROLLER_BUTTON_START,
        SDL_CONTROLLER_BUTTON_LEFTSTICK,
        SDL_CONTROLLER_BUTTON_RIGHTSTICK,
        SDL_CONTROLLER_BUTTON_LEFTSHOULDER,
        SDL_CONTROLLER_BUTTON_RIGHTSHOULDER,
        SDL_CONTROLLER_BUTTON_DPAD_UP,
        SDL_CONTROLLER_BUTTON_DPAD_DOWN,
        SDL_CONTROLLER_BUTTON_DPAD_LEFT,
        SDL_CONTROLLER_BUTTON_DPAD_RIGHT,
        SDL_CONTROLLER_BUTTON_MAX,
    }
}
mixin(expandEnum!SDL_GameControllerButton);

static if(sdlSupport >= SDLSupport.sdl202) {
    @nogc nothrow
    int SDL_GameControllerAddMappingsFromFile(const(char)* file) {
        pragma(inline, true);
        return SDL_GameControllerAddMappingsFromRW(SDL_RWFromFile(file,"rb"),1);
    }
}

mixin(makeFnBinds!(
    [q{int}, q{SDL_GameControllerAddMapping}, q{const(char)* mappingString}],
    [q{char*}, q{SDL_GameControllerMappingForGUID}, q{SDL_JoystickGUID guid}],
    [q{char*}, q{SDL_GameControllerMapping}, q{SDL_GameController* gamecontroller}],
    [q{SDL_bool}, q{SDL_IsGameController}, q{int joystick_index}],
    [q{const(char)*}, q{SDL_GameControllerNameForIndex}, q{int joystick_index}],
    [q{SDL_GameController*}, q{SDL_GameControllerOpen}, q{int joystick_index}],
    [q{const(char)*}, q{SDL_GameControllerName}, q{SDL_GameController* gamecontroller}],
    [q{SDL_bool}, q{SDL_GameControllerGetAttached}, q{SDL_GameController* gamecontroller}],
    [q{SDL_Joystick*}, q{SDL_GameControllerGetJoystick}, q{SDL_GameController* gamecontroller}],
    [q{int}, q{SDL_GameControllerEventState}, q{int state}],
    [q{void}, q{SDL_GameControllerUpdate}, q{}],
    [q{SDL_GameControllerAxis}, q{SDL_GameControllerGetAxisFromString}, q{const(char)* pchString}],
    [q{const(char)*}, q{SDL_GameControllerGetStringForAxis}, q{SDL_GameControllerAxis axis}],
    [q{SDL_GameControllerButtonBind}, q{SDL_GameControllerGetBindForAxis}, q{SDL_GameController* gamecontroller, SDL_GameControllerAxis axis}],
    [q{short}, q{SDL_GameControllerGetAxis}, q{SDL_GameController* gamecontroller, SDL_GameControllerAxis axis}],
    [q{SDL_GameControllerButton}, q{SDL_GameControllerGetButtonFromString}, q{const(char*) pchString}],
    [q{const(char)*}, q{SDL_GameControllerGetStringForButton}, q{SDL_GameControllerButton button}],
    [q{SDL_GameControllerButtonBind}, q{SDL_GameControllerGetBindForButton}, q{SDL_GameController* gamecontroller, SDL_GameControllerButton button}],
    [q{ubyte}, q{SDL_GameControllerGetButton}, q{SDL_GameController* gamecontroller, SDL_GameControllerButton button}],
    [q{void}, q{SDL_GameControllerClose}, q{SDL_GameController* gamecontroller}],
));

static if(sdlSupport >= SDLSupport.sdl202) {
    mixin(makeFnBinds!(
        [q{int}, q{SDL_GameControllerAddMappingsFromRW}, q{SDL_RWops* rw, int freerw}],
    ));
}
static if(sdlSupport >= SDLSupport.sdl204) {
    mixin(makeFnBinds!(
        [q{SDL_GameController*}, q{SDL_GameControllerFromInstanceID}, q{SDL_JoystickID joyid}],
    ));
}
static if(sdlSupport >= SDLSupport.sdl206) {
    mixin(makeFnBinds!(
        [q{ushort}, q{SDL_GameControllerGetProduct}, q{SDL_GameController* gamecontroller}],
        [q{ushort}, q{SDL_GameControllerGetProductVersion}, q{SDL_GameController* gamecontroller}],
        [q{ushort}, q{SDL_GameControllerGetVendor}, q{SDL_GameController* gamecontroller}],
        [q{char*}, q{SDL_GameControllerMappingForIndex}, q{int mapping_index}],
        [q{int}, q{SDL_GameControllerNumMappings}, q{}],
    ));
}
static if(sdlSupport >= SDLSupport.sdl209) {
    mixin(makeFnBinds!(
        [q{char*}, q{SDL_GameControllerMappingForDeviceIndex}, q{int joystick_index}],
        [q{int}, q{SDL_GameControllerRumble}, q{SDL_GameController* gamecontroller, ushort low_frequency_rumble, ushort high_frequency_rumble, uint duration_ms}],
    ));
}
static if(sdlSupport >= SDLSupport.sdl2010) {
    mixin(makeFnBinds!(
        [q{int}, q{SDL_GameControllerGetPlayerIndex}, q{SDL_GameController* gamecontroller}],
    ));
}
static if(sdlSupport >= SDLSupport.sdl2012) {
    mixin(makeFnBinds!(
        [q{SDL_GameControllerType}, q{SDL_GameControllerTypeForIndex}, q{int joystick_index}],
        [q{SDL_GameController*}, q{SDL_GameControllerFromPlayerIndex}, q{int player_index}],
        [q{SDL_GameControllerType}, q{SDL_GameControllerGetType}, q{SDL_GameController* gamecontroller}],
        [q{void}, q{SDL_GameControllerSetPlayerIndex}, q{SDL_GameController* gamecontroller, int player_index}],
    ));
}
static if(sdlSupport >= SDLSupport.sdl2014) {
    mixin(makeFnBinds!(
        [q{SDL_bool}, q{SDL_GameControllerHasAxis}, q{SDL_GameController* gamecontroller, SDL_GameControllerAxis axis}],
        [q{SDL_bool}, q{SDL_GameControllerHasButton}, q{SDL_GameController* gamecontroller, SDL_GameControllerButton button}],
        [q{int}, q{SDL_GameControllerGetNumTouchpads}, q{SDL_GameController* gamecontroller}],
        [q{int}, q{SDL_GameControllerGetNumTouchpadFingers}, q{SDL_GameController* gamecontroller, int touchpad}],
        [q{int}, q{SDL_GameControllerGetTouchpadFinger}, q{SDL_GameController* gamecontroller, int touchpad, int finger, ubyte* state, float* x, float* y, float* pressure}],
        [q{SDL_bool}, q{SDL_GameControllerHasSensor}, q{SDL_GameController* gamecontroller, SDL_SensorType type}],
        [q{int}, q{SDL_GameControllerSetSensorEnabled}, q{SDL_GameController* gamecontroller, SDL_SensorType type, SDL_bool enabled}],
        [q{SDL_bool}, q{SDL_GameControllerIsSensorEnabled}, q{SDL_GameController* gamecontroller, SDL_SensorType type}],
        [q{int}, q{SDL_GameControllerGetSensorData}, q{SDL_GameController* gamecontroller, SDL_SensorType type, float* data, int num_values}],
        [q{int}, q{SDL_GameControllerRumbleTriggers}, q{SDL_GameController* gamecontroller, ushort left_rumble, ushort right_rumble, uint duration_ms}],
        [q{SDL_bool}, q{SDL_GameControllerHasLED}, q{SDL_GameController* gamecontroller}],
        [q{int}, q{SDL_GameControllerSetLED}, q{SDL_GameController* gamecontroller, ubyte red, ubyte green, ubyte blue}],
    ));
}
static if(sdlSupport >= SDLSupport.sdl2016) {
    mixin(makeFnBinds!(
        [q{int}, q{SDL_GameControllerSendEffect}, q{SDL_GameController* gamecontroller, const(void)* data, int size}],
        [q{float}, q{SDL_GameControllerGetSensorDataRate}, q{SDL_GameController* gamecontroller, SDL_SensorType type}],
    ));
}
static if(sdlSupport >= SDLSupport.sdl2018) {
    mixin(makeFnBinds!(
        [q{SDL_bool}, q{SDL_GameControllerHasRumble}, q{SDL_GameController* gamecontroller}],
        [q{SDL_bool}, q{SDL_GameControllerHasRumbleTriggers}, q{SDL_GameController* gamecontroller}],
        [q{const(char)*}, q{SDL_GameControllerGetAppleSFSymbolsNameForButton}, q{SDL_GameController* gamecontroller, SDL_GameControllerButton button}],
        [q{const(char)*}, q{SDL_GameControllerGetAppleSFSymbolsNameForAxis}, q{SDL_GameController* gamecontroller, SDL_GameControllerAxis axis}],
    ));
}

