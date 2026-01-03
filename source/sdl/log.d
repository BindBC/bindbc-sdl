/+
+            Copyright 2024 – 2026 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.log;

import bindbc.sdl.config, bindbc.sdl.codegen;

mixin(makeEnumBind(q{SDL_LogCategory}, members: (){
	EnumMember[] ret = [
		{{q{application},  q{SDL_LOG_CATEGORY_APPLICATION}}},
		{{q{error},        q{SDL_LOG_CATEGORY_ERROR}}},
		{{q{assert_},      q{SDL_LOG_CATEGORY_ASSERT}}},
		{{q{system},       q{SDL_LOG_CATEGORY_SYSTEM}}},
		{{q{audio},        q{SDL_LOG_CATEGORY_AUDIO}}},
		{{q{video},        q{SDL_LOG_CATEGORY_VIDEO}}},
		{{q{render},       q{SDL_LOG_CATEGORY_RENDER}}},
		{{q{input},        q{SDL_LOG_CATEGORY_INPUT}}},
		{{q{test},         q{SDL_LOG_CATEGORY_TEST}}},
		{{q{gpu},          q{SDL_LOG_CATEGORY_GPU}}},
		{{q{reserved2},    q{SDL_LOG_CATEGORY_RESERVED2}}},
		{{q{reserved3},    q{SDL_LOG_CATEGORY_RESERVED3}}},
		{{q{reserved4},    q{SDL_LOG_CATEGORY_RESERVED4}}},
		{{q{reserved5},    q{SDL_LOG_CATEGORY_RESERVED5}}},
		{{q{reserved6},    q{SDL_LOG_CATEGORY_RESERVED6}}},
		{{q{reserved7},    q{SDL_LOG_CATEGORY_RESERVED7}}},
		{{q{reserved8},    q{SDL_LOG_CATEGORY_RESERVED8}}},
		{{q{reserved9},    q{SDL_LOG_CATEGORY_RESERVED9}}},
		{{q{reserved10},   q{SDL_LOG_CATEGORY_RESERVED10}}},
		{{q{custom},       q{SDL_LOG_CATEGORY_CUSTOM}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_LogPriority}, members: (){
	EnumMember[] ret = [
		{{q{invalid},     q{SDL_LOG_PRIORITY_INVALID}}},
		{{q{trace},       q{SDL_LOG_PRIORITY_TRACE}}},
		{{q{verbose},     q{SDL_LOG_PRIORITY_VERBOSE}}},
		{{q{debug_},      q{SDL_LOG_PRIORITY_DEBUG}}},
		{{q{info},        q{SDL_LOG_PRIORITY_INFO}}},
		{{q{warn},        q{SDL_LOG_PRIORITY_WARN}}},
		{{q{error},       q{SDL_LOG_PRIORITY_ERROR}}},
		{{q{critical},    q{SDL_LOG_PRIORITY_CRITICAL}}},
		{{q{count},       q{SDL_LOG_PRIORITY_COUNT}}},
	];
	return ret;
}()));

alias SDL_LogOutputFunction = extern(C) void function(void* userData, int category, SDL_LogPriority priority, const(char)* message) nothrow;

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{void}, q{SDL_SetLogPriorities}, q{SDL_LogPriority priority}},
		{q{void}, q{SDL_SetLogPriority}, q{int category, SDL_LogPriority priority}},
		{q{SDL_LogPriority}, q{SDL_GetLogPriority}, q{int category}},
		{q{void}, q{SDL_ResetLogPriorities}, q{}},
		{q{bool}, q{SDL_SetLogPriorityPrefix}, q{SDL_LogPriority priority, const(char)* prefix}},
		{q{void}, q{SDL_Log}, q{const(char)* fmt, ...}},
		{q{void}, q{SDL_LogTrace}, q{int category, const(char)* fmt, ...}},
		{q{void}, q{SDL_LogVerbose}, q{int category, const(char)* fmt, ...}},
		{q{void}, q{SDL_LogDebug}, q{int category, const(char)* fmt, ...}},
		{q{void}, q{SDL_LogInfo}, q{int category, const(char)* fmt, ...}},
		{q{void}, q{SDL_LogWarn}, q{int category, const(char)* fmt, ...}},
		{q{void}, q{SDL_LogError}, q{int category, const(char)* fmt, ...}},
		{q{void}, q{SDL_LogCritical}, q{int category, const(char)* fmt, ...}},
		{q{void}, q{SDL_LogMessage}, q{int category, SDL_LogPriority priority, const(char)* fmt, ...}},
		{q{void}, q{SDL_LogMessageV}, q{int category, SDL_LogPriority priority, const(char)* fmt, va_list ap}},
		{q{SDL_LogOutputFunction}, q{SDL_GetDefaultLogOutputFunction}, q{}},
		{q{void}, q{SDL_GetLogOutputFunction}, q{SDL_LogOutputFunction* callback, void** userData}},
		{q{void}, q{SDL_SetLogOutputFunction}, q{SDL_LogOutputFunction callback, void* userData}},
	];
	return ret;
}()));
