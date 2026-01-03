/+
+            Copyright 2024 – 2026 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.events;

import bindbc.sdl.config, bindbc.sdl.codegen;

import sdl.audio: SDL_AudioDeviceID;
import sdl.camera: SDL_CameraID;
import sdl.joystick: SDL_Hat, SDL_JoystickID;
import sdl.keyboard: SDL_KeyboardID;
import sdl.keycode: SDL_KeyCode, SDL_KeyMod;
import sdl.mouse: SDL_MouseButton, SDL_MouseButtonFlags, SDL_MouseID, SDL_MouseWheelDirection;
import sdl.pen: SDL_PenID, SDL_PenInputFlags_, SDL_PenAxis;
import sdl.power: SDL_PowerState;
import sdl.sensor: SDL_SensorID;
import sdl.scancode: SDL_Scancode;
import sdl.touch: SDL_TouchID, SDL_FingerID;
import sdl.video: SDL_DisplayID, SDL_Window, SDL_WindowID;

mixin(makeEnumBind(q{SDL_EventType}, q{uint}, members: (){
	EnumMember[] ret = [
		{{q{first},                             q{SDL_EVENT_FIRST}},                   q{0}},
		{{q{quit},                              q{SDL_EVENT_QUIT}},                    q{0x100}},
		{{q{terminating},                       q{SDL_EVENT_TERMINATING}}},
		{{q{lowMemory},                         q{SDL_EVENT_LOW_MEMORY}}},
		{{q{willEnterBackground},               q{SDL_EVENT_WILL_ENTER_BACKGROUND}}},
		{{q{didEnterBackground},                q{SDL_EVENT_DID_ENTER_BACKGROUND}}},
		{{q{willEnterForeground},               q{SDL_EVENT_WILL_ENTER_FOREGROUND}}},
		{{q{didEnterForeground},                q{SDL_EVENT_DID_ENTER_FOREGROUND}}},
		{{q{localeChanged},                     q{SDL_EVENT_LOCALE_CHANGED}}},
		{{q{systemThemeChanged},                q{SDL_EVENT_SYSTEM_THEME_CHANGED}}},
		{{q{displayOrientation},                q{SDL_EVENT_DISPLAY_ORIENTATION}},     q{0x151}},
		{{q{displayAdded},                      q{SDL_EVENT_DISPLAY_ADDED}}},
		{{q{displayRemoved},                    q{SDL_EVENT_DISPLAY_REMOVED}}},
		{{q{displayMoved},                      q{SDL_EVENT_DISPLAY_MOVED}}},
		{{q{displayDesktopModeChanged},         q{SDL_EVENT_DISPLAY_DESKTOP_MODE_CHANGED}}},
		{{q{displayCurrentModeChanged},         q{SDL_EVENT_DISPLAY_CURRENT_MODE_CHANGED}}},
		{{q{displayContentScaleChanged},        q{SDL_EVENT_DISPLAY_CONTENT_SCALE_CHANGED}}},
	];
	string displayLast = q{SDL_EventType.displayContentScaleChanged};
	if(sdlVersion >= Version(3,4,0)){
		EnumMember add =
			{{q{displayUsableBoundsChanged},    q{SDL_EVENT_DISPLAY_USABLE_BOUNDS_CHANGED}}};
		ret ~= add;
		displayLast = q{SDL_EventType.displayUsableBoundsChanged};
	}
	{
		EnumMember[] add = [
			{{q{displayFirst},                  q{SDL_EVENT_DISPLAY_FIRST}},           q{SDL_EventType.displayOrientation}},
			{{q{displayLast},                   q{SDL_EVENT_DISPLAY_LAST}},            displayLast},
			{{q{windowShown},                   q{SDL_EVENT_WINDOW_SHOWN}},            q{0x202}},
			{{q{windowHidden},                  q{SDL_EVENT_WINDOW_HIDDEN}}},
			{{q{windowExposed},                 q{SDL_EVENT_WINDOW_EXPOSED}}},
			{{q{windowMoved},                   q{SDL_EVENT_WINDOW_MOVED}}},
			{{q{windowResized},                 q{SDL_EVENT_WINDOW_RESIZED}}},
			{{q{windowPixelSizeChanged},        q{SDL_EVENT_WINDOW_PIXEL_SIZE_CHANGED}}},
			{{q{windowMetalViewResized},        q{SDL_EVENT_WINDOW_METAL_VIEW_RESIZED}}},
			{{q{windowMinimized},               q{SDL_EVENT_WINDOW_MINIMIZED}}},
			{{q{windowMaximized},               q{SDL_EVENT_WINDOW_MAXIMIZED}}},
			{{q{windowRestored},                q{SDL_EVENT_WINDOW_RESTORED}}},
			{{q{windowMouseEnter},              q{SDL_EVENT_WINDOW_MOUSE_ENTER}}},
			{{q{windowMouseLeave},              q{SDL_EVENT_WINDOW_MOUSE_LEAVE}}},
			{{q{windowFocusGained},             q{SDL_EVENT_WINDOW_FOCUS_GAINED}}},
			{{q{windowFocusLost},               q{SDL_EVENT_WINDOW_FOCUS_LOST}}},
			{{q{windowCloseRequested},          q{SDL_EVENT_WINDOW_CLOSE_REQUESTED}}},
			{{q{windowHitTest},                 q{SDL_EVENT_WINDOW_HIT_TEST}}},
			{{q{windowICCProfChanged},          q{SDL_EVENT_WINDOW_ICCPROF_CHANGED}}},
			{{q{windowDisplayChanged},          q{SDL_EVENT_WINDOW_DISPLAY_CHANGED}}},
			{{q{windowDisplayScaleChanged},     q{SDL_EVENT_WINDOW_DISPLAY_SCALE_CHANGED}}},
			{{q{windowSafeAreaChanged},         q{SDL_EVENT_WINDOW_SAFE_AREA_CHANGED}}},
			{{q{windowOccluded},                q{SDL_EVENT_WINDOW_OCCLUDED}}},
			{{q{windowEnterFullscreen},         q{SDL_EVENT_WINDOW_ENTER_FULLSCREEN}}},
			{{q{windowLeaveFullscreen},         q{SDL_EVENT_WINDOW_LEAVE_FULLSCREEN}}},
			{{q{windowDestroyed},               q{SDL_EVENT_WINDOW_DESTROYED}}},
			{{q{windowHDRStateChanged},         q{SDL_EVENT_WINDOW_HDR_STATE_CHANGED}}},
			{{q{windowFirst},                   q{SDL_EVENT_WINDOW_FIRST}},            q{SDL_EventType.windowShown}},
			{{q{windowLast},                    q{SDL_EVENT_WINDOW_LAST}},             q{SDL_EventType.windowHDRStateChanged}},
			{{q{keyDown},                       q{SDL_EVENT_KEY_DOWN}},                q{0x300}},
			{{q{keyUp},                         q{SDL_EVENT_KEY_UP}}},
			{{q{textEditing},                   q{SDL_EVENT_TEXT_EDITING}}},
			{{q{textInput},                     q{SDL_EVENT_TEXT_INPUT}}},
			{{q{keymapChanged},                 q{SDL_EVENT_KEYMAP_CHANGED}}},
			{{q{keyboardAdded},                 q{SDL_EVENT_KEYBOARD_ADDED}}},
			{{q{keyboardRemoved},               q{SDL_EVENT_KEYBOARD_REMOVED}}},
			{{q{textEditingCandidates},         q{SDL_EVENT_TEXT_EDITING_CANDIDATES}}},
		];
		ret ~= add;
	}
	if(sdlVersion >= Version(3,4,0)){
		EnumMember[] add = [
			{{q{screenKeyboardShown},           q{SDL_EVENT_SCREEN_KEYBOARD_SHOWN}}},
			{{q{screenKeyboardHidden},          q{SDL_EVENT_SCREEN_KEYBOARD_HIDDEN}}},
		];
		ret ~= add;
	}
	{
		EnumMember[] add = [
			{{q{mouseMotion},                   q{SDL_EVENT_MOUSE_MOTION}},            q{0x400}},
			{{q{mouseButtonDown},               q{SDL_EVENT_MOUSE_BUTTON_DOWN}}},
			{{q{mouseButtonUp},                 q{SDL_EVENT_MOUSE_BUTTON_UP}}},
			{{q{mouseWheel},                    q{SDL_EVENT_MOUSE_WHEEL}}},
			{{q{mouseAdded},                    q{SDL_EVENT_MOUSE_ADDED}}},
			{{q{mouseRemoved},                  q{SDL_EVENT_MOUSE_REMOVED}}},
			{{q{joystickAxisMotion},            q{SDL_EVENT_JOYSTICK_AXIS_MOTION}},    q{0x600}},
			{{q{joystickBallMotion},            q{SDL_EVENT_JOYSTICK_BALL_MOTION}}},
			{{q{joystickHatMotion},             q{SDL_EVENT_JOYSTICK_HAT_MOTION}}},
			{{q{joystickButtonDown},            q{SDL_EVENT_JOYSTICK_BUTTON_DOWN}}},
			{{q{joystickButtonUp},              q{SDL_EVENT_JOYSTICK_BUTTON_UP}}},
			{{q{joystickAdded},                 q{SDL_EVENT_JOYSTICK_ADDED}}},
			{{q{joystickRemoved},               q{SDL_EVENT_JOYSTICK_REMOVED}}},
			{{q{joystickBatteryUpdated},        q{SDL_EVENT_JOYSTICK_BATTERY_UPDATED}}},
			{{q{joystickUpdateComplete},        q{SDL_EVENT_JOYSTICK_UPDATE_COMPLETE}}},
			{{q{gamepadAxisMotion},             q{SDL_EVENT_GAMEPAD_AXIS_MOTION}},     q{0x650}},
			{{q{gamepadButtonDown},             q{SDL_EVENT_GAMEPAD_BUTTON_DOWN}}},
			{{q{gamepadButtonUp},               q{SDL_EVENT_GAMEPAD_BUTTON_UP}}},
			{{q{gamepadAdded},                  q{SDL_EVENT_GAMEPAD_ADDED}}},
			{{q{gamepadRemoved},                q{SDL_EVENT_GAMEPAD_REMOVED}}},
			{{q{gamepadRemapped},               q{SDL_EVENT_GAMEPAD_REMAPPED}}},
			{{q{gamepadTouchpadDown},           q{SDL_EVENT_GAMEPAD_TOUCHPAD_DOWN}}},
			{{q{gamepadTouchpadMotion},         q{SDL_EVENT_GAMEPAD_TOUCHPAD_MOTION}}},
			{{q{gamepadTouchpadUp},             q{SDL_EVENT_GAMEPAD_TOUCHPAD_UP}}},
			{{q{gamepadSensorUpdate},           q{SDL_EVENT_GAMEPAD_SENSOR_UPDATE}}},
			{{q{gamepadUpdateComplete},         q{SDL_EVENT_GAMEPAD_UPDATE_COMPLETE}}},
			{{q{gamepadSteamHandleUpdated},     q{SDL_EVENT_GAMEPAD_STEAM_HANDLE_UPDATED}}},
			{{q{fingerDown},                    q{SDL_EVENT_FINGER_DOWN}},             q{0x700}},
			{{q{fingerUp},                      q{SDL_EVENT_FINGER_UP}}},
			{{q{fingerMotion},                  q{SDL_EVENT_FINGER_MOTION}}},
			{{q{fingerCancelled},               q{SDL_EVENT_FINGER_CANCELLED}}, aliases: [{q{fingerCanceled}, q{SDL_EVENT_FINGER_CANCELED}}]},
		];
		ret ~= add;
	}
	if(sdlVersion >= Version(3,4,0)){
		EnumMember[] add = [
			{{q{pinchBegin},                    q{SDL_EVENT_PINCH_BEGIN}},             q{0x710}},
			{{q{pinchUpdate},                   q{SDL_EVENT_PINCH_UPDATE}}},
			{{q{pinchEnd},                      q{SDL_EVENT_PINCH_END}}},
		];
	}
	{
		EnumMember[] add = [
			{{q{clipboardUpdate},               q{SDL_EVENT_CLIPBOARD_UPDATE}},        q{0x900}},
			{{q{dropFile},                      q{SDL_EVENT_DROP_FILE}},               q{0x1000}},
			{{q{dropText},                      q{SDL_EVENT_DROP_TEXT}}},
			{{q{dropBegin},                     q{SDL_EVENT_DROP_BEGIN}}},
			{{q{dropComplete},                  q{SDL_EVENT_DROP_COMPLETE}}},
			{{q{dropPosition},                  q{SDL_EVENT_DROP_POSITION}}},
			{{q{audioDeviceAdded},              q{SDL_EVENT_AUDIO_DEVICE_ADDED}},      q{0x1100}},
			{{q{audioDeviceRemoved},            q{SDL_EVENT_AUDIO_DEVICE_REMOVED}}},
			{{q{audioDeviceFormatChanged},      q{SDL_EVENT_AUDIO_DEVICE_FORMAT_CHANGED}}},
			{{q{sensorUpdate},                  q{SDL_EVENT_SENSOR_UPDATE}},           q{0x1200}},
			{{q{penProximityIn},                q{SDL_EVENT_PEN_PROXIMITY_IN}},        q{0x1300}},
			{{q{penProximityOut},               q{SDL_EVENT_PEN_PROXIMITY_OUT}}},
			{{q{penDown},                       q{SDL_EVENT_PEN_DOWN}}},
			{{q{penUp},                         q{SDL_EVENT_PEN_UP}}},
			{{q{penButtonDown},                 q{SDL_EVENT_PEN_BUTTON_DOWN}}},
			{{q{penButtonUp},                   q{SDL_EVENT_PEN_BUTTON_UP}}},
			{{q{penMotion},                     q{SDL_EVENT_PEN_MOTION}}},
			{{q{penAxis},                       q{SDL_EVENT_PEN_AXIS}}},
			{{q{cameraDeviceAdded},             q{SDL_EVENT_CAMERA_DEVICE_ADDED}},     q{0x1400}},
			{{q{cameraDeviceRemoved},           q{SDL_EVENT_CAMERA_DEVICE_REMOVED}}},
			{{q{cameraDeviceApproved},          q{SDL_EVENT_CAMERA_DEVICE_APPROVED}}},
			{{q{cameraDeviceDenied},            q{SDL_EVENT_CAMERA_DEVICE_DENIED}}},
			{{q{renderTargetsReset},            q{SDL_EVENT_RENDER_TARGETS_RESET}},    q{0x2000}},
			{{q{renderDeviceReset},             q{SDL_EVENT_RENDER_DEVICE_RESET}}},
			{{q{renderDeviceLost},              q{SDL_EVENT_RENDER_DEVICE_LOST}}},
			{{q{private0},                      q{SDL_EVENT_PRIVATE0}},                q{0x4000}},
			{{q{private1},                      q{SDL_EVENT_PRIVATE1}}},
			{{q{private2},                      q{SDL_EVENT_PRIVATE2}}},
			{{q{private3},                      q{SDL_EVENT_PRIVATE3}}},
			{{q{pollSentinel},                  q{SDL_EVENT_POLL_SENTINEL}},           q{0x7F00}},
			{{q{user},                          q{SDL_EVENT_USER}},                    q{0x8000}},
			{{q{last},                          q{SDL_EVENT_LAST}},                    q{0xFFFF}},
			{{q{enumPadding},                   q{SDL_EVENT_ENUM_PADDING}},            q{0x7FFFFFFF}},
		];
		ret ~= add;
	}
	return ret;
}()));

struct SDL_CommonEvent{
	uint type;
	uint reserved;
	ulong timestamp;
}

struct SDL_DisplayEvent{
	SDL_EventType type;
	uint reserved;
	ulong timestamp;
	SDL_DisplayID displayID;
	int data1, data2;
}

struct SDL_WindowEvent{
	SDL_EventType type;
	uint reserved;
	ulong timestamp;
	SDL_WindowID windowID;
	int data1, data2;
}

struct SDL_KeyboardDeviceEvent{
	SDL_EventType type;
	uint reserved;
	ulong timestamp;
	SDL_KeyboardID which;
}

struct SDL_KeyboardEvent{
	SDL_EventType type;
	uint reserved;
	ulong timestamp;
	SDL_WindowID windowID;
	SDL_KeyboardID which;
	SDL_Scancode scancode;
	SDL_KeyCode key;
	SDL_KeyMod mod;
	ushort raw;
	bool down, repeat;
}

struct SDL_TextEditingEvent{
	SDL_EventType type;
	uint reserved;
	ulong timestamp;
	SDL_WindowID windowID;
	const(char)* text;
	int start, length;
}

struct SDL_TextEditingCandidatesEvent{
	SDL_EventType type;
	uint reserved;
	ulong timestamp;
	SDL_WindowID windowID;
	const(char*)* candidates;
	int numCandidates, selectedCandidate;
	bool horizontal;
	ubyte padding1;
	ubyte padding2;
	ubyte padding3;
	
	alias num_candidates = numCandidates;
	alias selected_candidate = selectedCandidate;
}

struct SDL_TextInputEvent{
	SDL_EventType type;
	uint reserved;
	ulong timestamp;
	SDL_WindowID windowID;
	const(char)* text;
}

struct SDL_MouseDeviceEvent{
	SDL_EventType type;
	uint reserved;
	ulong timestamp;
	SDL_MouseID which;
}

struct SDL_MouseMotionEvent{
	SDL_EventType type;
	uint reserved;
	ulong timestamp;
	SDL_WindowID windowID;
	SDL_MouseID which;
	SDL_MouseButtonFlags state;
	float x, y;
	float xRel, yRel;
	
	alias xrel = xRel;
	alias yrel = yRel;
}

struct SDL_MouseButtonEvent{
	SDL_EventType type;
	uint reserved;
	ulong timestamp;
	SDL_WindowID windowID;
	SDL_MouseID which;
	SDL_MouseButton button;
	bool down;
	ubyte clicks;
	ubyte padding;
	float x, y;
}

struct SDL_MouseWheelEvent{
	SDL_EventType type;
	uint reserved;
	ulong timestamp;
	SDL_WindowID windowID;
	SDL_MouseID which;
	float x, y;
	SDL_MouseWheelDirection direction;
	float mouseX, mouseY;
	
	alias mouse_x = mouseX;
	alias mouse_y = mouseY;
	
	static if(sdlVersion >= Version(3,2,12)){
		int integerX, integerY;
		
		alias integer_x = integerX;
		alias integer_y = integerY;
	}
}

struct SDL_JoyAxisEvent{
	SDL_EventType type;
	uint reserved;
	ulong timestamp;
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
	uint reserved;
	ulong timestamp;
	SDL_JoystickID which;
	ubyte ball;
	ubyte padding1;
	ubyte padding2;
	ubyte padding3;
	short xRel, yRel;
	
	alias xrel = xRel;
	alias yrel = yRel;
}

struct SDL_JoyHatEvent{
	SDL_EventType type;
	uint reserved;
	ulong timestamp;
	SDL_JoystickID which;
	SDL_Hat hat;
	ubyte value;
	ubyte padding1;
	ubyte padding2;
}

struct SDL_JoyButtonEvent{
	SDL_EventType type;
	uint reserved;
	ulong timestamp;
	SDL_JoystickID which;
	ubyte button;
	bool down;
	ubyte padding1;
	ubyte padding2;
}

struct SDL_JoyDeviceEvent{
	SDL_EventType type;
	uint reserved;
	ulong timestamp;
	SDL_JoystickID which;
}

struct SDL_JoyBatteryEvent{
	SDL_EventType type;
	uint reserved;
	ulong timestamp;
	SDL_JoystickID which;
	SDL_PowerState state;
	int percent;
}

struct SDL_GamepadAxisEvent{
	SDL_EventType type;
	uint reserved;
	ulong timestamp;
	SDL_JoystickID which;
	ubyte axis;
	ubyte padding1;
	ubyte padding2;
	ubyte padding3;
	short value;
	ushort padding4;
}

struct SDL_GamepadButtonEvent{
	SDL_EventType type;
	uint reserved;
	ulong timestamp;
	SDL_JoystickID which;
	ubyte button;
	bool down;
	ubyte padding1;
	ubyte padding2;
}

struct SDL_GamepadDeviceEvent{
	SDL_EventType type;
	uint reserved;
	ulong timestamp;
	SDL_JoystickID which;
}

struct SDL_GamepadTouchpadEvent{
	SDL_EventType type;
	uint reserved;
	ulong timestamp;
	SDL_JoystickID which;
	int touchpad, finger;
	float x, y, pressure;
}

struct SDL_GamepadSensorEvent{
	SDL_EventType type;
	uint reserved;
	ulong timestamp;
	SDL_JoystickID which;
	int sensor;
	float[3] data;
	ulong sensorTimestamp;
	
	alias sensor_timestamp = sensorTimestamp;
}

struct SDL_AudioDeviceEvent{
	SDL_EventType type;
	uint reserved;
	ulong timestamp;
	SDL_AudioDeviceID which;
	bool recording;
	ubyte padding1;
	ubyte padding2;
	ubyte padding3;
}

struct SDL_CameraDeviceEvent{
	SDL_EventType type;
	uint reserved;
	ulong timestamp;
	SDL_CameraID which;
}

struct SDL_RenderEvent{
	SDL_EventType type;
	uint reserved;
	ulong timestamp;
	SDL_WindowID windowID;
}

struct SDL_TouchFingerEvent{
	SDL_EventType type;
	uint reserved;
	ulong timestamp;
	SDL_TouchID touchID;
	SDL_FingerID fingerID;
	float x, y, dx, dy, pressure;
	SDL_WindowID windowID;
}

struct SDL_PinchFingerEvent{
	SDL_EventType type;
	uint reserved;
	ulong timestamp;
	float scale;
	SDL_WindowID windowID;
}

struct SDL_PenProximityEvent{
	SDL_EventType type;
	uint reserved;
	ulong timestamp;
	SDL_WindowID windowID;
	SDL_PenID which;
}

struct SDL_PenMotionEvent{
	SDL_EventType type;
	uint reserved;
	ulong timestamp;
	SDL_WindowID windowID;
	SDL_PenID which;
	SDL_PenInputFlags_ penState;
	float x, y;
	
	alias pen_state = penState;
}

struct SDL_PenTouchEvent{
	SDL_EventType type;
	uint reserved;
	ulong timestamp;
	SDL_WindowID windowID;
	SDL_PenID which;
	SDL_PenInputFlags_ penState;
	float x, y;
	bool eraser, down;
	
	alias pen_state = penState;
}

struct SDL_PenButtonEvent{
	SDL_EventType type;
	uint reserved;
	ulong timestamp;
	SDL_WindowID windowID;
	SDL_PenID which;
	SDL_PenInputFlags_ penState;
	float x, y;
	ubyte button;
	bool down;
	
	alias pen_state = penState;
}

struct SDL_PenAxisEvent{
	SDL_EventType type;
	uint reserved;
	ulong timestamp;
	SDL_WindowID windowID;
	SDL_PenID which;
	SDL_PenInputFlags_ penState;
	float x, y;
	SDL_PenAxis axis;
	float value;
	
	alias pen_state = penState;
}

struct SDL_DropEvent{
	SDL_EventType type;
	uint reserved;
	ulong timestamp;
	SDL_WindowID windowID;
	float x, y;
	const(char)* source, data;
}

struct SDL_ClipboardEvent{
	SDL_EventType type;
	uint reserved;
	ulong timestamp;
	bool owner;
	int numMIMETypes;
	const(char)** mimeTypes;
	
	alias num_mime_types = numMIMETypes;
	alias mime_types = mimeTypes;
}

struct SDL_SensorEvent{
	SDL_EventType type;
	uint reserved;
	ulong timestamp;
	SDL_SensorID which;
	float[6] data;
	ulong sensorTimestamp;
	
	alias sensor_timestamp = sensorTimestamp;
}

struct SDL_QuitEvent{
	SDL_EventType type;
	uint reserved;
	ulong timestamp;
}

struct SDL_UserEvent{
	uint type;
	uint reserved;
	ulong timestamp;
	SDL_WindowID windowID;
	int code;
	void* data1, data2;
}

union SDL_Event{
	uint type;
	SDL_CommonEvent common;
	SDL_DisplayEvent display;
	SDL_WindowEvent window;
	SDL_KeyboardDeviceEvent kDevice;
	SDL_KeyboardEvent key;
	SDL_TextEditingEvent edit;
	SDL_TextEditingCandidatesEvent editCandidates;
	SDL_TextInputEvent text;
	SDL_MouseDeviceEvent mDevice;
	SDL_MouseMotionEvent motion;
	SDL_MouseButtonEvent button;
	SDL_MouseWheelEvent wheel;
	SDL_JoyDeviceEvent jDevice;
	SDL_JoyAxisEvent jAxis;
	SDL_JoyBallEvent jBall;
	SDL_JoyHatEvent jHat;
	SDL_JoyButtonEvent jButton;
	SDL_JoyBatteryEvent jBattery;
	SDL_GamepadDeviceEvent gDevice;
	SDL_GamepadAxisEvent gAxis;
	SDL_GamepadButtonEvent gButton;
	SDL_GamepadTouchpadEvent gTouchpad;
	SDL_GamepadSensorEvent gSensor;
	SDL_AudioDeviceEvent aDevice;
	SDL_CameraDeviceEvent cDevice;
	SDL_SensorEvent sensor;
	SDL_QuitEvent quit;
	SDL_UserEvent user;
	SDL_TouchFingerEvent tFinger;
	SDL_PenProximityEvent pProximity;
	SDL_PenTouchEvent pTouch;
	SDL_PenMotionEvent pMotion;
	SDL_PenButtonEvent pButton;
	SDL_PenAxisEvent pAxis;
	SDL_RenderEvent render;
	SDL_DropEvent drop;
	SDL_ClipboardEvent clipboard;
	ubyte[128] padding;
	
	alias kdevice = kDevice;
	alias edit_candidates = editCandidates;
	alias mdevice = mDevice;
	alias jdevice = jDevice;
	alias jaxis = jAxis;
	alias jball = jBall;
	alias jhat = jHat;
	alias jbutton = jButton;
	alias jbattery = jBattery;
	alias gdevice = gDevice;
	alias gaxis = gAxis;
	alias gbutton = gButton;
	alias gtouchpad = gTouchpad;
	alias gsensor = gSensor;
	alias adevice = aDevice;
	alias cdevice = cDevice;
	alias tfinger = tFinger;
	alias pproximity = pProximity;
	alias ptouch = pTouch;
	alias pmotion = pMotion;
	alias pbutton = pButton;
	alias paxis = pAxis;
}

static assert(SDL_Event.sizeof == (cast(SDL_Event*)null).padding.sizeof);

mixin(makeEnumBind(q{SDL_EventAction}, members: (){
	EnumMember[] ret = [
		{{q{addEvent},   q{SDL_ADDEVENT}}},
		{{q{peekEvent},  q{SDL_PEEKEVENT}}},
		{{q{getEvent},   q{SDL_GETEVENT}}},
	];
	return ret;
}()));

alias SDL_EventFilter = extern(C) bool function(void* userData, SDL_Event* event) nothrow;

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{void}, q{SDL_PumpEvents}, q{}},
		{q{int}, q{SDL_PeepEvents}, q{SDL_Event* events, int numEvents, SDL_EventAction action, uint minType, uint maxType}},
		{q{bool}, q{SDL_HasEvent}, q{uint type}},
		{q{bool}, q{SDL_HasEvents}, q{uint minType, uint maxType}},
		{q{void}, q{SDL_FlushEvent}, q{uint type}},
		{q{void}, q{SDL_FlushEvents}, q{uint minType, uint maxType}},
		{q{bool}, q{SDL_PollEvent}, q{SDL_Event* event}},
		{q{bool}, q{SDL_WaitEvent}, q{SDL_Event* event}},
		{q{bool}, q{SDL_WaitEventTimeout}, q{SDL_Event* event, int timeoutMS}},
		{q{bool}, q{SDL_PushEvent}, q{SDL_Event* event}},
		{q{void}, q{SDL_SetEventFilter}, q{SDL_EventFilter filter, void* userData}},
		{q{bool}, q{SDL_GetEventFilter}, q{SDL_EventFilter* filter, void** userData}},
		{q{bool}, q{SDL_AddEventWatch}, q{SDL_EventFilter filter, void* userData}},
		{q{void}, q{SDL_RemoveEventWatch}, q{SDL_EventFilter filter, void* userData}},
		{q{void}, q{SDL_FilterEvents}, q{SDL_EventFilter filter, void* userData}},
		{q{void}, q{SDL_SetEventEnabled}, q{uint type, bool enabled}},
		{q{bool}, q{SDL_EventEnabled}, q{uint type}},
		{q{uint}, q{SDL_RegisterEvents}, q{int numEvents}},
		{q{SDL_Window*}, q{SDL_GetWindowFromEvent}, q{const(SDL_Event)* event}},
	];
	if(sdlVersion >= Version(3,4,0)){
		FnBind[] add = [
			{q{int}, q{SDL_GetEventDescription}, q{const(SDL_Event)* event, char* buf, int bufLen}},
		];
		ret ~= add;
	}
	return ret;
}()));
