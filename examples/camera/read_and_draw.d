/*
This example code reads frames from a camera and draws it to the screen.

This is a very simple approach that is often Good Enough. You can get
fancier with this: multiple cameras, front/back facing cameras on phones,
color spaces, choosing formats and framerates...this just requests
_anything_ and goes with what it is handed.

This code is public domain. Feel free to use it for any purpose!
*/

import bindbc.sdl;

//We will use this renderer to draw into this window every frame.
SDL_Window* window = null;
SDL_Renderer* renderer = null;
SDL_Camera* camera = null;
SDL_Texture* texture = null;

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
	SDL_CameraID* devices = null;
	int devCount = 0;
	
	if(!SDL_Init(SDL_InitFlags.video | SDL_InitFlags.camera)){
		SDL_Log("Couldn't initialise SDL: %s", SDL_GetError());
		return SDL_AppResult.failure;
	}
	
	if(!SDL_CreateWindowAndRenderer("examples/camera/read-and-draw", 640, 480, 0, &window, &renderer)){
		SDL_Log("Couldn't create window/renderer: %s", SDL_GetError());
		return SDL_AppResult.failure;
	}
	
	devices = SDL_GetCameras(&devCount);
	if(devices is null){
		SDL_Log("Couldn't enumerate camera devices: %s", SDL_GetError());
		return SDL_AppResult.failure;
	}else if(devCount == 0){
		SDL_ShowSimpleMessageBox(SDL_MessageBoxFlags.error, "Couldn't find any camera devices!", "Please connect a camera and try again.", window);
		return SDL_AppResult.failure;
	}
	
	camera = SDL_OpenCamera(devices[0], null); // just take the first thing we see in any format it wants.
	SDL_free(devices);
	if(camera is null){
		SDL_Log("Couldn't open camera: %s", SDL_GetError());
		return SDL_AppResult.failure;
	}
	
	return SDL_AppResult.continue_; //carry on with the program!
}

//This function runs when a new event (mouse input, keypresses, etc) occurs.
SDL_AppResult SDL_AppEvent(void* appState, SDL_Event* event){
	if(event.type == SDL_EventType.quit){
		return SDL_AppResult.success; //end the program, reporting success to the OS.
	}else if(event.type == SDL_EventType.cameraDeviceApproved){
		SDL_Log("Camera use approved by user!");
	}else if(event.type == SDL_EventType.cameraDeviceDenied){
		SDL_Log("Camera use denied by user!");
		SDL_ShowSimpleMessageBox(SDL_MessageBoxFlags.error, "Camera permission denied!", "User denied access to the camera!", window);
		return SDL_AppResult.failure;
	}
	return SDL_AppResult.continue_; //carry on with the program!
}

//This function runs once per frame, and is the heart of the program.
SDL_AppResult SDL_AppIterate(void* appState){
	ulong timestampNS = 0;
	SDL_Surface* frame = SDL_AcquireCameraFrame(camera, &timestampNS);
	
	if(frame !is null){
		/*
		Some platforms (like Emscripten) don't know _what_ the camera offers
		until the user gives permission, so we build the texture and resize
		the window when we get a first frame from the camera.
		*/
		if(!texture){
			SDL_SetWindowSize(window, frame.w/2, frame.h/2); //Resize the window to match
			texture = SDL_CreateTexture(renderer, frame.format, SDL_TextureAccess.streaming, frame.w, frame.h);
		}
		
		if(texture){
			SDL_UpdateTexture(texture, null, frame.pixels, frame.pitch);
		}
		
		SDL_ReleaseCameraFrame(camera, frame);
	}
	
	SDL_SetRenderDrawColour(renderer, 0x99, 0x99, 0x99, 255);
	SDL_RenderClear(renderer);
	if(texture){ //draw the latest camera frame, if available.
		SDL_RenderTexture(renderer, texture, null, null);
	}
	SDL_RenderPresent(renderer);
	
	return SDL_AppResult.continue_; //carry on with the program!
}

//This function runs once at shutdown.
void SDL_AppQuit(void* appState, SDL_AppResult result){
	SDL_CloseCamera(camera);
	SDL_DestroyTexture(texture);
	//SDL will clean up the window/renderer for us.
}
