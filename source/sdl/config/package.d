/+
+            Copyright 2022 – 2023 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.config;

version(iOS){
	version = Cocoa;
}else version(TVOS){
	version = Cocoa;
}

version(WinRT){
	public import sdl.config.winrt;
}else version(PSP){
	public import sdl.config.psp;
}else version(OS2){
	public import sdl.config.os2;
}else version(Windows){
	public import sdl.config.windows;
}else version(OSX){
	public import sdl.config.macosx;
}else version(Cocoa){
	public import sdl.config.iphoneos;
}else version(Android){
	public import sdl.config.android;
}else{
	public import sdl.config.minimal;
}
