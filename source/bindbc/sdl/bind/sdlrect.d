
//          Copyright 2018 - 2022 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlrect;

import std.math : fabs;

import bindbc.sdl.config;
import bindbc.sdl.bind.sdlstdinc;

struct SDL_Point {
    int x;
    int y;
}

struct SDL_Rect {
    int x, y;
    int w, h;
}

static if(sdlSupport >= SDLSupport.sdl2010) {
    struct SDL_FPoint {
        float x, y;
    }

    struct SDL_FRect {
        float x, y;
        float w, h;
    }
}

@nogc nothrow pure {
    // This macro was added to SDL_rect.h in 2.0.4, but hurts nothing to implement for
    // all versions.
    bool SDL_PointInRect(const(SDL_Point)* p, const(SDL_Rect)* r) {
        pragma(inline, true);
        return ((p.x >= r.x) && (p.x < (r.x + r.w)) &&
                (p.y >= r.y) && (p.y < (r.y + r.h)));
    }

    bool SDL_RectEmpty(const(SDL_Rect)* r) {
        pragma(inline, true);
        return !r || (r.w <= 0) || (r.h <= 0);
    }

    bool SDL_RectEquals(const(SDL_Rect)* a, const(SDL_Rect)* b) {
        pragma(inline, true);
        return a && b &&
            (a.x == b.x) && (a.y == b.y) &&
            (a.w == b.w) && (a.h == b.h);
    }

    static if(sdlSupport >= SDLSupport.sdl2022) {
        bool SDL_PointInFRect(const(SDL_FPoint)* p, const(SDL_FRect)* r) {
            pragma(inline, true);
            return ((p.x >= r.x) && (p.x < (r.x + r.w)) &&
                    (p.y >= r.y) && (p.y < (r.y + r.h)));
        }

        bool SDL_FRectEmpty(const(SDL_FRect)* x) {
            pragma(inline, true);
            return !x || (x.w <= 0) || (x.h <= 0);
        }

        bool SDL_FRectEqualsEpsilon(const(SDL_FRect)* a, const(SDL_FRect)* b, const(float) epsilon) {
            pragma(inline, true);
            return a && b && ((a == b) ||
                (fabs(a.x - b.x) <= epsilon) && (fabs(a.y - b.y) <= epsilon) &&
                (fabs(a.w - b.w) <= epsilon) && (fabs(a.h - b.h) <= epsilon));
        }

        bool SDL_FRectEquals(const(SDL_FRect)* a, const(SDL_FRect)* b) {
            pragma(inline, true);
            return SDL_FRectEqualsEpsilon(a, b, SDL_FLT_EPSILON);
        }
    }
}

static if(staticBinding) {
    extern(C) @nogc nothrow {
        SDL_bool SDL_HasIntersection(const(SDL_Rect)* A, const(SDL_Rect)* B);
        SDL_bool SDL_IntersectRect(const(SDL_Rect)* A, const(SDL_Rect)* B,SDL_Rect* result);
        void SDL_UnionRect(const(SDL_Rect)* A, const(SDL_Rect)* B, SDL_Rect* result);
        SDL_bool SDL_EnclosePoints(const(SDL_Point)* points, int count, const(SDL_Rect)* clip, SDL_Rect* result);
        SDL_bool SDL_IntersectRectAndLine(const(SDL_Rect)* rect, int* X1, int* Y1, int* X2, int* Y2);

        static if(sdlSupport >= SDLSupport.sdl2022) {
            SDL_bool SDL_HasIntersectionF(const(SDL_FRect)* A, const(SDL_FRect)* B);
            SDL_bool SDL_IntersectFRect(const(SDL_FRect)* A, const(SDL_FRect)* B, SDL_FRect* result);
            SDL_bool SDL_UnionFRect(const(SDL_FRect)* A, const(SDL_FRect)* B, SDL_FRect* result);
            SDL_bool SDL_EncloseFPoints(const(SDL_FPoint)* points, int count, const(SDL_FRect)* clip, SDL_FRect* result);
            SDL_bool SDL_IntersectFRectAndLine(const(SDL_FRect)* rect, int* X1, int* Y1, int* X2, int* Y2);
        }
    }
}
else {
    extern(C) @nogc nothrow {
        alias pSDL_HasIntersection = SDL_bool function(const(SDL_Rect)* A, const(SDL_Rect)* B);
        alias pSDL_IntersectRect = SDL_bool function(const(SDL_Rect)* A, const(SDL_Rect)* B, SDL_Rect* result);
        alias pSDL_UnionRect = void function(const(SDL_Rect)* A, const(SDL_Rect)* B,SDL_Rect* result);
        alias pSDL_EnclosePoints = SDL_bool function(const(SDL_Point)* points, int count, const(SDL_Rect)* clip, SDL_Rect* result);
        alias pSDL_IntersectRectAndLine = SDL_bool function(const(SDL_Rect)* rect, int* X1, int* Y1, int* X2, int* Y2);
    }

    __gshared {
        pSDL_HasIntersection SDL_HasIntersection;
        pSDL_IntersectRect SDL_IntersectRect;
        pSDL_UnionRect SDL_UnionRect;
        pSDL_EnclosePoints SDL_EnclosePoints;
        pSDL_IntersectRectAndLine SDL_IntersectRectAndLine;
    }

    static if(sdlSupport >= SDLSupport.sdl2022) {
        extern(C) @nogc nothrow {
            alias pSDL_HasIntersectionF = SDL_bool function(const(SDL_FRect)* A, const(SDL_FRect)* B);
            alias pSDL_IntersectFRect = SDL_bool function(const(SDL_FRect)* A, const(SDL_FRect)* B, SDL_FRect* result);
            alias pSDL_UnionFRect = void function(const(SDL_FRect)* A, const(SDL_FRect)* B,SDL_FRect* result);
            alias pSDL_EncloseFPoints = SDL_bool function(const(SDL_FPoint)* points, int count, const(SDL_FRect)* clip, SDL_FRect* result);
            alias pSDL_IntersectFRectAndLine = SDL_bool function(const(SDL_FRect)* rect, int* X1, int* Y1, int* X2, int* Y2);
        }

        __gshared {
            pSDL_HasIntersectionF SDL_HasIntersectionF;
            pSDL_IntersectFRect SDL_IntersectFRect;
            pSDL_UnionFRect SDL_UnionFRect;
            pSDL_EncloseFPoints SDL_EncloseFPoints;
            pSDL_IntersectFRectAndLine SDL_IntersectFRectAndLine;
        }
    }
}