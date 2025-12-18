/+
+               Copyright 2025 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl_shadercross;

import bindbc.sdl.config;
static if(sdlShaderCrossVersion):
import bindbc.sdl.codegen;

import sdl.gpu: SDL_GPUComputePipeline, SDL_GPUDevice, SDL_GPUShader, SDL_GPUShaderFormat;
import sdl.properties: SDL_PropertiesID;

enum{
	SDL_ShaderCross_MajorVersion = sdlShaderCrossVersion.major,
	SDL_ShaderCross_MinorVersion = sdlShaderCrossVersion.minor,
	SDL_ShaderCross_MicroVersion = sdlShaderCrossVersion.patch,
	
	SDL_SHADERCROSS_MAJOR_VERSION = SDL_ShaderCross_MajorVersion,
	SDL_SHADERCROSS_MINOR_VERSION = SDL_ShaderCross_MinorVersion,
	SDL_SHADERCROSS_MICRO_VERSION = SDL_ShaderCross_MicroVersion,
}

mixin(makeEnumBind(q{SDL_ShaderCross_IOVarType}, members: (){
	EnumMember[] ret = [
		{{q{unknown}, q{SDL_SHADERCROSS_IOVAR_TYPE_UNKNOWN}}},
		{{q{int8}, q{SDL_SHADERCROSS_IOVAR_TYPE_INT8}}},
		{{q{uint8}, q{SDL_SHADERCROSS_IOVAR_TYPE_UINT8}}},
		{{q{int16}, q{SDL_SHADERCROSS_IOVAR_TYPE_INT16}}},
		{{q{uint16}, q{SDL_SHADERCROSS_IOVAR_TYPE_UINT16}}},
		{{q{int32}, q{SDL_SHADERCROSS_IOVAR_TYPE_INT32}}},
		{{q{uint32}, q{SDL_SHADERCROSS_IOVAR_TYPE_UINT32}}},
		{{q{int64}, q{SDL_SHADERCROSS_IOVAR_TYPE_INT64}}},
		{{q{uint64}, q{SDL_SHADERCROSS_IOVAR_TYPE_UINT64}}},
		{{q{float16}, q{SDL_SHADERCROSS_IOVAR_TYPE_FLOAT16}}},
		{{q{float32}, q{SDL_SHADERCROSS_IOVAR_TYPE_FLOAT32}}},
		{{q{float64}, q{SDL_SHADERCROSS_IOVAR_TYPE_FLOAT64}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_ShaderCross_ShaderStage}, members: (){
	EnumMember[] ret = [
		{{q{vertex}, q{SDL_SHADERCROSS_SHADERSTAGE_VERTEX}}},
		{{q{fragment}, q{SDL_SHADERCROSS_SHADERSTAGE_FRAGMENT}}},
		{{q{compute}, q{SDL_SHADERCROSS_SHADERSTAGE_COMPUTE}}},
	];
	return ret;
}()));

struct SDL_ShaderCross_IOVarMetadata{
	char* name;
	uint location;
	SDL_ShaderCross_IOVarType vectorType;
	uint vectorSize;
	
	alias vector_type = vectorType;
	alias vector_size = vectorSize;
}

struct SDL_ShaderCross_GraphicsShaderResourceInfo{
	uint numSamplers;
	uint numStorageTextures;
	uint numStorageBuffers;
	uint numUniformBuffers;
	
	alias num_samplers = numSamplers;
	alias num_storage_textures = numStorageTextures;
	alias num_storage_buffers = numStorageBuffers;
	alias num_uniform_buffers = numUniformBuffers;
}

struct SDL_ShaderCross_GraphicsShaderMetadata{
	SDL_ShaderCross_GraphicsShaderResourceInfo resourceInfo;
	uint numInputs;
	SDL_ShaderCross_IOVarMetadata* inputs;
	uint numOutputs;
	SDL_ShaderCross_IOVarMetadata* outputs;
	
	alias resource_info = resourceInfo;
	alias num_inputs = numInputs;
	alias num_outputs = numOutputs;
}

struct SDL_ShaderCross_ComputePipelineMetadata{
	uint numSamplers;
	uint numReadOnlyStorageTextures, numReadOnlyStorageBuffers;
	uint numReadWriteStorageTextures, numReadWriteStorageBuffers;
	uint numUniformBuffers;
	uint threadCountX, threadCountY, threadCountZ;
	
	alias num_samplers = numSamplers;
	alias num_readonly_storage_textures = numReadOnlyStorageTextures;
	alias num_readonly_storage_buffers = numReadOnlyStorageBuffers;
	alias num_readwrite_storage_textures = numReadWriteStorageTextures;
	alias num_readwrite_storage_buffers = numReadWriteStorageBuffers;
	alias num_uniform_buffers = numUniformBuffers;
	alias threadcount_x = threadCountX;
	alias threadcount_y = threadCountY;
	alias threadcount_z = threadCountZ;
}

struct SDL_ShaderCross_SPIRV_Info{
	const(ubyte)* bytecode;
	size_t bytecodeSize;
	const(char)* entryPoint;
	SDL_ShaderCross_ShaderStage shaderStage;
	SDL_PropertiesID props;
	
	alias bytecode_size = bytecodeSize;
	alias entrypoint = entryPoint;
	alias shader_stage = shaderStage;
}

mixin(makeEnumBind(q{SDL_ShaderCrossProp_Shader}, q{const(char)*}, members: (){
	EnumMember[] ret = [
		{{q{debugEnableBoolean},           q{SDL_SHADERCROSS_PROP_SHADER_DEBUG_ENABLE_BOOLEAN}},            q{"SDL_shadercross.spirv.debug.enable"}},
		{{q{debugNameString},              q{SDL_SHADERCROSS_PROP_SHADER_DEBUG_NAME_STRING}},               q{"SDL_shadercross.spirv.debug.name"}},
		{{q{cullUnusedBindingsBoolean},    q{SDL_SHADERCROSS_PROP_SHADER_CULL_UNUSED_BINDINGS_BOOLEAN}},    q{"SDL_shadercross.spirv.cull_unused_bindings"}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_ShaderCrossProp_SPIRV}, q{const(char)*}, members: (){
	EnumMember[] ret = [
		{{q{psslCompatibilityBoolean},    q{SDL_SHADERCROSS_PROP_SPIRV_PSSL_COMPATIBILITY_BOOLEAN}},    q{"SDL_shadercross.spirv.pssl.compatibility"}},
		{{q{mslVersionString},            q{SDL_SHADERCROSS_PROP_SPIRV_MSL_VERSION_STRING}},            q{"SDL_shadercross.spirv.msl.version"}},
	];
	return ret;
}()));

struct SDL_ShaderCross_HLSL_Define{
	char* name, value;
}

struct SDL_ShaderCross_HLSL_Info{
	const(char)* source;
	const(char)* entryPoint;
	const(char)* includeDir;
	SDL_ShaderCross_HLSL_Define* defines;
	SDL_ShaderCross_ShaderStage shaderStage;
	SDL_PropertiesID props;
	
	alias entrypoint = entryPoint;
	alias include_dir = includeDir;
	alias shader_stage = shaderStage;
}

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{bool}, q{SDL_ShaderCross_Init}, q{}},
		{q{void}, q{SDL_ShaderCross_Quit}, q{}},
		{q{SDL_GPUShaderFormat}, q{SDL_ShaderCross_GetSPIRVShaderFormats}, q{}},
		{q{void*}, q{SDL_ShaderCross_TranspileMSLFromSPIRV}, q{const(SDL_ShaderCross_SPIRV_Info)* info}},
		{q{void*}, q{SDL_ShaderCross_TranspileHLSLFromSPIRV}, q{const(SDL_ShaderCross_SPIRV_Info)* info}},
		{q{void*}, q{SDL_ShaderCross_CompileDXBCFromSPIRV}, q{const(SDL_ShaderCross_SPIRV_Info)* info, size_t* size}},
		{q{void*}, q{SDL_ShaderCross_CompileDXILFromSPIRV}, q{const(SDL_ShaderCross_SPIRV_Info)* info, size_t* size}},
		{q{SDL_GPUShader*}, q{SDL_ShaderCross_CompileGraphicsShaderFromSPIRV}, q{SDL_GPUDevice* device, const(SDL_ShaderCross_SPIRV_Info)* info, SDL_ShaderCross_GraphicsShaderResourceInfo* resourceInfo, SDL_PropertiesID props}},
		{q{SDL_GPUComputePipeline*}, q{SDL_ShaderCross_CompileComputePipelineFromSPIRV}, q{SDL_GPUDevice* device, const(SDL_ShaderCross_SPIRV_Info)* info, SDL_ShaderCross_ComputePipelineMetadata* metadata, SDL_PropertiesID props}},
		{q{SDL_ShaderCross_GraphicsShaderMetadata*}, q{SDL_ShaderCross_ReflectGraphicsSPIRV}, q{const(ubyte)* bytecode, size_t bytecodeSize, SDL_PropertiesID props}},
		{q{SDL_ShaderCross_ComputePipelineMetadata*}, q{SDL_ShaderCross_ReflectComputeSPIRV}, q{const(ubyte)* bytecode, size_t bytecodeSize, SDL_PropertiesID props}},
		{q{SDL_GPUShaderFormat}, q{SDL_ShaderCross_GetHLSLShaderFormats}, q{}},
		{q{void*}, q{SDL_ShaderCross_CompileDXBCFromHLSL}, q{const(SDL_ShaderCross_HLSL_Info)* info, size_t* size}},
		{q{void*}, q{SDL_ShaderCross_CompileDXILFromHLSL}, q{const(SDL_ShaderCross_HLSL_Info)* info, size_t* size}},
		{q{void*}, q{SDL_ShaderCross_CompileSPIRVFromHLSL}, q{const(SDL_ShaderCross_HLSL_Info)* info, size_t* size}},
	];
	return ret;
}()));

static if(!staticBinding):
import bindbc.loader;

mixin(makeDynloadFns("SDLShaderCross", makeLibPaths(["SDL3_shadercross"]), [__MODULE__]));
