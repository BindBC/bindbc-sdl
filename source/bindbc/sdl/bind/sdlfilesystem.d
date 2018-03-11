module bindbc.sdl.bind.sdlfilesystem;

import bindbc.sdl.config;

version(BindSDL_Static){
    extern(C) @nogc nothrow {
        static if(sdlSupport >= SDLSupport.sdl201) {
            char* SDL_GetBasePath();
            char* SDL_GetPrefPath(const(char)* org,const(char)* app);
        }
    }
}
else {
    static if(sdlSupport >= SDLSupport.sdl201) {
        extern(C) @nogc nothrow {
            alias pSDL_GetBasePath = char* function();
            alias pSDL_GetPrefPath = char* function(const(char)* org,const(char)* app);
        }

        __gshared {
            pSDL_GetBasePath SDL_GetBasePath;
            pSDL_GetPrefPath SDL_GetPrefPath;
        }
    }
}
