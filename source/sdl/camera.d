/+
+            Copyright 2024 – 2025 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.camera;

import bindbc.sdl.config, bindbc.sdl.codegen;

import sdl.pixels: SDL_PixelFormat, SDL_Colourspace;
import sdl.properties: SDL_PropertiesID;
import sdl.surface: SDL_Surface;

alias SDL_CameraID = uint;

struct SDL_Camera;

struct SDL_CameraSpec{
	SDL_PixelFormat format;
	SDL_Colourspace colourspace;
	int width;
	int height;
	int framerateNumerator;
	int framerateDenominator;
	
	alias colorspace = colourspace;
	alias framerate_numerator = framerateNumerator;
	alias framerate_denominator = framerateDenominator;
}

mixin(makeEnumBind(q{SDL_CameraPosition}, members: (){
	EnumMember[] ret = [
		{{q{unknown},      q{SDL_CAMERA_POSITION_UNKNOWN}}},
		{{q{frontFacing},  q{SDL_CAMERA_POSITION_FRONT_FACING}}},
		{{q{backFacing},   q{SDL_CAMERA_POSITION_BACK_FACING}}},
	];
	return ret;
}()));

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{int}, q{SDL_GetNumCameraDrivers}, q{}},
		{q{const(char)*}, q{SDL_GetCameraDriver}, q{int index}},
		{q{const(char)*}, q{SDL_GetCurrentCameraDriver}, q{}},
		{q{SDL_CameraID*}, q{SDL_GetCameras}, q{int* count}},
		{q{SDL_CameraSpec**}, q{SDL_GetCameraSupportedFormats}, q{SDL_CameraID devid, int* count}},
		{q{const(char)*}, q{SDL_GetCameraName}, q{SDL_CameraID instanceID}},
		{q{SDL_CameraPosition}, q{SDL_GetCameraPosition}, q{SDL_CameraID instanceID}},
		{q{SDL_Camera*}, q{SDL_OpenCamera}, q{SDL_CameraID instanceID, const(SDL_CameraSpec)* spec}},
		{q{int}, q{SDL_GetCameraPermissionState}, q{SDL_Camera* camera}},
		{q{SDL_CameraID}, q{SDL_GetCameraID}, q{SDL_Camera* camera}},
		{q{SDL_PropertiesID}, q{SDL_GetCameraProperties}, q{SDL_Camera* camera}},
		{q{bool}, q{SDL_GetCameraFormat}, q{SDL_Camera* camera, SDL_CameraSpec* spec}},
		{q{SDL_Surface*}, q{SDL_AcquireCameraFrame}, q{SDL_Camera* camera, ulong* timestampNS}},
		{q{void}, q{SDL_ReleaseCameraFrame}, q{SDL_Camera* camera, SDL_Surface* frame}},
		{q{void}, q{SDL_CloseCamera}, q{SDL_Camera* camera}},
	];
	return ret;
}()));
