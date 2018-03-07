module bindbc.sdl.bind.sdlloadso;

version(BindSDL_Static){
    extern(C) @nogc nothrow {
        void* SDL_LoadObject(const(char)*);
        void* SDL_LoadFunction(void*,const(char*));
        void SDL_UnloadObject(void*);
    }
}
else {
    extern(C) @nogc nothrow {
        alias pSDL_LoadObject = void* function(const(char)*);
        alias pSDL_LoadFunction = void* function(void*,const(char*));
        alias pSDL_UnloadObject = void function(void*);
    }

    __gshared {
        pSDL_LoadObject SDL_LoadObject;
        pSDL_LoadFunction SDL_LoadFunction;
        pSDL_UnloadObject SDL_UnloadObject;
    }
}