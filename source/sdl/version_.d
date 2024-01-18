/+
+            Copyright 2022 – 2024 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.version_;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

enum SDL_MAJOR_VERSION = sdlSupport.major;
enum SDL_MINOR_VERSION = sdlSupport.minor;
enum SDL_PATCHLEVEL    = sdlSupport.patch;

pragma(inline, true) void SDL_VERSION(SDL_version* x) nothrow @nogc pure @safe{
	x.major = SDL_MAJOR_VERSION;
	x.minor = SDL_MINOR_VERSION;
	x.patch = SDL_PATCHLEVEL;
}

deprecated("Please use SDL_version() instead")
	enum SDL_VERSIONNUM(ubyte x, ubyte y, ubyte z) = x*1000 + y*100 + z;

deprecated("Please use SDL_VERSION_ATLEAST or SDL_version() instead")
	enum SDL_COMPILEDVERSION = SDL_version(SDL_MAJOR_VERSION, SDL_MINOR_VERSION, SDL_PATCHLEVEL);

pragma(inline, true) nothrow @nogc{
	bool SDL_VERSION_ATLEAST(ubyte x, ubyte y, ubyte z){ return SDL_version(SDL_MAJOR_VERSION, SDL_MINOR_VERSION, SDL_PATCHLEVEL) >= SDL_version(x, y, z); }
}
deprecated("Please use the non-template variant instead"){
	enum SDL_VERSION_ATLEAST(ubyte x, ubyte y, ubyte z) = SDL_version(SDL_MAJOR_VERSION, SDL_MINOR_VERSION, SDL_PATCHLEVEL) >= SDL_version(x, y, z);
}

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{void}, q{SDL_GetVersion}, q{SDL_version* ver}},
		{q{const(char)*}, q{SDL_GetRevision}, q{}},
		{q{int}, q{SDL_GetRevisionNumber}, q{}}, //NOTE: this function is deprecated
	];
	return ret;
}()));
