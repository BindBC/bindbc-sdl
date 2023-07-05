/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.joystick;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

import sdl.stdinc: SDL_bool;
import sdl.guid: SDL_GUID;

version(SDL_ThreadSafetyAnalysis){
	import sdl.mutex: SDL_mutex;
	extern extern(C) SDL_mutex* SDL_joystick_lock;
}

struct SDL_Joystick;

alias SDL_JoystickGUID = SDL_GUID;

alias SDL_JoystickID = int;

enum: ubyte{
	SDL_HAT_CENTERED   = 0x00,
	SDL_HAT_UP         = 0x01,
	SDL_HAT_RIGHT      = 0x02,
	SDL_HAT_DOWN       = 0x04,
	SDL_HAT_LEFT       = 0x08,
	SDL_HAT_RIGHTUP    = (SDL_HAT_RIGHT | SDL_HAT_UP),
	SDL_HAT_RIGHTDOWN  = (SDL_HAT_RIGHT | SDL_HAT_DOWN),
	SDL_HAT_LEFTUP     = (SDL_HAT_LEFT  | SDL_HAT_UP),
	SDL_HAT_LEFTDOWN   = (SDL_HAT_LEFT  | SDL_HAT_DOWN),
}

static if(sdlSupport >= SDLSupport.v2_0_4){
	alias SDL_JoystickPowerLevel = int;
	enum: SDL_JoystickPowerLevel{
		SDL_JOYSTICK_POWER_UNKNOWN = -1,
		SDL_JOYSTICK_POWER_EMPTY,
		SDL_JOYSTICK_POWER_LOW,
		SDL_JOYSTICK_POWER_MEDIUM,
		SDL_JOYSTICK_POWER_FULL,
		SDL_JOYSTICK_POWER_WIRED,
		SDL_JOYSTICK_POWER_MAX
	}
}

static if(sdlSupport >= SDLSupport.v2_0_14){
	enum SDL_IPHONE_MAX_GFORCE = 5.0;
}

static if(sdlSupport >= SDLSupport.v2_24){
	struct SDL_VirtualJoystickDesc{
		ushort version_; //NOTE: the original variable's name is `version`
		ushort type;
		ushort naxes;
		ushort nbuttons;
		ushort nhats;
		ushort vendor_id;
		ushort product_id;
		ushort padding;
		uint button_mask;
		uint axis_mask;
		const(char)* name;

		void* userdata;
		void function(void* userdata) Update;
		void function(void* userdata, int player_index) SetPlayerIndex;
		int function(void* userdata, ushort low_frequency_rumble, ushort high_frequency_rumble) Rumble;
		int function(void* userdata, ushort left_rumble, ushort right_rumble) RumbleTriggers;
		int function(void* userdata, ubyte red, ubyte green, ubyte blue) SetLED;
		int function(void* userdata, const(void)* data, int size) SendEffect;
	}
	
	enum ushort SDL_VIRTUAL_JOYSTICK_DESC_VERSION = 1;
}

static if(sdlSupport >= SDLSupport.v2_0_6){
	alias SDL_JoystickType = ushort;
	enum: SDL_JoystickType{
		SDL_JOYSTICK_TYPE_UNKNOWN,
		SDL_JOYSTICK_TYPE_GAMECONTROLLER,
		SDL_JOYSTICK_TYPE_WHEEL,
		SDL_JOYSTICK_TYPE_ARCADE_STICK,
		SDL_JOYSTICK_TYPE_FLIGHT_STICK,
		SDL_JOYSTICK_TYPE_DANCE_PAD,
		SDL_JOYSTICK_TYPE_GUITAR,
		SDL_JOYSTICK_TYPE_DRUM_KIT,
		SDL_JOYSTICK_TYPE_ARCADE_PAD,
		SDL_JOYSTICK_TYPE_THROTTLE,
	}
	
	enum{
		SDL_JOYSTICK_AXIS_MAX = 32767,
		SDL_JOYSTICK_AXIS_MIN = -32768,
	}
}

mixin(joinFnBinds((){
	string[][] ret;
	ret ~= makeFnBinds([
		[q{int}, q{SDL_NumJoysticks}, q{}],
		[q{const(char)*}, q{SDL_JoystickNameForIndex}, q{int device_index}],
		[q{SDL_JoystickGUID}, q{SDL_JoystickGetDeviceGUID}, q{int device_index}],
		[q{SDL_Joystick*}, q{SDL_JoystickOpen}, q{int device_index}],
		[q{const(char)*}, q{SDL_JoystickName}, q{SDL_Joystick* joystick}],
		[q{SDL_JoystickGUID}, q{SDL_JoystickGetGUID}, q{SDL_Joystick* joystick}],
		[q{void}, q{SDL_JoystickGetGUIDString}, q{SDL_JoystickGUID guid, char* pszGUID, int cbGUID}],
		[q{SDL_JoystickGUID}, q{SDL_JoystickGetGUIDFromString}, q{const(char)* }],
		[q{SDL_bool}, q{SDL_JoystickGetAttached}, q{SDL_Joystick* joystick}],
		[q{SDL_JoystickID}, q{SDL_JoystickInstanceID}, q{SDL_Joystick* joystick}],
		[q{int}, q{SDL_JoystickNumAxes}, q{SDL_Joystick* joystick}],
		[q{int}, q{SDL_JoystickNumBalls}, q{SDL_Joystick* joystick}],
		[q{int}, q{SDL_JoystickNumHats}, q{SDL_Joystick* joystick}],
		[q{int}, q{SDL_JoystickNumButtons}, q{SDL_Joystick* joystick}],
		[q{void}, q{SDL_JoystickUpdate}, q{}],
		[q{int}, q{SDL_JoystickEventState}, q{int state}],
		[q{short}, q{SDL_JoystickGetAxis}, q{SDL_Joystick* joystick, int axis}],
		[q{ubyte}, q{SDL_JoystickGetHat}, q{SDL_Joystick* joystick, int hat}],
		[q{int}, q{SDL_JoystickGetBall}, q{SDL_Joystick* joystick, int ball, int* dx, int* dy}],
		[q{ubyte}, q{SDL_JoystickGetButton}, q{SDL_Joystick* joystick, int button}],
		[q{void}, q{SDL_JoystickClose}, q{SDL_Joystick* joystick}],
	]);
	static if(sdlSupport >= SDLSupport.v2_0_4){
		ret ~= makeFnBinds([
			[q{SDL_JoystickPowerLevel}, q{SDL_JoystickCurrentPowerLevel}, q{SDL_Joystick* joystick}],
			[q{SDL_Joystick*}, q{SDL_JoystickFromInstanceID}, q{SDL_JoystickID instance_id}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_6){
		ret ~= makeFnBinds([
			[q{SDL_bool}, q{SDL_JoystickGetAxisInitialState}, q{SDL_Joystick* joystick, int axis, short* state}],
			[q{ushort}, q{SDL_JoystickGetDeviceProduct}, q{int device_index}],
			[q{ushort}, q{SDL_JoystickGetDeviceProductVersion}, q{int device_index}],
			[q{SDL_JoystickType}, q{SDL_JoystickGetDeviceType}, q{int device_index}],
			[q{SDL_JoystickType}, q{SDL_JoystickGetDeviceInstanceID}, q{int device_index}],
			[q{ushort}, q{SDL_JoystickGetDeviceVendor}, q{int device_index}],
			[q{ushort}, q{SDL_JoystickGetProduct}, q{SDL_Joystick* joystick}],
			[q{ushort}, q{SDL_JoystickGetProductVersion}, q{SDL_Joystick* joystick}],
			[q{SDL_JoystickType}, q{SDL_JoystickGetType}, q{SDL_Joystick* joystick}],
			[q{ushort}, q{SDL_JoystickGetVendor}, q{SDL_Joystick* joystick}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_7){
		ret ~= makeFnBinds([
			[q{void}, q{SDL_LockJoysticks}, q{}],
			[q{void}, q{SDL_UnlockJoysticks}, q{}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_9){
		ret ~= makeFnBinds([
			[q{int}, q{SDL_JoystickRumble}, q{SDL_Joystick* joystick, ushort low_frequency_rumble, ushort high_frequency_rumble, uint duration_ms}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_10){
		ret ~= makeFnBinds([
			[q{int}, q{SDL_JoystickGetDevicePlayerIndex}, q{int device_index}],
			[q{int}, q{SDL_JoystickGetPlayerIndex}, q{SDL_Joystick* joystick}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_12){
		ret ~= makeFnBinds([
			[q{SDL_Joystick*}, q{SDL_JoystickFromPlayerIndex}, q{int}],
			[q{void}, q{SDL_JoystickSetPlayerIndex}, q{SDL_Joystick* joystick,int}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_14){
		ret ~= makeFnBinds([
			[q{int}, q{SDL_JoystickAttachVirtual}, q{SDL_JoystickType type, int naxes, int nbuttons, int nhats}],
			[q{int}, q{SDL_JoystickDetachVirtual}, q{int device_index}],
			[q{SDL_bool}, q{SDL_JoystickIsVirtual}, q{int device_index}],
			[q{int}, q{SDL_JoystickSetVirtualAxis}, q{SDL_Joystick* joystick, int axis, short value}],
			[q{int}, q{SDL_JoystickSetVirtualButton}, q{SDL_Joystick* joystick, int button, ubyte value}],
			[q{int}, q{SDL_JoystickSetVirtualHat}, q{SDL_Joystick* joystick, int hat, ubyte value}],
			[q{const(char)*}, q{SDL_JoystickGetSerial}, q{SDL_Joystick* joystick}],
			[q{int}, q{SDL_JoystickRumbleTriggers}, q{SDL_Joystick* joystick, ushort left_rumble, ushort right_rumble, uint duration_ms}],
			[q{SDL_bool}, q{SDL_JoystickHasLED}, q{SDL_Joystick* joystick}],
			[q{int}, q{SDL_JoystickSetLED}, q{SDL_Joystick* joystick, ubyte red, ubyte green, ubyte blue}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_16){
		ret ~= makeFnBinds([
			[q{int}, q{SDL_JoystickSendEffect}, q{SDL_Joystick* joystick, const(void)*data, int size}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_18){
		ret ~= makeFnBinds([
			[q{SDL_bool}, q{SDL_JoystickHasRumble}, q{SDL_Joystick* joystick}],
			[q{SDL_bool}, q{SDL_JoystickHasRumbleTriggers}, q{SDL_Joystick* joystick}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_24){
		ret ~= makeFnBinds([
			[q{const(char)*}, q{SDL_JoystickPathForIndex}, q{int device_index}],
			[q{int}, q{SDL_JoystickAttachVirtualEx}, q{const(SDL_VirtualJoystickDesc)* desc}],
			[q{const(char)*}, q{SDL_JoystickPath}, q{SDL_Joystick* joystick}],
			[q{ushort}, q{SDL_JoystickGetFirmwareVersion}, q{SDL_Joystick* joystick}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_26){
		ret ~= makeFnBinds([
			[q{void}, q{SDL_GetJoystickGUIDInfo}, q{SDL_JoystickGUID guid, ushort* vendor, ushort* product, ushort* version_, ushort* crc16}],
		]);
	}
	return ret;
}()));
