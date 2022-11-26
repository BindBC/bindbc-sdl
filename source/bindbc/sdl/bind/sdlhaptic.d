
//          Copyright 2018 - 2022 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlhaptic;

import bindbc.sdl.config;
import bindbc.sdl.bind.sdljoystick : SDL_Joystick;

struct SDL_Haptic;

enum : ushort {
    SDL_HAPTIC_CONSTANT = 1u<<0,
    SDL_HAPTIC_SINE = 1u<<1,
    SDL_HAPTIC_LEFTRIGHT = 1u<<2,
    SDL_HAPTIC_TRIANGLE = 1u<<3,
    SDL_HAPTIC_SAWTOOTHUP = 1u<<4,
    SDL_HAPTIC_SAWTOOTHDOWN = 1u<<5,
    SDL_HAPTIC_RAMP = 1u<<6,
    SDL_HAPTIC_SPRING = 1u<<7,
    SDL_HAPTIC_DAMPER = 1u<<8,
    SDL_HAPTIC_INERTIA = 1u<<9,
    SDL_HAPTIC_FRICTION = 1u<<10,
    SDL_HAPTIC_CUSTOM = 1u<<11,
    SDL_HAPTIC_GAIN = 1u<<12,
    SDL_HAPTIC_AUTOCENTER = 1u<<13,
    SDL_HAPTIC_STATUS = 1u<<14,
    SDL_HAPTIC_PAUSE = 1u<<15,
}

enum SDL_HAPTIC_POLAR = 0;
enum SDL_HAPTIC_CARTESIAN = 1;
enum SDL_HAPTIC_SPHERICAL = 2;
static if(sdlSupport >= SDLSupport.sdl2014) enum SDL_HAPTIC_STEERING_AXIS = 3;

enum SDL_HAPTIC_INFINITY = 4294967295U;

struct SDL_HapticDirection {
    ubyte type;
    int[3] dir;
}

struct SDL_HapticConstant {
    ushort type;
    SDL_HapticDirection direction;
    uint length;
    ushort delay;
    ushort button;
    ushort interval;
    short level;
    ushort attack_length;
    ushort attack_level;
    ushort fade_length;
    ushort fade_level;
}

struct SDL_HapticPeriodic {
    ushort type;
    SDL_HapticDirection direction;
    uint length;
    uint delay;
    ushort button;
    ushort interval;
    ushort period;
    short magnitude;
    short offset;
    ushort phase;
    ushort attack_length;
    ushort attack_level;
    ushort fade_length;
    ushort fade_level;
}

struct SDL_HapticCondition {
    ushort type;
    SDL_HapticDirection direciton;
    uint length;
    ushort delay;
    ushort button;
    ushort interval;
    ushort[3] right_sat;
    ushort[3] left_sat;
    short[3] right_coeff;
    short[3] left_coeff;
    ushort[3] deadband;
    ushort[3] center;
}

struct SDL_HapticRamp {
    ushort type;
    SDL_HapticDirection direction;
    uint length;
    ushort delay;
    ushort button;
    ushort interval;
    short start;
    short end;
    ushort attack_length;
    ushort attack_level;
    ushort fade_length;
    ushort fade_level;
}

struct SDL_HapticLeftRight {
    ushort type;
    uint length;
    ushort large_magnitude;
    ushort small_magnitude;
}

struct SDL_HapticCustom {
    ushort type;
    SDL_HapticDirection direction;
    uint length;
    ushort delay;
    ushort button;
    ushort interval;
    ubyte channels;
    ushort period;
    ushort samples;
    ushort* data;
    ushort attack_length;
    ushort attack_level;
    ushort fade_length;
    ushort fade_level;
}

union SDL_HapticEffect {
    ushort type;
    SDL_HapticConstant constant;
    SDL_HapticPeriodic periodic;
    SDL_HapticCondition condition;
    SDL_HapticRamp ramp;
    SDL_HapticLeftRight leftright;
    SDL_HapticCustom custom;
}

mixin(makeFnBinds!(
    [q{int}, q{SDL_NumHaptics}, q{}],
    [q{const(char)*}, q{SDL_HapticName}, q{int device_index}],
    [q{SDL_Haptic*}, q{SDL_HapticOpen}, q{int device_index}],
    [q{int}, q{SDL_HapticOpened}, q{int device_index}],
    [q{int}, q{SDL_HapticIndex}, q{SDL_Haptic* haptic}],
    [q{int}, q{SDL_MouseIsHaptic}, q{}],
    [q{SDL_Haptic*}, q{SDL_HapticOpenFromMouse}, q{}],
    [q{int}, q{SDL_JoystickIsHaptic}, q{SDL_Joystick* joystick}],
    [q{SDL_Haptic*}, q{SDL_HapticOpenFromJoystick}, q{SDL_Joystick* joystick}],
    [q{void}, q{SDL_HapticClose}, q{SDL_Haptic* haptic}],
    [q{int}, q{SDL_HapticNumEffects}, q{SDL_Haptic* haptic}],
    [q{int}, q{SDL_HapticNumEffectsPlaying}, q{SDL_Haptic* haptic}],
    [q{uint}, q{SDL_HapticQuery}, q{SDL_Haptic* haptic}],
    [q{int}, q{SDL_HapticNumAxes}, q{SDL_Haptic* haptic}],
    [q{int}, q{SDL_HapticEffectSupported}, q{SDL_Haptic* haptic, SDL_HapticEffect* effect}],
    [q{int}, q{SDL_HapticNewEffect}, q{SDL_Haptic* haptic, SDL_HapticEffect* effect}],
    [q{int}, q{SDL_HapticUpdateEffect}, q{SDL_Haptic* haptic, int effect, SDL_HapticEffect* data}],
    [q{int}, q{SDL_HapticRunEffect}, q{SDL_Haptic* haptic, int effect, uint iterations}],
    [q{int}, q{SDL_HapticStopEffect}, q{SDL_Haptic* haptic, int effect}],
    [q{int}, q{SDL_HapticDestroyEffect}, q{SDL_Haptic* haptic, int effect}],
    [q{int}, q{SDL_HapticGetEffectStatus}, q{SDL_Haptic* haptic, int effect}],
    [q{int}, q{SDL_HapticSetGain}, q{SDL_Haptic* haptic, int gain}],
    [q{int}, q{SDL_HapticSetAutocenter}, q{SDL_Haptic* haptic, int autocenter}],
    [q{int}, q{SDL_HapticPause}, q{SDL_Haptic* haptic}],
    [q{int}, q{SDL_HapticUnpause}, q{SDL_Haptic* haptic}],
    [q{int}, q{SDL_HapticStopAll}, q{SDL_Haptic* haptic}],
    [q{int}, q{SDL_HapticRumbleSupported}, q{SDL_Haptic* haptic}],
    [q{int}, q{SDL_HapticRumbleInit}, q{SDL_Haptic* haptic}],
    [q{int}, q{SDL_HapticRumblePlay}, q{SDL_Haptic* haptic, float strength, uint length}],
    [q{int}, q{SDL_HapticRumbleStop}, q{SDL_Haptic* haptic}],
));
