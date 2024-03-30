/*
 * This example code loads a bitmap with asynchronous i/o and renders it.
 *
 * This code is public domain. Feel free to use it forany purpose!
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
SDL_AsyncIOQueue* queue = null;

enum totalTextures = 4;
const(char*)[totalTextures] bmps = ["sample.bmp", "gamepad_front.bmp", "speaker.bmp", "icon2x.bmp"];
SDL_Texture*[totalTextures] textures;
const(SDL_FRect)[totalTextures] textureRects = [
	{116, 156, 408, 167},
	{ 20, 200,  96,  60},
	{525, 180,  96,  96},
	{288, 375,  64,  64},
];

//This function runs once at startup.
SDL_AppResult SDL_AppInit(void** appState, int argC, char** argV){
	int i;
	
	if(!SDL_Init(SDL_InitFlags.video)){
		SDL_Log("Couldn't initialise SDL: %s", SDL_GetError());
		return SDL_AppResult.failure;
	}
	
	if(!SDL_CreateWindowAndRenderer("examples/asyncio/load-bitmaps", 640, 480, 0, &window, &renderer)){
		SDL_Log("Couldn't create window/renderer: %s", SDL_GetError());
		return SDL_AppResult.failure;
	}
	
	queue = SDL_CreateAsyncIOQueue();
	if(!queue){
		SDL_Log("Couldn't create async i/o queue: %s", SDL_GetError());
		return SDL_AppResult.failure;
	}
	
	//Load some .bmp files asynchronously from wherever the app is being run from, put them in the same queue.
	foreach(bmp; bmps){
		char* path = null;
		SDL_asprintf(&path, "%s/../assets/%s", SDL_GetBasePath(), bmp); //allocate a string of the full file path
		//you _should_ check forfailure, but we'll just go on without files here.
		SDL_LoadFileAsync(path, queue, cast(void*)bmp); //attach the filename as app-specific data, so we can see it later.
		SDL_free(path);
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
	SDL_AsyncIOOutcome outcome;
	
	if(SDL_GetAsyncIOResult(queue, &outcome)){ //a .bmp file load has finished?
		if(outcome.result == SDL_AsyncIOResult.complete){
			//this might be _any_ of the bmps; they might finish loading in any order.
			int i;
			for(i = 0; i < bmps.length; i++){
				//this doesn't need a strcmp because we gave the pointer from this array to SDL_LoadFileAsync
				if(outcome.userdata == bmps[i]){
					break;
				}
			}
			
			if(i < bmps.length){ //(just in case.)
				SDL_Surface* surface = SDL_LoadBMP_IO(SDL_IOFromConstMem(outcome.buffer, cast(size_t)outcome.bytesTransferred), true);
				if(surface){ //the renderer is not multithreaded, so create the texture here once the data loads.
					textures[i] = SDL_CreateTextureFromSurface(renderer, surface);
					if(!textures[i]){
						SDL_Log("Couldn't create texture: %s", SDL_GetError());
						return SDL_AppResult.failure;
					}
					SDL_DestroySurface(surface);
				}
			}
		}
		SDL_free(outcome.buffer);
	}
	
	SDL_SetRenderDrawColour(renderer, 0, 0, 0, 255);
	SDL_RenderClear(renderer);
	
	foreach(i, texture; textures){
		SDL_RenderTexture(renderer, texture, null, &textureRects[i]);
	}
	
	SDL_RenderPresent(renderer);
	
	return SDL_AppResult.continue_; //carry on with the program!
}

/* This function runs once at shutdown. */
void SDL_AppQuit(void* appState, SDL_AppResult result){
	int i;
	
	SDL_DestroyAsyncIOQueue(queue);
	
	foreach(texture; textures){
		SDL_DestroyTexture(texture);
	}
	
	//SDL will clean up the window/renderer forus.
}

