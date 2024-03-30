/+
+            Copyright 2024 – 2025 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.vulkan;

import bindbc.sdl.config, bindbc.sdl.codegen;

import sdl.stdinc: SDL_FunctionPointer;
import sdl.video: SDL_Window;

alias VkInstance = void*;

alias VkPhysicalDevice = void*;

alias VkSurfaceKHR = ulong;

struct VkAllocationCallbacks;

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{bool}, q{SDL_Vulkan_LoadLibrary}, q{const(char)* path}},
		{q{SDL_FunctionPointer}, q{SDL_Vulkan_GetVkGetInstanceProcAddr}, q{}},
		{q{void}, q{SDL_Vulkan_UnloadLibrary}, q{}},
		{q{const(char*)*}, q{SDL_Vulkan_GetInstanceExtensions}, q{uint* count}},
		{q{bool}, q{SDL_Vulkan_CreateSurface}, q{SDL_Window* window, VkInstance instance, const(VkAllocationCallbacks)* allocator, VkSurfaceKHR* surface}},
		{q{void}, q{SDL_Vulkan_DestroySurface}, q{VkInstance instance, VkSurfaceKHR surface, const(VkAllocationCallbacks)* allocator}},
		{q{bool}, q{SDL_Vulkan_GetPresentationSupport}, q{VkInstance instance, VkPhysicalDevice physicalDevice, uint queueFamilyIndex}},
	];
	return ret;
}()));
