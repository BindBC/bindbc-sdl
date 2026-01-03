/+
+            Copyright 2024 – 2026 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.process;

import bindbc.sdl.config, bindbc.sdl.codegen;

import sdl.iostream: SDL_IOStream;
import sdl.properties: SDL_PropertiesID;

struct SDL_Process;

mixin(makeEnumBind(q{SDL_ProcessIO}, aliases: [q{SDL_ProcessStdIO}], members: (){
	EnumMember[] ret = [
		{{q{inherited},    q{SDL_PROCESS_STDIO_INHERITED}}},
		{{q{null_},        q{SDL_PROCESS_STDIO_NULL}}},
		{{q{app},          q{SDL_PROCESS_STDIO_APP}}},
		{{q{redirect},     q{SDL_PROCESS_STDIO_REDIRECT}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDLProp_ProcessCreate}, q{const(char)*}, members: (){
	EnumMember[] ret = [
		{{q{argsPointer},                   q{SDL_PROP_PROCESS_CREATE_ARGS_POINTER}},                q{"SDL.process.create.args"}},
		{{q{environmentPointer},            q{SDL_PROP_PROCESS_CREATE_ENVIRONMENT_POINTER}},         q{"SDL.process.create.environment"}},
		{{q{stdInNumber},                   q{SDL_PROP_PROCESS_CREATE_STDIN_NUMBER}},                q{"SDL.process.create.stdin_option"}},
		{{q{stdInPointer},                  q{SDL_PROP_PROCESS_CREATE_STDIN_POINTER}},               q{"SDL.process.create.stdin_source"}},
		{{q{stdOutNumber},                  q{SDL_PROP_PROCESS_CREATE_STDOUT_NUMBER}},               q{"SDL.process.create.stdout_option"}},
		{{q{stdOutPointer},                 q{SDL_PROP_PROCESS_CREATE_STDOUT_POINTER}},              q{"SDL.process.create.stdout_source"}},
		{{q{stdErrNumber},                  q{SDL_PROP_PROCESS_CREATE_STDERR_NUMBER}},               q{"SDL.process.create.stderr_option"}},
		{{q{stdErrPointer},                 q{SDL_PROP_PROCESS_CREATE_STDERR_POINTER}},              q{"SDL.process.create.stderr_source"}},
		{{q{stdErrToStdOutBoolean},         q{SDL_PROP_PROCESS_CREATE_STDERR_TO_STDOUT_BOOLEAN}},    q{"SDL.process.create.stderr_to_stdout"}},
		{{q{backgroundBoolean},             q{SDL_PROP_PROCESS_CREATE_BACKGROUND_BOOLEAN}},          q{"SDL.process.create.background"}},
	];
	if(sdlVersion >= Version(3,4,0)){
		EnumMember[] add = [
			{{q{workingDirectoryString},    q{SDL_PROP_PROCESS_CREATE_WORKING_DIRECTORY_STRING}},    q{"SDL.process.create.working_directory"}},
			{{q{cmdLineString},             q{SDL_PROP_PROCESS_CREATE_CMDLINE_STRING}},              q{"SDL.process.create.cmdline"}},
		];
		ret ~= add;
	}
	return ret;
}()));

mixin(makeEnumBind(q{SDLProp_Process}, q{const(char)*}, members: (){
	EnumMember[] ret = [
		{{q{pidNumber},            q{SDL_PROP_PROCESS_PID_NUMBER}},            q{"SDL.process.pid"}},
		{{q{stdInPointer},         q{SDL_PROP_PROCESS_STDIN_POINTER}},         q{"SDL.process.stdin"}},
		{{q{stdOutPointer},        q{SDL_PROP_PROCESS_STDOUT_POINTER}},        q{"SDL.process.stdout"}},
		{{q{stdErrPointer},        q{SDL_PROP_PROCESS_STDERR_POINTER}},        q{"SDL.process.stderr"}},
		{{q{backgroundBoolean},    q{SDL_PROP_PROCESS_BACKGROUND_BOOLEAN}},    q{"SDL.process.background"}},
	];
	return ret;
}()));

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{SDL_Process*}, q{SDL_CreateProcess}, q{const(char*)* args, bool pipeStdIO}},
		{q{SDL_Process*}, q{SDL_CreateProcessWithProperties}, q{SDL_PropertiesID props}},
		{q{SDL_PropertiesID}, q{SDL_GetProcessProperties}, q{SDL_Process* process}},
		{q{void*}, q{SDL_ReadProcess}, q{SDL_Process* process, size_t* dataSize, int* exitCode}},
		{q{SDL_IOStream*}, q{SDL_GetProcessInput}, q{SDL_Process* process}},
		{q{SDL_IOStream*}, q{SDL_GetProcessOutput}, q{SDL_Process* process}},
		{q{bool}, q{SDL_KillProcess}, q{SDL_Process* process, bool force}},
		{q{bool}, q{SDL_WaitProcess}, q{SDL_Process* process, bool block, int* exitCode}},
		{q{void}, q{SDL_DestroyProcess}, q{SDL_Process* process}},
	];
	return ret;
}()));
