/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.sensor;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

static if(sdlSupport >= SDLSupport.v2_0_9){
	struct SDL_Sensor;
	
	alias SDL_SensorID = int;
	
	alias SDL_SensorType = int;
	enum: SDL_SensorType{
		SDL_SENSOR_INVALID    = -1,
		SDL_SENSOR_UNKNOWN    = 0,
		SDL_SENSOR_ACCEL      = 1,
		SDL_SENSOR_GYRO       = 2,
	}
	static if(sdlSupport >= SDLSupport.v2_26)
	enum: SDL_SensorType{
		SDL_SENSOR_ACCEL_L    = 3,
		SDL_SENSOR_GYRO_L     = 4,
		SDL_SENSOR_ACCEL_R    = 5,
		SDL_SENSOR_GYRO_R     = 6,
	}
	
	enum SDL_STANDARD_GRAVITY = 9.80665f;
}

mixin(joinFnBinds((){
	string[][] ret;
	static if(sdlSupport >= SDLSupport.v2_0_9){
		ret ~= makeFnBinds([
			[q{int}, q{SDL_NumSensors}, q{}],
			[q{const(char)*}, q{SDL_SensorGetDeviceName}, q{int device_index}],
			[q{SDL_SensorType}, q{SDL_SensorGetDeviceType}, q{int device_index}],
			[q{int}, q{SDL_SensorGetDeviceNonPortableType}, q{int device_index}],
			[q{SDL_SensorID}, q{SDL_SensorGetDeviceInstanceID}, q{int device_index}],
			[q{SDL_Sensor*}, q{SDL_SensorOpen}, q{int device_index}],
			[q{SDL_Sensor*}, q{SDL_SensorFromInstanceID}, q{SDL_SensorID instance_id}],
			[q{const(char)*}, q{SDL_SensorGetName}, q{SDL_Sensor* sensor}],
			[q{SDL_SensorType}, q{SDL_SensorGetType}, q{SDL_Sensor* sensor}],
			[q{int}, q{SDL_SensorGetNonPortableType}, q{SDL_Sensor* sensor}],
			[q{int}, q{SDL_SensorGetData}, q{SDL_Sensor* sensor, float* data, int num_values}],
			[q{void}, q{SDL_SensorClose}, q{SDL_Sensor* sensor}],
			[q{void}, q{SDL_SensorUpdate}, q{}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_14){
		ret ~= makeFnBinds([
			[q{void}, q{SDL_LockSensors}, q{}],
			[q{void}, q{SDL_UnlockSensors}, q{}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_26){
		ret ~= makeFnBinds([
			[q{int}, q{SDL_SensorGetDataWithTimestamp}, q{SDL_Sensor* sensor, ulong* timestamp, float* data, int num_values}],	
		]);
	}
	return ret;
}()));
