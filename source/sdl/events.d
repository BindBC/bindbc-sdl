/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.events;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

import sdl.gesture;
import sdl.joystick;
import sdl.keyboard;
import sdl.keycode;
import sdl.stdinc;
import sdl.syswm;
import sdl.touch;
import sdl.video;

enum: ubyte{
	SDL_RELEASED  = 0,
	SDL_PRESSED   = 1,
}

alias SDL_EventType = uint;
enum: SDL_EventType{
	SDL_FIRSTEVENT                = 0,
	SDL_QUIT                      = 0x100,
	SDL_APP_TERMINATING           = 0x101,
	SDL_APP_LOWMEMORY             = 0x102,
	SDL_APP_WILLENTERBACKGROUND   = 0x103,
	SDL_APP_DIDENTERBACKGROUND    = 0x104,
	SDL_APP_WILLENTERFOREGROUND   = 0x105,
	SDL_APP_DIDENTERFOREGROUND    = 0x106,
	SDL_WINDOWEVENT               = 0x200,
	SDL_SYSWMEVENT                = 0x201,
	SDL_KEYDOWN                   = 0x300,
	SDL_KEYUP                     = 0x301,
	SDL_TEXTEDITING               = 0x302,
	SDL_TEXTINPUT                 = 0x303,
	SDL_MOUSEMOTION               = 0x400,
	SDL_MOUSEBUTTONDOWN           = 0x401,
	SDL_MOUSEBUTTONUP             = 0x402,
	SDL_MOUSEWHEEL                = 0x403,
	SDL_JOYAXISMOTION             = 0x600,
	SDL_JOYBALLMOTION             = 0x601,
	SDL_JOYHATMOTION              = 0x602,
	SDL_JOYBUTTONDOWN             = 0x603,
	SDL_JOYBUTTONUP               = 0x604,
	SDL_JOYDEVICEADDED            = 0x605,
	SDL_JOYDEVICEREMOVED          = 0x606,
	SDL_CONTROLLERAXISMOTION      = 0x650,
	SDL_CONTROLLERBUTTONDOWN      = 0x651,
	SDL_CONTROLLERBUTTONUP        = 0x652,
	SDL_CONTROLLERDEVICEADDED     = 0x653,
	SDL_CONTROLLERDEVICEREMOVED   = 0x654,
	SDL_CONTROLLERDEVICEREMAPPED  = 0x655,
	SDL_FINGERDOWN                = 0x700,
	SDL_FINGERUP                  = 0x701,
	SDL_FINGERMOTION              = 0x702,
	SDL_DOLLARGESTURE             = 0x800,
	SDL_DOLLARRECORD              = 0x801,
	SDL_MULTIGESTURE              = 0x802,
	SDL_CLIPBOARDUPDATE           = 0x900,
	SDL_DROPFILE                  = 0x1000,
	SDL_USEREVENT                 = 0x8000,
	SDL_LASTEVENT                 = 0xFFFF,
}
static if(sdlSupport >= SDLSupport.v2_0_1)
enum: SDL_EventType{
	SDL_RENDER_TARGETS_RESET      = 0x2000,
}
static if(sdlSupport >= SDLSupport.v2_0_4)
enum: SDL_EventType{
	SDL_KEYMAPCHANGED             = 0x304,
	SDL_AUDIODEVICEADDED          = 0x1100,
	SDL_AUDIODEVICEREMOVED        = 0x1101,
	SDL_RENDER_DEVICE_RESET       = 0x2001,
}
static if(sdlSupport >= SDLSupport.v2_0_5)
enum: SDL_EventType{
	SDL_DROPTEXT                  = 0x1001,
	SDL_DROPBEGIN                 = 0x1002,
	SDL_DROPCOMPLETE              = 0x1003,
}
static if(sdlSupport >= SDLSupport.v2_0_9)
enum: SDL_EventType{
	SDL_DISPLAYEVENT              = 0x150,
	SDL_SENSORUPDATE              = 0x1200,
}
static if(sdlSupport >= SDLSupport.v2_0_14)
enum: SDL_EventType{
	SDL_LOCALECHANGED             = 0x107,
	SDL_CONTROLLERTOUCHPADDOWN    = 0x656,
	SDL_CONTROLLERTOUCHPADMOTION  = 0x657,
	SDL_CONTROLLERTOUCHPADUP      = 0x658,
	SDL_CONTROLLERSENSORUPDATE    = 0x659,
}
static if(sdlSupport >= SDLSupport.v2_0_22)
enum: SDL_EventType{
	SDL_TEXTEDITING_EXT           = 0x305,
}
static if(sdlSupport >= SDLSupport.v2_24)
enum: SDL_EventType{
	SDL_JOYBATTERYUPDATED         = 0x607,
}

struct SDL_CommonEvent{
	SDL_EventType type;
	uint timestamp;
}

static if(sdlSupport >= SDLSupport.v2_0_9){
	struct SDL_DisplayEvent{
		SDL_EventType type;
		uint timestamp;
		uint display;
		ubyte event;
		ubyte padding1;
		ubyte padding2;
		ubyte padding3;
		int data1;
	}
}

struct SDL_WindowEvent{
	SDL_EventType type;
	uint timestamp;
	uint windowID;
	SDL_WindowEventID event;
	ubyte padding1;
	ubyte padding2;
	ubyte padding3;
	int data1;
	int data2;
}

struct SDL_KeyboardEvent{
	SDL_EventType type;
	uint timestamp;
	uint windowID;
	ubyte state;
	ubyte repeat;
	ubyte padding2;
	ubyte padding3;
	SDL_Keysym keysym;
}

enum SDL_TEXTEDITINGEVENT_TEXT_SIZE = 32;
struct SDL_TextEditingEvent{
	SDL_EventType type;
	uint timestamp;
	uint windowID;
	char[SDL_TEXTEDITINGEVENT_TEXT_SIZE] text;
	int start;
	int length;
}

static if(sdlSupport >= SDLSupport.v2_0_22){
	struct SDL_TextEditingExtEvent{
		SDL_EventType type;
		uint timestamp;
		uint windowID;
		char* text;
		int start;
		int length;
	}
}

enum SDL_TEXTINPUTEVENT_TEXT_SIZE = 32;
struct SDL_TextInputEvent{
	SDL_EventType type;
	uint timestamp;
	uint windowID;
	char[SDL_TEXTINPUTEVENT_TEXT_SIZE] text;
}

struct SDL_MouseMotionEvent{
	SDL_EventType type;
	uint timestamp;
	uint windowID;
	uint which;
	uint state;
	int x;
	int y;
	int xrel;
	int yrel;
}

struct SDL_MouseButtonEvent{
	SDL_EventType type;
	uint timestamp;
	uint windowID;
	uint which;
	ubyte button;
	ubyte state;
	static if(sdlSupport <= SDLSupport.v2_0_0){
		ubyte padding1;
		ubyte padding2;
	}else{
		ubyte clicks;
		ubyte padding1;
	}
	int x;
	int y;
}

struct SDL_MouseWheelEvent{
	SDL_EventType type;
	uint timestamp;
	uint windowID;
	uint which;
	int x;
	int y;
	static if(sdlSupport >= SDLSupport.v2_0_4){
		uint direction;
	}
	static if(sdlSupport >= SDLSupport.v2_0_18){
		float preciseX;
		float preciseY;
	}
	static if(sdlSupport >= SDLSupport.v2_26){
		int mouseX;
		int mouseY;
	}
}

struct SDL_JoyAxisEvent{
	SDL_EventType type;
	uint timestamp;
	SDL_JoystickID which;
	ubyte axis;
	ubyte padding1;
	ubyte padding2;
	ubyte padding3;
	short value;
	ushort padding4;
}

struct SDL_JoyBallEvent{
	SDL_EventType type;
	uint timestamp;
	SDL_JoystickID which;
	ubyte ball;
	ubyte padding1;
	ubyte padding2;
	ubyte padding3;
	short xrel;
	short yrel;
}

struct SDL_JoyHatEvent{
	SDL_EventType type;
	uint timestamp;
	SDL_JoystickID which;
	ubyte hat;
	ubyte value;
	ubyte padding1;
	ubyte padding2;
}

struct SDL_JoyButtonEvent{
	SDL_EventType type;
	uint timestamp;
	SDL_JoystickID which;
	ubyte button;
	ubyte state;
	ubyte padding1;
	ubyte padding2;
}

struct SDL_JoyDeviceEvent{
	SDL_EventType type;
	uint timestamp;
	int which;
}

static if(sdlSupport >= SDLSupport.v2_24){
	struct SDL_JoyBatteryEvent{
		SDL_EventType type;
		uint timestamp;
		SDL_JoystickID which;
		SDL_JoystickPowerLevel level;
	}
}

struct SDL_ControllerAxisEvent{
	SDL_EventType type;
	uint timestamp;
	SDL_JoystickID which;
	ubyte axis;
	ubyte padding1;
	ubyte padding2;
	ubyte padding3;
	short value;
	ushort padding4;
}

struct SDL_ControllerButtonEvent{
	SDL_EventType type;
	uint timestamp;
	SDL_JoystickID which;
	ubyte button;
	ubyte state;
	ubyte padding1;
	ubyte padding2;
}

struct SDL_ControllerDeviceEvent{
	SDL_EventType type;
	uint timestamp;
	int which;
}

static if(sdlSupport >= SDLSupport.v2_0_14){
	struct SDL_ControllerTouchpadEvent{
		uint type;
		uint timestamp;
		SDL_JoystickID which;
		int touchpad;
		int finger;
		float x;
		float y;
		float pressure;
	}
	
	struct SDL_ControllerSensorEvent{
		uint type;
		uint timestamp;
		SDL_JoystickID which;
		int sensor;
		float[3] data;
		static if(sdlSupport >= SDLSupport.v2_26){
			ulong timestamp_us;
		}
	}
}

static if(sdlSupport >= SDLSupport.v2_0_4){
	struct SDL_AudioDeviceEvent{
		uint type;
		uint timestamp;
		uint which;
		ubyte iscapture;
		ubyte padding1;
		ubyte padding2;
		ubyte padding3;
	}
}

struct SDL_TouchFingerEvent{
	SDL_EventType type;
	uint timestamp;
	SDL_TouchID touchId;
	SDL_FingerID fingerId;
	float x;
	float y;
	float dx;
	float dy;
	float pressure;
	static if(sdlSupport >= SDLSupport.v2_0_12){
		uint windowID;
	}
}

struct SDL_MultiGestureEvent{
	SDL_EventType type;
	uint timestamp;
	SDL_TouchID touchId;
	float dTheta;
	float dDist;
	float x;
	float y;
	ushort numFingers;
	ushort padding;
}

struct SDL_DollarGestureEvent{
	SDL_EventType type;
	uint timestamp;
	SDL_TouchID touchId;
	SDL_GestureID gestureId;
	uint numFingers;
	float error;
	float x;
	float y;
}

struct SDL_DropEvent{
	SDL_EventType type;
	uint timestamp;
	char* file;
	static if(sdlSupport >= SDLSupport.v2_0_5){
		uint windowID;
	}
}

struct SDL_SensorEvent{
	SDL_EventType type;
	uint timestamp;
	int which;
	float[6] data;
	static if(sdlSupport >= SDLSupport.v2_26){
		ulong timestamp_us;
	}
}

struct SDL_QuitEvent{
	SDL_EventType type;
	uint timestamp;
}

struct SDL_OSEvent{
	SDL_EventType type;
	uint timestamp;
}

struct SDL_UserEvent{
	SDL_EventType type;
	uint timestamp;
	uint windowID;
	int code;
	void* data1;
	void* data2;
}

struct SDL_SysWMEvent{
	SDL_EventType type;
	uint timestamp;
	SDL_SysWMmsg* msg;
}

union SDL_Event{
	SDL_EventType type;
	SDL_CommonEvent common;
	static if(sdlSupport >= SDLSupport.v2_0_9){
		SDL_DisplayEvent display;
	}
	SDL_WindowEvent window;
	SDL_KeyboardEvent key;
	SDL_TextEditingEvent edit;
	static if(sdlSupport >= SDLSupport.v2_0_22){
		SDL_TextEditingExtEvent editExt;
	}
	SDL_TextInputEvent text;
	SDL_MouseMotionEvent motion;
	SDL_MouseButtonEvent button;
	SDL_MouseWheelEvent wheel;
	SDL_JoyAxisEvent jaxis;
	SDL_JoyBallEvent jball;
	SDL_JoyHatEvent jhat;
	SDL_JoyButtonEvent jbutton;
	SDL_JoyDeviceEvent jdevice;
	static if(sdlSupport >= SDLSupport.v2_24){
		SDL_JoyBatteryEvent jbattery;
	}
	SDL_ControllerAxisEvent caxis;
	SDL_ControllerButtonEvent cbutton;
	SDL_ControllerDeviceEvent cdevice;
	static if(sdlSupport >= SDLSupport.v2_0_14){
		SDL_ControllerTouchpadEvent ctouchpad;
		SDL_ControllerSensorEvent csensor;
	}
	static if(sdlSupport >= SDLSupport.v2_0_4){
		SDL_AudioDeviceEvent adevice;
	}
	static if(sdlSupport >= SDLSupport.v2_0_9){
		SDL_SensorEvent sensor;
	}
	SDL_QuitEvent quit;
	SDL_UserEvent user;
	SDL_SysWMEvent syswm;
	SDL_TouchFingerEvent tfinger;
	SDL_MultiGestureEvent mgesture;
	SDL_DollarGestureEvent dgesture;
	SDL_DropEvent drop;
	
	ubyte[56] padding;
}

alias SDL_eventaction = uint;
enum: SDL_eventaction{
	SDL_ADDEVENT,
	SDL_PEEKEVENT,
	SDL_GETEVENT,
}
alias SDL_EventAction = SDL_eventaction;

alias SDL_EventFilter = extern(C) int function(void* userdata, SDL_Event* event) nothrow;

enum{
	SDL_QUERY    = -1,
	SDL_IGNORE   = 0,
	SDL_DISABLE  = 0,
	SDL_ENABLE   = 1,
}

pragma(inline, true) @nogc nothrow{
	int SDL_GetEventState(SDL_EventType type){
		return SDL_EventState(type, SDL_QUERY);
	}
	
	// This is implemented in SDL_quit.h, but works better here.
	bool SDL_QuitRequested(){
		SDL_PumpEvents();
		return SDL_PeepEvents(null, 0, SDL_PEEKEVENT, SDL_QUIT, SDL_QUIT) > 0;
	}
}

mixin(joinFnBinds((){
	string[][] ret;
	ret ~= makeFnBinds([
		[q{void}, q{SDL_PumpEvents}, q{}],
		[q{int}, q{SDL_PeepEvents}, q{SDL_Event* events, int numevents, SDL_eventaction action, uint minType, uint maxType}],
		[q{SDL_bool}, q{SDL_HasEvent}, q{uint type}],
		[q{SDL_bool}, q{SDL_HasEvents}, q{uint minType, uint maxType}],
		[q{void}, q{SDL_FlushEvent}, q{uint type}],
		[q{void}, q{SDL_FlushEvents}, q{uint minType, uint maxType}],
		[q{int}, q{SDL_PollEvent}, q{SDL_Event* event}],
		[q{int}, q{SDL_WaitEvent}, q{SDL_Event* event}],
		[q{int}, q{SDL_WaitEventTimeout}, q{SDL_Event* event, int timeout}],
		[q{int}, q{SDL_PushEvent}, q{SDL_Event* event}],
		[q{void}, q{SDL_SetEventFilter}, q{SDL_EventFilter filter, void* userdata}],
		[q{SDL_bool}, q{SDL_GetEventFilter}, q{SDL_EventFilter* filter, void** userdata}],
		[q{void}, q{SDL_AddEventWatch}, q{SDL_EventFilter filter, void* userdata}],
		[q{void}, q{SDL_DelEventWatch}, q{SDL_EventFilter filter, void* userdata}],
		[q{void}, q{SDL_FilterEvents}, q{SDL_EventFilter filter, void* userdata}],
		[q{ubyte}, q{SDL_EventState}, q{uint type, int state}],
		[q{uint}, q{SDL_RegisterEvents}, q{int numevents}],
	]);
	return ret;
}()));

