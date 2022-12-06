/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module bindbc.sdl.bind.sdlversion;

import bindbc.sdl.config;

struct SDL_version{
	ubyte major;
	ubyte minor;
	ubyte patch;
	
	int opCmp(SDL_version x){
		if(major != x.major)
			return major - x.major;
		else if(minor != x.minor)
			return minor - x.minor;
		else
			return patch - x.patch;
	}
}

enum SDL_MAJOR_VERSION = sdlSupport.major;
enum SDL_MINOR_VERSION = sdlSupport.minor;
enum SDL_PATCHLEVEL    = sdlSupport.patch;

void SDL_VERSION(SDL_version* x) @nogc nothrow pure{
	pragma(inline, true);
	x.major = SDL_MAJOR_VERSION;
	x.minor = SDL_MINOR_VERSION;
	x.patch = SDL_PATCHLEVEL;
}

enum SDL_VERSIONNUM(ubyte X, ubyte Y, ubyte Z) = X*1000 + Y*100 + Z;
deprecated enum SDL_COMPILEDVERSION = SDL_VERSIONNUM!(SDL_MAJOR_VERSION, SDL_MINOR_VERSION, SDL_PATCHLEVEL);
enum SDL_VERSION_ATLEAST(ubyte X, ubyte Y, ubyte Z) = SDL_COMPILEDVERSION >= SDL_VERSIONNUM!(X, Y, Z);

mixin(joinFnBinds!((){
	string[][] ret;
	ret ~= makeFnBinds!(
		[q{void}, q{SDL_GetVersion}, q{SDL_version* ver}],
		[q{const(char)*}, q{SDL_GetRevision}, q{}],
		[q{int}, q{SDL_GetRevisionNumber}, q{}], //NOTE: this function is deprecated
	);
	return ret;
}()));
