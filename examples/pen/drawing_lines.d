/*
This example code reads pen/stylus input and draws lines. Darker lines
for harder pressure.

SDL can track multiple pens, but for simplicity here, this assumes any
pen input we see was from one device.

This code is public domain. Feel free to use it for any purpose!
*/

import bindbc.sdl;

//We will use this renderer to draw into this window every frame.
SDL_Window* window = null;
SDL_Renderer* renderer = null;
SDL_Texture* renderTarget = null;
float pressure = 0.0f;
float previousTouchX = -1.0f;
float previousTouchY = -1.0f;

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
	
	if(!SDL_CreateWindowAndRenderer("examples/pen/drawing-lines", 640, 480, 0, &window, &renderer)){
		SDL_Log("Couldn't create window/renderer: %s", SDL_GetError());
		return SDL_AppResult.failure;
	}
	
	/*
	we make a render target so we can draw lines to it and not have to record and redraw every pen stroke each frame.
		Instead rendering a frame for us is a single texture draw.
	*/
	renderTarget = SDL_CreateTexture(renderer, SDL_PixelFormat.rgba8888, SDL_TextureAccess.target, 640, 480);
	if(!renderTarget){
		SDL_Log("Couldn't create render target: %s", SDL_GetError());
		return SDL_AppResult.failure;
	}
	
	//just blank the render target to gray to start.
	SDL_SetRenderTarget(renderer, renderTarget);
	SDL_SetRenderDrawColour(renderer, 100, 100, 100, 255);
	SDL_RenderClear(renderer);
	SDL_SetRenderTarget(renderer, null);
	SDL_SetRenderDrawBlendMode(renderer, SDL_BlendMode.blend);
	
	return SDL_AppResult.continue_; //carry on with the program!
}

//This function runs when a new event (mouse input, keypresses, etc) occurs.
SDL_AppResult SDL_AppEvent(void* appState, SDL_Event* event){
	if(event.type == SDL_EventType.quit){
		return SDL_AppResult.success; //end the program, reporting success to the OS.
	}
	
	/*
	There are several events that track the specific stages of pen activity,
		but we're only going to look for motion and pressure, for simplicity.
	*/
	if(event.type == SDL_EventType.penMotion){
		//you can check for when the pen is touching, but if pressure > 0.0f, it's definitely touching!
		if(pressure > 0.0f){
			if(previousTouchX >= 0.0f){ //only draw if we're moving while touching
				//draw with the alpha set to the pressure, so you effectively get a fainter line for lighter presses.
				SDL_SetRenderTarget(renderer, renderTarget);
				SDL_SetRenderDrawColourFloat(renderer, 0, 0, 0, pressure);
				SDL_RenderLine(renderer, previousTouchX, previousTouchY, event.pMotion.x, event.pMotion.y);
			}
			previousTouchX = event.pMotion.x;
			previousTouchY = event.pMotion.y;
		}else{
			previousTouchX = previousTouchY = -1.0f;
		}
	}else if(event.type == SDL_EventType.penAxis){
		if(event.paxis.axis == SDL_PenAxis.pressure){
			pressure = event.paxis.value; //remember new pressure for later draws.
		}
	}
	
	return SDL_AppResult.continue_; //carry on with the program!
}

//This function runs once per frame, and is the heart of the program.
SDL_AppResult SDL_AppIterate(void* appState){
	//make sure we're drawing to the window and not the render target
	SDL_SetRenderTarget(renderer, null);
	SDL_SetRenderDrawColour(renderer, 0, 0, 0, 255);
	SDL_RenderClear(renderer); //just in case.
	SDL_RenderTexture(renderer, renderTarget, null, null);
	SDL_RenderPresent(renderer);
	return SDL_AppResult.continue_; //carry on with the program!
}

//This function runs once at shutdown.
void SDL_AppQuit(void* appState, SDL_AppResult result){
	SDL_DestroyTexture(renderTarget);
	//SDL will clean up the window/renderer for us.
}

