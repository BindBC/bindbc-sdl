/*
This example code creates an simple audio stream for playing sound, and
generates a sine wave sound effect for it to play as time goes on. Unlike
the previous example, this uses a callback to generate sound.

This might be the path of least resistance if you're moving an SDL2
program's audio code to SDL3.

This code is public domain. Feel free to use it for any purpose!
*/

import bindbc.sdl;

//We will use this renderer to draw into this window every frame.
SDL_Window* window = null;
SDL_Renderer* renderer = null;
SDL_AudioStream* stream = null;
int totalSamplesGenerated = 0;

extern(C) nothrow:
mixin(makeSDLMain(dynLoad: q{
	import core.stdc.stdio, bindbc.loader;
	LoadMsg ret = loadSDL();
	if(ret != LoadMsg.success){
		foreach(error; bindbc.loader.errors){
			printf("%s\n", error.message);
		}
	}}));

//this function will be called (usually in a background thread) when the audio stream is consuming data.
void FeedTheAudioStreamMore(void* userData, SDL_AudioStream* aStream, int additionalAmount, int totalAmount){
	/*
	totalAmount is how much data the audio stream is eating right now, additionalAmount is how much more it needs
	than what it currently has queued (which might be zero!). You can supply any amount of data here; it will take what
	it needs and use the extra later. If you don't give it enough, it will take everything and then feed silence to the
	hardware for the rest. Ideally, though, we always give it what it needs and no extra, so we aren't buffering more
	than necessary.
	*/
	additionalAmount /= float.sizeof; //convert from bytes to samples
	while(additionalAmount > 0){
		float[128] samples; //this will feed 128 samples each iteration until we have enough.
		import std.algorithm.comparison: min;
		const int total = min(additionalAmount, samples.length);
		
		foreach(ref sample; samples[0..total]){
			/*
			You don't have to care about this math; we're just generating a simple sine wave as we go.
			https://en.wikipedia.org/wiki/Sine_wave
			*/
			const float time = totalSamplesGenerated / 8_000.0f;
			const int sineFreq = 500; //run the wave at 500Hz
			sample = SDL_sinf(6.283_185f * sineFreq * time) * 0.05f;
			totalSamplesGenerated++;
		}
		
		//feed the new data to the stream. It will queue at the end, and trickle out as the hardware needs more data.
		SDL_PutAudioStreamData(aStream, &samples[0], cast(int)(total * float.sizeof));
		additionalAmount -= total; //subtract what we've just fed the stream.
	}
}

//This function runs once at startup.
SDL_AppResult SDL_AppInit(void** appState, int argC, char** argV){
	SDL_AudioSpec spec;
	
	if(!SDL_Init(SDL_InitFlags.video | SDL_InitFlags.audio)){
		SDL_Log("Couldn't initialise SDL: %s", SDL_GetError());
		return SDL_AppResult.failure;
	}
	
	//we don't _need_ a window for audio-only things but it's good policy to have one.
	if(!SDL_CreateWindowAndRenderer("examples/audio/simple-playback-callback", 640, 480, 0, &window, &renderer)){
		SDL_Log("Couldn't create window/renderer: %s", SDL_GetError());
		return SDL_AppResult.failure;
	}
	
	/*
	We're just playing a single thing here, so we'll use the simplified option.
	We are always going to feed audio in as mono, float32 data at 8000Hz.
	The stream will convert it to whatever the hardware wants on the other side.
	*/
	spec.channels = 1;
	spec.format = SDL_AudioFormat.f32;
	spec.freq = 8000;
	stream = SDL_OpenAudioDeviceStream(SDL_AudioDevice.defaultPlayback, &spec, &FeedTheAudioStreamMore, null);
	if(!stream){
		SDL_Log("Couldn't create audio stream: %s", SDL_GetError());
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
	//we're not doing anything with the renderer, so just blank it out.
	SDL_RenderClear(renderer);
	SDL_RenderPresent(renderer);
	
	//all the work of feeding the audio stream is happening in a callback in a background thread.
	
	return SDL_AppResult.continue_; //carry on with the program!
}

//This function runs once at shutdown.
void SDL_AppQuit(void* appState, SDL_AppResult result){
	//SDL will clean up the window/renderer for us.
}
