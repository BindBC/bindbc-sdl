/*
This example creates an SDL window and renderer, and then draws some
textures to it every frame, adjusting the viewport.

This code is public domain. Feel free to use it for any purpose!
*/

import bindbc.sdl;

//We will use this renderer to draw into this window every frame.
SDL_Window* window = null;
SDL_Renderer* renderer = null;
SDL_Texture* texture = null;
int textureWidth = 0;
int textureHeight = 0;

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
	SDL_Surface* surface = null;
	char* bmpPath = null;
	
	if(!SDL_Init(SDL_InitFlags.video)){
		SDL_Log("Couldn't initialise SDL: %s", SDL_GetError());
		return SDL_AppResult.failure;
	}
	
	if(!SDL_CreateWindowAndRenderer("examples/renderer/viewport", windowWidth, windowHeight, 0, &window, &renderer)){
		SDL_Log("Couldn't create window/renderer: %s", SDL_GetError());
		return SDL_AppResult.failure;
	}
	
	/*
	Textures are pixel data that we upload to the video hardware for fast drawing. Lots of 2D
	engines refer to these as "sprites." We'll do a static texture (upload once, draw many
	times) with data from a bitmap file.
	*/
	
	/*
	SDL_Surface is pixel data the CPU can access. SDL_Texture is pixel data the GPU can access.
	Load a .bmp into a surface, move it to a texture from there.
	*/
	SDL_asprintf(&bmpPath, "%s/../assets/sample.bmp", SDL_GetBasePath()); //allocate a string of the full file path
	surface = SDL_LoadBMP(bmpPath);
	if(!surface){
		SDL_Log("Couldn't load bitmap: %s", SDL_GetError());
		return SDL_AppResult.failure;
	}
	
	SDL_free(bmpPath); //done with this, the file is loaded.
	
	textureWidth = surface.w;
	textureHeight = surface.h;
	
	texture = SDL_CreateTextureFromSurface(renderer, surface);
	if(!texture){
		SDL_Log("Couldn't create static texture: %s", SDL_GetError());
		return SDL_AppResult.failure;
	}
	
	SDL_DestroySurface(surface); //done with this, the texture has a copy of the pixels now.
	
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
	SDL_FRect dstRect ={ 0, 0, cast(float)textureWidth, cast(float)textureHeight };
	SDL_Rect viewport;
	
	/*
	Setting a viewport has the effect of limiting the area that rendering
	can happen, and making coordinate (0, 0) live somewhere else in the
	window. It does _not_ scale rendering to fit the viewport.
	*/
	
	//as you can see from this, rendering draws over whatever was drawn before it.
	SDL_SetRenderDrawColour(renderer, 0, 0, 0, 255); //black, full alpha
	SDL_RenderClear(renderer); //start with a blank canvas.
	
	//Draw once with the whole window as the viewport.
	viewport.x = 0;
	viewport.y = 0;
	viewport.w = windowWidth / 2;
	viewport.h = windowHeight / 2;
	SDL_SetRenderViewport(renderer, null); //null means "use the whole window"
	SDL_RenderTexture(renderer, texture, null, &dstRect);
	
	//top right quarter of the window.
	viewport.x = windowWidth / 2;
	viewport.y = windowHeight / 2;
	viewport.w = windowWidth / 2;
	viewport.h = windowHeight / 2;
	SDL_SetRenderViewport(renderer, &viewport);
	SDL_RenderTexture(renderer, texture, null, &dstRect);
	
	//bottom 20% of the window. Note it clips the width!
	viewport.x = 0;
	viewport.y = windowHeight - (windowHeight / 5);
	viewport.w = windowWidth / 5;
	viewport.h = windowHeight / 5;
	SDL_SetRenderViewport(renderer, &viewport);
	SDL_RenderTexture(renderer, texture, null, &dstRect);
	
	//what happens if you try to draw above the viewport? It should clip!
	viewport.x = 100;
	viewport.y = 200;
	viewport.w = windowWidth;
	viewport.h = windowHeight;
	SDL_SetRenderViewport(renderer, &viewport);
	dstRect.y = -50;
	SDL_RenderTexture(renderer, texture, null, &dstRect);
	
	SDL_RenderPresent(renderer); //put it all on the screen!
	
	return SDL_AppResult.continue_; //carry on with the program!
}

//This function runs once at shutdown.
void SDL_AppQuit(void* appState, SDL_AppResult result){
	SDL_DestroyTexture(texture);
	//SDL will clean up the window/renderer for us.
}
