/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.rect;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

import sdl.stdinc;

struct SDL_Point{
	int x;
	int y;
}

struct SDL_Rect{
	int x, y;
	int w, h;
}

static if(sdlSupport >= SDLSupport.v2_0_10){
	struct SDL_FPoint{
		float x, y;
	}

	struct SDL_FRect{
		float x, y;
		float w, h;
	}
}

pragma(inline, true) @nogc nothrow pure{
	// This macro was added to SDL_rect.h in 2.0.4, but hurts nothing to implement for all versions.
	bool SDL_PointInRect(const(SDL_Point)* p, const(SDL_Rect)* r){
		return (
			(p.x >= r.x) && (p.x < (r.x + r.w)) &&
			(p.y >= r.y) && (p.y < (r.y + r.h))
		);
	}
	bool SDL_RectEmpty(const(SDL_Rect)* r){
		return !r || (r.w <= 0) || (r.h <= 0);
	}
	bool SDL_RectEquals(const(SDL_Rect)* a, const(SDL_Rect)* b){
		return a && b &&
			(a.x == b.x) && (a.y == b.y) &&
			(a.w == b.w) && (a.h == b.h);
	}
	static if(sdlSupport >= SDLSupport.v2_0_22){
		bool SDL_PointInFRect(const(SDL_FPoint)* p, const(SDL_FRect)* r){
			return (
				(p.x >= r.x) && (p.x < (r.x + r.w)) &&
				(p.y >= r.y) && (p.y < (r.y + r.h))
			);
		}
		bool SDL_FRectEmpty(const(SDL_FRect)* x){
			return !x || (x.w <= 0) || (x.h <= 0);
		}
		bool SDL_FRectEqualsEpsilon(const(SDL_FRect)* a, const(SDL_FRect)* b, const float epsilon){
			import core.math: fabs;
			return a && b && ((a == b) ||
				(fabs(a.x - b.x) <= epsilon) && (fabs(a.y - b.y) <= epsilon) &&
				(fabs(a.w - b.w) <= epsilon) && (fabs(a.h - b.h) <= epsilon));
		}
		bool SDL_FRectEquals(const(SDL_FRect)* a, const(SDL_FRect)* b){
			return SDL_FRectEqualsEpsilon(a, b, SDL_FLT_EPSILON);
		}
	}
}

mixin(joinFnBinds((){
	string[][] ret;
	ret ~= makeFnBinds([
		[q{SDL_bool}, q{SDL_HasIntersection}, q{const(SDL_Rect)* A, const(SDL_Rect)* B}],
		[q{SDL_bool}, q{SDL_IntersectRect}, q{const(SDL_Rect)* A, const(SDL_Rect)* B,SDL_Rect* result}],
		[q{void}, q{SDL_UnionRect}, q{const(SDL_Rect)* A, const(SDL_Rect)* B, SDL_Rect* result}],
		[q{SDL_bool}, q{SDL_EnclosePoints}, q{const(SDL_Point)* points, int count, const(SDL_Rect)* clip, SDL_Rect* result}],
		[q{SDL_bool}, q{SDL_IntersectRectAndLine}, q{const(SDL_Rect)* rect, int* X1, int* Y1, int* X2, int* Y2}],
	]);
	static if(sdlSupport >= SDLSupport.v2_0_22){
		ret ~= makeFnBinds([
			[q{SDL_bool}, q{SDL_HasIntersectionF}, q{const(SDL_FRect)* A, const(SDL_FRect)* B}],
			[q{SDL_bool}, q{SDL_IntersectFRect}, q{const(SDL_FRect)* A, const(SDL_FRect)* B, SDL_FRect* result}],
			[q{SDL_bool}, q{SDL_UnionFRect}, q{const(SDL_FRect)* A, const(SDL_FRect)* B, SDL_FRect* result}],
			[q{SDL_bool}, q{SDL_EncloseFPoints}, q{const(SDL_FPoint)* points, int count, const(SDL_FRect)* clip, SDL_FRect* result}],
			[q{SDL_bool}, q{SDL_IntersectFRectAndLine}, q{const(SDL_FRect)* rect, float* X1, float* Y1, float* X2, float* Y2}],
		]);
	}
	return ret;
}()));
