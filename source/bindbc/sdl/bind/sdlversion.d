/+
            Copyright 2022 – 2023 Aya Partridge
          Copyright 2018 - 2022 Michael D. Parker
 Distributed under the Boost Software License, Version 1.0.
     (See accompanying file LICENSE_1_0.txt or copy at
           http://www.boost.org/LICENSE_1_0.txt)
+/
module bindbc.sdl.bind.sdlversion;

import bindbc.sdl.config;

struct SDL_version{
	ubyte major;
	ubyte minor;
	ubyte patch;
}

enum SDL_MAJOR_VERSION = 2;

version(SDL_2260){
	enum SDL_MINOR_VERSION = 26;
	enum SDL_PATCHLEVEL = 0;
}else version(SDL_2240){
	enum SDL_MINOR_VERSION = 24;
	enum SDL_PATCHLEVEL = 0;
}else{
	enum SDL_MINOR_VERSION = 0;
	     version(SDL_2022) enum SDL_PATCHLEVEL = 22;
	else version(SDL_2020) enum SDL_PATCHLEVEL = 20;
	else version(SDL_2018) enum SDL_PATCHLEVEL = 18;
	else version(SDL_2016) enum SDL_PATCHLEVEL = 16;
	else version(SDL_2014) enum SDL_PATCHLEVEL = 14;
	else version(SDL_2012) enum SDL_PATCHLEVEL = 12;
	else version(SDL_2010) enum SDL_PATCHLEVEL = 10;
	else version(SDL_209)  enum SDL_PATCHLEVEL = 9;
	else version(SDL_208)  enum SDL_PATCHLEVEL = 8;
	else version(SDL_207)  enum SDL_PATCHLEVEL = 7;
	else version(SDL_206)  enum SDL_PATCHLEVEL = 6;
	else version(SDL_205)  enum SDL_PATCHLEVEL = 5;
	else version(SDL_204)  enum SDL_PATCHLEVEL = 4;
	else version(SDL_203)  enum SDL_PATCHLEVEL = 3;
	else version(SDL_202)  enum SDL_PATCHLEVEL = 2;
	else version(SDL_201)  enum SDL_PATCHLEVEL = 1;
	else                   enum SDL_PATCHLEVEL = 0;
}

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
