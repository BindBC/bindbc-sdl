/*
This example code creates an SDL window and renderer, and then clears the
window to a different colour every frame, so you'll effectively get a window
that's smoothly fading between colours.

This code is public domain. Feel free to use it for any purpose!
*/

import bindbc.sdl;

extern(C) nothrow:
mixin(makeSDLMain(dynLoad: q{
	import core.stdc.stdio, bindbc.loader;
	LoadMsg ret = loadSDL();
	if(ret != LoadMsg.success){
		foreach(error; bindbc.loader.errors){
			printf("%s\n", error.message);
		}
	}}));

//We will use this renderer to draw into this window every frame.
SDL_Window* window = null;
SDL_Renderer* renderer = null;

//This function runs once at startup.
SDL_AppResult SDL_AppInit(void** appState, int argC, char** argV){
	if(!SDL_Init(SDL_InitFlags.video)){
		SDL_Log("Couldn't initialise SDL: %s", SDL_GetError());
		return SDL_AppResult.failure;
	}
	
	if(!SDL_CreateWindowAndRenderer("examples/renderer/clear", 640, 480, 0, &window, &renderer)){
		SDL_Log("Couldn't create window/renderer: %s", SDL_GetError());
		return SDL_AppResult.failure;
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
	const double now = (cast(double)SDL_GetTicks()) / 1_000.0; //convert from milliseconds to seconds.
	//choose the colour for the frame we will draw. The sine wave trick makes it fade between colours smoothly.
	const float red = cast(float)(0.5 + 0.5 * SDL_sin(now));
	const float green = cast(float)(0.5 + 0.5 * SDL_sin(now + sdl.piD * 2 / 3));
	const float blue = cast(float)(0.5 + 0.5 * SDL_sin(now + sdl.piD * 4 / 3));
	SDL_SetRenderDrawColourFloat(renderer, red, green, blue, SDL_AlphaOpaqueFloat); //new colour, full alpha.
	
	//clear the window to the draw colour.
	SDL_RenderClear(renderer);
	
	//put the newly-cleared rendering on the screen.
	SDL_RenderPresent(renderer);
	
	return SDL_AppResult.continue_; //carry on with the program!
}

//This function runs once at shutdown.
void SDL_AppQuit(void* appState, SDL_AppResult result){
	//SDL will clean up the window/renderer for us.
}
