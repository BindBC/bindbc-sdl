module bindbc.sdl.bind.sdlclipboard;

import bindbc.sdl.config;
import bindbc.sdl.bind.sdlstdinc : SDL_bool;

version(BindSDL_Static) {
    extern(C) @nogc nothrow {
        int SDL_SetClipboardText(const(char)*);
        char* SDL_GetClipboardText();
        SDL_bool SDL_HasClipboardText();
    }
}
else {
    extern(C) @nogc nothrow {
        alias pSDL_SetClipboardText = int function(const(char)*);
        alias pSDL_GetClipboardText = char* function();
        alias pSDL_HasClipboardText = SDL_bool function();
    }

    __gshared {
        pSDL_SetClipboardText SDL_SetClipboardText;
        pSDL_GetClipboardText SDL_GetClipboardText;
        pSDL_HasClipboardText SDL_HasClipboardText;
    }
}