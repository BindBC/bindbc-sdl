/*
This example creates an SDL window and renderer, and then draws some
rectangles to it every frame.

This code is public domain. Feel free to use it for any purpose!
*/

import bindbc.sdl;

//We will use this renderer to draw into this window every frame.
SDL_Window* window = null;
SDL_Renderer* renderer = null;

enum windowWidth = 640;
enum windowHeight = 480;

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
	
	if(!SDL_CreateWindowAndRenderer("examples/renderer/rectangles", windowWidth, windowHeight, 0, &window, &renderer)){
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
	SDL_FRect[16] rects;
	const ulong now = SDL_GetTicks();
	int i;
	
	//we'll have the rectangles grow and shrink over a few seconds.
	const float direction = ((now % 2_000) >= 1_000) ? 1f : -1f;
	const float scale = (cast(float)((cast(int)(now % 1_000)) - 500) / 500f) * direction;
	
	//as you can see from this, rendering draws over whatever was drawn before it.
	SDL_SetRenderDrawColour(renderer, 0, 0, 0, 255); //black, full alpha
	SDL_RenderClear(renderer); //start with a blank canvas.
	
	/*
	Rectangles are comprised of set of X and Y coordinates, plus width and
	height. (0, 0) is the top left of the window, and larger numbers go
	down and to the right. This isn't how geometry works, but this is
	pretty standard in 2D graphics.
	*/
	
	//Let's draw a single rectangle (square, really).
	rects[0].x = rects[0].y = 100;
	rects[0].w = rects[0].h = 100 + (100 * scale);
	SDL_SetRenderDrawColour(renderer, 255, 0, 0, 255); //red, full alpha
	SDL_RenderRect(renderer, &rects[0]);
	
	//Now let's draw several rectangles with one function call.
	for(i = 0; i < 3; i++){
		const float size = (i+1) * 50f;
		rects[i].w = rects[i].h = size + (size * scale);
		rects[i].x = (windowWidth - rects[i].w) / 2; //centre it.
		rects[i].y = (windowHeight - rects[i].h) / 2; //centre it.
	}
	SDL_SetRenderDrawColour(renderer, 0, 255, 0, 255); //green, full alpha
	SDL_RenderRects(renderer, &rects[0], 3); //draw three rectangles at once
	
	//those were rectangle _outlines_, really. You can also draw _filled_ rectangles!
	rects[0].x = 400;
	rects[0].y = 50;
	rects[0].w = 100 + (100 * scale);
	rects[0].h = 50 + (50 * scale);
	SDL_SetRenderDrawColour(renderer, 0, 0, 255, 255); //blue, full alpha
	SDL_RenderFillRect(renderer, &rects[0]);
	
	//...and also fill a bunch of rectangles at once...
	for(i = 0; i < rects.length; i++){
		const float w = cast(float)(windowWidth / rects.length);
		const float h = i * 8f;
		rects[i].x = i * w;
		rects[i].y = windowHeight - h;
		rects[i].w = w;
		rects[i].h = h;
	}
	SDL_SetRenderDrawColour(renderer, 255, 255, 255, 255); //white, full alpha
	SDL_RenderFillRects(renderer, &rects[0], rects.length);
	
	SDL_RenderPresent(renderer); //put it all on the screen!
	
	return SDL_AppResult.continue_; //carry on with the program!
}

//This function runs once at shutdown.
void SDL_AppQuit(void* appState, SDL_AppResult result){
	//SDL will clean up the window/renderer for us.
}
