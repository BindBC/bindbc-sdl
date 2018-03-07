module bindbc.sdl.bind.sdl;

enum : uint {
    SDL_INIT_TIMER = 0x00000001,
    SDL_INIT_AUDIO = 0x00000010,
    SDL_INIT_VIDEO = 0x00000020,
    SDL_INIT_JOYSTICK = 0x00000200,
    SDL_INIT_HAPTIC = 0x00001000,
    SDL_INIT_GAMECONTROLLER = 0x00002000,
    SDL_INIT_EVENTS = 0x00004000,
    SDL_INIT_NOPARACHUTE = 0x00100000,
    SDL_INIT_EVERYTHING =
                SDL_INIT_TIMER | SDL_INIT_AUDIO | SDL_INIT_VIDEO |
                SDL_INIT_EVENTS | SDL_INIT_JOYSTICK | SDL_INIT_HAPTIC |
                SDL_INIT_GAMECONTROLLER
}

version(BindSDL_Static) {
    extern(C) @nogc nothrow {
        int SDL_Init(uint);
        int SDL_InitSubSystem(uint);
        void SDL_QuitSubSystem(uint);
        uint SDL_WasInit(uint);
        void SDL_Quit();
    }
}
else {
    extern(C) @nogc nothrow {
        alias pSDL_Init = int function(uint);
        alias pSDL_InitSubSystem = int function(uint);
        alias pSDL_QuitSubSystem = void function(uint);
        alias pSDL_WasInit = uint function(uint);
        alias pSDL_Quit = void function();
    }

    __gshared {
        pSDL_Init SDL_Init;
        pSDL_InitSubSystem SDL_InitSubSystem;
        pSDL_QuitSubSystem SDL_QuitSubSystem;
        pSDL_WasInit SDL_WasInit;
        pSDL_Quit SDL_Quit;
    }
}