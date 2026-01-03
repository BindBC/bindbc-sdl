/+
+            Copyright 2024 – 2026 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.haptic;

import bindbc.sdl.config, bindbc.sdl.codegen;

import sdl.joystick: SDL_Joystick;

struct SDL_Haptic;

enum SDL_HAPTIC_INFINITY = 4_294_967_295U;
alias infinity = SDL_HAPTIC_INFINITY;

mixin(makeEnumBind(q{SDL_HapticEffectType}, q{ushort}, aliases: [q{SDL_HapticType}], members: (){
	EnumMember[] ret = [
		{{q{constant},     q{SDL_HAPTIC_CONSTANT}},     q{1U <<  0}},
		{{q{sine},         q{SDL_HAPTIC_SINE}},         q{1U <<  1}},
		{{q{square},       q{SDL_HAPTIC_SQUARE}},       q{1U <<  2}},
		{{q{triangle},     q{SDL_HAPTIC_TRIANGLE}},     q{1U <<  3}},
		{{q{sawtoothUp},   q{SDL_HAPTIC_SAWTOOTHUP}},   q{1U <<  4}},
		{{q{sawtoothDown}, q{SDL_HAPTIC_SAWTOOTHDOWN}}, q{1U <<  5}},
		{{q{ramp},         q{SDL_HAPTIC_RAMP}},         q{1U <<  6}},
		{{q{spring},       q{SDL_HAPTIC_SPRING}},       q{1U <<  7}},
		{{q{damper},       q{SDL_HAPTIC_DAMPER}},       q{1U <<  8}},
		{{q{inertia},      q{SDL_HAPTIC_INERTIA}},      q{1U <<  9}},
		{{q{friction},     q{SDL_HAPTIC_FRICTION}},     q{1U << 10}},
		{{q{leftRight},    q{SDL_HAPTIC_LEFTRIGHT}},    q{1U << 11}},
		{{q{reserved1},    q{SDL_HAPTIC_RESERVED1}},    q{1U << 12}},
		{{q{reserved2},    q{SDL_HAPTIC_RESERVED2}},    q{1U << 13}},
		{{q{reserved3},    q{SDL_HAPTIC_RESERVED3}},    q{1U << 14}},
		{{q{custom},       q{SDL_HAPTIC_CUSTOM}},       q{1U << 15}},
	];
	return ret;
}()));
deprecated alias SDL_HapticType_ = SDL_HapticEffectType;

alias SDL_HapticFeature_ = uint;
mixin(makeEnumBind(q{SDL_HapticFeature}, q{SDL_HapticFeature_}, members: (){
	EnumMember[] ret = [
		{{q{constant}},                                   q{1U <<  0}},
		{{q{sine}},                                       q{1U <<  1}},
		{{q{square}},                                     q{1U <<  2}},
		{{q{triangle}},                                   q{1U <<  3}},
		{{q{sawtoothUp}},                                 q{1U <<  4}},
		{{q{sawtoothDown}},                               q{1U <<  5}},
		{{q{ramp}},                                       q{1U <<  6}},
		{{q{spring}},                                     q{1U <<  7}},
		{{q{damper}},                                     q{1U <<  8}},
		{{q{inertia}},                                    q{1U <<  9}},
		{{q{friction}},                                   q{1U << 10}},
		{{q{leftRight}},                                  q{1U << 11}},
		{{q{reserved1}},                                  q{1U << 12}},
		{{q{reserved2}},                                  q{1U << 13}},
		{{q{reserved3}},                                  q{1U << 14}},
		{{q{custom}},                                     q{1U << 15}},
		{{q{gain},          q{SDL_HAPTIC_GAIN}},          q{1U << 16}},
		{{q{autoCentre},    q{SDL_HAPTIC_AUTOCENTRE}},    q{1U << 17}, aliases: [{q{autoCenter}, q{SDL_HAPTIC_AUTOCENTER}}]},
		{{q{status},        q{SDL_HAPTIC_STATUS}},        q{1U << 18}},
		{{q{pause},         q{SDL_HAPTIC_PAUSE}},         q{1U << 19}},
	];
	return ret;
}()));

deprecated alias SDL_HapticDirectionType_ = ubyte;
mixin(makeEnumBind(q{SDL_HapticDirectionType}, q{ubyte}, aliases: [q{SDL_HapticDir}], members: (){
	EnumMember[] ret = [
		{{q{polar},           q{SDL_HAPTIC_POLAR}},            q{0}},
		{{q{cartesian},       q{SDL_HAPTIC_CARTESIAN}},        q{1}},
		{{q{spherical},       q{SDL_HAPTIC_SPHERICAL}},        q{2}},
		{{q{steeringAxis},    q{SDL_HAPTIC_STEERING_AXIS}},    q{3}},
	];
	return ret;
}()));

alias SDL_HapticEffectID = int;

struct SDL_HapticDirection{
	SDL_HapticDirectionType type;
	int[3] dir;
}

struct SDL_HapticConstant{
	SDL_HapticEffectType type;
	SDL_HapticDirection direction;
	uint length;
	ushort delay, button, interval;
	short level;
	ushort attackLength, attackLevel;
	ushort fadeLength, fadeLevel;
	
	alias attack_length = attackLength;
	alias attack_level = attackLevel;
	alias fade_length = fadeLength;
	alias fade_level = fadeLevel;
}

struct SDL_HapticPeriodic{
	SDL_HapticEffectType type;
	SDL_HapticDirection direction;
	uint length;
	ushort delay, button, interval;
	ushort period;
	short magnitude, offset;
	ushort phase;
	ushort attackLength, attackLevel;
	ushort fadeLength, fadeLevel;
	
	alias attack_length = attackLength;
	alias attack_level = attackLevel;
	alias fade_length = fadeLength;
	alias fade_level = fadeLevel;
}

struct SDL_HapticCondition{
	SDL_HapticEffectType type;
	SDL_HapticDirection direction;
	uint length;
	ushort delay, button, interval;
	ushort[3] rightSat, leftSat;
	short[3] rightCoeff, leftCoeff;
	ushort[3] deadband;
	short[3] centre;
	
	alias right_sat = rightSat;
	alias left_sat = leftSat;
	alias right_coeff = rightCoeff;
	alias left_coeff = leftCoeff;
	alias center = centre;
}

struct SDL_HapticRamp{
	SDL_HapticEffectType type;
	SDL_HapticDirection direction;
	uint length;
	ushort delay, button, interval;	
	short start, end;
	ushort attackLength, attackLevel;
	ushort fadeLength, fadeLevel;
	
	alias attack_length = attackLength;
	alias attack_level = attackLevel;
	alias fade_length = fadeLength;
	alias fade_level = fadeLevel;
}

struct SDL_HapticLeftRight{
	SDL_HapticEffectType type;
	uint length;
	ushort largeMagnitude, smallMagnitude;
	
	alias large_magnitude = largeMagnitude;
	alias small_magnitude = smallMagnitude;
}

struct SDL_HapticCustom{
	SDL_HapticEffectType type;
	SDL_HapticDirection direction;
	uint length;
	ushort delay, button, interval;
	ubyte channels;
	ushort period, samples;
	ushort* data;
	ushort attackLength, attackLevel;
	ushort fadeLength, fadeLevel;
	
	alias attack_length = attackLength;
	alias attack_level = attackLevel;
	alias fade_length = fadeLength;
	alias fade_level = fadeLevel;
}

union SDL_HapticEffect{
	SDL_HapticEffectType type;
	SDL_HapticConstant constant;
	SDL_HapticPeriodic periodic;
	SDL_HapticCondition condition;
	SDL_HapticRamp ramp;
	SDL_HapticLeftRight leftRight;
	SDL_HapticCustom custom;
	
	alias leftright = leftRight;
}

alias SDL_HapticID = uint;

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{SDL_HapticID*}, q{SDL_GetHaptics}, q{int* count}},
		{q{const(char)*}, q{SDL_GetHapticNameForID}, q{SDL_HapticID instanceID}},
		{q{SDL_Haptic*}, q{SDL_OpenHaptic}, q{SDL_HapticID instanceID}},
		{q{SDL_Haptic*}, q{SDL_GetHapticFromID}, q{SDL_HapticID instanceID}},
		{q{SDL_HapticID}, q{SDL_GetHapticID}, q{SDL_Haptic* haptic}},
		{q{const(char)*}, q{SDL_GetHapticName}, q{SDL_Haptic* haptic}},
		{q{bool}, q{SDL_IsMouseHaptic}, q{}},
		{q{SDL_Haptic*}, q{SDL_OpenHapticFromMouse}, q{}},
		{q{bool}, q{SDL_IsJoystickHaptic}, q{SDL_Joystick* joystick}},
		{q{SDL_Haptic*}, q{SDL_OpenHapticFromJoystick}, q{SDL_Joystick* joystick}},
		{q{void}, q{SDL_CloseHaptic}, q{SDL_Haptic* haptic}},
		{q{int}, q{SDL_GetMaxHapticEffects}, q{SDL_Haptic* haptic}},
		{q{int}, q{SDL_GetMaxHapticEffectsPlaying}, q{SDL_Haptic* haptic}},
		{q{uint}, q{SDL_GetHapticFeatures}, q{SDL_Haptic* haptic}},
		{q{int}, q{SDL_GetNumHapticAxes}, q{SDL_Haptic* haptic}},
		{q{bool}, q{SDL_HapticEffectSupported}, q{SDL_Haptic* haptic, const(SDL_HapticEffect)* effect}},
		{q{SDL_HapticEffectID}, q{SDL_CreateHapticEffect}, q{SDL_Haptic* haptic, const(SDL_HapticEffect)* effect}},
		{q{bool}, q{SDL_UpdateHapticEffect}, q{SDL_Haptic* haptic, SDL_HapticEffectID effect, const(SDL_HapticEffect)* data}},
		{q{bool}, q{SDL_RunHapticEffect}, q{SDL_Haptic* haptic, SDL_HapticEffectID effect, uint iterations}},
		{q{bool}, q{SDL_StopHapticEffect}, q{SDL_Haptic* haptic, SDL_HapticEffectID effect}},
		{q{void}, q{SDL_DestroyHapticEffect}, q{SDL_Haptic* haptic, SDL_HapticEffectID effect}},
		{q{bool}, q{SDL_GetHapticEffectStatus}, q{SDL_Haptic* haptic, SDL_HapticEffectID effect}},
		{q{bool}, q{SDL_SetHapticGain}, q{SDL_Haptic* haptic, int gain}},
		{q{bool}, q{SDL_SetHapticAutocenter}, q{SDL_Haptic* haptic, int autoCentre}, aliases: [q{SDL_SetHapticAutoCentre}, q{SDL_SetHapticAutoCenter}]},
		{q{bool}, q{SDL_PauseHaptic}, q{SDL_Haptic* haptic}},
		{q{bool}, q{SDL_ResumeHaptic}, q{SDL_Haptic* haptic}},
		{q{bool}, q{SDL_StopHapticEffects}, q{SDL_Haptic* haptic}},
		{q{bool}, q{SDL_HapticRumbleSupported}, q{SDL_Haptic* haptic}},
		{q{bool}, q{SDL_InitHapticRumble}, q{SDL_Haptic* haptic}},
		{q{bool}, q{SDL_PlayHapticRumble}, q{SDL_Haptic* haptic, float strength, uint length}},
		{q{bool}, q{SDL_StopHapticRumble}, q{SDL_Haptic* haptic}},
	];
	return ret;
}()));
