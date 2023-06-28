/+
+            Copyright 2022 – 2023 Aya Partridge
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
	pragma(inline, true) int SDL_GameControllerAddMappingsFromFile(const(char)* file) @nogc nothrow{
		return SDL_GameControllerAddMappingsFromRW(SDL_RWFromFile(file, "rb"), 1);
	}
}

mixin(joinFnBinds((){
	string[][] ret;
	ret ~= makeFnBinds([
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
	]);
	static if(sdlSupport >= SDLSupport.v2_0_2){
		ret ~= makeFnBinds([
			[q{int}, q{SDL_GameControllerAddMappingsFromRW}, q{SDL_RWops* rw, int freerw}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_4){
		ret ~= makeFnBinds([
			[q{SDL_GameController*}, q{SDL_GameControllerFromInstanceID}, q{SDL_JoystickID joyid}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_6){
		ret ~= makeFnBinds([
			[q{ushort}, q{SDL_GameControllerGetProduct}, q{SDL_GameController* gamecontroller}],
			[q{ushort}, q{SDL_GameControllerGetProductVersion}, q{SDL_GameController* gamecontroller}],
			[q{ushort}, q{SDL_GameControllerGetVendor}, q{SDL_GameController* gamecontroller}],
			[q{char*}, q{SDL_GameControllerMappingForIndex}, q{int mapping_index}],
			[q{int}, q{SDL_GameControllerNumMappings}, q{}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_9){
		ret ~= makeFnBinds([
			[q{char*}, q{SDL_GameControllerMappingForDeviceIndex}, q{int joystick_index}],
			[q{int}, q{SDL_GameControllerRumble}, q{SDL_GameController* gamecontroller, ushort low_frequency_rumble, ushort high_frequency_rumble, uint duration_ms}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_10){
		ret ~= makeFnBinds([
			[q{int}, q{SDL_GameControllerGetPlayerIndex}, q{SDL_GameController* gamecontroller}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_12){
		ret ~= makeFnBinds([
			[q{SDL_GameControllerType}, q{SDL_GameControllerTypeForIndex}, q{int joystick_index}],
			[q{SDL_GameController*}, q{SDL_GameControllerFromPlayerIndex}, q{int player_index}],
			[q{SDL_GameControllerType}, q{SDL_GameControllerGetType}, q{SDL_GameController* gamecontroller}],
			[q{void}, q{SDL_GameControllerSetPlayerIndex}, q{SDL_GameController* gamecontroller, int player_index}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_14){
		ret ~= makeFnBinds([
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
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_16){
		ret ~= makeFnBinds([
			[q{int}, q{SDL_GameControllerSendEffect}, q{SDL_GameController* gamecontroller, const(void)* data, int size}],
			[q{float}, q{SDL_GameControllerGetSensorDataRate}, q{SDL_GameController* gamecontroller, SDL_SensorType type}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_18){
		ret ~= makeFnBinds([
			[q{SDL_bool}, q{SDL_GameControllerHasRumble}, q{SDL_GameController* gamecontroller}],
			[q{SDL_bool}, q{SDL_GameControllerHasRumbleTriggers}, q{SDL_GameController* gamecontroller}],
			[q{const(char)*}, q{SDL_GameControllerGetAppleSFSymbolsNameForButton}, q{SDL_GameController* gamecontroller, SDL_GameControllerButton button}],
			[q{const(char)*}, q{SDL_GameControllerGetAppleSFSymbolsNameForAxis}, q{SDL_GameController* gamecontroller, SDL_GameControllerAxis axis}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_24){
		ret ~= makeFnBinds([
			[q{const(char)*}, q{SDL_GameControllerPathForIndex}, q{int joystick_index}],
			[q{const(char)*}, q{SDL_GameControllerPath}, q{SDL_GameController* gamecontroller}],
			[q{ushort}, q{SDL_GameControllerGetFirmwareVersion}, q{SDL_GameController* gamecontroller}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_26){
		ret ~= makeFnBinds([
			[q{int}, q{SDL_GameControllerGetSensorDataWithTimestamp}, q{SDL_GameController* gamecontroller, SDL_SensorType type, ulong* timestamp, float* data, int num_values}],
		]);
	}
	return ret;
}()));
