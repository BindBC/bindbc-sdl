/+
+            Copyright 2024 – 2026 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.mutex;

import bindbc.sdl.config, bindbc.sdl.codegen;

import sdl.atomic: SDL_AtomicInt;
import sdl.thread: SDL_ThreadID;

struct SDL_Mutex;

struct SDL_RWLock;

struct SDL_Semaphore;

struct SDL_Condition;

mixin(makeEnumBind(q{SDL_InitStatus}, members: (){
	EnumMember[] ret = [
		{{q{uninitialised},   q{SDL_INIT_STATUS_UNINITIALISED}}, aliases: [{q{uninitialized}, q{SDL_INIT_STATUS_UNINITIALIZED}}]},
		{{q{initialising},    q{SDL_INIT_STATUS_INITIALISING}}, aliases: [{q{initializing}, q{SDL_INIT_STATUS_INITIALIZING}}]},
		{{q{initialised},     q{SDL_INIT_STATUS_INITIALISED}}, aliases: [{q{initialized}, q{SDL_INIT_STATUS_INITIALIZED}}]},
		{{q{uninitialising},  q{SDL_INIT_STATUS_UNINITIALISING}}, aliases: [{q{uninitializing}, q{SDL_INIT_STATUS_UNINITIALIZING}}]},
	];
	return ret;
}()));

struct SDL_InitState{
	SDL_AtomicInt status;
	SDL_ThreadID thread;
	void* reserved;
}

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{SDL_Mutex*}, q{SDL_CreateMutex}, q{}},
		{q{void}, q{SDL_LockMutex}, q{SDL_Mutex* mutex}},
		{q{bool}, q{SDL_TryLockMutex}, q{SDL_Mutex* mutex}},
		{q{void}, q{SDL_UnlockMutex}, q{SDL_Mutex* mutex}},
		{q{void}, q{SDL_DestroyMutex}, q{SDL_Mutex* mutex}},
		{q{SDL_RWLock*}, q{SDL_CreateRWLock}, q{}},
		{q{void}, q{SDL_LockRWLockForReading}, q{SDL_RWLock* rwlock}},
		{q{void}, q{SDL_LockRWLockForWriting}, q{SDL_RWLock* rwlock}},
		{q{bool}, q{SDL_TryLockRWLockForReading}, q{SDL_RWLock* rwlock}},
		{q{bool}, q{SDL_TryLockRWLockForWriting}, q{SDL_RWLock* rwlock}},
		{q{void}, q{SDL_UnlockRWLock}, q{SDL_RWLock* rwlock}},
		{q{void}, q{SDL_DestroyRWLock}, q{SDL_RWLock* rwlock}},
		{q{SDL_Semaphore*}, q{SDL_CreateSemaphore}, q{uint initialValue}},
		{q{void}, q{SDL_DestroySemaphore}, q{SDL_Semaphore* sem}},
		{q{void}, q{SDL_WaitSemaphore}, q{SDL_Semaphore* sem}},
		{q{bool}, q{SDL_TryWaitSemaphore}, q{SDL_Semaphore* sem}},
		{q{bool}, q{SDL_WaitSemaphoreTimeout}, q{SDL_Semaphore* sem, int timeoutMS}},
		{q{void}, q{SDL_SignalSemaphore}, q{SDL_Semaphore* sem}},
		{q{uint}, q{SDL_GetSemaphoreValue}, q{SDL_Semaphore* sem}},
		{q{SDL_Condition*}, q{SDL_CreateCondition}, q{}},
		{q{void}, q{SDL_DestroyCondition}, q{SDL_Condition* cond}},
		{q{void}, q{SDL_SignalCondition}, q{SDL_Condition* cond}},
		{q{void}, q{SDL_BroadcastCondition}, q{SDL_Condition* cond}},
		{q{void}, q{SDL_WaitCondition}, q{SDL_Condition* cond, SDL_Mutex* mutex}},
		{q{bool}, q{SDL_WaitConditionTimeout}, q{SDL_Condition* cond, SDL_Mutex* mutex, int timeoutMS}},
		{q{bool}, q{SDL_ShouldInit}, q{SDL_InitState* state}},
		{q{bool}, q{SDL_ShouldQuit}, q{SDL_InitState* state}},
		{q{void}, q{SDL_SetInitialized}, q{SDL_InitState* state, bool initialised}, aliases: [q{SDL_SetInitialised}]},
	];
	return ret;
}()));
