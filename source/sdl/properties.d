/+
+            Copyright 2024 – 2025 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.properties;

import bindbc.sdl.config, bindbc.sdl.codegen;

alias SDL_PropertiesID = uint;

mixin(makeEnumBind(q{SDL_PropertyType}, members: (){
	EnumMember[] ret = [
		{{q{invalid},  q{SDL_PROPERTY_TYPE_INVALID}}},
		{{q{pointer},  q{SDL_PROPERTY_TYPE_POINTER}}},
		{{q{string},   q{SDL_PROPERTY_TYPE_STRING}}},
		{{q{number},   q{SDL_PROPERTY_TYPE_NUMBER}}},
		{{q{float_},   q{SDL_PROPERTY_TYPE_FLOAT}}},
		{{q{boolean},  q{SDL_PROPERTY_TYPE_BOOLEAN}}},
	];
	return ret;
}()));

extern(C) nothrow{
	alias SDL_CleanupPropertyCallback = void function(void* userData, void* value);
	alias SDL_EnumeratePropertiesCallback = void function(void* userData, SDL_PropertiesID props, const(char)* name);
}

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{SDL_PropertiesID}, q{SDL_GetGlobalProperties}, q{}},
		{q{SDL_PropertiesID}, q{SDL_CreateProperties}, q{}},
		{q{bool}, q{SDL_CopyProperties}, q{SDL_PropertiesID src, SDL_PropertiesID dst}},
		{q{bool}, q{SDL_LockProperties}, q{SDL_PropertiesID props}},
		{q{void}, q{SDL_UnlockProperties}, q{SDL_PropertiesID props}},
		{q{bool}, q{SDL_SetPointerPropertyWithCleanup}, q{SDL_PropertiesID props, const(char)* name, void* value, SDL_CleanupPropertyCallback cleanup, void* userData}},
		{q{bool}, q{SDL_SetPointerProperty}, q{SDL_PropertiesID props, const(char)* name, void* value}},
		{q{bool}, q{SDL_SetStringProperty}, q{SDL_PropertiesID props, const(char)* name, const(char)* value}},
		{q{bool}, q{SDL_SetNumberProperty}, q{SDL_PropertiesID props, const(char)* name, long value}},
		{q{bool}, q{SDL_SetFloatProperty}, q{SDL_PropertiesID props, const(char)* name, float value}},
		{q{bool}, q{SDL_SetBooleanProperty}, q{SDL_PropertiesID props, const(char)* name, bool value}},
		{q{bool}, q{SDL_HasProperty}, q{SDL_PropertiesID props, const(char)* name}},
		{q{SDL_PropertyType}, q{SDL_GetPropertyType}, q{SDL_PropertiesID props, const(char)* name}},
		{q{void*}, q{SDL_GetPointerProperty}, q{SDL_PropertiesID props, const(char)* name, void* defaultValue}},
		{q{const(char)*}, q{SDL_GetStringProperty}, q{SDL_PropertiesID props, const(char)* name, const(char)* defaultValue}},
		{q{long}, q{SDL_GetNumberProperty}, q{SDL_PropertiesID props, const(char)* name, long defaultValue}},
		{q{float}, q{SDL_GetFloatProperty}, q{SDL_PropertiesID props, const(char)* name, float defaultValue}},
		{q{bool}, q{SDL_GetBooleanProperty}, q{SDL_PropertiesID props, const(char)* name, bool defaultValue}},
		{q{bool}, q{SDL_ClearProperty}, q{SDL_PropertiesID props, const(char)* name}},
		{q{bool}, q{SDL_EnumerateProperties}, q{SDL_PropertiesID props, SDL_EnumeratePropertiesCallback callback, void* userData}},
		{q{void}, q{SDL_DestroyProperties}, q{SDL_PropertiesID props}},
	];
	return ret;
}()));
