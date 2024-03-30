/+
+            Copyright 2024 – 2025 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.sensor;

import bindbc.sdl.config, bindbc.sdl.codegen;

import sdl.properties;

struct SDL_Sensor;

alias SDL_SensorID = uint;

enum{
	SDL_StandardGravity = 9.80665f,
	SDL_STANDARD_GRAVITY = SDL_StandardGravity,
}

mixin(makeEnumBind(q{SDL_SensorType}, members: (){
	EnumMember[] ret = [
		{{q{invalid},  q{SDL_SENSOR_INVALID}}, q{-1}},
		{{q{unknown},  q{SDL_SENSOR_UNKNOWN}}},
		{{q{accel},    q{SDL_SENSOR_ACCEL}}},
		{{q{gyro},     q{SDL_SENSOR_GYRO}}},
		{{q{accelL},   q{SDL_SENSOR_ACCEL_L}}},
		{{q{gyroL},    q{SDL_SENSOR_GYRO_L}}},
		{{q{accelR},   q{SDL_SENSOR_ACCEL_R}}},
		{{q{gyroR},    q{SDL_SENSOR_GYRO_R}}},
	];
	return ret;
}()));

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{SDL_SensorID*}, q{SDL_GetSensors}, q{int* count}},
		{q{const(char)*}, q{SDL_GetSensorNameForID}, q{SDL_SensorID instanceID}},
		{q{SDL_SensorType}, q{SDL_GetSensorTypeForID}, q{SDL_SensorID instanceID}},
		{q{int}, q{SDL_GetSensorNonPortableTypeForID}, q{SDL_SensorID instanceID}},
		{q{SDL_Sensor*}, q{SDL_OpenSensor}, q{SDL_SensorID instanceID}},
		{q{SDL_Sensor*}, q{SDL_GetSensorFromID}, q{SDL_SensorID instanceID}},
		{q{SDL_PropertiesID}, q{SDL_GetSensorProperties}, q{SDL_Sensor* sensor}},
		{q{const(char)*}, q{SDL_GetSensorName}, q{SDL_Sensor* sensor}},
		{q{SDL_SensorType}, q{SDL_GetSensorType}, q{SDL_Sensor* sensor}},
		{q{int}, q{SDL_GetSensorNonPortableType}, q{SDL_Sensor* sensor}},
		{q{SDL_SensorID}, q{SDL_GetSensorID}, q{SDL_Sensor* sensor}},
		{q{bool}, q{SDL_GetSensorData}, q{SDL_Sensor* sensor, float* data, int numValues}},
		{q{void}, q{SDL_CloseSensor}, q{SDL_Sensor* sensor}},
		{q{void}, q{SDL_UpdateSensors}, q{}},
	];
	return ret;
}()));
