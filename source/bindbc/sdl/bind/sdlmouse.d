
//          Copyright 2018 - 2022 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlmouse;

import bindbc.sdl.config;
import bindbc.sdl.bind.sdlstdinc : SDL_bool;
import bindbc.sdl.bind.sdlsurface : SDL_Surface;
import bindbc.sdl.bind.sdlvideo : SDL_Window;

struct SDL_Cursor;

enum SDL_SystemCursor {
    SDL_SYSTEM_CURSOR_ARROW,
    SDL_SYSTEM_CURSOR_IBEAM,
    SDL_SYSTEM_CURSOR_WAIT,
    SDL_SYSTEM_CURSOR_CROSSHAIR,
    SDL_SYSTEM_CURSOR_WAITARROW,
    SDL_SYSTEM_CURSOR_SIZENWSE,
    SDL_SYSTEM_CURSOR_SIZENESW,
    SDL_SYSTEM_CURSOR_SIZEWE,
    SDL_SYSTEM_CURSOR_SIZENS,
    SDL_SYSTEM_CURSOR_SIZEALL,
    SDL_SYSTEM_CURSOR_NO,
    SDL_SYSTEM_CURSOR_HAND,
    SDL_NUM_SYSTEM_CURSORS
}
mixin(expandEnum!SDL_SystemCursor);

enum SDL_BUTTON(ubyte x) = 1 << (x-1);

enum : ubyte {
    SDL_BUTTON_LEFT = 1,
    SDL_BUTTON_MIDDLE = 2,
    SDL_BUTTON_RIGHT = 3,
    SDL_BUTTON_X1 = 4,
    SDL_BUTTON_X2 = 5,
    SDL_BUTTON_LMASK = SDL_BUTTON!(SDL_BUTTON_LEFT),
    SDL_BUTTON_MMASK = SDL_BUTTON!(SDL_BUTTON_MIDDLE),
    SDL_BUTTON_RMASK = SDL_BUTTON!(SDL_BUTTON_RIGHT),
    SDL_BUTTON_X1MASK = SDL_BUTTON!(SDL_BUTTON_X1),
    SDL_BUTTON_X2MASK = SDL_BUTTON!(SDL_BUTTON_X2),
}

static if(sdlSupport >= SDLSupport.sdl204) {
    enum SDL_MouseWheelDirection {
        SDL_MOUSEWHEEL_NORMAL,
        SDL_MOUSEWHEEL_FLIPPED,
    }
    mixin(expandEnum!SDL_MouseWheelDirection);
}

mixin(makeFnBinds!(
    [q{SDL_Window*}, q{SDL_GetMouseFocus}, q{}],
    [q{uint}, q{SDL_GetMouseState}, q{int* x, int* y}],
    [q{uint}, q{SDL_GetRelativeMouseState}, q{int* x, int* y}],
    [q{void}, q{SDL_WarpMouseInWindow}, q{SDL_Window* window, int x, int y}],
    [q{int}, q{SDL_SetRelativeMouseMode}, q{SDL_bool enabled}],
    [q{SDL_bool}, q{SDL_GetRelativeMouseMode}, q{}],
    [q{SDL_Cursor*}, q{SDL_CreateCursor}, q{const(ubyte)* data, const(ubyte)* mask, int w, int h, int hot_x, int hot_y}],
    [q{SDL_Cursor*}, q{SDL_CreateColorCursor}, q{SDL_Surface* surface, int hot_x, int hot_y}],
    [q{SDL_Cursor*}, q{SDL_CreateSystemCursor}, q{SDL_SystemCursor id}],
    [q{void}, q{SDL_SetCursor}, q{SDL_Cursor* cursor}],
    [q{SDL_Cursor*}, q{SDL_GetCursor}, q{}],
    [q{SDL_Cursor*}, q{SDL_GetDefaultCursor}, q{}],
    [q{void}, q{SDL_FreeCursor}, q{SDL_Cursor* cursor}],
    [q{int}, q{SDL_ShowCursor}, q{int toggle}],
));

static if(sdlSupport >= SDLSupport.sdl204) {
    mixin(makeFnBinds!(
        [q{int}, q{SDL_CaptureMouse}, q{SDL_bool enabled}],
        [q{uint}, q{SDL_GetGlobalMouseState}, q{int* x, int* y}],
        [q{void}, q{SDL_WarpMouseGlobal}, q{int x, int y}],
    ));
}
