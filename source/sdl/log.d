/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.log;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

//NOTE: as-of SDL 2.24, there is no longer a max log message length
enum SDL_MAX_LOG_MESSAGE = 4096;

alias SDL_LogCategory = uint;
enum: SDL_LogCategory{
	SDL_LOG_CATEGORY_APPLICATION,
	SDL_LOG_CATEGORY_ERROR,
	SDL_LOG_CATEGORY_ASSERT,
	SDL_LOG_CATEGORY_SYSTEM,
	SDL_LOG_CATEGORY_AUDIO,
	SDL_LOG_CATEGORY_VIDEO,
	SDL_LOG_CATEGORY_RENDER,
	SDL_LOG_CATEGORY_INPUT,
	SDL_LOG_CATEGORY_TEST,
	
	SDL_LOG_CATEGORY_RESERVED1,
	SDL_LOG_CATEGORY_RESERVED2,
	SDL_LOG_CATEGORY_RESERVED3,
	SDL_LOG_CATEGORY_RESERVED4,
	SDL_LOG_CATEGORY_RESERVED5,
	SDL_LOG_CATEGORY_RESERVED6,
	SDL_LOG_CATEGORY_RESERVED7,
	SDL_LOG_CATEGORY_RESERVED8,
	SDL_LOG_CATEGORY_RESERVED9,
	SDL_LOG_CATEGORY_RESERVED10,
	
	SDL_LOG_CATEGORY_CUSTOM,
}

alias SDL_LogPriority = uint;
enum: SDL_LogPriority{
	SDL_LOG_PRIORITY_VERBOSE = 1,
	SDL_LOG_PRIORITY_DEBUG,
	SDL_LOG_PRIORITY_INFO,
	SDL_LOG_PRIORITY_WARN,
	SDL_LOG_PRIORITY_ERROR,
	SDL_LOG_PRIORITY_CRITICAL,
	SDL_NUM_LOG_PRIORITIES,
}

alias SDL_LogOutputFunction = extern(C) void function(void* userdata, int category, SDL_LogPriority priority, const(char)* message) nothrow;

mixin(joinFnBinds((){
	string[][] ret;
	ret ~= makeFnBinds([
		[q{void}, q{SDL_LogSetAllPriority}, q{SDL_LogPriority priority}],
		[q{void}, q{SDL_LogSetPriority}, q{int category, SDL_LogPriority priority}],
		[q{SDL_LogPriority}, q{SDL_LogGetPriority}, q{int category}],
		[q{void}, q{SDL_LogResetPriorities}, q{}],
		[q{void}, q{SDL_Log}, q{const(char)* fmt, ...}],
		[q{void}, q{SDL_LogVerbose}, q{int category, const(char)* fmt, ...}],
		[q{void}, q{SDL_LogDebug}, q{int category, const(char)* fmt, ...}],
		[q{void}, q{SDL_LogInfo}, q{int category, const(char)* fmt, ...}],
		[q{void}, q{SDL_LogWarn}, q{int category, const(char)* fmt, ...}],
		[q{void}, q{SDL_LogError}, q{int category, const(char)* fmt, ...}],
		[q{void}, q{SDL_LogCritical}, q{int category, const(char)* fmt, ...}],
		[q{void}, q{SDL_LogMessage}, q{int category, SDL_LogPriority priority, const(char)* fmt, ...}],
		[q{void}, q{SDL_LogMessageV}, q{int category, SDL_LogPriority priority, const(char)* fmt, va_list ap}],
		[q{void}, q{SDL_LogGetOutputFunction}, q{SDL_LogOutputFunction callback, void** userdata}],
		[q{void}, q{SDL_LogSetOutputFunction}, q{SDL_LogOutputFunction callback, void* userdata}],
	]);
	return ret;
}()));
