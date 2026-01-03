/+
+            Copyright 2024 – 2026 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.gesture;

import bindbc.sdl.config, bindbc.sdl.codegen;

import sdl.events: SDL_Event, SDL_EventType;
import sdl.iostream: SDL_IOStream;
import sdl.rect: SDL_FPoint;
import sdl.touch: SDL_TouchID;

alias Gesture_ID = long;

enum{
	Gesture_DollarGesture = 0x800,
	Gesture_DollarRecord  = 0x801,
	Gesture_MultiGesture  = 0x802,
	
	GESTURE_DOLLARGESTURE = Gesture_DollarGesture,
	GESTURE_DOLLARRECORD = Gesture_DollarRecord,
	GESTURE_MULTIGESTURE = Gesture_MultiGesture,
}

struct Gesture_MultiGestureEvent{
	uint type;
	uint timestamp;
	SDL_TouchID touchID;
	float dTheta, dDist;
	float x, y;
	ushort numFingers;
	ushort padding;
}

struct Gesture_DollarGestureEvent{
	uint type;
	uint timestamp;
	SDL_TouchID touchID;
	Gesture_ID gestureID;
	uint numFingers;
	float error;
	float x, y;
}

version(SDL_Gesture):
private nothrow @nogc:

enum{
	GESTURE_MAX_DOLLAR_PATH_SIZE = 1024,
	GESTURE_DOLLARNPOINTS = 64,
	GESTURE_DOLLARSIZE = 256,
	GESTURE_PHI        = 0.618033989,
}

struct GestureDollarPath{
	float length;
	int numPoints;
	SDL_FPoint[GESTURE_MAX_DOLLAR_PATH_SIZE] p;
}

struct GestureDollarTemplate{
	SDL_FPoint[GESTURE_DOLLARNPOINTS] path;
	c_ulong hash;
}

struct GestureTouch{
	SDL_TouchID touchID;
	SDL_FPoint centroid;
	GestureDollarPath dollarPath;
	ushort numDownFingers;
	int numDollarTemplates;
	GestureDollarTemplate* dollarTemplate;
	bool recording;
}

GestureTouch* gestureTouches = null;
int gestureNumTouches = 0;
bool gestureRecordAll = false;

bool gestureEventWatch(void* userData, SDL_Event* event){
	gestureProcessEvent(event);
	return true;
}

public int Gesture_Init(){
	Gesture_Quit();
	SDL_AddEventWatch(gestureEventWatch, null);
	return 0;
}

GestureTouch* gestureAddTouch(const SDL_TouchID touchID){
	GestureTouch* gestureTouch = cast(GestureTouch*)SDL_realloc(gestureTouches, (gestureNumTouches + 1) * GestureTouch.sizeof);
	if(gestureTouch is null){
		SDL_OutOfMemory();
		return null;
	}
	
	gestureTouches = gestureTouch;
	(cast(ubyte*)(&gestureTouches[gestureNumTouches]))[0..GestureTouch.sizeof] = 0;
	gestureTouches[gestureNumTouches].touchID = touchID;
	return &gestureTouches[gestureNumTouches++];
}

int GestureDelTouch(const SDL_TouchID touchID){
	int i;
	for(i = 0; i < gestureNumTouches; i++){
		if(gestureTouches[i].touchID == touchID){
			break;
		}
	}
	
	if(i == gestureNumTouches){
		return -1;
	}
	
	SDL_free(gestureTouches[i].dollarTemplate);
	SDL_zero(gestureTouches[i]);
	
	gestureNumTouches--;
	if(i != gestureNumTouches){
		SDL_copyp(&gestureTouches[i], &gestureTouches[gestureNumTouches]);
	}
	return 0;
}

GestureTouch* gestureGetTouch(const SDL_TouchID touchID){
	int i;
	for(i = 0; i < gestureNumTouches; i++){
		if(gestureTouches[i].touchID == touchID){
			return &gestureTouches[i];
		}
	}
	return null;
}

int Gesture_RecordGesture(SDL_TouchID touchID){
	SDL_TouchID* devices;
	int i;
	
	devices = SDL_GetTouchDevices(null);
	if(devices){
		for(i = 0; devices[i]; i++){
			if(!gestureGetTouch(devices[i])){
				gestureAddTouch(devices[i]);
			}
		}
		SDL_free(devices);
	}
	
	if(touchID != 0){
		gestureRecordAll = true;
		for(i = 0; i < gestureNumTouches; i++){
			gestureTouches[i].recording = true;
		}
	}else{
		GestureTouch* touch = gestureGetTouch(touchID);
		if(!touch){
			return 0;
		}
		touch.recording = true;
	}
	
	return 1;
}

public void Gesture_Quit(){
	SDL_RemoveEventWatch(gestureEventWatch, null);
	SDL_free(gestureTouches);
	gestureTouches = null;
	gestureNumTouches = 0;
	gestureRecordAll = false;
}

c_ulong gestureHashDollar(SDL_FPoint* points){
	c_ulong hash = 5381;
	int i;
	for(i = 0; i < GESTURE_DOLLARNPOINTS; i++){
		hash = ((hash << 5) + hash) + cast(c_ulong)points[i].x;
		hash = ((hash << 5) + hash) + cast(c_ulong)points[i].y;
	}
	return hash;
}

int gestureSaveTemplate(GestureDollarTemplate* templ, SDL_IOStream* dst){
	const long bytes = (templ.path[0]).sizeof * GESTURE_DOLLARNPOINTS;
	
	if(dst is null){
		return 0;
	}
	
	version(LittleEndian){
		if(SDL_WriteIO(dst, templ.path, bytes) != bytes){
			return 0;
		}
	}else{{
		GestureDollarTemplate copy = *templ;
		SDL_FPoint* p = copy.path;
		int i;
		for(i = 0; i < GESTURE_DOLLARNPOINTS; i++, p++){
			p.x = SDL_SwapFloatLE(p.x);
			p.y = SDL_SwapFloatLE(p.y);
		}
		
		if(SDL_WriteIO(dst, copy.path, bytes) != bytes){
			return 0;
		}
	}}
	
	return 1;
}

public int Gesture_SaveAllDollarTemplates(SDL_IOStream* dst){
	int i, j, rtrn = 0;
	for(i = 0; i < gestureNumTouches; i++){
		GestureTouch* touch = &gestureTouches[i];
		for(j = 0; j < touch.numDollarTemplates; j++){
			rtrn += gestureSaveTemplate(&touch.dollarTemplate[j], dst);
		}
	}
	return rtrn;
}

public int Gesture_SaveDollarTemplate(Gesture_ID gestureID, SDL_IOStream* dst){
	int i, j;
	for(i = 0; i < gestureNumTouches; i++){
		GestureTouch* touch = &gestureTouches[i];
		for(j = 0; j < touch.numDollarTemplates; j++){
			if(touch.dollarTemplate[j].hash == gestureID){
				return gestureSaveTemplate(&touch.dollarTemplate[j], dst);
			}
		}
	}
	return SDL_SetError("Unknown gestureID");
}

int gestureAddDollarOne(GestureTouch* inTouch, SDL_FPoint* path){
	GestureDollarTemplate* dollarTemplate;
	GestureDollarTemplate* templ;
	int index;
	
	index = inTouch.numDollarTemplates;
	dollarTemplate = cast(GestureDollarTemplate*)SDL_realloc(inTouch.dollarTemplate, (index + 1) * GestureDollarTemplate.sizeof);
	if(dollarTemplate is null){
		return SDL_OutOfMemory();
	}
	inTouch.dollarTemplate = dollarTemplate;
	
	templ = &inTouch.dollarTemplate[index];
	SDL_memcpy(templ.path, path, GESTURE_DOLLARNPOINTS * SDL_FPoint.sizeof);
	templ.hash = gestureHashDollar(templ.path);
	inTouch.numDollarTemplates++;
	
	return index;
}

int gestureAddDollar(GestureTouch* inTouch, SDL_FPoint* path){
	int index = -1;
	int i = 0;
	if(inTouch is null){
		if(gestureNumTouches == 0){
			return SDL_SetError("no gesture touch devices registered");
		}
		for(i = 0; i < gestureNumTouches; i++){
			inTouch = &gestureTouches[i];
			index = gestureAddDollarOne(inTouch, path);
			if(index < 0){
				return -1;
			}
		}
		return index;
	}
	return gestureAddDollarOne(inTouch, path);
}

public int Gesture_LoadDollarTemplates(SDL_TouchID touchID, SDL_IOStream* src){
	int i, loaded = 0;
	GestureTouch* touch = null;
	if(src is null){
		return 0;
	}
	if(touchID >= 0){
		for(i = 0; i < gestureNumTouches; i++){
			if(gestureTouches[i].touchID == touchID){
				touch = &gestureTouches[i];
			}
		}
		if(touch is null){
			return SDL_SetError("given touch id not found");
		}
	}
	
	while(1){
		GestureDollarTemplate templ;
		const long bytes = (templ.path[0]).sizeof * GESTURE_DOLLARNPOINTS;
		
		if(SDL_ReadIO(src, templ.path, bytes) < bytes){
			if(loaded == 0){
				return SDL_SetError("could not read any dollar gesture from rwops");
			}
			break;
		}
		
		version(BigEndian){
			for(i = 0; i < GESTURE_DOLLARNPOINTS; i++){
				SDL_FPoint* p = &templ.path[i];
				p.x = SDL_SwapFloatLE(p.x);
				p.y = SDL_SwapFloatLE(p.y);
			}
		}
		
		if(touchID >= 0){
			if(gestureAddDollar(touch, templ.path) >= 0){
				loaded++;
			}
		}else{
			for(i = 0; i < gestureNumTouches; i++){
				touch = &gestureTouches[i];
				gestureAddDollar(touch, templ.path);
			}
			loaded++;
		}
	}
	
	return loaded;
}

float gestureDollarDifference(SDL_FPoint* points, SDL_FPoint* templ, float ang){
	float dist = 0;
	SDL_FPoint p;
	int i;
	for(i = 0; i < GESTURE_DOLLARNPOINTS; i++){
		p.x = points[i].x * SDL_cosf(ang) - points[i].y * SDL_sinf(ang);
		p.y = points[i].x * SDL_sinf(ang) + points[i].y * SDL_cosf(ang);
		dist += SDL_sqrtf((p.x - templ[i].x) * (p.x - templ[i].x) + (p.y - templ[i].y) * (p.y - templ[i].y));
	}
	return dist / GESTURE_DOLLARNPOINTS;
}

float gestureBestDollarDifference(SDL_FPoint* points, SDL_FPoint* templ){
	double ta = -SDL_PI_D / 4;
	double tb = SDL_PI_D / 4;
	double dt = SDL_PI_D / 90;
	float x1 = cast(float)(GESTURE_PHI * ta + (1 - GESTURE_PHI) * tb);
	float f1 = gestureDollarDifference(points, templ, x1);
	float x2 = cast(float)((1 - GESTURE_PHI) * ta + GESTURE_PHI * tb);
	float f2 = gestureDollarDifference(points, templ, x2);
	while(SDL_fabs(ta - tb) > dt){
		if(f1 < f2){
			tb = x2;
			x2 = x1;
			f2 = f1;
			x1 = cast(float)(GESTURE_PHI * ta + (1 - GESTURE_PHI) * tb);
			f1 = gestureDollarDifference(points, templ, x1);
		}else{
			ta = x1;
			x1 = x2;
			f1 = f2;
			x2 = cast(float)((1 - GESTURE_PHI) * ta + GESTURE_PHI * tb);
			f2 = gestureDollarDifference(points, templ, x2);
		}
	}
	return SDL_min(f1, f2);
}

int gestureDollarNormalise(const(GestureDollarPath)* path, SDL_FPoint* points, bool isRecording){
	int i;
	float interval;
	float dist;
	int numPoints = 0;
	SDL_FPoint centroid;
	float xMin, xMax, yMin, yMax;
	float ang;
	float w, h;
	float length = path.length;
	
	if(length <= 0){
		for(i = 1; i < path.numPoints; i++){
			const float dx = path.p[i].x - path.p[i - 1].x;
			const float dy = path.p[i].y - path.p[i - 1].y;
			length += SDL_sqrtf(dx * dx + dy * dy);
		}
	}
	
	interval = length / (GESTURE_DOLLARNPOINTS - 1);
	dist = interval;
	
	centroid.x = 0;
	centroid.y = 0;
	
	for(i = 1; i < path.numPoints; i++){
		const float d = SDL_sqrtf((path.p[i-1].x - path.p[i].x) * (path.p[i-1].x - path.p[i].x) + (path.p[i-1].y - path.p[i].y) * (path.p[i - 1].y - path.p[i].y));
		while(dist + d > interval){
			points[numPoints].x = path.p[i-1].x + ((interval - dist) / d) * (path.p[i].x - path.p[i-1].x);
			points[numPoints].y = path.p[i-1].y + ((interval - dist) / d) * (path.p[i].y - path.p[i-1].y);
			centroid.x += points[numPoints].x;
			centroid.y += points[numPoints].y;
			numPoints++;
			
			dist -= interval;
		}
		dist += d;
	}
	if(numPoints < GESTURE_DOLLARNPOINTS - 1){
		if(isRecording){
			SDL_SetError("ERROR: NumPoints = %i", numPoints);
		}
		return 0;
	}
	points[GESTURE_DOLLARNPOINTS - 1] = path.p[path.numPoints - 1];
	numPoints = GESTURE_DOLLARNPOINTS;
	
	centroid.x /= numPoints;
	centroid.y /= numPoints;
	
	xMin = centroid.x;
	xMax = centroid.x;
	yMin = centroid.y;
	yMax = centroid.y;
	
	ang = SDL_atan2f(centroid.y - points[0].y, centroid.x - points[0].x);
	
	for(i = 0; i < numPoints; i++){
		const float px = points[i].x;
		const float py = points[i].y;
		points[i].x = (px - centroid.x) * SDL_cosf(ang) - (py - centroid.y) * SDL_sinf(ang) + centroid.x;
		points[i].y = (px - centroid.x) * SDL_sinf(ang) + (py - centroid.y) * SDL_cosf(ang) + centroid.y;
		
		if(points[i].x < xMin){
			xMin = points[i].x;
		}
		if(points[i].x > xMax){
			xMax = points[i].x;
		}
		if(points[i].y < yMin){
			yMin = points[i].y;
		}
		if(points[i].y > yMax){
			yMax = points[i].y;
		}
	}
	
	w = xMax - xMin;
	h = yMax - yMin;
	
	for(i = 0; i < numPoints; i++){
		points[i].x = (points[i].x - centroid.x) * GESTURE_DOLLARSIZE / w;
		points[i].y = (points[i].y - centroid.y) * GESTURE_DOLLARSIZE / h;
	}
	return numPoints;
}

float gestureDollarRecognise(const(GestureDollarPath)* path, int* bestTempl, GestureTouch* touch){
	SDL_FPoint[GESTURE_DOLLARNPOINTS] points;
	int i;
	float bestDiff = 10000;
	
	SDL_memset(points, 0, points.sizeof);
	
	gestureDollarNormalise(path, points, false);
	
	*bestTempl = -1;
	for(i = 0; i < touch.numDollarTemplates; i++){
		const float diff = gestureBestDollarDifference(points, touch.dollarTemplate[i].path);
		if(diff < bestDiff){
			bestDiff = diff;
			*bestTempl = i;
		}
	}
	return bestDiff;
}

void gestureSendMulti(GestureTouch* touch, float dTheta, float dDist){
	if(SDL_EventEnabled(Gesture_MultiGesture)){
		Gesture_MultiGestureEvent mGesture;
		mGesture.type = Gesture_MultiGesture;
		mGesture.timestamp = 0;
		mGesture.touchID = touch.touchID;
		mGesture.x = touch.centroid.x;
		mGesture.y = touch.centroid.y;
		mGesture.dTheta = dTheta;
		mGesture.dDist = dDist;
		mGesture.numFingers = touch.numDownFingers;
		SDL_PushEvent(cast(SDL_Event*)&mGesture);
	}
}

void gestureSendDollar(GestureTouch* touch, Gesture_ID gestureID, float error){
	if(SDL_EventEnabled(Gesture_DollarGesture)){
		Gesture_DollarGestureEvent dGesture;
		dGesture.type = Gesture_DollarGesture;
		dGesture.timestamp = 0;
		dGesture.touchID = touch.touchID;
		dGesture.x = touch.centroid.x;
		dGesture.y = touch.centroid.y;
		dGesture.gestureID = gestureID;
		dGesture.error = error;
		dGesture.numFingers = touch.numDownFingers + 1;
		SDL_PushEvent(cast(SDL_Event*)&dGesture);
	}
}

void gestureSendDollarRecord(GestureTouch* touch, Gesture_ID gestureID){
	if(SDL_EventEnabled(Gesture_DollarRecord)){
		Gesture_DollarGestureEvent dGesture;
		dGesture.type = Gesture_DollarRecord;
		dGesture.timestamp = 0;
		dGesture.touchID = touch.touchID;
		dGesture.gestureID = gestureID;
		SDL_PushEvent(cast(SDL_Event*)&dGesture);
	}
}

void gestureProcessEvent(const(SDL_Event)* event){
	float x, y;
	int index;
	int i;
	float pathDx, pathDy;
	SDL_FPoint lastP;
	SDL_FPoint lastCentroid;
	float lDist;
	float dist;
	float dtheta;
	float dDist;
	
	if(event.type == SDL_EventType.fingerMotion || event.type == SDL_EventType.fingerDown || event.type == SDL_EventType.fingerUp){
		GestureTouch* inTouch = gestureGetTouch(event.tfinger.touchID);
		
		if(inTouch is null){
			inTouch = gestureAddTouch(event.tfinger.touchID);
			if(!inTouch){
				return;
			}
		}
		
		x = event.tfinger.x;
		y = event.tfinger.y;
		
		if(event.type == SDL_EVENT_FINGER_UP){
			SDL_FPoint[GESTURE_DOLLARNPOINTS] path;
			inTouch.numDownFingers--;
			
			if(inTouch.recording){
				inTouch.recording = false;
				gestureDollarNormalise(&inTouch.dollarPath, path, true);
				if(gestureRecordAll){
					index = gestureAddDollar(null, path);
					for(i = 0; i < gestureNumTouches; i++){
						gestureTouches[i].recording = false;
					}
				}else{
					index = gestureAddDollar(inTouch, path);
				}
				
				if(index >= 0){
					gestureSendDollarRecord(inTouch, inTouch.dollarTemplate[index].hash);
				}else{
					gestureSendDollarRecord(inTouch, -1);
				}
			}else{
				int bestTempl = -1;
				const float error = gestureDollarRecognise(&inTouch.dollarPath, &bestTempl, inTouch);
				if(bestTempl >= 0){
					const c_ulong gestureID = inTouch.dollarTemplate[bestTempl].hash;
					gestureSendDollar(inTouch, gestureID, error);
				}
			}
			
			if(inTouch.numDownFingers > 0){
				inTouch.centroid.x = (inTouch.centroid.x * (inTouch.numDownFingers + 1) - x) / inTouch.numDownFingers;
				inTouch.centroid.y = (inTouch.centroid.y * (inTouch.numDownFingers + 1) - y) / inTouch.numDownFingers;
			}
		}else if(event.type == SDL_EVENT_FINGER_MOTION){
			const float dx = event.tfinger.dx;
			const float dy = event.tfinger.dy;
			GestureDollarPath* path = &inTouch.dollarPath;
			if(path.numPoints < GESTURE_MAX_DOLLAR_PATH_SIZE){
				path.p[path.numPoints].x = inTouch.centroid.x;
				path.p[path.numPoints].y = inTouch.centroid.y;
				pathDx = (path.p[path.numPoints].x - path.p[path.numPoints - 1].x);
				pathDy = (path.p[path.numPoints].y - path.p[path.numPoints - 1].y);
				path.length += cast(float)SDL_sqrt(pathDx * pathDx + pathDy * pathDy);
				path.numPoints++;
			}
			
			lastP.x = x - dx;
			lastP.y = y - dy;
			lastCentroid = inTouch.centroid;
			
			inTouch.centroid.x += dx / inTouch.numDownFingers;
			inTouch.centroid.y += dy / inTouch.numDownFingers;
			if(inTouch.numDownFingers > 1){
				SDL_FPoint lv;
				SDL_FPoint v;
				lv.x = lastP.x - lastCentroid.x;
				lv.y = lastP.y - lastCentroid.y;
				lDist = SDL_sqrtf(lv.x * lv.x + lv.y * lv.y);
				v.x = x - inTouch.centroid.x;
				v.y = y - inTouch.centroid.y;
				dist = SDL_sqrtf(v.x * v.x + v.y * v.y);
				
				lv.x /= lDist;
				lv.y /= lDist;
				v.x /= dist;
				v.y /= dist;
				dtheta = SDL_atan2f(lv.x * v.y - lv.y * v.x, lv.x * v.x + lv.y * v.y);
				
				dDist = (dist - lDist);
				if(lDist == 0){
					dDist = 0;
					dtheta = 0;
				}
				
				gestureSendMulti(inTouch, dtheta, dDist);
			}else{
			}
		}else if(event.type == SDL_EVENT_FINGER_DOWN){
			inTouch.numDownFingers++;
			inTouch.centroid.x = (inTouch.centroid.x * (inTouch.numDownFingers - 1) + x) / inTouch.numDownFingers;
			inTouch.centroid.y = (inTouch.centroid.y * (inTouch.numDownFingers - 1) + y) / inTouch.numDownFingers;
			
			inTouch.dollarPath.length = 0;
			inTouch.dollarPath.p[0].x = x;
			inTouch.dollarPath.p[0].y = y;
			inTouch.dollarPath.numPoints = 1;
		}
	}
}
