/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.stdinc;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

alias SDL_bool = int;
enum: SDL_bool{
	SDL_FALSE = 0,
	SDL_TRUE  = 1
}

deprecated("Please use `byte` instead") alias Sint8 = byte;
deprecated("Please use `ubyte` instead") alias Uint8 = ubyte;
deprecated("Please use `short` instead") alias Sint16 = short;
deprecated("Please use `ushort` instead") alias Uint16 = ushort;
deprecated("Please use `int` instead") alias Sint32 = int;
deprecated("Please use `uint` instead") alias Uint32 = uint;
deprecated("Please use `long` instead") alias Sint64 = long;
deprecated("Please use `ulong` instead") alias Uint64 = ulong;

static if(sdlSupport >= SDLSupport.v2_0_22){
	enum SDL_FLT_EPSILON = 1.1920928955078125e-07F;
}

static if(sdlSupport >= SDLSupport.v2_0_4){
	version(Win32){
		enum{
			SDL_PRIs64 = "I64d",
			SDL_PRIu64 = "I64u",
			SDL_PRIx64 = "I64x",
			SDL_PRIX64 = "I64X",
		}
	}else{
		enum linuxAndLP64 = (){
			version(linux){
				version(D_LP64){
					return true;
				}else return false;
			}else return false;
		}();
		
		static if(linuxAndLP64)
		enum{
			SDL_PRIs64 = "ld",
			SDL_PRIu64 = "lu",
			SDL_PRIx64 = "lx",
			SDL_PRIX64 = "lX",
		}
		else
		enum{
			SDL_PRIs64 = "lld",
			SDL_PRIu64 = "llu",
			SDL_PRIx64 = "llx",
			SDL_PRIX64 = "llX",
		}
	}
	static if(sdlSupport >= SDLSupport.v2_0_16){
		enum{
			SDL_PRIs32 = "d",
			SDL_PRIu32 = "u",
			SDL_PRIx32 = "x",
			SDL_PRIX32 = "X",
		}
	}
}

static if(sdlSupport >= SDLSupport.v2_0_7){
	extern(C) @nogc nothrow{
		alias SDL_malloc_func = void* function(size_t size);
		alias SDL_calloc_func = void* function(size_t nmemb, size_t size);
		alias SDL_realloc_func = void* function(void* mem, size_t size);
		alias SDL_free_func = void function(void* mem);
	}
}

enum SDL_PI = 3.14159265358979323846264338327950288;

enum: size_t{
	SDL_ICONV_ERROR     = -1,
	SDL_ICONV_E2BIG     = -2,
	SDL_ICONV_EILSEQ    = -3,
	SDL_ICONV_EINVAL    = -4,
}

struct SDL_iconv_t;

pragma(inline, true) @nogc nothrow{
	int SDL_arraysize(T)(T array) pure @safe{ return array.sizeof/array[0].sizeof; }
	
	dchar SDL_FOURCC(char A, char B, char C, char D) pure @safe{
		return (A << 0) | (B << 8) | (C << 16) | (D << 24);
	}
	
	T* SDL_stack_alloc(T)(size_t count){ return cast(T*)SDL_malloc(T.sizeof*count); }
	void SDL_stack_free(void* data){ SDL_free(data); }
	
	T SDL_min(T)(T x, T y) pure @safe{ return ((x) < (y)) ? (x) : (y); }
	T SDL_max(T)(T x, T y) pure @safe{ return ((x) > (y)) ? (x) : (y); }
	static if(sdlSupport >= SDLSupport.v2_0_18){
		T SDL_clamp(T)(T x, T a, T b) pure @safe{ return ((x) < (a)) ? (a) : (((x) > (b)) ? (b) : (x)); }
	}
	
	void* SDL_zero(T)(T x){ return SDL_memset(&x, 0, x.sizeof); }
	void* SDL_zerop(T)(T x){ return SDL_memset(x, 0, (*x).sizeof); }
	static if(sdlSupport >= SDLSupport.v2_0_12){
		void* SDL_zeroa(T)(T x){ return SDL_memset(x, 0, x.sizeof); }
	}
	
	char* SDL_iconv_utf8_locale(const(char)* S){ return SDL_iconv_string("", "UTF-8", S, SDL_strlen(S)+1); }
	ushort* SDL_iconv_utf8_ucs2(const(char)* S){ return cast(ushort*)SDL_iconv_string("UCS-2-INTERNAL", "UTF-8", S, SDL_strlen(S)+1); }
	uint* SDL_iconv_utf8_ucs4(const(char)* S){ return cast(uint*)SDL_iconv_string("UCS-4-INTERNAL", "UTF-8", S, SDL_strlen(S)+1); }
	static if(sdlSupport >= SDLSupport.v2_0_18){
		char* SDL_iconv_wchar_utf8(const(wchar_t)* S){ return SDL_iconv_string("UTF-8", "WCHAR_T", cast(char*)S, (SDL_wcslen(S)+1)*(wchar_t.sizeof)); }
	}
}
deprecated("Please use the non-template variant instead"){
	enum SDL_FOURCC(char A, char B, char C, char D) =
		((A << 0) | (B << 8) | (C << 16) | (D << 24));
}

mixin(joinFnBinds((){
	string[][] ret;
	ret ~= makeFnBinds([
		[q{void*}, q{SDL_malloc}, q{size_t size}],
		[q{void*}, q{SDL_calloc}, q{size_t nmemb, size_t size}],
		[q{void*}, q{SDL_realloc}, q{void* mem, size_t size}],
		[q{void}, q{SDL_free}, q{void* mem}],
		
		[q{char*}, q{SDL_getenv}, q{const(char)* name}],
		[q{int}, q{SDL_setenv}, q{const(char)* name, const(char)* value, int overwrite}],
		
		[q{void}, q{SDL_qsort}, q{void* base, size_t nmemb, size_t size, int function(const(void)*, const(void)*) compare}],
		
		[q{int}, q{SDL_abs}, q{int x}],
		
		[q{int}, q{SDL_isdigit}, q{int x}],
		[q{int}, q{SDL_isspace}, q{int x}],
		[q{int}, q{SDL_toupper}, q{int x}],
		[q{int}, q{SDL_tolower}, q{int x}],
		
		[q{void*}, q{SDL_memset}, q{void* dst, int c, size_t len}],
		[q{void*}, q{SDL_memcpy}, q{void* dst, const(void)* src, size_t len}],
		[q{void*}, q{SDL_memmove}, q{void* dst, const(void)* src, size_t len}],
		[q{int}, q{SDL_memcmp}, q{const(void)* s1, const(void)* s2, size_t len}],
		
		[q{size_t}, q{SDL_wcslen}, q{const(wchar_t)* wstr}],
		[q{size_t}, q{SDL_wcslcpy}, q{wchar_t* dst, const(wchar_t)* src, size_t maxlen}],
		[q{size_t}, q{SDL_wcslcat}, q{wchar_t* dst, const(wchar_t)* src, size_t maxlen}],
		
		[q{size_t}, q{SDL_strlen}, q{const(char)* str}],
		[q{size_t}, q{SDL_strlcpy}, q{char* dst, const(char)* src, size_t maxlen}],
		[q{size_t}, q{SDL_utf8strlcpy}, q{char* dst, const(char)* src, size_t dst_bytes}],
		[q{size_t}, q{SDL_strlcat}, q{char* dst, const(char)* src, size_t maxlen}],
		[q{char*}, q{SDL_strdup}, q{const(char)* str}],
		[q{char*}, q{SDL_strrev}, q{char* str}],
		[q{char*}, q{SDL_strupr}, q{char* str}],
		[q{char*}, q{SDL_strlwr}, q{char* str}],
		[q{char*}, q{SDL_strchr}, q{const(char)* str, int c}],
		[q{char*}, q{SDL_strrchr}, q{const(char)* str, int c}],
		[q{char*}, q{SDL_strstr}, q{const(char)* haystack, const(char)* needle}],
		
		[q{char*}, q{SDL_itoa}, q{int value, char* str, int radix}],
		[q{char*}, q{SDL_uitoa}, q{uint value, char* str, int radix}],
		[q{char*}, q{SDL_ltoa}, q{long value, char* str, int radix}],
		[q{char*}, q{SDL_ultoa}, q{ulong value, char* str, int radix}],
		[q{char*}, q{SDL_lltoa}, q{long value, char* str, int radix}],
		[q{char*}, q{SDL_ulltoa}, q{ulong value, char* str, int radix}],
		
		[q{int}, q{SDL_atoi}, q{const(char)* str}],
		[q{double}, q{SDL_atof}, q{const(char)* str}],
		[q{long}, q{SDL_strtol}, q{const(char)* str, char** endp, int base}],
		[q{ulong}, q{SDL_strtoul}, q{const(char)* str, char** endp, int base}],
		[q{long}, q{SDL_strtoll}, q{const(char)* str, char** endp, int base}],
		[q{ulong}, q{SDL_strtoull}, q{const(char)* str, char** endp, int base}],
		[q{double}, q{SDL_strtod}, q{const(char)* str, char** endp}],
		
		[q{int}, q{SDL_strcmp}, q{const(char)* str1, const(char)* str2}],
		[q{int}, q{SDL_strncmp}, q{const(char)* str1, const(char)* str2, size_t maxlen}],
		[q{int}, q{SDL_strcasecmp}, q{const(char)* str1, const(char)* str2}],
		[q{int}, q{SDL_strncasecmp}, q{const(char)* str1, const(char)* str2, size_t len}],
		
		[q{int}, q{SDL_sscanf}, q{const(char)* text, const(char)* fmt, ...}],
		[q{int}, q{SDL_snprintf}, q{char* text, size_t maxlen, const(char)* fmt, ...}],
		[q{int}, q{SDL_vsnprintf}, q{char* text, size_t maxlen, const(char)* fmt, va_list ap}],
		
		[q{double}, q{SDL_atan}, q{double x}],
		[q{double}, q{SDL_atan2}, q{double y, double x}],
		[q{double}, q{SDL_ceil}, q{double x}],
		[q{double}, q{SDL_copysign}, q{double x, double y}],
		[q{double}, q{SDL_cos}, q{double x}],
		[q{float}, q{SDL_cosf}, q{float x}],
		[q{double}, q{SDL_fabs}, q{double x}],
		[q{double}, q{SDL_floor}, q{double x}],
		[q{double}, q{SDL_log}, q{double x}],
		[q{double}, q{SDL_pow}, q{double x, double y}],
		[q{double}, q{SDL_scalbn}, q{double x, int n}],
		[q{double}, q{SDL_sin}, q{double x}],
		[q{float}, q{SDL_sinf}, q{float x}],
		[q{double}, q{SDL_sqrt}, q{double x}],
		[q{SDL_iconv_t*}, q{SDL_iconv_open}, q{const(char)* tocode, const(char)* fromcode}],
		[q{int}, q{SDL_iconv_close}, q{SDL_iconv_t* cd}],
		[q{size_t}, q{SDL_iconv}, q{SDL_iconv_t* cd, const(char)** inbuf, size_t* inbytesleft, char** outbuf, size_t* outbytesleft}],
		[q{char*}, q{SDL_iconv_string}, q{const(char)* tocode, const(char)* fromcode, const(char)* inbuf, size_t inbytesleft}],
	]);
	static if(sdlSupport >= SDLSupport.v2_0_2){
		ret ~= makeFnBinds([
			[q{int}, q{SDL_vsscanf}, q{const(char)* text, const(char)* fmt, va_list ap}],
			
			[q{double}, q{SDL_acos}, q{double x}],
			[q{double}, q{SDL_asin}, q{double x}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_4){
		ret ~= makeFnBinds([
			[q{double}, q{SDL_tan}, q{double x}],
			[q{float}, q{SDL_tanf}, q{float x}],
			[q{float}, q{SDL_sqrtf}, q{float x}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_6){
		ret ~= makeFnBinds([
			[q{int}, q{SDL_wcscmp}, q{const(wchar_t)* str1, const(wchar_t)* str2}],
			
			[q{size_t}, q{SDL_utf8strlen}, q{const(char)* str}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_7){
		ret ~= makeFnBinds([
			[q{void}, q{SDL_GetMemoryFunctions}, q{SDL_malloc_func* malloc_func, SDL_calloc_func* calloc_func, SDL_realloc_func* realloc_func, SDL_free_func* free_func}],
			[q{int}, q{SDL_SetMemoryFunctions}, q{SDL_malloc_func malloc_func, SDL_calloc_func calloc_func, SDL_realloc_func realloc_func, SDL_free_func free_func}],
			[q{int}, q{SDL_GetNumAllocations}, q{}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_8){
		ret ~= makeFnBinds([
			[q{float}, q{SDL_acosf}, q{float x}],
			[q{float}, q{SDL_asinf}, q{float x}],
			[q{float}, q{SDL_atanf}, q{float x}],
			[q{float}, q{SDL_atan2f}, q{float y, float x}],
			[q{float}, q{SDL_ceilf}, q{float x}],
			[q{float}, q{SDL_copysignf}, q{float x, float y}],
			[q{float}, q{SDL_fabsf}, q{float x}],
			[q{float}, q{SDL_floorf}, q{float x}],
			[q{double}, q{SDL_fmod}, q{double x, double y}],
			[q{float}, q{SDL_fmodf}, q{float x, float y}],
			[q{float}, q{SDL_logf}, q{float x}],
			[q{double}, q{SDL_log10}, q{double x}],
			[q{float}, q{SDL_log10f}, q{float x}],
			[q{float}, q{SDL_powf}, q{float x, float y}],
			[q{float}, q{SDL_scalbnf}, q{float x, int n}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_9){
		ret ~= makeFnBinds([
			[q{wchar_t*}, q{SDL_wcsdup}, q{const(wchar_t)* wstr}],
			
			[q{double}, q{SDL_exp}, q{double x}],
			[q{float}, q{SDL_expf}, q{float x}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_12){
		ret ~= makeFnBinds([
			[q{int}, q{SDL_isupper}, q{int x}],
			[q{int}, q{SDL_islower}, q{int x}],
			
			[q{wchar_t*}, q{SDL_wcsstr}, q{const(wchar_t)* haystack, const(wchar_t)* needle}],
			[q{int}, q{SDL_wcsncmp}, q{const(wchar_t)* str1, const(wchar_t)* str2, size_t maxlen}],
			
			[q{char*}, q{SDL_strtokr}, q{char* s1, const(char)* s2, char** saveptr}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_14){
		ret ~= makeFnBinds([
			[q{uint}, q{SDL_crc32}, q{uint crc, const(void)* data, size_t len}],
			
			[q{int}, q{SDL_wcscasecmp}, q{const(wchar_t)* str1, const(wchar_t)* str2}],
			[q{int}, q{SDL_wcsncasecmp}, q{const(wchar_t)* str1, const(wchar_t)* str2, size_t len}],
			
			[q{double}, q{SDL_trunc}, q{double x}],
			[q{float}, q{SDL_truncf}, q{float x}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_16){
		ret ~= makeFnBinds([
			[q{int}, q{SDL_isalpha}, q{int x}],
			[q{int}, q{SDL_isalnum}, q{int x}],
			[q{int}, q{SDL_isblank}, q{int x}],
			[q{int}, q{SDL_iscntrl}, q{int x}],
			[q{int}, q{SDL_isxdigit}, q{int x}],
			[q{int}, q{SDL_ispunct}, q{int x}],
			[q{int}, q{SDL_isprint}, q{int x}],
			[q{int}, q{SDL_isgraph}, q{int x}],
			
			[q{double}, q{SDL_round}, q{double x}],
			[q{float}, q{SDL_roundf}, q{float x}],
			[q{long}, q{SDL_lround}, q{double x}],
			[q{long}, q{SDL_lroundf}, q{float x}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_18){
		ret ~= makeFnBinds([
			[q{int}, q{SDL_asprintf}, q{char** strp, const(char)* fmt, ...}],
			[q{int}, q{SDL_vasprintf}, q{char** strp, const(char)* fmt, va_list ap}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_24){
		ret ~= makeFnBinds([
			[q{void}, q{SDL_GetOriginalMemoryFunctions}, q{SDL_malloc_func* malloc_func, SDL_calloc_func* calloc_func, SDL_realloc_func* realloc_func, SDL_free_func* free_func}],
			
			[q{void*}, q{SDL_bsearch}, q{const(void)* key, const(void)* base, size_t nmemb, size_t size, int function(const(void)*, const(void)*) compare}],
			
			[q{ushort}, q{SDL_crc16}, q{ushort crc, const(void)* data, size_t len}],
			
			[q{size_t}, q{SDL_utf8strnlen}, q{const(char)* str, size_t bytes}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_26){
		ret ~= makeFnBinds([
			[q{char*}, q{SDL_strcasestr}, q{const(char)* haystack, const(char)* needle}],
		]);
	}
	return ret;
}()));
