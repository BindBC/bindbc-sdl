/*
This example creates an SDL window and renderer, and then draws a scene
to it every frame, while sliding around a clipping rectangle.

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

enum windowWidth = 640;
enum windowHeight = 480;
enum clipRectSize = 250;
enum clipRectSpeed = 200; //pixels per second

//We will use this renderer to draw into this window every frame.
SDL_Window* window = null;
SDL_Renderer* renderer = null;
SDL_Texture* texture = null;
SDL_FPoint clipRectPosition = {0, 0};
SDL_FPoint clipRectDirection = {0, 0};
ulong lastTime = 0;

/*
A lot of this program is examples/renderer/02-primitives, so we have a good
visual that we can slide a clip rect around. The actual new magic in here
is the SDL_SetRenderClipRect() function.
*/

//This function runs once at startup.
SDL_AppResult SDL_AppInit(void** appState, int argC, char** argV){
	SDL_Surface* surface = null;
	char* bmpPath = null;
	
	if(!SDL_Init(SDL_InitFlags.video)){
		SDL_Log("Couldn't initialize SDL: %s", SDL_GetError());
		return SDL_AppResult.failure;
	}
	
	if(!SDL_CreateWindowAndRenderer("examples/renderer/clipRect", windowWidth, windowHeight, 0, &window, &renderer)){
		SDL_Log("Couldn't create window/renderer: %s", SDL_GetError());
		return SDL_AppResult.failure;
	}
	
	clipRectDirection.x = clipRectDirection.y = 1.0f;
	
	lastTime = SDL_GetTicks();
	
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
	const SDL_Rect clipRect = {
		cast(int)SDL_roundf(clipRectPosition.x),
		cast(int)SDL_roundf(clipRectPosition.y),
		clipRectSize,
		clipRectSize,
	};
	const ulong now = SDL_GetTicks();
	const float elapsed = (cast(float)(now - lastTime)) / 1_000.0f; //seconds since last iteration
	const float distance = elapsed * clipRectSpeed;
	
	//Set a new clipping rectangle position
	clipRectPosition.x += distance * clipRectDirection.x;
	if(clipRectPosition.x < 0.0f){
		clipRectPosition.x = 0.0f;
		clipRectDirection.x = 1.0f;
	}else if(clipRectPosition.x >= (windowWidth - clipRectSize)){
		clipRectPosition.x = (windowWidth - clipRectSize) - 1;
		clipRectDirection.x = -1.0f;
	}
	
	clipRectPosition.y += distance * clipRectDirection.y;
	if(clipRectPosition.y < 0.0f){
		clipRectPosition.y = 0.0f;
		clipRectDirection.y = 1.0f;
	}else if(clipRectPosition.y >= (windowHeight - clipRectSize)){
		clipRectPosition.y = (windowHeight - clipRectSize) - 1;
		clipRectDirection.y = -1.0f;
	}
	SDL_SetRenderClipRect(renderer, &clipRect);
	
	lastTime = now;
	
	//okay, now draw!
	
	//Note that SDL_RenderClear is _not_ affected by the clipping rectangle!
	SDL_SetRenderDrawColour(renderer, 33, 33, 33, 255); //grey, full alpha
	SDL_RenderClear(renderer); //start with a blank canvas.
	
	/*
	stretch the texture across the entire window. Only the piece in the
	clipping rectangle will actually render, though!
	*/
	SDL_RenderTexture(renderer, texture, null, null);
	
	SDL_RenderPresent(renderer); //put it all on the screen!
	
	return SDL_AppResult.continue_; //carry on with the program!
}

//This function runs once at shutdown.
void SDL_AppQuit(void* appState, SDL_AppResult result){
	SDL_DestroyTexture(texture);
	//SDL will clean up the window/renderer for us.
}

