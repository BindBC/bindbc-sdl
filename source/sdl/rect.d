/+
+            Copyright 2024 – 2025 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.rect;

import bindbc.sdl.config, bindbc.sdl.codegen;

import sdl.stdinc: SDL_fabsf;

struct SDL_Point{
	int x, y;
}

struct SDL_FPoint{
	float x, y;
}

struct SDL_Rect{
	int x, y, w, h;
}

struct SDL_FRect{
	float x, y, w, h;
}

pragma(inline,true) nothrow @nogc{
	void SDL_RectToFRect(const(SDL_Rect)* rect, SDL_FRect* fRect) pure @safe{
		*fRect = SDL_FRect(cast(float)rect.x, cast(float)rect.y, cast(float)rect.w, cast(float)rect.h);
	}
	
	bool SDL_PointInRect(const(SDL_Point)* p, const(SDL_Rect)* r) pure @safe =>
		p && r && p.x >= r.x && p.x < r.x + r.w && p.y >= r.y && p.y < r.y + r.h;
		
	bool SDL_RectEmpty(const(SDL_Rect)* r) pure @safe =>
		!r || r.w <= 0 || r.h <= 0;
	
	bool SDL_RectsEqual(const(SDL_Rect)* a, const(SDL_Rect)* b) pure @safe =>
		a && b && *a == *b;
	
	bool SDL_PointInRectFloat(const(SDL_FPoint)* p, const(SDL_FRect)* r) pure @safe =>
		p && r && p.x >= r.x && p.x <= r.x + r.w && p.y >= r.y && p.y <= r.y + r.h;
	
	bool SDL_RectEmptyFloat(const(SDL_FRect)* r) pure @safe =>
		!r || r.w < 0f || r.h < 0f;
	
	bool SDL_RectsEqualEpsilon(const(SDL_FRect)* a, const(SDL_FRect)* b, const float epsilon) @trusted =>
		a && b && (a == b || (
			SDL_fabsf(a.x - b.x) <= epsilon &&
			SDL_fabsf(a.y - b.y) <= epsilon &&
			SDL_fabsf(a.w - b.w) <= epsilon &&
			SDL_fabsf(a.h - b.h) <= epsilon
		));
	
	bool SDL_RectsEqualFloat(const(SDL_FRect)* a, const(SDL_FRect)* b) @safe =>
		SDL_RectsEqualEpsilon(a, b, float.epsilon);
}

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{bool}, q{SDL_HasRectIntersection}, q{const(SDL_Rect)* a, const(SDL_Rect)* b}},
		{q{bool}, q{SDL_GetRectIntersection}, q{const(SDL_Rect)* a, const(SDL_Rect)* b, SDL_Rect* result}},
		{q{bool}, q{SDL_GetRectUnion}, q{const(SDL_Rect)* a, const(SDL_Rect)* b, SDL_Rect* result}},
		{q{bool}, q{SDL_GetRectEnclosingPoints}, q{const(SDL_Point)* points, int count, const(SDL_Rect)* clip, SDL_Rect* result}},
		{q{bool}, q{SDL_GetRectAndLineIntersection}, q{const(SDL_Rect)* rect, int* x1, int* y1, int* x2, int* y2}},
		{q{bool}, q{SDL_HasRectIntersectionFloat}, q{const(SDL_FRect)* a, const(SDL_FRect)* b}},
		{q{bool}, q{SDL_GetRectIntersectionFloat}, q{const(SDL_FRect)* a, const(SDL_FRect)* b, SDL_FRect* result}},
		{q{bool}, q{SDL_GetRectUnionFloat}, q{const(SDL_FRect)* a, const(SDL_FRect)* B, SDL_FRect* result}},
		{q{bool}, q{SDL_GetRectEnclosingPointsFloat}, q{const(SDL_FPoint)* points, int count, const(SDL_FRect)* clip, SDL_FRect* result}},
		{q{bool}, q{SDL_GetRectAndLineIntersectionFloat}, q{const(SDL_FRect)* rect, float* x1, float* y1, float* x2, float* y2}},
	];
	return ret;
}()));
