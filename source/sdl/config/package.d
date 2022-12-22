/+
+            Copyright 2022 – 2023 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.config;

import bindbc.sdl.config;

version(iOS){
	version = CocoaTouch;
}else version(TVOS){
	version = CocoaTouch;
}

private template Version(string x){
	mixin(q{version(}~x~q{){
		enum Version = true;
	}else{
		enum Version = false;
	}});
}

static if(sdlSupport >= SDLSupport.v2_0_3 && Version!`WinRT`){
	public import sdl.config.winrt;
}else static if(sdlSupport >= SDLSupport.v2_24 && Version!`WinGDK`){
	public import sdl.config.wingdk;
}else static if(sdlSupport >= SDLSupport.v2_24 && (Version!`XboxOne` || Version!`XboxSeries`)){
	public import sdl.config.xbox;
}else static if(sdlSupport < SDLSupport.v2_0_22 && Version!`PSP`){
	public import sdl.config.psp;
}else static if(sdlSupport >= SDLSupport.v2_0_9 && Version!`OS2`){
	public import sdl.config.os2;
}else version(Windows){
	public import sdl.config.windows;
}else version(OSX){
	public import sdl.config.macosx;
}else version(CocoaTouch){
	public import sdl.config.iphoneos;
}else version(Android){
	public import sdl.config.android;
}else static if(sdlSupport >= SDLSupport.v2_0_18 && Version!`Emscripten`){
	public import sdl.config.emscripten;
}else static if(sdlSupport >= SDLSupport.v2_24 && Version!`NGage`){
	public import sdl.config.ngage;
}else{
	public import sdl.config.minimal;
}
