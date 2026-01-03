/+
+            Copyright 2024 – 2026 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.stdinc;

import bindbc.sdl.config, bindbc.sdl.codegen;

version(GNU){
	import gcc.builtins;
}

pragma(inline,true)
uint SDL_FOURCC(uint a, uint b, uint c, uint d) nothrow @nogc pure @safe =>
	(cast(ubyte)a <<  0) |
	(cast(ubyte)b <<  8) |
	(cast(ubyte)c << 16) |
	(cast(ubyte)d << 24);

alias SDL_Time = long;

private struct SDL_alignment_test{
	ubyte a;
	void* b;
}
static assert(SDL_alignment_test.sizeof == 2* (void*).sizeof);
static assert(cast(int)~cast(int)0 == cast(int)-1);

version(Vita){
}else version(_3DS){
}else{
	private enum SDL_DUMMY_ENUM{
		DUMMY_ENUM_VALUE,
	}
	static assert(SDL_DUMMY_ENUM.sizeof == int.sizeof);
}

pragma(inline,true)
void SDL_INIT_INTERFACE(IFace)(IFace* iface) nothrow @nogc{
	(cast(ubyte*)iface)[0..IFace.sizeof] = 0;
	iface.version_ = IFace.sizeof;
}

extern(C) nothrow{
	alias SDL_malloc_func = void* function(size_t size);
	alias SDL_calloc_func = void* function(size_t nMemb, size_t size);
	alias SDL_realloc_func = void* function(void* mem, size_t size);
	alias SDL_free_func = void function(void* mem);
}

struct SDL_Environment;

extern(C) nothrow{
	alias SDL_CompareCallback = int function(const(void)* a, const(void)* b);
	alias SDL_CompareCallback_r = int function(void* userData, const(void)* a, const(void)* b);
}

enum{
	SDL_InvalidUnicodeCodepoint = '\uFFFD',
	SDL_INVALID_UNICODE_CODEPOINT = SDL_InvalidUnicodeCodepoint,
}

enum: double{
	SDL_PiD = 3.141592653589793238462643383279502884,
	SDL_PI_D = SDL_PiD,
}
enum: float{
	SDL_PiF = 3.141592653589793238462643383279502884f,
	SDL_PI_F = SDL_PiF,
}

mixin(makeEnumBind(q{SDL_IConvError}, q{SDL_IConv}, members: (){
	EnumMember[] ret = [
		{{q{error},    q{SDL_ICONV_ERROR}},   q{cast(SDL_IConv)-1}},
		{{q{tooBig},   q{SDL_ICONV_E2BIG}},   q{cast(SDL_IConv)-2}},
		{{q{ilSeq},    q{SDL_ICONV_EILSEQ}},  q{cast(SDL_IConv)-3}},
		{{q{inval},    q{SDL_ICONV_EINVAL}},  q{cast(SDL_IConv)-4}},
	];
	return ret;
}()));

struct SDL_IConvData;
alias SDL_iconv_data_t = SDL_IConvData;
alias SDL_IConv = SDL_IConvData*;
alias SDL_iconv_t = SDL_IConvData*;

pragma(inline,true) nothrow @nogc{
	char* SDL_iconv_utf8_locale(const(char)* s) =>
		SDL_iconv_string("", "UTF-8", s, SDL_strlen(s)+1);
	
	wchar* SDL_iconv_utf8_ucs2(const(char)* s) =>
		cast(wchar*)SDL_iconv_string("UCS-2", "UTF-8", s, SDL_strlen(s)+1);
	
	dchar* SDL_iconv_utf8_ucs4(const(char)* s) =>
		cast(dchar*)SDL_iconv_string("UCS-4", "UTF-8", s, SDL_strlen(s)+1);
	
	char* SDL_iconv_wchar_utf8(const(wchar_t)* s) =>
		SDL_iconv_string("UTF-8", "WCHAR_T", cast(const(char)*)s, (SDL_wcslen(s)+1)* wchar_t.sizeof);
	
	bool SDL_size_mul_check_overflow(size_t a, size_t b, size_t* ret) pure @safe{
		static if(__traits(compiles, __builtin_mul_overflow)){
			return __builtin_mul_overflow(a, b, ret) == 0;
		}else{
			if(a != 0 && b > size_t.max / a){
				return false;
			}
			*ret = a* b;
			return true;
		}
	}
	bool SDL_size_add_check_overflow(size_t a, size_t b, size_t* ret) pure @safe{
		static if(__traits(compiles, __builtin_add_overflow)){
			return __builtin_add_overflow(a, b, ret) == 0;
		}else{
			if(b > size_t.max - a){
				return false;
			}
			*ret = a + b;
			return true;
		}
	}
}

alias SDL_FunctionPointer = extern(C) void function() nothrow;

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{void*}, q{SDL_malloc}, q{size_t size}},
		{q{void*}, q{SDL_calloc}, q{size_t nMemb, size_t size}},
		{q{void*}, q{SDL_realloc}, q{void* mem, size_t size}},
		{q{void}, q{SDL_free}, q{void* mem}},
		{q{void}, q{SDL_GetOriginalMemoryFunctions}, q{SDL_malloc_func* mallocFunc, SDL_calloc_func* callocFunc, SDL_realloc_func* reallocFunc, SDL_free_func* freeFunc}},
		{q{void}, q{SDL_GetMemoryFunctions}, q{SDL_malloc_func* mallocFunc, SDL_calloc_func* callocFunc, SDL_realloc_func* reallocFunc, SDL_free_func* freeFunc}},
		{q{bool}, q{SDL_SetMemoryFunctions}, q{SDL_malloc_func mallocFunc, SDL_calloc_func callocFunc, SDL_realloc_func reallocFunc, SDL_free_func freeFunc}},
		{q{void*}, q{SDL_aligned_alloc}, q{size_t alignment, size_t size}},
		{q{void}, q{SDL_aligned_free}, q{void* mem}},
		{q{int}, q{SDL_GetNumAllocations}, q{}},
		{q{SDL_Environment*}, q{SDL_GetEnvironment}, q{}},
		{q{SDL_Environment*}, q{SDL_CreateEnvironment}, q{bool populated}},
		{q{const(char)*}, q{SDL_GetEnvironmentVariable}, q{SDL_Environment* env, const(char)* name}},
		{q{char**}, q{SDL_GetEnvironmentVariables}, q{SDL_Environment* env}},
		{q{bool}, q{SDL_SetEnvironmentVariable}, q{SDL_Environment* env, const(char)* name, const(char)* value, bool overwrite}},
		{q{bool}, q{SDL_UnsetEnvironmentVariable}, q{SDL_Environment* env, const(char)* name}},
		{q{void}, q{SDL_DestroyEnvironment}, q{SDL_Environment* env}},
		{q{const(char)*}, q{SDL_getenv}, q{const(char)* name}},
		{q{const(char)*}, q{SDL_getenv_unsafe}, q{const(char)* name}},
		{q{int}, q{SDL_setenv_unsafe}, q{const(char)* name, const(char)* value, int overwrite}},
		{q{int}, q{SDL_unsetenv_unsafe}, q{const(char)* name}},
		{q{void}, q{SDL_qsort}, q{void* base, size_t nMemb, size_t size, SDL_CompareCallback compare}},
		{q{void*}, q{SDL_bsearch}, q{const(void)* key, const(void)* base, size_t nMemb, size_t size, SDL_CompareCallback compare}},
		{q{void}, q{SDL_qsort_r}, q{void* base, size_t nMemb, size_t size, SDL_CompareCallback_r compare, void* userData}},
		{q{void*}, q{SDL_bsearch_r}, q{const(void)* key, const(void)* base, size_t nMemb, size_t size, SDL_CompareCallback_r compare, void* userData}},
		{q{int}, q{SDL_abs}, q{int x}},
		{q{int}, q{SDL_isalpha}, q{int x}},
		{q{int}, q{SDL_isalnum}, q{int x}},
		{q{int}, q{SDL_isblank}, q{int x}},
		{q{int}, q{SDL_iscntrl}, q{int x}},
		{q{int}, q{SDL_isdigit}, q{int x}},
		{q{int}, q{SDL_isxdigit}, q{int x}},
		{q{int}, q{SDL_ispunct}, q{int x}},
		{q{int}, q{SDL_isspace}, q{int x}},
		{q{int}, q{SDL_isupper}, q{int x}},
		{q{int}, q{SDL_islower}, q{int x}},
		{q{int}, q{SDL_isprint}, q{int x}},
		{q{int}, q{SDL_isgraph}, q{int x}},
		{q{int}, q{SDL_toupper}, q{int x}},
		{q{int}, q{SDL_tolower}, q{int x}},
		{q{ushort}, q{SDL_crc16}, q{ushort crc, const(void)* data, size_t len}},
		{q{uint}, q{SDL_crc32}, q{uint crc, const(void)* data, size_t len}},
		{q{uint}, q{SDL_murmur3_32}, q{const(void)* data, size_t len, uint seed}},
		{q{void*}, q{SDL_memcpy}, q{void* dst, const(void)* src, size_t len}},
		{q{void*}, q{SDL_memmove}, q{void* dst, const(void)* src, size_t len}},
		{q{void*}, q{SDL_memset}, q{void* dst, int c, size_t len}},
		{q{void*}, q{SDL_memset4}, q{void* dst, uint val, size_t dwords}},
		{q{int}, q{SDL_memcmp}, q{const(void)* s1, const(void)* s2, size_t len}},
		{q{size_t}, q{SDL_wcslen}, q{const(wchar_t)* wStr}},
		{q{size_t}, q{SDL_wcsnlen}, q{const(wchar_t)* wStr, size_t maxLen}},
		{q{size_t}, q{SDL_wcslcpy}, q{wchar_t* dst, const(wchar_t)* src, size_t maxLen}},
		{q{size_t}, q{SDL_wcslcat}, q{wchar_t* dst, const(wchar_t)* src, size_t maxLen}},
		{q{wchar_t*}, q{SDL_wcsdup}, q{const(wchar_t)* wStr}},
		{q{wchar_t*}, q{SDL_wcsstr}, q{const(wchar_t)* haystack, const(wchar_t)* needle}},
		{q{wchar_t*}, q{SDL_wcsnstr}, q{const(wchar_t)* haystack, const(wchar_t)* needle, size_t maxLen}},
		{q{int}, q{SDL_wcscmp}, q{const(wchar_t)* str1, const(wchar_t)* str2}},
		{q{int}, q{SDL_wcsncmp}, q{const(wchar_t)* str1, const(wchar_t)* str2, size_t maxLen}},
		{q{int}, q{SDL_wcscasecmp}, q{const(wchar_t)* str1, const(wchar_t)* str2}},
		{q{int}, q{SDL_wcsncasecmp}, q{const(wchar_t)* str1, const(wchar_t)* str2, size_t maxLen}},
		{q{c_long}, q{SDL_wcstol}, q{const(wchar_t)* str, wchar_t** endP, int base}},
		{q{size_t}, q{SDL_strlen}, q{const(char)* str}},
		{q{size_t}, q{SDL_strnlen}, q{const(char)* str, size_t maxLen}},
		{q{size_t}, q{SDL_strlcpy}, q{char* dst, const(char)* src, size_t maxLen}},
		{q{size_t}, q{SDL_utf8strlcpy}, q{char* dst, const(char)* src, size_t dstBytes}},
		{q{size_t}, q{SDL_strlcat}, q{char* dst, const(char)* src, size_t maxLen}},
		{q{char*}, q{SDL_strdup}, q{const(char)* str}},
		{q{char*}, q{SDL_strndup}, q{const(char)* str, size_t maxLen}},
		{q{char*}, q{SDL_strrev}, q{char* str}},
		{q{char*}, q{SDL_strupr}, q{char* str}},
		{q{char*}, q{SDL_strlwr}, q{char* str}},
		{q{char*}, q{SDL_strchr}, q{const(char)* str, int c}},
		{q{char*}, q{SDL_strrchr}, q{const(char)* str, int c}},
		{q{char*}, q{SDL_strstr}, q{const(char)* haystack, const(char)* needle}},
		{q{char*}, q{SDL_strnstr}, q{const(char)* haystack, const(char)* needle, size_t maxLen}},
		{q{char*}, q{SDL_strcasestr}, q{const(char)* haystack, const(char)* needle}},
		{q{char*}, q{SDL_strtok_r}, q{char* s1, const(char)* s2, char** savePtr}},
		{q{size_t}, q{SDL_utf8strlen}, q{const(char)* str}},
		{q{size_t}, q{SDL_utf8strnlen}, q{const(char)* str, size_t bytes}},
		{q{char*}, q{SDL_itoa}, q{int value, char* str, int radix}},
		{q{char*}, q{SDL_uitoa}, q{uint value, char* str, int radix}},
		{q{char*}, q{SDL_ltoa}, q{c_long value, char* str, int radix}},
		{q{char*}, q{SDL_ultoa}, q{c_ulong value, char* str, int radix}},
		{q{char*}, q{SDL_lltoa}, q{c_longlong value, char* str, int radix}},
		{q{char*}, q{SDL_ulltoa}, q{c_ulonglong value, char* str, int radix}},
		{q{int}, q{SDL_atoi}, q{const(char)* str}},
		{q{double}, q{SDL_atof}, q{const(char)* str}},
		{q{c_long}, q{SDL_strtol}, q{const(char)* str, char** endP, int base}},
		{q{c_ulong}, q{SDL_strtoul}, q{const(char)* str, char** endP, int base}},
		{q{c_longlong}, q{SDL_strtoll}, q{const(char)* str, char** endP, int base}},
		{q{c_ulonglong}, q{SDL_strtoull}, q{const(char)* str, char** endP, int base}},
		{q{double}, q{SDL_strtod}, q{const(char)* str, char** endP}},
		{q{int}, q{SDL_strcmp}, q{const(char)* str1, const(char)* str2}},
		{q{int}, q{SDL_strncmp}, q{const(char)* str1, const(char)* str2, size_t maxLen}},
		{q{int}, q{SDL_strcasecmp}, q{const(char)* str1, const(char)* str2}},
		{q{int}, q{SDL_strncasecmp}, q{const(char)* str1, const(char)* str2, size_t maxLen}},
		{q{char*}, q{SDL_strpbrk}, q{const(char)* str, const(char)* breakSet}},
		{q{uint}, q{SDL_StepUTF8}, q{const(char)** pStr, size_t* psLen}},
		{q{uint}, q{SDL_StepBackUTF8}, q{const(char)* start, const(char)** pStr}},
		{q{char*}, q{SDL_UCS4ToUTF8}, q{uint codePoint, char* dst}},
		{q{int}, q{SDL_sscanf}, q{const(char)* text, const(char)* fmt, ...}},
		{q{int}, q{SDL_vsscanf}, q{const(char)* text, const(char)* fmt, va_list ap}},
		{q{int}, q{SDL_snprintf}, q{char* text, size_t maxLen, const(char)* fmt, ...}},
		{q{int}, q{SDL_swprintf}, q{wchar_t* text, size_t maxLen, const(wchar_t)* fmt, ...}},
		{q{int}, q{SDL_vsnprintf}, q{char* text, size_t maxLen, const(char)* fmt, va_list ap}},
		{q{int}, q{SDL_vswprintf}, q{wchar_t* text, size_t maxLen, const(wchar_t)* fmt, va_list ap}},
		{q{int}, q{SDL_asprintf}, q{char** strP, const(char)* fmt, ...}},
		{q{int}, q{SDL_vasprintf}, q{char** strP, const(char)* fmt, va_list ap}},
		{q{void}, q{SDL_srand}, q{ulong seed}},
		{q{int}, q{SDL_rand}, q{int n}},
		{q{float}, q{SDL_randf}, q{}},
		{q{uint}, q{SDL_rand_bits}, q{}},
		{q{int}, q{SDL_rand_r}, q{ulong* state, int n}},
		{q{float}, q{SDL_randf_r}, q{ulong* state}},
		{q{uint}, q{SDL_rand_bits_r}, q{ulong* state}},
		{q{double}, q{SDL_acos}, q{double x}},
		{q{float}, q{SDL_acosf}, q{float x}},
		{q{double}, q{SDL_asin}, q{double x}},
		{q{float}, q{SDL_asinf}, q{float x}},
		{q{double}, q{SDL_atan}, q{double x}},
		{q{float}, q{SDL_atanf}, q{float x}},
		{q{double}, q{SDL_atan2}, q{double y, double x}},
		{q{float}, q{SDL_atan2f}, q{float y, float x}},
		{q{double}, q{SDL_ceil}, q{double x}},
		{q{float}, q{SDL_ceilf}, q{float x}},
		{q{double}, q{SDL_copysign}, q{double x, double y}},
		{q{float}, q{SDL_copysignf}, q{float x, float y}},
		{q{double}, q{SDL_cos}, q{double x}},
		{q{float}, q{SDL_cosf}, q{float x}},
		{q{double}, q{SDL_exp}, q{double x}},
		{q{float}, q{SDL_expf}, q{float x}},
		{q{double}, q{SDL_fabs}, q{double x}},
		{q{float}, q{SDL_fabsf}, q{float x}},
		{q{double}, q{SDL_floor}, q{double x}},
		{q{float}, q{SDL_floorf}, q{float x}},
		{q{double}, q{SDL_trunc}, q{double x}},
		{q{float}, q{SDL_truncf}, q{float x}},
		{q{double}, q{SDL_fmod}, q{double x, double y}},
		{q{float}, q{SDL_fmodf}, q{float x, float y}},
		{q{int}, q{SDL_isinf}, q{double x}},
		{q{int}, q{SDL_isinff}, q{float x}},
		{q{int}, q{SDL_isnan}, q{double x}},
		{q{int}, q{SDL_isnanf}, q{float x}},
		{q{double}, q{SDL_log}, q{double x}},
		{q{float}, q{SDL_logf}, q{float x}},
		{q{double}, q{SDL_log10}, q{double x}},
		{q{float}, q{SDL_log10f}, q{float x}},
		{q{double}, q{SDL_modf}, q{double x, double* y}},
		{q{float}, q{SDL_modff}, q{float x, float* y}},
		{q{double}, q{SDL_pow}, q{double x, double y}},
		{q{float}, q{SDL_powf}, q{float x, float y}},
		{q{double}, q{SDL_round}, q{double x}},
		{q{float}, q{SDL_roundf}, q{float x}},
		{q{c_long}, q{SDL_lround}, q{double x}},
		{q{c_long}, q{SDL_lroundf}, q{float x}},
		{q{double}, q{SDL_scalbn}, q{double x, int n}},
		{q{float}, q{SDL_scalbnf}, q{float x, int n}},
		{q{double}, q{SDL_sin}, q{double x}},
		{q{float}, q{SDL_sinf}, q{float x}},
		{q{double}, q{SDL_sqrt}, q{double x}},
		{q{float}, q{SDL_sqrtf}, q{float x}},
		{q{double}, q{SDL_tan}, q{double x}},
		{q{float}, q{SDL_tanf}, q{float x}},
		{q{SDL_IConv}, q{SDL_iconv_open}, q{const(char)* toCode, const(char)* fromCode}},
		{q{int}, q{SDL_iconv_close}, q{SDL_IConv cd}},
		{q{size_t}, q{SDL_iconv}, q{SDL_IConv cd, const(char)** inBuf, size_t* inbytesleft, char** outBuf, size_t* outBytesLeft}},
		{q{char*}, q{SDL_iconv_string}, q{const(char)* toCode, const(char)* fromCode, const(char)* inBuf, size_t inBytesLeft}},
	];
	return ret;
}()));
