/+
+            Copyright 2022 – 2024 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.gamecontroller;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

import sdl.joystick;
import sdl.rwops;
import sdl.sensor;
import sdl.stdinc: SDL_bool;

struct SDL_GameController;

static if(sdlSupport >= SDLSupport.v2_0_12){
	alias SDL_GameControllerType = uint;
	enum: SDL_GameControllerType{
		SDL_CONTROLLER_TYPE_UNKNOWN                         = 0,
		SDL_CONTROLLER_TYPE_XBOX360                         = 1,
		SDL_CONTROLLER_TYPE_XBOXONE                         = 2,
		SDL_CONTROLLER_TYPE_PS3                             = 3,
		SDL_CONTROLLER_TYPE_PS4                             = 4,
		SDL_CONTROLLER_TYPE_NINTENDO_SWITCH_PRO             = 5,
	}
	static if(sdlSupport >= SDLSupport.v2_0_14):
	enum: SDL_GameControllerType{
		SDL_CONTROLLER_TYPE_VIRTUAL                         = 6,
		SDL_CONTROLLER_TYPE_PS5                             = 7,
	}
	static if(sdlSupport >= SDLSupport.v2_0_16):
	enum: SDL_GameControllerType{
		SDL_CONTROLLER_TYPE_AMAZON_LUNA                     = 8,
		SDL_CONTROLLER_TYPE_GOOGLE_STADIA                   = 9,
	}
	static if(sdlSupport >= SDLSupport.v2_24):
	enum: SDL_GameControllerType{
		SDL_CONTROLLER_TYPE_NVIDIA_SHIELD                   = 10,
		SDL_CONTROLLER_TYPE_NINTENDO_SWITCH_JOYCON_LEFT     = 11,
		SDL_CONTROLLER_TYPE_NINTENDO_SWITCH_JOYCON_RIGHT    = 12,
		SDL_CONTROLLER_TYPE_NINTENDO_SWITCH_JOYCON_PAIR     = 13,
	}
	static if(sdlSupport >= SDLSupport.v2_30):
	enum: SDL_GameControllerType{
		SDL_CONTROLLER_TYPE_MAX                             = 14,
	}
}

alias SDL_GameControllerBindType = uint;
enum: SDL_GameControllerBindType{
	SDL_CONTROLLER_BINDTYPE_NONE    = 0,
	SDL_CONTROLLER_BINDTYPE_BUTTON  = 1,
	SDL_CONTROLLER_BINDTYPE_AXIS    = 2,
	SDL_CONTROLLER_BINDTYPE_HAT     = 3,
}

struct SDL_GameControllerButtonBind{
	SDL_GameControllerBindType bindType;
	union Value_{
		int button;
		int axis;
		struct Hat_{
			int hat;
			int hat_mask;
		}
		Hat_ hat;
	}
	Value_ value;
}

alias SDL_GameControllerAxis = int;
enum: SDL_GameControllerAxis{
	SDL_CONTROLLER_AXIS_INVALID = -1,
	SDL_CONTROLLER_AXIS_LEFTX,
	SDL_CONTROLLER_AXIS_LEFTY,
	SDL_CONTROLLER_AXIS_RIGHTX,
	SDL_CONTROLLER_AXIS_RIGHTY,
	SDL_CONTROLLER_AXIS_TRIGGERLEFT,
	SDL_CONTROLLER_AXIS_TRIGGERRIGHT,
	SDL_CONTROLLER_AXIS_MAX,
}

alias SDL_GameControllerButton = int;
enum: SDL_GameControllerButton{
	SDL_CONTROLLER_BUTTON_INVALID        = -1,
	SDL_CONTROLLER_BUTTON_A              = 0,
	SDL_CONTROLLER_BUTTON_B              = 1,
	SDL_CONTROLLER_BUTTON_X              = 2,
	SDL_CONTROLLER_BUTTON_Y              = 3,
	SDL_CONTROLLER_BUTTON_BACK           = 4,
	SDL_CONTROLLER_BUTTON_GUIDE          = 5,
	SDL_CONTROLLER_BUTTON_START          = 6,
	SDL_CONTROLLER_BUTTON_LEFTSTICK      = 7,
	SDL_CONTROLLER_BUTTON_RIGHTSTICK     = 8,
	SDL_CONTROLLER_BUTTON_LEFTSHOULDER   = 9,
	SDL_CONTROLLER_BUTTON_RIGHTSHOULDER  = 10,
	SDL_CONTROLLER_BUTTON_DPAD_UP        = 11,
	SDL_CONTROLLER_BUTTON_DPAD_DOWN      = 12,
	SDL_CONTROLLER_BUTTON_DPAD_LEFT      = 13,
	SDL_CONTROLLER_BUTTON_DPAD_RIGHT     = 14,
}
static if(sdlSupport >= SDLSupport.v2_0_14)
enum: SDL_GameControllerButton{
	SDL_CONTROLLER_BUTTON_MISC1          = 15,
	SDL_CONTROLLER_BUTTON_PADDLE1        = 16,
	SDL_CONTROLLER_BUTTON_PADDLE2        = 17,
	SDL_CONTROLLER_BUTTON_PADDLE3        = 18,
	SDL_CONTROLLER_BUTTON_PADDLE4        = 19,
	SDL_CONTROLLER_BUTTON_TOUCHPAD       = 20,
	SDL_CONTROLLER_BUTTON_MAX            = 21,
}
else
enum: SDL_GameControllerButton{
	SDL_CONTROLLER_BUTTON_MAX            = 15,
}

static if(sdlSupport >= SDLSupport.v2_0_2){
	pragma(inline, true) int SDL_GameControllerAddMappingsFromFile(const(char)* file) nothrow @nogc{
		return SDL_GameControllerAddMappingsFromRW(SDL_RWFromFile(file, "rb"), 1);
	}
}

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{int}, q{SDL_GameControllerAddMapping}, q{const(char)* mappingString}},
		{q{char*}, q{SDL_GameControllerMappingForGUID}, q{SDL_JoystickGUID guid}},
		{q{char*}, q{SDL_GameControllerMapping}, q{SDL_GameController* gameController}},
		{q{SDL_bool}, q{SDL_IsGameController}, q{int joystickIndex}},
		{q{const(char)*}, q{SDL_GameControllerNameForIndex}, q{int joystickIndex}},
		{q{SDL_GameController*}, q{SDL_GameControllerOpen}, q{int joystickIndex}},
		{q{const(char)*}, q{SDL_GameControllerName}, q{SDL_GameController* gameController}},
		{q{SDL_bool}, q{SDL_GameControllerGetAttached}, q{SDL_GameController* gameController}},
		{q{SDL_Joystick*}, q{SDL_GameControllerGetJoystick}, q{SDL_GameController* gameController}},
		{q{int}, q{SDL_GameControllerEventState}, q{int state}},
		{q{void}, q{SDL_GameControllerUpdate}, q{}},
		{q{SDL_GameControllerAxis}, q{SDL_GameControllerGetAxisFromString}, q{const(char)* pchString}},
		{q{const(char)*}, q{SDL_GameControllerGetStringForAxis}, q{SDL_GameControllerAxis axis}},
		{q{SDL_GameControllerButtonBind}, q{SDL_GameControllerGetBindForAxis}, q{SDL_GameController* gameController, SDL_GameControllerAxis axis}},
		{q{short}, q{SDL_GameControllerGetAxis}, q{SDL_GameController* gameController, SDL_GameControllerAxis axis}},
		{q{SDL_GameControllerButton}, q{SDL_GameControllerGetButtonFromString}, q{const(char*) pchString}},
		{q{const(char)*}, q{SDL_GameControllerGetStringForButton}, q{SDL_GameControllerButton button}},
		{q{SDL_GameControllerButtonBind}, q{SDL_GameControllerGetBindForButton}, q{SDL_GameController* gameController, SDL_GameControllerButton button}},
		{q{ubyte}, q{SDL_GameControllerGetButton}, q{SDL_GameController* gameController, SDL_GameControllerButton button}},
		{q{void}, q{SDL_GameControllerClose}, q{SDL_GameController* gameController}},
	];
	if(sdlSupport >= SDLSupport.v2_0_2){
		FnBind[] add = [
			{q{int}, q{SDL_GameControllerAddMappingsFromRW}, q{SDL_RWops* rw, int freeRW}},
		];
		ret ~= add;
	}
	if(sdlSupport >= SDLSupport.v2_0_4){
		FnBind[] add = [
			{q{SDL_GameController*}, q{SDL_GameControllerFromInstanceID}, q{SDL_JoystickID joyID}},
		];
		ret ~= add;
	}
	if(sdlSupport >= SDLSupport.v2_0_6){
		FnBind[] add = [
			{q{ushort}, q{SDL_GameControllerGetProduct}, q{SDL_GameController* gameController}},
			{q{ushort}, q{SDL_GameControllerGetProductVersion}, q{SDL_GameController* gameController}},
			{q{ushort}, q{SDL_GameControllerGetVendor}, q{SDL_GameController* gameController}},
			{q{char*}, q{SDL_GameControllerMappingForIndex}, q{int mappingIndex}},
			{q{int}, q{SDL_GameControllerNumMappings}, q{}},
		];
		ret ~= add;
	}
	if(sdlSupport >= SDLSupport.v2_0_9){
		FnBind[] add = [
			{q{char*}, q{SDL_GameControllerMappingForDeviceIndex}, q{int joystickIndex}},
			{q{int}, q{SDL_GameControllerRumble}, q{SDL_GameController* gameController, ushort lowFrequencyRumble, ushort highFrequencyRumble, uint durationMS}},
		];
		ret ~= add;
	}
	if(sdlSupport >= SDLSupport.v2_0_10){
		FnBind[] add = [
			{q{int}, q{SDL_GameControllerGetPlayerIndex}, q{SDL_GameController* gameController}},
		];
		ret ~= add;
	}
	if(sdlSupport >= SDLSupport.v2_0_12){
		FnBind[] add = [
			{q{SDL_GameControllerType}, q{SDL_GameControllerTypeForIndex}, q{int joystickIndex}},
			{q{SDL_GameController*}, q{SDL_GameControllerFromPlayerIndex}, q{int playerIndex}},
			{q{SDL_GameControllerType}, q{SDL_GameControllerGetType}, q{SDL_GameController* gameController}},
			{q{void}, q{SDL_GameControllerSetPlayerIndex}, q{SDL_GameController* gameController, int playerIndex}},
		];
		ret ~= add;
	}
	if(sdlSupport >= SDLSupport.v2_0_14){
		FnBind[] add = [
			{q{SDL_bool}, q{SDL_GameControllerHasAxis}, q{SDL_GameController* gameController, SDL_GameControllerAxis axis}},
			{q{SDL_bool}, q{SDL_GameControllerHasButton}, q{SDL_GameController* gameController, SDL_GameControllerButton button}},
			{q{int}, q{SDL_GameControllerGetNumTouchpads}, q{SDL_GameController* gameController}},
			{q{int}, q{SDL_GameControllerGetNumTouchpadFingers}, q{SDL_GameController* gameController, int touchpad}},
			{q{int}, q{SDL_GameControllerGetTouchpadFinger}, q{SDL_GameController* gameController, int touchpad, int finger, ubyte* state, float* x, float* y, float* pressure}},
			{q{SDL_bool}, q{SDL_GameControllerHasSensor}, q{SDL_GameController* gameController, SDL_SensorType type}},
			{q{int}, q{SDL_GameControllerSetSensorEnabled}, q{SDL_GameController* gameController, SDL_SensorType type, SDL_bool enabled}},
			{q{SDL_bool}, q{SDL_GameControllerIsSensorEnabled}, q{SDL_GameController* gameController, SDL_SensorType type}},
			{q{int}, q{SDL_GameControllerGetSensorData}, q{SDL_GameController* gameController, SDL_SensorType type, float* data, int numValues}},
			{q{int}, q{SDL_GameControllerRumbleTriggers}, q{SDL_GameController* gameController, ushort leftRumble, ushort rightRumble, uint durationMS}},
			{q{SDL_bool}, q{SDL_GameControllerHasLED}, q{SDL_GameController* gameController}},
			{q{int}, q{SDL_GameControllerSetLED}, q{SDL_GameController* gameController, ubyte red, ubyte green, ubyte blue}},
		];
		ret ~= add;
	}
	if(sdlSupport >= SDLSupport.v2_0_16){
		FnBind[] add = [
			{q{int}, q{SDL_GameControllerSendEffect}, q{SDL_GameController* gameController, const(void)* data, int size}},
			{q{float}, q{SDL_GameControllerGetSensorDataRate}, q{SDL_GameController* gameController, SDL_SensorType type}},
		];
		ret ~= add;
	}
	if(sdlSupport >= SDLSupport.v2_0_18){
		FnBind[] add = [
			{q{SDL_bool}, q{SDL_GameControllerHasRumble}, q{SDL_GameController* gameController}},
			{q{SDL_bool}, q{SDL_GameControllerHasRumbleTriggers}, q{SDL_GameController* gameController}},
			{q{const(char)*}, q{SDL_GameControllerGetAppleSFSymbolsNameForButton}, q{SDL_GameController* gameController, SDL_GameControllerButton button}},
			{q{const(char)*}, q{SDL_GameControllerGetAppleSFSymbolsNameForAxis}, q{SDL_GameController* gameController, SDL_GameControllerAxis axis}},
		];
		ret ~= add;
	}
	if(sdlSupport >= SDLSupport.v2_24){
		FnBind[] add = [
			{q{const(char)*}, q{SDL_GameControllerPathForIndex}, q{int joystickIndex}},
			{q{const(char)*}, q{SDL_GameControllerPath}, q{SDL_GameController* gameController}},
			{q{ushort}, q{SDL_GameControllerGetFirmwareVersion}, q{SDL_GameController* gameController}},
		];
		ret ~= add;
	}
	if(sdlSupport >= SDLSupport.v2_26){
		FnBind[] add = [
			{q{int}, q{SDL_GameControllerGetSensorDataWithTimestamp}, q{SDL_GameController* gameController, SDL_SensorType type, ulong* timestamp, float* data, int numValues}},
		];
		ret ~= add;
	}
	if(sdlSupport >= SDLSupport.v2_30){
		FnBind[] add = [
			{q{ulong}, q{SDL_GameControllerGetSteamHandle}, q{SDL_GameController* gameController}},
		];
		ret ~= add;
	}
	return ret;
}()));
