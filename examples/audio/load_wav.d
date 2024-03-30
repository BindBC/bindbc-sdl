/*
This example code creates an simple audio stream for playing sound, and
loads a .wav file that is pushed through the stream in a loop.

This code is public domain. Feel free to use it for any purpose!

The .wav file is a sample from Will Provost's song, The Living Proof,
used with permission.

 *    From the album The Living Proof
 *    Publisher: 5 Guys Named Will
 *    Copyright 1996 Will Provost
 *    https://itunes.apple.com/us/album/the-living-proof/id4153978
 *    http://www.amazon.com/The-Living-Proof-Will-Provost/dp/B00004R8RH
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
SDL_AudioStream* stream = null;
ubyte* wavData = null;
uint wavDataLen = 0;

//This function runs once at startup.
SDL_AppResult SDL_AppInit(void** appState, int argC, char** argV){
	SDL_AudioSpec spec;
	char* wavPath = null;
	
	if(!SDL_Init(SDL_InitFlags.video | SDL_InitFlags.audio)){
		SDL_Log("Couldn't initialise SDL: %s", SDL_GetError());
		return SDL_AppResult.failure;
	}
	
	//we don't _need_ a window for audio-only things but it's good policy to have one.
	if(!SDL_CreateWindowAndRenderer("examples/audio/load-wav", 640, 480, 0, &window, &renderer)){
		SDL_Log("Couldn't create window/renderer: %s", SDL_GetError());
		return SDL_AppResult.failure;
	}
	
	//Load the .wav file from wherever the app is being run from.
	SDL_asprintf(&wavPath, "%s/../assets/sample.wav", SDL_GetBasePath()); //allocate a string of the full file path
	if(!SDL_LoadWAV(wavPath, &spec, &wavData, &wavDataLen)){
		SDL_Log("Couldn't load .wav file: %s", SDL_GetError());
		return SDL_AppResult.failure;
	}
	
	SDL_free(wavPath); //done with this string.
	
	//Create our audio stream in the same format as the .wav file. It'll convert to what the audio hardware wants.
	stream = SDL_OpenAudioDeviceStream(SDL_AudioDevice.defaultPlayback, &spec, null, null);
	if(!stream){
		SDL_Log("Couldn't create audio stream: %s", SDL_GetError());
		return SDL_AppResult.failure;
	}
	if(!SDL_SetAudioStreamGain(stream, 0.05f)){
		SDL_Log("Couldn't set the audio stream's gain: %s", SDL_GetError());
		return SDL_AppResult.failure;
	}
	
	//SDL_OpenAudioDeviceStream starts the device paused. You have to tell it to start!
	SDL_ResumeAudioStreamDevice(stream);
	
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
	/*
	see if we need to feed the audio stream more data yet.
	We're being lazy here, but if there's less than the entire wav file left to play,
	just shove a whole copy of it into the queue, so we always have _tons_ of
	data queued for playback.
	*/
	if(SDL_GetAudioStreamAvailable(stream) < cast(int)wavDataLen){
		//feed more data to the stream. It will queue at the end, and trickle out as the hardware needs more data.
		SDL_PutAudioStreamData(stream, wavData, wavDataLen);
	}
	
	//we're not doing anything with the renderer, so just blank it out.
	SDL_RenderClear(renderer);
	SDL_RenderPresent(renderer);
	
	return SDL_AppResult.continue_; //carry on with the program!
}

//This function runs once at shutdown.
void SDL_AppQuit(void* appState, SDL_AppResult result){
	SDL_free(wavData); //strictly speaking, this isn't necessary because the process is ending, but it's good policy.
	//SDL will clean up the window/renderer for us.
}
