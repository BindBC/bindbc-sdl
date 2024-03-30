/+
+            Copyright 2024 – 2025 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.gamepad;

import bindbc.sdl.config, bindbc.sdl.codegen;

import sdl.guid: SDL_GUID;
import sdl.iostream: SDL_IOStream;
import sdl.joystick: SDL_Joystick, SDL_JoystickConnectionState, SDL_JoystickID, SDLProp_JoystickCap;
import sdl.power: SDL_PowerState;
import sdl.properties: SDL_PropertiesID;
import sdl.sensor: SDL_SensorType;

struct SDL_Gamepad;

mixin(makeEnumBind(q{SDL_GamepadType}, members: (){
	EnumMember[] ret = [
		{{q{unknown},                      q{SDL_GAMEPAD_TYPE_UNKNOWN}}, q{0}},
		{{q{standard},                     q{SDL_GAMEPAD_TYPE_STANDARD}}},
		{{q{xbox360},                      q{SDL_GAMEPAD_TYPE_XBOX360}}},
		{{q{xboxOne},                      q{SDL_GAMEPAD_TYPE_XBOXONE}}},
		{{q{ps3},                          q{SDL_GAMEPAD_TYPE_PS3}}},
		{{q{ps4},                          q{SDL_GAMEPAD_TYPE_PS4}}},
		{{q{ps5},                          q{SDL_GAMEPAD_TYPE_PS5}}},
		{{q{nintendoSwitchPro},            q{SDL_GAMEPAD_TYPE_NINTENDO_SWITCH_PRO}}},
		{{q{nintendoSwitchJoyconLeft},     q{SDL_GAMEPAD_TYPE_NINTENDO_SWITCH_JOYCON_LEFT}}},
		{{q{nintendoSwitchJoyconRight},    q{SDL_GAMEPAD_TYPE_NINTENDO_SWITCH_JOYCON_RIGHT}}},
		{{q{nintendoSwitchJoyconPair},     q{SDL_GAMEPAD_TYPE_NINTENDO_SWITCH_JOYCON_PAIR}}},
		{{q{count},                        q{SDL_GAMEPAD_TYPE_COUNT}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_GamepadButton}, members: (){
	EnumMember[] ret = [
		{{q{invalid},          q{SDL_GAMEPAD_BUTTON_INVALID}}, q{-1}},
		{{q{south},            q{SDL_GAMEPAD_BUTTON_SOUTH}}},
		{{q{east},             q{SDL_GAMEPAD_BUTTON_EAST}}},
		{{q{west},             q{SDL_GAMEPAD_BUTTON_WEST}}},
		{{q{north},            q{SDL_GAMEPAD_BUTTON_NORTH}}},
		{{q{back},             q{SDL_GAMEPAD_BUTTON_BACK}}},
		{{q{guide},            q{SDL_GAMEPAD_BUTTON_GUIDE}}},
		{{q{start},            q{SDL_GAMEPAD_BUTTON_START}}},
		{{q{leftStick},        q{SDL_GAMEPAD_BUTTON_LEFT_STICK}}},
		{{q{rightStick},       q{SDL_GAMEPAD_BUTTON_RIGHT_STICK}}},
		{{q{leftShoulder},     q{SDL_GAMEPAD_BUTTON_LEFT_SHOULDER}}},
		{{q{rightShoulder},    q{SDL_GAMEPAD_BUTTON_RIGHT_SHOULDER}}},
		{{q{dpadUp},           q{SDL_GAMEPAD_BUTTON_DPAD_UP}}},
		{{q{dpadDown},         q{SDL_GAMEPAD_BUTTON_DPAD_DOWN}}},
		{{q{dpadLeft},         q{SDL_GAMEPAD_BUTTON_DPAD_LEFT}}},
		{{q{dpadRight},        q{SDL_GAMEPAD_BUTTON_DPAD_RIGHT}}},
		{{q{misc1},            q{SDL_GAMEPAD_BUTTON_MISC1}}},
		{{q{rightPaddle1},     q{SDL_GAMEPAD_BUTTON_RIGHT_PADDLE1}}},
		{{q{leftPaddle1},      q{SDL_GAMEPAD_BUTTON_LEFT_PADDLE1}}},
		{{q{rightPaddle2},     q{SDL_GAMEPAD_BUTTON_RIGHT_PADDLE2}}},
		{{q{leftPaddle2},      q{SDL_GAMEPAD_BUTTON_LEFT_PADDLE2}}},
		{{q{touchpad},         q{SDL_GAMEPAD_BUTTON_TOUCHPAD}}},
		{{q{misc2},            q{SDL_GAMEPAD_BUTTON_MISC2}}},
		{{q{misc3},            q{SDL_GAMEPAD_BUTTON_MISC3}}},
		{{q{misc4},            q{SDL_GAMEPAD_BUTTON_MISC4}}},
		{{q{misc5},            q{SDL_GAMEPAD_BUTTON_MISC5}}},
		{{q{misc6},            q{SDL_GAMEPAD_BUTTON_MISC6}}},
		{{q{count},            q{SDL_GAMEPAD_BUTTON_COUNT}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_GamepadButtonLabel}, members: (){
	EnumMember[] ret = [
		{{q{unknown},     q{SDL_GAMEPAD_BUTTON_LABEL_UNKNOWN}}},
		{{q{a},           q{SDL_GAMEPAD_BUTTON_LABEL_A}}},
		{{q{b},           q{SDL_GAMEPAD_BUTTON_LABEL_B}}},
		{{q{x},           q{SDL_GAMEPAD_BUTTON_LABEL_X}}},
		{{q{y},           q{SDL_GAMEPAD_BUTTON_LABEL_Y}}},
		{{q{cross},       q{SDL_GAMEPAD_BUTTON_LABEL_CROSS}}},
		{{q{circle},      q{SDL_GAMEPAD_BUTTON_LABEL_CIRCLE}}},
		{{q{square},      q{SDL_GAMEPAD_BUTTON_LABEL_SQUARE}}},
		{{q{triangle},    q{SDL_GAMEPAD_BUTTON_LABEL_TRIANGLE}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_GamepadAxis}, members: (){
	EnumMember[] ret = [
		{{q{invalid},         q{SDL_GAMEPAD_AXIS_INVALID}}, q{-1}},
		{{q{leftX},           q{SDL_GAMEPAD_AXIS_LEFTX}}},
		{{q{leftY},           q{SDL_GAMEPAD_AXIS_LEFTY}}},
		{{q{rightX},          q{SDL_GAMEPAD_AXIS_RIGHTX}}},
		{{q{rightY},          q{SDL_GAMEPAD_AXIS_RIGHTY}}},
		{{q{leftTrigger},     q{SDL_GAMEPAD_AXIS_LEFT_TRIGGER}}},
		{{q{rightTrigger},    q{SDL_GAMEPAD_AXIS_RIGHT_TRIGGER}}},
		{{q{count},           q{SDL_GAMEPAD_AXIS_COUNT}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_GamepadBindingType}, aliases: [q{SDL_GamepadBindType}], members: (){
	EnumMember[] ret = [
		{{q{none},      q{SDL_GAMEPAD_BINDTYPE_NONE}}, q{0}},
		{{q{button},    q{SDL_GAMEPAD_BINDTYPE_BUTTON}}},
		{{q{axis},      q{SDL_GAMEPAD_BINDTYPE_AXIS}}},
		{{q{hat},       q{SDL_GAMEPAD_BINDTYPE_HAT}}},
	];
	return ret;
}()));

struct SDL_GamepadBinding{
	struct Axis{
		SDL_GamepadAxis axis;
		int axisMin;
		int axisMax;
		
		alias axis_min = axisMin;
		alias axis_max = axisMax;
	}
	struct Hat{
		int hat;
		int hatMask;
		
		alias hat_mask = hatMask;
	}
	SDL_GamepadBindingType inputType;
	union Input{
		int button;
		Axis axis;
		Hat hat;
	}
	Input input;
	SDL_GamepadBindingType outputType;
	union Output{
		SDL_GamepadButton button;
		Axis axis;
	}
	Output output;
	
	alias input_type = inputType;
	alias output_type = outputType;
}

mixin(makeEnumBind(q{SDLProp_GamepadCap}, q{SDLProp_JoystickCap}, members: (){
	EnumMember[] ret = [
		{{q{monoLEDBoolean},          q{SDL_PROP_GAMEPAD_CAP_MONO_LED_BOOLEAN}},          q{SDLProp_JoystickCap.monoLEDBoolean}},
		{{q{rgbLEDBoolean},           q{SDL_PROP_GAMEPAD_CAP_RGB_LED_BOOLEAN}},           q{SDLProp_JoystickCap.rgbLEDBoolean}},
		{{q{playerLEDBoolean},        q{SDL_PROP_GAMEPAD_CAP_PLAYER_LED_BOOLEAN}},        q{SDLProp_JoystickCap.playerLEDBoolean}},
		{{q{rumbleBoolean},           q{SDL_PROP_GAMEPAD_CAP_RUMBLE_BOOLEAN}},            q{SDLProp_JoystickCap.rumbleBoolean}},
		{{q{triggerRumbleBoolean},    q{SDL_PROP_GAMEPAD_CAP_TRIGGER_RUMBLE_BOOLEAN}},    q{SDLProp_JoystickCap.triggerRumbleBoolean}},
	];
	return ret;
}()));

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{int}, q{SDL_AddGamepadMapping}, q{const(char)* mapping}},
		{q{int}, q{SDL_AddGamepadMappingsFromIO}, q{SDL_IOStream* src, bool closeIO}},
		{q{int}, q{SDL_AddGamepadMappingsFromFile}, q{const(char)* file}},
		{q{bool}, q{SDL_ReloadGamepadMappings}, q{}},
		{q{char**}, q{SDL_GetGamepadMappings}, q{int* count}},
		{q{char*}, q{SDL_GetGamepadMappingForGUID}, q{SDL_GUID guid}},
		{q{char*}, q{SDL_GetGamepadMapping}, q{SDL_Gamepad* gamepad}},
		{q{bool}, q{SDL_SetGamepadMapping}, q{SDL_JoystickID instanceID, const(char)* mapping}},
		{q{bool}, q{SDL_HasGamepad}, q{}},
		{q{SDL_JoystickID*}, q{SDL_GetGamepads}, q{int* count}},
		{q{bool}, q{SDL_IsGamepad}, q{SDL_JoystickID instanceID}},
		{q{const(char)*}, q{SDL_GetGamepadNameForID}, q{SDL_JoystickID instanceID}},
		{q{const(char)*}, q{SDL_GetGamepadPathForID}, q{SDL_JoystickID instanceID}},
		{q{int}, q{SDL_GetGamepadPlayerIndexForID}, q{SDL_JoystickID instanceID}},
		{q{SDL_GUID}, q{SDL_GetGamepadGUIDForID}, q{SDL_JoystickID instanceID}},
		{q{ushort}, q{SDL_GetGamepadVendorForID}, q{SDL_JoystickID instanceID}},
		{q{ushort}, q{SDL_GetGamepadProductForID}, q{SDL_JoystickID instanceID}},
		{q{ushort}, q{SDL_GetGamepadProductVersionForID}, q{SDL_JoystickID instanceID}},
		{q{SDL_GamepadType}, q{SDL_GetGamepadTypeForID}, q{SDL_JoystickID instanceID}},
		{q{SDL_GamepadType}, q{SDL_GetRealGamepadTypeForID}, q{SDL_JoystickID instanceID}},
		{q{char*}, q{SDL_GetGamepadMappingForID}, q{SDL_JoystickID instanceID}},
		{q{SDL_Gamepad*}, q{SDL_OpenGamepad}, q{SDL_JoystickID instanceID}},
		{q{SDL_Gamepad*}, q{SDL_GetGamepadFromID}, q{SDL_JoystickID instanceID}},
		{q{SDL_Gamepad*}, q{SDL_GetGamepadFromPlayerIndex}, q{int player_index}},
		{q{SDL_PropertiesID}, q{SDL_GetGamepadProperties}, q{SDL_Gamepad* gamepad}},
		{q{SDL_JoystickID}, q{SDL_GetGamepadID}, q{SDL_Gamepad* gamepad}},
		{q{const(char)*}, q{SDL_GetGamepadName}, q{SDL_Gamepad* gamepad}},
		{q{const(char)*}, q{SDL_GetGamepadPath}, q{SDL_Gamepad* gamepad}},
		{q{SDL_GamepadType}, q{SDL_GetGamepadType}, q{SDL_Gamepad* gamepad}},
		{q{SDL_GamepadType}, q{SDL_GetRealGamepadType}, q{SDL_Gamepad* gamepad}},
		{q{int}, q{SDL_GetGamepadPlayerIndex}, q{SDL_Gamepad* gamepad}},
		{q{bool}, q{SDL_SetGamepadPlayerIndex}, q{SDL_Gamepad* gamepad, int playerIndex}},
		{q{ushort}, q{SDL_GetGamepadVendor}, q{SDL_Gamepad* gamepad}},
		{q{ushort}, q{SDL_GetGamepadProduct}, q{SDL_Gamepad* gamepad}},
		{q{ushort}, q{SDL_GetGamepadProductVersion}, q{SDL_Gamepad* gamepad}},
		{q{ushort}, q{SDL_GetGamepadFirmwareVersion}, q{SDL_Gamepad* gamepad}},
		{q{const(char)*}, q{SDL_GetGamepadSerial}, q{SDL_Gamepad* gamepad}},
		{q{ulong}, q{SDL_GetGamepadSteamHandle}, q{SDL_Gamepad* gamepad}},
		{q{SDL_JoystickConnectionState}, q{SDL_GetGamepadConnectionState}, q{SDL_Gamepad* gamepad}},
		{q{SDL_PowerState}, q{SDL_GetGamepadPowerInfo}, q{SDL_Gamepad* gamepad, int* percent}},
		{q{bool}, q{SDL_GamepadConnected}, q{SDL_Gamepad* gamepad}},
		{q{SDL_Joystick*}, q{SDL_GetGamepadJoystick}, q{SDL_Gamepad* gamepad}},
		{q{void}, q{SDL_SetGamepadEventsEnabled}, q{bool enabled}},
		{q{bool}, q{SDL_GamepadEventsEnabled}, q{}},
		{q{SDL_GamepadBinding**}, q{SDL_GetGamepadBindings}, q{SDL_Gamepad* gamepad, int* count}},
		{q{void}, q{SDL_UpdateGamepads}, q{}},
		{q{SDL_GamepadType}, q{SDL_GetGamepadTypeFromString}, q{const(char)* str}},
		{q{const(char)*}, q{SDL_GetGamepadStringForType}, q{SDL_GamepadType type}},
		{q{SDL_GamepadAxis}, q{SDL_GetGamepadAxisFromString}, q{const(char)* str}},
		{q{const(char)*}, q{SDL_GetGamepadStringForAxis}, q{SDL_GamepadAxis axis}},
		{q{bool}, q{SDL_GamepadHasAxis}, q{SDL_Gamepad* gamepad, SDL_GamepadAxis axis}},
		{q{short}, q{SDL_GetGamepadAxis}, q{SDL_Gamepad* gamepad, SDL_GamepadAxis axis}},
		{q{SDL_GamepadButton}, q{SDL_GetGamepadButtonFromString}, q{const(char)* str}},
		{q{const(char)*}, q{SDL_GetGamepadStringForButton}, q{SDL_GamepadButton button}},
		{q{bool}, q{SDL_GamepadHasButton}, q{SDL_Gamepad* gamepad, SDL_GamepadButton button}},
		{q{bool}, q{SDL_GetGamepadButton}, q{SDL_Gamepad* gamepad, SDL_GamepadButton button}},
		{q{SDL_GamepadButtonLabel}, q{SDL_GetGamepadButtonLabelForType}, q{SDL_GamepadType type, SDL_GamepadButton button}},
		{q{SDL_GamepadButtonLabel}, q{SDL_GetGamepadButtonLabel}, q{SDL_Gamepad* gamepad, SDL_GamepadButton button}},
		{q{int}, q{SDL_GetNumGamepadTouchpads}, q{SDL_Gamepad* gamepad}},
		{q{int}, q{SDL_GetNumGamepadTouchpadFingers}, q{SDL_Gamepad* gamepad, int touchpad}},
		{q{bool}, q{SDL_GetGamepadTouchpadFinger}, q{SDL_Gamepad* gamepad, int touchpad, int finger, bool* down, float* x, float* y, float* pressure}},
		{q{bool}, q{SDL_GamepadHasSensor}, q{SDL_Gamepad* gamepad, SDL_SensorType type}},
		{q{bool}, q{SDL_SetGamepadSensorEnabled}, q{SDL_Gamepad* gamepad, SDL_SensorType type, bool enabled}},
		{q{bool}, q{SDL_GamepadSensorEnabled}, q{SDL_Gamepad* gamepad, SDL_SensorType type}},
		{q{float}, q{SDL_GetGamepadSensorDataRate}, q{SDL_Gamepad* gamepad, SDL_SensorType type}},
		{q{bool}, q{SDL_GetGamepadSensorData}, q{SDL_Gamepad* gamepad, SDL_SensorType type, float* data, int numValues}},
		{q{bool}, q{SDL_RumbleGamepad}, q{SDL_Gamepad* gamepad, ushort lowFrequencyRumble, ushort highFrequencyRumble, uint durationMS}},
		{q{bool}, q{SDL_RumbleGamepadTriggers}, q{SDL_Gamepad* gamepad, ushort leftRumble, ushort rightRumble, uint durationMS}},
		{q{bool}, q{SDL_SetGamepadLED}, q{SDL_Gamepad* gamepad, ubyte red, ubyte green, ubyte blue}},
		{q{bool}, q{SDL_SendGamepadEffect}, q{SDL_Gamepad* gamepad, const(void)* data, int size}},
		{q{void}, q{SDL_CloseGamepad}, q{SDL_Gamepad* gamepad}},
		{q{const(char)*}, q{SDL_GetGamepadAppleSFSymbolsNameForButton}, q{SDL_Gamepad* gamepad, SDL_GamepadButton button}},
		{q{const(char)*}, q{SDL_GetGamepadAppleSFSymbolsNameForAxis}, q{SDL_Gamepad* gamepad, SDL_GamepadAxis axis}},
	];
	return ret;
}()));
