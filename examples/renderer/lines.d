/*
This example creates an SDL window and renderer, and then draws some lines
to it every frame.

This code is public domain. Feel free to use it for any purpose!
*/

import bindbc.sdl;

//We will use this renderer to draw into this window every frame.
SDL_Window* window = null;
SDL_Renderer* renderer = null;

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
	
	if(!SDL_CreateWindowAndRenderer("examples/renderer/lines", 640, 480, 0, &window, &renderer)){
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
	int i;
	
	/*
	Lines (line segments, really) are drawn in terms of points: a set of
	X and Y coordinates, one set for each end of the line.
	(0, 0) is the top left of the window, and larger numbers go down
	and to the right. This isn't how geometry works, but this is pretty
	standard in 2D graphics.
	*/
	static const(SDL_FPoint)[] linePoints = [
		{100, 354}, {220, 230}, {140, 230}, {320, 100}, {500, 230},
		{420, 230}, {540, 354}, {400, 354}, {100, 354}
	];
	
	//as you can see from this, rendering draws over whatever was drawn before it.
	SDL_SetRenderDrawColour(renderer, 100, 100, 100, 255); //grey, full alpha
	SDL_RenderClear(renderer); //start with a blank canvas.
	
	//You can draw lines, one at a time, like these brown ones...
	SDL_SetRenderDrawColour(renderer, 127, 49, 32, 255);
	SDL_RenderLine(renderer, 240, 450, 400, 450);
	SDL_RenderLine(renderer, 240, 356, 400, 356);
	SDL_RenderLine(renderer, 240, 356, 240, 450);
	SDL_RenderLine(renderer, 400, 356, 400, 450);
	
	//You can also draw a series of connected lines in a single batch...
	SDL_SetRenderDrawColour(renderer, 0, 255, 0, 255);
	SDL_RenderLines(renderer, &linePoints[0], cast(int)linePoints.length);
	
	//here's a bunch of lines drawn out from a centre point in a circle.
	//we randomise the colour of each line, so it functions as animation.
	for(i = 0; i < 360; i++){
		const float size = 30f;
		const float x = 320f;
		const float y = 95f - (size / 2f);
		SDL_SetRenderDrawColour(renderer, cast(ubyte)SDL_rand(256), cast(ubyte)SDL_rand(256), cast(ubyte)SDL_rand(256), 255);
		SDL_RenderLine(renderer, x, y, x + SDL_sinf(cast(float)i) * size, y + SDL_cosf(cast(float)i) * size);
	}
	
	SDL_RenderPresent(renderer); //put it all on the screen!
	
	return SDL_AppResult.continue_; //carry on with the program!
}

//This function runs once at shutdown.
void SDL_AppQuit(void* appState, SDL_AppResult result){
	//SDL will clean up the window/renderer for us.
}
