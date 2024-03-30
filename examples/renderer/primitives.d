/*
This example creates an SDL window and renderer, and then draws some lines,
rectangles and points to it every frame.

This code is public domain. Feel free to use it for any purpose!
*/

import bindbc.sdl;

//We will use this renderer to draw into this window every frame.
SDL_Window* window = null;
SDL_Renderer* renderer = null;
SDL_FPoint[500] points;

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
	int i;
	
	if(!SDL_Init(SDL_InitFlags.video)){
		SDL_Log("Couldn't initialise SDL: %s", SDL_GetError());
		return SDL_AppResult.failure;
	}
	
	if(!SDL_CreateWindowAndRenderer("examples/renderer/primitives", 640, 480, 0, &window, &renderer)){
		SDL_Log("Couldn't create window/renderer: %s", SDL_GetError());
		return SDL_AppResult.failure;
	}
	
	//set up some random points
	for(i = 0; i < points.length; i++){
		points[i].x = (SDL_randf() * 440f) + 100f;
		points[i].y = (SDL_randf() * 280f) + 100f;
	}
	
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
	SDL_FRect rect;
	
	//as you can see from this, rendering draws over whatever was drawn before it.
	SDL_SetRenderDrawColour(renderer, 33, 33, 33, 255); //dark gray, full alpha
	SDL_RenderClear(renderer); //start with a blank canvas.
	
	//draw a filled rectangle in the middle of the canvas.
	SDL_SetRenderDrawColour(renderer, 0, 0, 255, 255); //blue, full alpha
	rect.x = rect.y = 100;
	rect.w = 440;
	rect.h = 280;
	SDL_RenderFillRect(renderer, &rect);
	
	//draw some points across the canvas.
	SDL_SetRenderDrawColour(renderer, 255, 0, 0, 255); //red, full alpha
	SDL_RenderPoints(renderer, &points[0], points.length);
	
	//draw a unfilled rectangle in-set a little bit.
	SDL_SetRenderDrawColour(renderer, 0, 255, 0, 255); //green, full alpha
	rect.x += 30;
	rect.y += 30;
	rect.w -= 60;
	rect.h -= 60;
	SDL_RenderRect(renderer, &rect);
	
	//draw two lines in an X across the whole canvas.
	SDL_SetRenderDrawColour(renderer, 255, 255, 0, 255); //yellow, full alpha
	SDL_RenderLine(renderer, 0, 0, 640, 480);
	SDL_RenderLine(renderer, 0, 480, 640, 0);
	
	SDL_RenderPresent(renderer); //put it all on the screen!
	
	return SDL_AppResult.continue_; //carry on with the program!
}

//This function runs once at shutdown.
void SDL_AppQuit(void* appState, SDL_AppResult result){
	//SDL will clean up the window/renderer for us.
}
