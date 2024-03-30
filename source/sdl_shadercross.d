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
	SDL_SHADERCROSS_MAJOR_VERSION = sdlShaderCrossVersion.major,
	SDL_SHADERCROSS_MINOR_VERSION = sdlShaderCrossVersion.minor,
	SDL_SHADERCROSS_MICRO_VERSION = sdlShaderCrossVersion.patch,
}

mixin(makeEnumBind(q{SDL_ShaderCross_ShaderStage}, members: (){
	EnumMember[] ret = [
		{{q{vertex}, q{SDL_SHADERCROSS_SHADERSTAGE_VERTEX}}},
		{{q{fragment}, q{SDL_SHADERCROSS_SHADERSTAGE_FRAGMENT}}},
		{{q{compute}, q{SDL_SHADERCROSS_SHADERSTAGE_COMPUTE}}},
	];
	return ret;
}()));

struct SDL_ShaderCross_GraphicsShaderMetadata{
	uint numSamplers;
	uint numStorageTextures;
	uint numStorageBuffers;
	uint numUniformBuffers;
	SDL_PropertiesID props;
	
	alias num_samplers = numSamplers;
	alias num_storage_textures = numStorageTextures;
	alias num_storage_buffers = numStorageBuffers;
	alias num_uniform_buffers = numUniformBuffers;
}

struct SDL_ShaderCross_ComputePipelineMetadata{
	uint numSamplers;
	uint numReadOnlyStorageTextures, numReadOnlyStorageBuffers;
	uint numReadWriteStorageTextures, numReadWriteStorageBuffers;
	uint numUniformBuffers;
	uint threadCountX, threadCountY, threadCountZ;
	SDL_PropertiesID props;
	
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

struct SDL_ShaderCross_SPIRV_Info
{
	const(ubyte)* bytecode;
	size_t bytecodeSize;
	const(char)* entryPoint;
	SDL_ShaderCross_ShaderStage shaderStage;
	bool enableDebug;
	const(char)* name;
	SDL_PropertiesID props;
	
	alias bytecode_size = bytecodeSize;
	alias entrypoint = entryPoint;
	alias shader_stage = shaderStage;
	alias enable_debug = enableDebug;
}

struct SDL_ShaderCross_HLSL_Define{
	char* name, value;
}

struct SDL_ShaderCross_HLSL_Info{
	const(char)* source;
	const(char)* entryPoint;
	const(char)* includeDir;
	SDL_ShaderCross_HLSL_Define* defines;
	SDL_ShaderCross_ShaderStage shaderStage;
	bool enableDebug;
	const(char)* name;
	SDL_PropertiesID props;
	
	alias entrypoint = entryPoint;
	alias include_dir = includeDir;
	alias shader_stage = shaderStage;
	alias enable_debug = enableDebug;
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
		{q{SDL_GPUShader*}, q{SDL_ShaderCross_CompileGraphicsShaderFromSPIRV}, q{SDL_GPUDevice* device, const(SDL_ShaderCross_SPIRV_Info)* info, SDL_ShaderCross_GraphicsShaderMetadata* metadata}},
		{q{SDL_GPUComputePipeline*}, q{SDL_ShaderCross_CompileComputePipelineFromSPIRV}, q{SDL_GPUDevice* device, const(SDL_ShaderCross_SPIRV_Info)* info, SDL_ShaderCross_ComputePipelineMetadata* metadata}},
		{q{bool}, q{SDL_ShaderCross_ReflectGraphicsSPIRV}, q{const(ubyte)* bytecode, size_t bytecodeSize, SDL_ShaderCross_GraphicsShaderMetadata* metadata}},
		{q{bool}, q{SDL_ShaderCross_ReflectComputeSPIRV}, q{const(ubyte)* bytecode, size_t bytecodeSize, SDL_ShaderCross_ComputePipelineMetadata* metadata}},
		{q{SDL_GPUShaderFormat}, q{SDL_ShaderCross_GetHLSLShaderFormats}, q{}},
		{q{void*}, q{SDL_ShaderCross_CompileDXBCFromHLSL}, q{const(SDL_ShaderCross_HLSL_Info)* info, size_t* size}},
		{q{void*}, q{SDL_ShaderCross_CompileDXILFromHLSL}, q{const(SDL_ShaderCross_HLSL_Info)* info, size_t* size}},
		{q{void*}, q{SDL_ShaderCross_CompileSPIRVFromHLSL}, q{const(SDL_ShaderCross_HLSL_Info)* info, size_t* size}},
		{q{SDL_GPUShader*}, q{SDL_ShaderCross_CompileGraphicsShaderFromHLSL}, q{SDL_GPUDevice* device, const(SDL_ShaderCross_HLSL_Info)* info, SDL_ShaderCross_GraphicsShaderMetadata* metadata}},
		{q{SDL_GPUComputePipeline*}, q{SDL_ShaderCross_CompileComputePipelineFromHLSL}, q{SDL_GPUDevice* device, const(SDL_ShaderCross_HLSL_Info)* info, SDL_ShaderCross_ComputePipelineMetadata* metadata}},
	];
	return ret;
}()));

static if(!staticBinding):
import bindbc.loader;

mixin(makeDynloadFns("SDLShaderCross", makeLibPaths(["SDL3_shadercross"]), [__MODULE__]));
