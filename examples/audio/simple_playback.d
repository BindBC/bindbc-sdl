/*
This example code creates an simple audio stream for playing sound, and
generates a sine wave sound effect for it to play as time goes on. This
is the simplest way to get up and running with procedural sound.

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

//This function runs once at startup.
SDL_AppResult SDL_AppInit(void** appState, int argC, char** argV){
	SDL_AudioSpec spec;
	
	if(!SDL_Init(SDL_InitFlags.video | SDL_InitFlags.audio)){
		SDL_Log("Couldn't initialise SDL: %s", SDL_GetError());
		return SDL_AppResult.failure;
	}
	
	//we don't _need_ a window for audio-only things but it's good policy to have one.
	if(!SDL_CreateWindowAndRenderer("examples/audio/simple-playback", 640, 480, 0, &window, &renderer)){
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
	spec.freq = 8_000;
	stream = SDL_OpenAudioDeviceStream(SDL_AudioDevice.defaultPlayback, &spec, null, null);
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
	/*
	see if we need to feed the audio stream more data yet.
	We're being lazy here, but if there's less than half a second queued, generate more.
	A sine wave is unchanging audio--easy to stream--but for video games, you'll want
	to generate significantly _less_ audio ahead of time!
	*/
	enum int minimumAudio = (8_000 * float.sizeof) / 2; //8000 float samples per second. Half of that.
	if(SDL_GetAudioStreamAvailable(stream) < minimumAudio){
		static float[512] samples; //this will feed 512 samples each frame until we get to our maximum.
		
		foreach(ref sample; samples){
			/*
			You don't have to care about this math; we're just generating a simple sine wave as we go.
				https://en.wikipedia.org/wiki/Sine_wave
			*/
			const float time = totalSamplesGenerated / 8_000.0f;
			enum int sineFreq = 500; //run the wave at 500Hz
			sample = SDL_sinf(6.283_185f * sineFreq * time) * 0.05f;
			totalSamplesGenerated++;
		}
		
		//feed the new data to the stream. It will queue at the end, and trickle out as the hardware needs more data.
		SDL_PutAudioStreamData(stream, &samples[0], samples.sizeof);
	}
	
	//we're not doing anything with the renderer, so just blank it out.
	SDL_RenderClear(renderer);
	SDL_RenderPresent(renderer);
	
	return SDL_AppResult.continue_; //carry on with the program!
}

//This function runs once at shutdown.
void SDL_AppQuit(void* appState, SDL_AppResult result){
	//SDL will clean up the window/renderer for us.
}
