/+
+            Copyright 2024 – 2025 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.joystick;

import bindbc.sdl.config, bindbc.sdl.codegen;

import sdl.guid: SDL_GUID;
import sdl.power: SDL_PowerState;
import sdl.properties: SDL_PropertiesID;
import sdl.sensor: SDL_SensorType;

struct SDL_Joystick;

alias SDL_JoystickID = uint;

mixin(makeEnumBind(q{SDL_JoystickType}, members: (){
	EnumMember[] ret = [
		{{q{unknown},        q{SDL_JOYSTICK_TYPE_UNKNOWN}}},
		{{q{gamepad},        q{SDL_JOYSTICK_TYPE_GAMEPAD}}},
		{{q{wheel},          q{SDL_JOYSTICK_TYPE_WHEEL}}},
		{{q{arcadeStick},    q{SDL_JOYSTICK_TYPE_ARCADE_STICK}}},
		{{q{flightStick},    q{SDL_JOYSTICK_TYPE_FLIGHT_STICK}}},
		{{q{dancePad},       q{SDL_JOYSTICK_TYPE_DANCE_PAD}}},
		{{q{guitar},         q{SDL_JOYSTICK_TYPE_GUITAR}}},
		{{q{drumKit},        q{SDL_JOYSTICK_TYPE_DRUM_KIT}}},
		{{q{arcadePad},      q{SDL_JOYSTICK_TYPE_ARCADE_PAD}}},
		{{q{throttle},       q{SDL_JOYSTICK_TYPE_THROTTLE}}},
		{{q{count},          q{SDL_JOYSTICK_TYPE_COUNT}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_JoystickConnectionState}, aliases: [q{SDL_JoystickConnection}], members: (){
	EnumMember[] ret = [
		{{q{invalid},   q{SDL_JOYSTICK_CONNECTION_INVALID}}, q{-1}},
		{{q{unknown},   q{SDL_JOYSTICK_CONNECTION_UNKNOWN}}},
		{{q{wired},     q{SDL_JOYSTICK_CONNECTION_WIRED}}},
		{{q{wireless},  q{SDL_JOYSTICK_CONNECTION_WIRELESS}}},
	];
	return ret;
}()));

enum{
	SDL_JOYSTICK_AXIS_MAX  =  32767,
	SDL_JOYSTICK_AXIS_MIN  = -32768,
}
static if(dStyleEnums){
	alias axisMax = SDL_JOYSTICK_AXIS_MAX;
	alias axisMin = SDL_JOYSTICK_AXIS_MIN;
}

struct SDL_VirtualJoystickTouchpadDesc{
	ushort nFingers;
	ushort[3] padding;
	
	alias nfingers = nFingers;
}

struct SDL_VirtualJoystickSensorDesc{
	SDL_SensorType type;
	float rate;
}

struct SDL_VirtualJoystickDesc{
	uint version_;
	ushort type;
	ushort padding;
	ushort vendorID;
	ushort productID;
	ushort nAxes;
	ushort nButtons;
	ushort nBalls;
	ushort nHats;
	ushort nTouchpads;
	ushort nSensors;
	ushort[2] padding2;
	uint buttonMask;
	uint axisMask;
	const(char)* name;
	const(SDL_VirtualJoystickTouchpadDesc)* touchpads;
	const(SDL_VirtualJoystickSensorDesc)* sensors;
	void* userData;
	private extern(C) nothrow{
		alias UpdateFn = void function(void* userData);
		alias SetPlayerIndexFn = void function(void* userData, int playerIndex);
		alias RumbleFn = bool function(void* userData, ushort lowFrequencyRumble, ushort highFrequencyRumble);
		alias RumbleTriggersFn = bool function(void* userData, ushort leftRumble, ushort rightRumble);
		alias SetLEDFn = bool function(void* userData, ubyte red, ubyte green, ubyte blue);
		alias SendEffectFn = bool function(void* userData, const(void)* data, int size);
		alias SetSensorsEnabledFn = bool function(void* userData, bool enabled);
		alias CleanUpFn = void function(void* userData);
	}
	UpdateFn update;
	SetPlayerIndexFn setPlayerIndex;
	RumbleFn rumble;
	RumbleTriggersFn rumbleTriggers;
	SetLEDFn setLED;
	SendEffectFn sendEffect;
	SetSensorsEnabledFn setSensorsEnabled;
	CleanUpFn cleanUp;
	
	alias vendor_id = vendorID;
	alias product_id = productID;
	alias naxes = nAxes;
	alias nbuttons = nButtons;
	alias nballs = nBalls;
	alias nhats = nHats;
	alias ntouchpads = nTouchpads;
	alias nsensors = nSensors;
	alias button_mask = buttonMask;
	alias axis_mask = axisMask;
	alias userdata = userData;
	alias Update = update;
	alias SetPlayerIndex = setPlayerIndex;
	alias Rumble = rumble;
	alias RumbleTriggers = rumbleTriggers;
	alias SetLED = setLED;
	alias SendEffect = sendEffect;
	alias SetSensorsEnabled = setSensorsEnabled;
	alias Cleanup = cleanUp;
}

static assert(
	((void*).sizeof == 4 && SDL_VirtualJoystickDesc.sizeof ==  84) ||
	((void*).sizeof == 8 && SDL_VirtualJoystickDesc.sizeof == 136)
);

mixin(makeEnumBind(q{SDLProp_JoystickCap}, q{const(char)*}, members: (){
	EnumMember[] ret = [
		{{q{monoLEDBoolean},          q{SDL_PROP_JOYSTICK_CAP_MONO_LED_BOOLEAN}},          q{"SDL.joystick.cap.mono_led"}},
		{{q{rgbLEDBoolean},           q{SDL_PROP_JOYSTICK_CAP_RGB_LED_BOOLEAN}},           q{"SDL.joystick.cap.rgb_led"}},
		{{q{playerLEDBoolean},        q{SDL_PROP_JOYSTICK_CAP_PLAYER_LED_BOOLEAN}},        q{"SDL.joystick.cap.player_led"}},
		{{q{rumbleBoolean},           q{SDL_PROP_JOYSTICK_CAP_RUMBLE_BOOLEAN}},            q{"SDL.joystick.cap.rumble"}},
		{{q{triggerRumbleBoolean},    q{SDL_PROP_JOYSTICK_CAP_TRIGGER_RUMBLE_BOOLEAN}},    q{"SDL.joystick.cap.trigger_rumble"}},
	];
	return ret;
}()));

alias SDL_Hat_ = ubyte;
mixin(makeEnumBind(q{SDL_Hat}, q{SDL_Hat_}, members: (){
	EnumMember[] ret = [
		{{q{centred},      q{SDL_HAT_CENTRED}},      q{0x00U}, aliases: [{q{centered}, q{SDL_HAT_CENTERED}}]},
		{{q{up},           q{SDL_HAT_UP}},           q{0x01U}},
		{{q{right},        q{SDL_HAT_RIGHT}},        q{0x02U}},
		{{q{down},         q{SDL_HAT_DOWN}},         q{0x04U}},
		{{q{left},         q{SDL_HAT_LEFT}},         q{0x08U}},
		{{q{rightUp},      q{SDL_HAT_RIGHTUP}},      q{SDL_Hat.right | SDL_Hat.up}},
		{{q{rightDown},    q{SDL_HAT_RIGHTDOWN}},    q{SDL_Hat.right | SDL_Hat.down}},
		{{q{leftUp},       q{SDL_HAT_LEFTUP}},       q{SDL_Hat.left  | SDL_Hat.up}},
		{{q{leftDown},     q{SDL_HAT_LEFTDOWN}},     q{SDL_Hat.left  | SDL_Hat.down}},
	];
	return ret;
}()));

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{void}, q{SDL_LockJoysticks}, q{}},
		{q{void}, q{SDL_UnlockJoysticks}, q{}},
		{q{bool}, q{SDL_HasJoystick}, q{}},
		{q{SDL_JoystickID*}, q{SDL_GetJoysticks}, q{int* count}},
		{q{const(char)*}, q{SDL_GetJoystickNameForID}, q{SDL_JoystickID instanceID}},
		{q{const(char)*}, q{SDL_GetJoystickPathForID}, q{SDL_JoystickID instanceID}},
		{q{int}, q{SDL_GetJoystickPlayerIndexForID}, q{SDL_JoystickID instanceID}},
		{q{SDL_GUID}, q{SDL_GetJoystickGUIDForID}, q{SDL_JoystickID instanceID}},
		{q{ushort}, q{SDL_GetJoystickVendorForID}, q{SDL_JoystickID instanceID}},
		{q{ushort}, q{SDL_GetJoystickProductForID}, q{SDL_JoystickID instanceID}},
		{q{ushort}, q{SDL_GetJoystickProductVersionForID}, q{SDL_JoystickID instanceID}},
		{q{SDL_JoystickType}, q{SDL_GetJoystickTypeForID}, q{SDL_JoystickID instanceID}},
		{q{SDL_Joystick*}, q{SDL_OpenJoystick}, q{SDL_JoystickID instanceID}},
		{q{SDL_Joystick*}, q{SDL_GetJoystickFromID}, q{SDL_JoystickID instanceID}},
		{q{SDL_Joystick*}, q{SDL_GetJoystickFromPlayerIndex}, q{int playerIndex}},
		{q{SDL_JoystickID}, q{SDL_AttachVirtualJoystick}, q{const(SDL_VirtualJoystickDesc)* desc}},
		{q{bool}, q{SDL_DetachVirtualJoystick}, q{SDL_JoystickID instanceID}},
		{q{bool}, q{SDL_IsJoystickVirtual}, q{SDL_JoystickID instanceID}},
		{q{bool}, q{SDL_SetJoystickVirtualAxis}, q{SDL_Joystick* joystick, int axis, short value}},
		{q{bool}, q{SDL_SetJoystickVirtualBall}, q{SDL_Joystick* joystick, int ball, short xRel, short yRel}},
		{q{bool}, q{SDL_SetJoystickVirtualButton}, q{SDL_Joystick* joystick, int button, bool down}},
		{q{bool}, q{SDL_SetJoystickVirtualHat}, q{SDL_Joystick* joystick, int hat, SDL_Hat_ value}},
		{q{bool}, q{SDL_SetJoystickVirtualTouchpad}, q{SDL_Joystick* joystick, int touchpad, int finger, bool down, float x, float y, float pressure}},
		{q{bool}, q{SDL_SendJoystickVirtualSensorData}, q{SDL_Joystick* joystick, SDL_SensorType type, ulong sensorTimestamp, const(float)* data, int numValues}},
		{q{SDL_PropertiesID}, q{SDL_GetJoystickProperties}, q{SDL_Joystick* joystick}},
		{q{const(char)*}, q{SDL_GetJoystickName}, q{SDL_Joystick* joystick}},
		{q{const(char)*}, q{SDL_GetJoystickPath}, q{SDL_Joystick* joystick}},
		{q{int}, q{SDL_GetJoystickPlayerIndex}, q{SDL_Joystick* joystick}},
		{q{bool}, q{SDL_SetJoystickPlayerIndex}, q{SDL_Joystick* joystick, int playerIndex}},
		{q{SDL_GUID}, q{SDL_GetJoystickGUID}, q{SDL_Joystick* joystick}},
		{q{ushort}, q{SDL_GetJoystickVendor}, q{SDL_Joystick* joystick}},
		{q{ushort}, q{SDL_GetJoystickProduct}, q{SDL_Joystick* joystick}},
		{q{ushort}, q{SDL_GetJoystickProductVersion}, q{SDL_Joystick* joystick}},
		{q{ushort}, q{SDL_GetJoystickFirmwareVersion}, q{SDL_Joystick* joystick}},
		{q{const(char)*}, q{SDL_GetJoystickSerial}, q{SDL_Joystick* joystick}},
		{q{SDL_JoystickType}, q{SDL_GetJoystickType}, q{SDL_Joystick* joystick}},
		{q{void}, q{SDL_GetJoystickGUIDInfo}, q{SDL_GUID guid, ushort* vendor, ushort* product, ushort* version_, ushort* crc16}},
		{q{bool}, q{SDL_JoystickConnected}, q{SDL_Joystick* joystick}},
		{q{SDL_JoystickID}, q{SDL_GetJoystickID}, q{SDL_Joystick* joystick}},
		{q{int}, q{SDL_GetNumJoystickAxes}, q{SDL_Joystick* joystick}},
		{q{int}, q{SDL_GetNumJoystickBalls}, q{SDL_Joystick* joystick}},
		{q{int}, q{SDL_GetNumJoystickHats}, q{SDL_Joystick* joystick}},
		{q{int}, q{SDL_GetNumJoystickButtons}, q{SDL_Joystick* joystick}},
		{q{void}, q{SDL_SetJoystickEventsEnabled}, q{bool enabled}},
		{q{bool}, q{SDL_JoystickEventsEnabled}, q{}},
		{q{void}, q{SDL_UpdateJoysticks}, q{}},
		{q{short}, q{SDL_GetJoystickAxis}, q{SDL_Joystick* joystick, int axis}},
		{q{bool}, q{SDL_GetJoystickAxisInitialState}, q{SDL_Joystick* joystick, int axis, short* state}},
		{q{bool}, q{SDL_GetJoystickBall}, q{SDL_Joystick* joystick, int ball, int* dx, int* dy}},
		{q{SDL_Hat}, q{SDL_GetJoystickHat}, q{SDL_Joystick* joystick, int hat}},
		{q{bool}, q{SDL_GetJoystickButton}, q{SDL_Joystick* joystick, int button}},
		{q{bool}, q{SDL_RumbleJoystick}, q{SDL_Joystick* joystick, ushort lowFrequencyRumble, ushort highFrequencyRumble, uint durationMS}},
		{q{bool}, q{SDL_RumbleJoystickTriggers}, q{SDL_Joystick* joystick, ushort leftRumble, ushort rightRumble, uint durationMS}},
		{q{bool}, q{SDL_SetJoystickLED}, q{SDL_Joystick* joystick, ubyte red, ubyte green, ubyte blue}},
		{q{bool}, q{SDL_SendJoystickEffect}, q{SDL_Joystick* joystick, const(void)* data, int size}},
		{q{void}, q{SDL_CloseJoystick}, q{SDL_Joystick* joystick}},
		{q{SDL_JoystickConnectionState}, q{SDL_GetJoystickConnectionState}, q{SDL_Joystick* joystick}},
		{q{SDL_PowerState}, q{SDL_GetJoystickPowerInfo}, q{SDL_Joystick* joystick, int* percent}},
	];
	return ret;
}()));
