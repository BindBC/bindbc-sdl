
//          Copyright 2018 - 2022 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlversion;

import bindbc.sdl.config;

struct SDL_version {
    ubyte major;
    ubyte minor;
    ubyte patch;
}

enum SDL_MAJOR_VERSION = 2;
enum SDL_MINOR_VERSION = 0;

version(SDL_2022) {
    enum ubyte SDL_PATCHLEVEL = 22;
}
else version(SDL_2020) {
    enum ubyte SDL_PATCHLEVEL = 20;
}
else version(SDL_2018) {
    enum ubyte SDL_PATCHLEVEL = 18;
}
else version(SDL_2016) {
    enum ubyte SDL_PATCHLEVEL = 16;
}
else version(SDL_2014) {
    enum ubyte SDL_PATCHLEVEL = 14;
}
else version(SDL_2012) {
    enum ubyte SDL_PATCHLEVEL = 12;
}
else version(SDL_2010) {
    enum ubyte SDL_PATCHLEVEL = 10;
}
else version(SDL_209) {
    enum ubyte SDL_PATCHLEVEL = 9;
}
else version(SDL_208) {
    enum ubyte SDL_PATCHLEVEL = 8;
}
else version(SDL_207) {
    enum ubyte SDL_PATCHLEVEL = 7;
}
else version(SDL_206) {
    enum ubyte SDL_PATCHLEVEL = 6;
}
else version(SDL_205) {
    enum ubyte SDL_PATCHLEVEL = 5;
}
else version(SDL_204) {
    enum ubyte SDL_PATCHLEVEL = 4;
}
else version(SDL_203) {
    enum ubyte SDL_PATCHLEVEL = 3;
}
else version(SDL_202) {
    enum ubyte SDL_PATCHLEVEL = 2;
}
else version(SDL_201) {
    enum ubyte SDL_PATCHLEVEL = 1;
}
else {
    enum ubyte SDL_PATCHLEVEL = 0;
}

@nogc nothrow pure
void SDL_VERSION(SDL_version* x) {
    pragma(inline, true);
    x.major = SDL_MAJOR_VERSION;
    x.minor = SDL_MINOR_VERSION;
    x.patch = SDL_PATCHLEVEL;
}

enum SDL_VERSIONNUM(ubyte X, ubyte Y, ubyte Z) = X*1000 + Y*100 + Z;
enum SDL_COMPILEDVERSION = SDL_VERSIONNUM!(SDL_MAJOR_VERSION, SDL_MINOR_VERSION, SDL_PATCHLEVEL);
enum SDL_VERSION_ATLEAST(ubyte X, ubyte Y, ubyte Z) = SDL_COMPILEDVERSION >= SDL_VERSIONNUM!(X, Y, Z);

mixin(makeFnBinds!(
    [q{void}, q{SDL_GetVersion}, q{SDL_version* ver}],
    [q{const(char)*}, q{SDL_GetRevision}, q{}],
    [q{int}, q{SDL_GetRevisionNumber}, q{}],
));
