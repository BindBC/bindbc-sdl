/*
Example demonstrating SDL3_mixer API.

Adapted from `load-and-play.c` example in SDL3_mixer repo, and renderer/lines.d in this repo.

Author: Eric Yoon (2026-05-29)
License: Public Domain
*/

import bindbc.sdl;

SDL_Window* window = null;
SDL_Renderer* renderer = null;

extern(C) nothrow:
mixin(makeSDLMain(dynLoad: q{
	import core.stdc.stdio, bindbc.loader;
	LoadMsg sdlRes = loadSDL();
	if(sdlRes != LoadMsg.success){
		foreach(error; bindbc.loader.errors){
			printf("%s\n", error.message);
		}
    }
	LoadMsg mixerRes = loadSDLMixer("libSDL3_mixer.dylib");
	if(mixerRes != LoadMsg.success){
		foreach(error; bindbc.loader.errors){
			printf("%s\n", error.message);
		}
	}
	printf("SDL and SDL_mixer loaded successfully.\n");
}));

SDL_AppResult SDL_AppInit(void** appState, int argC, char** argV){
	if(!SDL_Init(SDL_InitFlags.video)){
		SDL_Log("Couldn't initialise SDL: %s", SDL_GetError());
		return SDL_AppResult.failure;
	}
	if(!MIX_Init()){
		SDL_Log("Couldn't initialise SDL_mixer: %s", SDL_GetError());
		return SDL_AppResult.failure;
	}

	if(!SDL_CreateWindowAndRenderer("examples/renderer/lines", 640, 480, 0, &window, &renderer)){
		SDL_Log("Couldn't create window/renderer: %s", SDL_GetError());
		return SDL_AppResult.failure;
	}

	SDL_AudioSpec audioSpec = SDL_AudioSpec(SDL_AUDIO_U8, 2, 44100);
	MIX_Mixer* mixer = MIX_CreateMixerDevice(SDL_AUDIO_DEVICE_DEFAULT_PLAYBACK, &audioSpec);
	if(!mixer) {
		SDL_Log("Couldn't open audio: %s", SDL_GetError());
		return SDL_AppResult.failure;
	}
	
	MIX_Audio* audio = MIX_LoadAudio(mixer, "../assets/sample.wav", false);
	if(!audio) {
		SDL_Log("Couldn't load audio: %s", SDL_GetError());
		return SDL_AppResult.failure;
	}

	MIX_Track* track = MIX_CreateTrack(mixer);
	if(!track) {
		SDL_Log("Couldn't create track: %s", SDL_GetError());
		return SDL_AppResult.failure;
	}

	MIX_SetTrackAudio(track, audio);

	MIX_PlayTrack(track, 0);

	return SDL_AppResult.continue_;
}

SDL_AppResult SDL_AppEvent(void* appState, SDL_Event* event){
	if(event.type == SDL_EventType.quit){
		return SDL_AppResult.success;
	}
	return SDL_AppResult.continue_;
}

SDL_AppResult SDL_AppIterate(void* appState){
	return SDL_AppResult.continue_; 
}

void SDL_AppQuit(void* appState, SDL_AppResult result){
}
