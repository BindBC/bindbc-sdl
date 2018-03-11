module bindbc.sdl.bind.sdlplatform;

version(BindSDL_Static) {
    extern(C) @nogc nothrow {
        const(char)* SDL_GetPlatform();
    }
}
else {
    extern(C) @nogc nothrow {
        alias pSDL_GetPlatform = const(char)* function();
    }

    __gshared {
        pSDL_GetPlatform SDL_GetPlatform;
    }
}