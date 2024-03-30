/*
This example creates an SDL window and renderer, and then draws some points
to it every frame.

This code is public domain. Feel free to use it for any purpose!
*/

import bindbc.sdl;

//We will use this renderer to draw into this window every frame.
SDL_Window* window = null;
SDL_Renderer* renderer = null;
ulong lastTime = 0;

enum windowWidth = 640;
enum windowHeight = 480;

enum numPoints = 500;
enum minPixelsPerSecond = 30; //move at least this many pixels per second.
enum maxPixelsPerSecond = 60; //move this many pixels per second at most.

/*
(track everything as parallel arrays instead of a array of structs,
so we can pass the coordinates to the renderer in a single function call.)
*/

/*
Points are plotted as a set of X and Y coordinates.
(0, 0) is the top left of the window, and larger numbers go down
and to the right. This isn't how geometry works, but this is pretty
standard in 2D graphics.
*/
SDL_FPoint[numPoints] points;
float[numPoints] pointSpeeds;

extern(C) nothrow:
mixin(makeSDLMain(dynLoad: q{
	import core.stdc.stdio, bindbc.loader;
	LoadMsg ret = loadSDL();
	if(ret != LoadMsg.success){
		foreach(error; bindbc.loader.errors){
			printf("%s\n", error.message);
		}
	}}));

//This function runs once at startup.
SDL_AppResult SDL_AppInit(void** appState, int argC, char** argV){
	if(!SDL_Init(SDL_InitFlags.video)){
		SDL_Log("Couldn't initialise SDL: %s", SDL_GetError());
		return SDL_AppResult.failure;
	}
	
	if(!SDL_CreateWindowAndRenderer("examples/renderer/points", windowWidth, windowHeight, 0, &window, &renderer)){
		SDL_Log("Couldn't create window/renderer: %s", SDL_GetError());
		return SDL_AppResult.failure;
	}
	
	//set up the data for a bunch of points.
	foreach(i, ref point; points){
		point.x = SDL_randf() * (cast(float)windowWidth);
		point.y = SDL_randf() * (cast(float)windowHeight);
		pointSpeeds[i] = minPixelsPerSecond + (SDL_randf() * (maxPixelsPerSecond - minPixelsPerSecond));
	}
	
	lastTime = SDL_GetTicks();
	
	return SDL_AppResult.continue_; //carry on with the program!
}

//This function runs when a new event (mouse input, keypresses, etc) occurs.
SDL_AppResult SDL_AppEvent(void* appState, SDL_Event* event){
	if(event.type == SDL_EventType.quit){
		return SDL_AppResult.success; //end the program, reporting success to the OS.
	}
	return SDL_AppResult.continue_; //carry on with the program!
}

//This function runs once per frame, and is the heart of the program.
SDL_AppResult SDL_AppIterate(void* appState){
	const ulong now = SDL_GetTicks();
	const float elapsed = (cast(float)(now - lastTime)) / 1_000.0f; //seconds since last iteration
	
	//let's move all our points a little for a new frame.
	foreach(i, ref point; points){
		const float distance = elapsed * pointSpeeds[i];
		point.x += distance;
		point.y += distance;
		if((point.x >= windowWidth) || (point.y >= windowHeight)){
			//off the screen; restart it elsewhere!
			if(SDL_rand(2)){
				point.x = SDL_randf() * (cast(float)windowWidth);
				point.y = 0.0f;
			}else{
				point.x = 0.0f;
				point.y = SDL_randf() * (cast(float)windowHeight);
			}
			pointSpeeds[i] = minPixelsPerSecond + (SDL_randf() * (maxPixelsPerSecond - minPixelsPerSecond));
		}
	}
	
	lastTime = now;
	
	//as you can see from this, rendering draws over whatever was drawn before it.
	SDL_SetRenderDrawColour(renderer, 0, 0, 0, 255); //black, full alpha
	SDL_RenderClear(renderer); //start with a blank canvas.
	SDL_SetRenderDrawColour(renderer, 255, 255, 255, 255); //white, full alpha
	SDL_RenderPoints(renderer, &points[0], points.length); //draw all the points!
	
	/*
	You can also draw single points with SDL_RenderPoint(), but it's
	cheaper (sometimes significantly so) to do them all at once.
	*/
	
	SDL_RenderPresent(renderer); //put it all on the screen!
	
	return SDL_AppResult.continue_; //carry on with the program!
}

//This function runs once at shutdown.
void SDL_AppQuit(void* appState, SDL_AppResult result){
	//SDL will clean up the window/renderer for us.
}

