/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module bindbc.sdl;

public import bindbc.sdl.config;
public import sdl;
static if(bindSDLImage) public import sdl_image;
static if(bindSDLMixer) public import sdl_mixer;
static if(bindSDLNet)   public import sdl_net;
static if(bindSDLTTF)   public import sdl_ttf;

/*
Putting this here allows me to match the SDL_thread.h interface without any
internal conflicts (which cause a runtime crash when the loader tries to
load the SDL_CreateThread* functions into these aliases--actual functions--
rather than the funcion pointers).
*/
version(Windows){
	alias SDL_CreateThread = SDL_CreateThreadImpl;

	static if(sdlSupport >= SDLSupport.v2_0_9){
		alias SDL_CreateThreadWithStackSize = SDL_CreateThreadWithStackSizeImpl;
	}
}
