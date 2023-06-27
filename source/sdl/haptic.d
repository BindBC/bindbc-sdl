/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.haptic;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

import sdl.joystick: SDL_Joystick;

struct SDL_Haptic;

enum: ushort{
	SDL_HAPTIC_CONSTANT      = 1U<<0,
	SDL_HAPTIC_SINE          = 1U<<1,
	SDL_HAPTIC_LEFTRIGHT     = 1U<<2,
	SDL_HAPTIC_TRIANGLE      = 1U<<3,
	SDL_HAPTIC_SAWTOOTHUP    = 1U<<4,
	SDL_HAPTIC_SAWTOOTHDOWN  = 1U<<5,
	SDL_HAPTIC_RAMP          = 1U<<6,
	SDL_HAPTIC_SPRING        = 1U<<7,
	SDL_HAPTIC_DAMPER        = 1U<<8,
	SDL_HAPTIC_INERTIA       = 1U<<9,
	SDL_HAPTIC_FRICTION      = 1U<<10,
	SDL_HAPTIC_CUSTOM        = 1U<<11,
	SDL_HAPTIC_GAIN          = 1U<<12,
	SDL_HAPTIC_AUTOCENTER    = 1U<<13,
	SDL_HAPTIC_STATUS        = 1U<<14,
	SDL_HAPTIC_PAUSE         = 1U<<15,
}

enum: uint{
	SDL_HAPTIC_POLAR          = 0,
	SDL_HAPTIC_CARTESIAN      = 1,
	SDL_HAPTIC_SPHERICAL      = 2,
	SDL_HAPTIC_INFINITY       = 4294967295U,
}
static if(sdlSupport >= SDLSupport.v2_0_14)
enum: uint{
	SDL_HAPTIC_STEERING_AXIS  = 3,
}

struct SDL_HapticDirection{
	ubyte type;
	int[3] dir;
}

struct SDL_HapticConstant{
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

struct SDL_HapticPeriodic{
	ushort type;
	SDL_HapticDirection direction;
	
	uint length;
	ushort delay;
	
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

struct SDL_HapticCondition{
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
	short[3] center;
}

struct SDL_HapticRamp{
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

struct SDL_HapticLeftRight{
	ushort type;
	
	uint length;
	
	ushort large_magnitude;
	ushort small_magnitude;
}

struct SDL_HapticCustom{
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

union SDL_HapticEffect{
	ushort type;
	SDL_HapticConstant constant;
	SDL_HapticPeriodic periodic;
	SDL_HapticCondition condition;
	SDL_HapticRamp ramp;
	SDL_HapticLeftRight leftright;
	SDL_HapticCustom custom;
}

mixin(joinFnBinds((){
	string[][] ret;
	ret ~= makeFnBinds([
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
	]);
	return ret;
}()));
