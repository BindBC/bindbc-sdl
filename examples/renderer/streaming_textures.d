/*
This example creates an SDL window and renderer, and then draws a streaming
texture to it every frame.

This code is public domain. Feel free to use it for any purpose!
*/

import bindbc.sdl;

//We will use this renderer to draw into this window every frame.
SDL_Window* window = null;
SDL_Renderer* renderer = null;
SDL_Texture* texture = null;

enum textureSize = 150;

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
	
	if(!SDL_CreateWindowAndRenderer("examples/renderer/streaming-textures", windowWidth, windowHeight, 0, &window, &renderer)){
		SDL_Log("Couldn't create window/renderer: %s", SDL_GetError());
		return SDL_AppResult.failure;
	}
	
	texture = SDL_CreateTexture(renderer, SDL_PixelFormat.rgba8888, SDL_TextureAccess.streaming, textureSize, textureSize);
	if(!texture){
		SDL_Log("Couldn't create streaming texture: %s", SDL_GetError());
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
	SDL_FRect dstRect;
	const ulong now = SDL_GetTicks();
	SDL_Surface* surface = null;
	
	//we'll have some colour move around over a few seconds.
	const float direction = ((now % 2_000) >= 1_000) ? 1f : -1f;
	const float scale = (cast(float)((cast(int)(now % 1_000)) - 500) / 500f) * direction;
	
	/*
	To update a streaming texture, you need to lock it first. This gets you access to the pixels.
	Note that this is considered a _write-only_ operation: the buffer you get from locking
	might not acutally have the existing contents of the texture, and you have to write to every
	locked pixel!
	*/
	
	/*
	You can use SDL_LockTexture() to get an array of raw pixels, but we're going to use
	SDL_LockTextureToSurface() here, because it wraps that array in a temporary SDL_Surface,
	letting us use the surface drawing functions instead of lighting up individual pixels.
	*/
	if(SDL_LockTextureToSurface(texture, null, &surface)){
		SDL_Rect r;
		SDL_FillSurfaceRect(surface, null, SDL_MapRGB(SDL_GetPixelFormatDetails(surface.format), null, 0, 0, 0)); //make the whole surface black
		r.w = textureSize;
		r.h = textureSize / 10;
		r.x = 0;
		r.y = cast(int)((cast(float)(textureSize - r.h)) * ((scale + 1f) / 2f));
		SDL_FillSurfaceRect(surface, &r, SDL_MapRGB(SDL_GetPixelFormatDetails(surface.format), null, 0, 255, 0)); //make a strip of the surface green
		SDL_UnlockTexture(texture); //upload the changes (and frees the temporary surface)!
	}
	
	//as you can see from this, rendering draws over whatever was drawn before it.
	SDL_SetRenderDrawColour(renderer, 66, 66, 66, 255); //grey, full alpha
	SDL_RenderClear(renderer); //start with a blank canvas.
	
	/*
	Just draw the static texture a few times. You can think of it like a
	stamp, there isn't a limit to the number of times you can draw with it.
	*/
	
	//Centre this one. It'll draw the latest version of the texture we drew while it was locked.
	dstRect.x = (cast(float)(windowWidth - textureSize)) / 2f;
	dstRect.y = (cast(float)(windowHeight - textureSize)) / 2f;
	dstRect.w = dstRect.h = cast(float)textureSize;
	SDL_RenderTexture(renderer, texture, null, &dstRect);
	
	SDL_RenderPresent(renderer); //put it all on the screen!
	
	return SDL_AppResult.continue_; //carry on with the program!
}

//This function runs once at shutdown.
void SDL_AppQuit(void* appState, SDL_AppResult result){
	SDL_DestroyTexture(texture);
	//SDL will clean up the window/renderer for us.
}
