/+
+            Copyright 2024 – 2026 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.gpu;

import bindbc.sdl.config, bindbc.sdl.codegen;

import sdl.pixels: SDL_FColour, SDL_PixelFormat;
import sdl.properties: SDL_PropertiesID;
import sdl.rect: SDL_Rect;
import sdl.surface: SDL_FlipMode;
import sdl.video: SDL_Window;

struct SDL_GPUDevice;

struct SDL_GPUBuffer;

struct SDL_GPUTransferBuffer;

struct SDL_GPUTexture;

struct SDL_GPUSampler;

struct SDL_GPUShader;

struct SDL_GPUComputePipeline;

struct SDL_GPUGraphicsPipeline;

struct SDL_GPUCommandBuffer;

struct SDL_GPURenderPass;

struct SDL_GPUComputePass;

struct SDL_GPUCopyPass;

struct SDL_GPUFence;

mixin(makeEnumBind(q{SDL_GPUPrimitiveType}, members: (){
	EnumMember[] ret = [
		{{q{triangleList},     q{SDL_GPU_PRIMITIVETYPE_TRIANGLELIST}}},
		{{q{triangleStrip},    q{SDL_GPU_PRIMITIVETYPE_TRIANGLESTRIP}}},
		{{q{lineList},         q{SDL_GPU_PRIMITIVETYPE_LINELIST}}},
		{{q{lineStrip},        q{SDL_GPU_PRIMITIVETYPE_LINESTRIP}}},
		{{q{pointList},        q{SDL_GPU_PRIMITIVETYPE_POINTLIST}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_GPULoadOp}, members: (){
	EnumMember[] ret = [
		{{q{load},        q{SDL_GPU_LOADOP_LOAD}}},
		{{q{clear},       q{SDL_GPU_LOADOP_CLEAR}}},
		{{q{dontCare},    q{SDL_GPU_LOADOP_DONT_CARE}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_GPUStoreOp}, members: (){
	EnumMember[] ret = [
		{{q{store},              q{SDL_GPU_STOREOP_STORE}}},
		{{q{dontCare},           q{SDL_GPU_STOREOP_DONT_CARE}}},
		{{q{resolve},            q{SDL_GPU_STOREOP_RESOLVE}}},
		{{q{resolveAndStore},    q{SDL_GPU_STOREOP_RESOLVE_AND_STORE}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_GPUIndexElementSize}, members: (){
	EnumMember[] ret = [
		{{q{_16Bit},  q{SDL_GPU_INDEXELEMENTSIZE_16BIT}}},
		{{q{_32Bit},  q{SDL_GPU_INDEXELEMENTSIZE_32BIT}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_GPUTextureFormat}, members: (){
	EnumMember[] ret = [
		{{q{invalid},              q{SDL_GPU_TEXTUREFORMAT_INVALID}}},
		{{q{a8UNorm},              q{SDL_GPU_TEXTUREFORMAT_A8_UNORM}}},
		{{q{r8UNorm},              q{SDL_GPU_TEXTUREFORMAT_R8_UNORM}}},
		{{q{r8g8UNorm},            q{SDL_GPU_TEXTUREFORMAT_R8G8_UNORM}}},
		{{q{r8g8b8a8UNorm},        q{SDL_GPU_TEXTUREFORMAT_R8G8B8A8_UNORM}}},
		{{q{r16UNorm},             q{SDL_GPU_TEXTUREFORMAT_R16_UNORM}}},
		{{q{r16g16UNorm},          q{SDL_GPU_TEXTUREFORMAT_R16G16_UNORM}}},
		{{q{r16g16b16a16UNorm},    q{SDL_GPU_TEXTUREFORMAT_R16G16B16A16_UNORM}}},
		{{q{r10g10b10a2UNorm},     q{SDL_GPU_TEXTUREFORMAT_R10G10B10A2_UNORM}}},
		{{q{b5g6r5UNorm},          q{SDL_GPU_TEXTUREFORMAT_B5G6R5_UNORM}}},
		{{q{b5g5r5a1UNorm},        q{SDL_GPU_TEXTUREFORMAT_B5G5R5A1_UNORM}}},
		{{q{b4g4r4a4UNorm},        q{SDL_GPU_TEXTUREFORMAT_B4G4R4A4_UNORM}}},
		{{q{b8g8r8a8UNorm},        q{SDL_GPU_TEXTUREFORMAT_B8G8R8A8_UNORM}}},
		{{q{bc1RGBAUNorm},         q{SDL_GPU_TEXTUREFORMAT_BC1_RGBA_UNORM}}},
		{{q{bc2RGBAUNorm},         q{SDL_GPU_TEXTUREFORMAT_BC2_RGBA_UNORM}}},
		{{q{bc3RGBAUNorm},         q{SDL_GPU_TEXTUREFORMAT_BC3_RGBA_UNORM}}},
		{{q{bc4RUNorm},            q{SDL_GPU_TEXTUREFORMAT_BC4_R_UNORM}}},
		{{q{bc5RGUNorm},           q{SDL_GPU_TEXTUREFORMAT_BC5_RG_UNORM}}},
		{{q{bc7RGBAUNorm},         q{SDL_GPU_TEXTUREFORMAT_BC7_RGBA_UNORM}}},
		{{q{bc6hRGBFloat},         q{SDL_GPU_TEXTUREFORMAT_BC6H_RGB_FLOAT}}},
		{{q{bc6hRGBUFloat},        q{SDL_GPU_TEXTUREFORMAT_BC6H_RGB_UFLOAT}}},
		{{q{r8SNorm},              q{SDL_GPU_TEXTUREFORMAT_R8_SNORM}}},
		{{q{r8g8SNorm},            q{SDL_GPU_TEXTUREFORMAT_R8G8_SNORM}}},
		{{q{r8g8b8a8SNorm},        q{SDL_GPU_TEXTUREFORMAT_R8G8B8A8_SNORM}}},
		{{q{r16SNorm},             q{SDL_GPU_TEXTUREFORMAT_R16_SNORM}}},
		{{q{r16g16SNorm},          q{SDL_GPU_TEXTUREFORMAT_R16G16_SNORM}}},
		{{q{r16g16b16a16SNorm},    q{SDL_GPU_TEXTUREFORMAT_R16G16B16A16_SNORM}}},
		{{q{r16Float},             q{SDL_GPU_TEXTUREFORMAT_R16_FLOAT}}},
		{{q{r16g16Float},          q{SDL_GPU_TEXTUREFORMAT_R16G16_FLOAT}}},
		{{q{r16g16b16a16Float},    q{SDL_GPU_TEXTUREFORMAT_R16G16B16A16_FLOAT}}},
		{{q{r32Float},             q{SDL_GPU_TEXTUREFORMAT_R32_FLOAT}}},
		{{q{r32g32Float},          q{SDL_GPU_TEXTUREFORMAT_R32G32_FLOAT}}},
		{{q{r32g32b32a32Float},    q{SDL_GPU_TEXTUREFORMAT_R32G32B32A32_FLOAT}}},
		{{q{r11g11b10UFloat},      q{SDL_GPU_TEXTUREFORMAT_R11G11B10_UFLOAT}}},
		{{q{r8UInt},               q{SDL_GPU_TEXTUREFORMAT_R8_UINT}}},
		{{q{r8g8Uint},             q{SDL_GPU_TEXTUREFORMAT_R8G8_UINT}}},
		{{q{r8g8b8a8UInt},         q{SDL_GPU_TEXTUREFORMAT_R8G8B8A8_UINT}}},
		{{q{r16UInt},              q{SDL_GPU_TEXTUREFORMAT_R16_UINT}}},
		{{q{r16g16UInt},           q{SDL_GPU_TEXTUREFORMAT_R16G16_UINT}}},
		{{q{r16g16b16a16UInt},     q{SDL_GPU_TEXTUREFORMAT_R16G16B16A16_UINT}}},
		{{q{r32UInt},              q{SDL_GPU_TEXTUREFORMAT_R32_UINT}}},
		{{q{r32g32UInt},           q{SDL_GPU_TEXTUREFORMAT_R32G32_UINT}}},
		{{q{r32g32b32a32UInt},     q{SDL_GPU_TEXTUREFORMAT_R32G32B32A32_UINT}}},
		{{q{r8Int},                q{SDL_GPU_TEXTUREFORMAT_R8_INT}}},
		{{q{r8g8Int},              q{SDL_GPU_TEXTUREFORMAT_R8G8_INT}}},
		{{q{r8g8b8a8Int},          q{SDL_GPU_TEXTUREFORMAT_R8G8B8A8_INT}}},
		{{q{r16Int},               q{SDL_GPU_TEXTUREFORMAT_R16_INT}}},
		{{q{r16g16Int},            q{SDL_GPU_TEXTUREFORMAT_R16G16_INT}}},
		{{q{r16g16b16a16Int},      q{SDL_GPU_TEXTUREFORMAT_R16G16B16A16_INT}}},
		{{q{r32Int},               q{SDL_GPU_TEXTUREFORMAT_R32_INT}}},
		{{q{r32g32Int},            q{SDL_GPU_TEXTUREFORMAT_R32G32_INT}}},
		{{q{r32g32b32a32Int},      q{SDL_GPU_TEXTUREFORMAT_R32G32B32A32_INT}}},
		{{q{r8g8b8a8UNormSRGB},    q{SDL_GPU_TEXTUREFORMAT_R8G8B8A8_UNORM_SRGB}}},
		{{q{b8g8r8a8UNormSRGB},    q{SDL_GPU_TEXTUREFORMAT_B8G8R8A8_UNORM_SRGB}}},
		{{q{bc1RGBAUNormSRGB},     q{SDL_GPU_TEXTUREFORMAT_BC1_RGBA_UNORM_SRGB}}},
		{{q{bc2RGBAUNormSRGB},     q{SDL_GPU_TEXTUREFORMAT_BC2_RGBA_UNORM_SRGB}}},
		{{q{bc3RGBAUNormSRGB},     q{SDL_GPU_TEXTUREFORMAT_BC3_RGBA_UNORM_SRGB}}},
		{{q{bc7RGBAUNormSRGB},     q{SDL_GPU_TEXTUREFORMAT_BC7_RGBA_UNORM_SRGB}}},
		{{q{d16UNorm},             q{SDL_GPU_TEXTUREFORMAT_D16_UNORM}}},
		{{q{d24UNorm},             q{SDL_GPU_TEXTUREFORMAT_D24_UNORM}}},
		{{q{d32Float},             q{SDL_GPU_TEXTUREFORMAT_D32_FLOAT}}},
		{{q{d24UNormS8UInt},       q{SDL_GPU_TEXTUREFORMAT_D24_UNORM_S8_UINT}}},
		{{q{d32FloatS8UInt},       q{SDL_GPU_TEXTUREFORMAT_D32_FLOAT_S8_UINT}}},
		{{q{astc4x4UNorm},         q{SDL_GPU_TEXTUREFORMAT_ASTC_4x4_UNORM}}},
		{{q{astc5x4UNorm},         q{SDL_GPU_TEXTUREFORMAT_ASTC_5x4_UNORM}}},
		{{q{astc5x5UNorm},         q{SDL_GPU_TEXTUREFORMAT_ASTC_5x5_UNORM}}},
		{{q{astc6x5UNorm},         q{SDL_GPU_TEXTUREFORMAT_ASTC_6x5_UNORM}}},
		{{q{astc6x6UNorm},         q{SDL_GPU_TEXTUREFORMAT_ASTC_6x6_UNORM}}},
		{{q{astc8x5UNorm},         q{SDL_GPU_TEXTUREFORMAT_ASTC_8x5_UNORM}}},
		{{q{astc8x6UNorm},         q{SDL_GPU_TEXTUREFORMAT_ASTC_8x6_UNORM}}},
		{{q{astc8x8UNorm},         q{SDL_GPU_TEXTUREFORMAT_ASTC_8x8_UNORM}}},
		{{q{astc10x5UNorm},        q{SDL_GPU_TEXTUREFORMAT_ASTC_10x5_UNORM}}},
		{{q{astc10x6UNorm},        q{SDL_GPU_TEXTUREFORMAT_ASTC_10x6_UNORM}}},
		{{q{astc10x8UNorm},        q{SDL_GPU_TEXTUREFORMAT_ASTC_10x8_UNORM}}},
		{{q{astc10x10UNorm},       q{SDL_GPU_TEXTUREFORMAT_ASTC_10x10_UNORM}}},
		{{q{astc12x10UNorm},       q{SDL_GPU_TEXTUREFORMAT_ASTC_12x10_UNORM}}},
		{{q{astc12x12UNorm},       q{SDL_GPU_TEXTUREFORMAT_ASTC_12x12_UNORM}}},
		{{q{astc4x4UNormSRGB},     q{SDL_GPU_TEXTUREFORMAT_ASTC_4x4_UNORM_SRGB}}},
		{{q{astc5x4UNormSRGB},     q{SDL_GPU_TEXTUREFORMAT_ASTC_5x4_UNORM_SRGB}}},
		{{q{astc5x5UNormSRGB},     q{SDL_GPU_TEXTUREFORMAT_ASTC_5x5_UNORM_SRGB}}},
		{{q{astc6x5UNormSRGB},     q{SDL_GPU_TEXTUREFORMAT_ASTC_6x5_UNORM_SRGB}}},
		{{q{astc6x6UNormSRGB},     q{SDL_GPU_TEXTUREFORMAT_ASTC_6x6_UNORM_SRGB}}},
		{{q{astc8x5UNormSRGB},     q{SDL_GPU_TEXTUREFORMAT_ASTC_8x5_UNORM_SRGB}}},
		{{q{astc8x6UNormSRGB},     q{SDL_GPU_TEXTUREFORMAT_ASTC_8x6_UNORM_SRGB}}},
		{{q{astc8x8UNormSRGB},     q{SDL_GPU_TEXTUREFORMAT_ASTC_8x8_UNORM_SRGB}}},
		{{q{astc10x5UNormSRGB},    q{SDL_GPU_TEXTUREFORMAT_ASTC_10x5_UNORM_SRGB}}},
		{{q{astc10x6UNormSRGB},    q{SDL_GPU_TEXTUREFORMAT_ASTC_10x6_UNORM_SRGB}}},
		{{q{astc10x8UNormSRGB},    q{SDL_GPU_TEXTUREFORMAT_ASTC_10x8_UNORM_SRGB}}},
		{{q{astc10x10UNormSRGB},   q{SDL_GPU_TEXTUREFORMAT_ASTC_10x10_UNORM_SRGB}}},
		{{q{astc12x10UNormSRGB},   q{SDL_GPU_TEXTUREFORMAT_ASTC_12x10_UNORM_SRGB}}},
		{{q{astc12x12UNormSRGB},   q{SDL_GPU_TEXTUREFORMAT_ASTC_12x12_UNORM_SRGB}}},
		{{q{astc4x4Float},         q{SDL_GPU_TEXTUREFORMAT_ASTC_4x4_FLOAT}}},
		{{q{astc5x4Float},         q{SDL_GPU_TEXTUREFORMAT_ASTC_5x4_FLOAT}}},
		{{q{astc5x5Float},         q{SDL_GPU_TEXTUREFORMAT_ASTC_5x5_FLOAT}}},
		{{q{astc6x5Float},         q{SDL_GPU_TEXTUREFORMAT_ASTC_6x5_FLOAT}}},
		{{q{astc6x6Float},         q{SDL_GPU_TEXTUREFORMAT_ASTC_6x6_FLOAT}}},
		{{q{astc8x5Float},         q{SDL_GPU_TEXTUREFORMAT_ASTC_8x5_FLOAT}}},
		{{q{astc8x6Float},         q{SDL_GPU_TEXTUREFORMAT_ASTC_8x6_FLOAT}}},
		{{q{astc8x8Float},         q{SDL_GPU_TEXTUREFORMAT_ASTC_8x8_FLOAT}}},
		{{q{astc10x5Float},        q{SDL_GPU_TEXTUREFORMAT_ASTC_10x5_FLOAT}}},
		{{q{astc10x6Float},        q{SDL_GPU_TEXTUREFORMAT_ASTC_10x6_FLOAT}}},
		{{q{astc10x8Float},        q{SDL_GPU_TEXTUREFORMAT_ASTC_10x8_FLOAT}}},
		{{q{astc10x10Float},       q{SDL_GPU_TEXTUREFORMAT_ASTC_10x10_FLOAT}}},
		{{q{astc12x10Float},       q{SDL_GPU_TEXTUREFORMAT_ASTC_12x10_FLOAT}}},
		{{q{astc12x12Float},       q{SDL_GPU_TEXTUREFORMAT_ASTC_12x12_FLOAT}}},
	];
	return ret;
}()));

alias SDL_GPUTextureUsageFlags_ = uint;
mixin(makeEnumBind(q{SDL_GPUTextureUsageFlags}, q{SDL_GPUTextureUsageFlags_}, aliases: [q{SDL_GPUTextureUsage}], members: (){
	EnumMember[] ret = [
		{{q{sampler},                                q{SDL_GPU_TEXTUREUSAGE_SAMPLER}},                                    q{1U << 0}},
		{{q{colourTarget},                           q{SDL_GPU_TEXTUREUSAGE_COLOUR_TARGET}},                              q{1U << 1}, aliases: [{q{colorTarget}, q{SDL_GPU_TEXTUREUSAGE_COLOR_TARGET}}]},
		{{q{depthStencilTarget},                     q{SDL_GPU_TEXTUREUSAGE_DEPTH_STENCIL_TARGET}},                       q{1U << 2}},
		{{q{graphicsStorageRead},                    q{SDL_GPU_TEXTUREUSAGE_GRAPHICS_STORAGE_READ}},                      q{1U << 3}},
		{{q{computeStorageRead},                     q{SDL_GPU_TEXTUREUSAGE_COMPUTE_STORAGE_READ}},                       q{1U << 4}},
		{{q{computeStorageWrite},                    q{SDL_GPU_TEXTUREUSAGE_COMPUTE_STORAGE_WRITE}},                      q{1U << 5}},
		{{q{computeStorageSimultaneousReadWrite},    q{SDL_GPU_TEXTUREUSAGE_COMPUTE_STORAGE_SIMULTANEOUS_READ_WRITE}},    q{1U << 6}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_GPUTextureType}, members: (){
	EnumMember[] ret = [
		{{q{_2D},          q{SDL_GPU_TEXTURETYPE_2D}}},
		{{q{_2DArray},     q{SDL_GPU_TEXTURETYPE_2D_ARRAY}}},
		{{q{_3D},          q{SDL_GPU_TEXTURETYPE_3D}}},
		{{q{cube},         q{SDL_GPU_TEXTURETYPE_CUBE}}},
		{{q{cubeArray},    q{SDL_GPU_TEXTURETYPE_CUBE_ARRAY}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_GPUSampleCount}, members: (){
	EnumMember[] ret = [
		{{q{_1},  q{SDL_GPU_SAMPLECOUNT_1}}},
		{{q{_2},  q{SDL_GPU_SAMPLECOUNT_2}}},
		{{q{_4},  q{SDL_GPU_SAMPLECOUNT_4}}},
		{{q{_8},  q{SDL_GPU_SAMPLECOUNT_8}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_GPUCubeMapFace}, members: (){
	EnumMember[] ret = [
		{{q{positiveX},  q{SDL_GPU_CUBEMAPFACE_POSITIVEX}}},
		{{q{negativeX},  q{SDL_GPU_CUBEMAPFACE_NEGATIVEX}}},
		{{q{positiveY},  q{SDL_GPU_CUBEMAPFACE_POSITIVEY}}},
		{{q{negativeY},  q{SDL_GPU_CUBEMAPFACE_NEGATIVEY}}},
		{{q{positiveZ},  q{SDL_GPU_CUBEMAPFACE_POSITIVEZ}}},
		{{q{negativeZ},  q{SDL_GPU_CUBEMAPFACE_NEGATIVEZ}}},
	];
	return ret;
}()));

alias SDL_GPUBufferUsageFlags_ = uint;
mixin(makeEnumBind(q{SDL_GPUBufferUsageFlags}, q{SDL_GPUBufferUsageFlags_}, aliases: [q{SDL_GPUBufferUsage}], members: (){
	EnumMember[] ret = [
		{{q{vertex},                 q{SDL_GPU_BUFFERUSAGE_VERTEX}},                   q{1U << 0}},
		{{q{index},                  q{SDL_GPU_BUFFERUSAGE_INDEX}},                    q{1U << 1}},
		{{q{indirect},               q{SDL_GPU_BUFFERUSAGE_INDIRECT}},                 q{1U << 2}},
		{{q{graphicsStorageRead},    q{SDL_GPU_BUFFERUSAGE_GRAPHICS_STORAGE_READ}},    q{1U << 3}},
		{{q{computeStorageRead},     q{SDL_GPU_BUFFERUSAGE_COMPUTE_STORAGE_READ}},     q{1U << 4}},
		{{q{computeStorageWrite},    q{SDL_GPU_BUFFERUSAGE_COMPUTE_STORAGE_WRITE}},    q{1U << 5}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_GPUTransferBufferUsage}, members: (){
	EnumMember[] ret = [
		{{q{upload},    q{SDL_GPU_TRANSFERBUFFERUSAGE_UPLOAD}}},
		{{q{download},  q{SDL_GPU_TRANSFERBUFFERUSAGE_DOWNLOAD}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_GPUShaderStage}, members: (){
	EnumMember[] ret = [
		{{q{vertex},      q{SDL_GPU_SHADERSTAGE_VERTEX}}},
		{{q{fragment},    q{SDL_GPU_SHADERSTAGE_FRAGMENT}}},
	];
	return ret;
}()));

alias SDL_GPUShaderFormat_ = uint;
mixin(makeEnumBind(q{SDL_GPUShaderFormat}, q{SDL_GPUShaderFormat_}, members: (){
	EnumMember[] ret = [
		{{q{invalid},     q{SDL_GPU_SHADERFORMAT_INVALID}},     q{0}},
		{{q{private_},    q{SDL_GPU_SHADERFORMAT_PRIVATE}},     q{1U << 0}},
		{{q{spirV},       q{SDL_GPU_SHADERFORMAT_SPIRV}},       q{1U << 1}},
		{{q{dxbc},        q{SDL_GPU_SHADERFORMAT_DXBC}},        q{1U << 2}},
		{{q{dxil},        q{SDL_GPU_SHADERFORMAT_DXIL}},        q{1U << 3}},
		{{q{msl},         q{SDL_GPU_SHADERFORMAT_MSL}},         q{1U << 4}},
		{{q{metallib},    q{SDL_GPU_SHADERFORMAT_METALLIB}},    q{1U << 5}},
		];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_GPUVertexElementFormat}, members: (){
	EnumMember[] ret = [
		{{q{invalid},        q{SDL_GPU_VERTEXELEMENTFORMAT_INVALID}}},
		{{q{int_},           q{SDL_GPU_VERTEXELEMENTFORMAT_INT}}},
		{{q{int2},           q{SDL_GPU_VERTEXELEMENTFORMAT_INT2}}},
		{{q{int3},           q{SDL_GPU_VERTEXELEMENTFORMAT_INT3}}},
		{{q{int4},           q{SDL_GPU_VERTEXELEMENTFORMAT_INT4}}},
		{{q{uint_},          q{SDL_GPU_VERTEXELEMENTFORMAT_UINT}}},
		{{q{uint2},          q{SDL_GPU_VERTEXELEMENTFORMAT_UINT2}}},
		{{q{uint3},          q{SDL_GPU_VERTEXELEMENTFORMAT_UINT3}}},
		{{q{uint4},          q{SDL_GPU_VERTEXELEMENTFORMAT_UINT4}}},
		{{q{float_},         q{SDL_GPU_VERTEXELEMENTFORMAT_FLOAT}}},
		{{q{float2},         q{SDL_GPU_VERTEXELEMENTFORMAT_FLOAT2}}},
		{{q{float3},         q{SDL_GPU_VERTEXELEMENTFORMAT_FLOAT3}}},
		{{q{float4},         q{SDL_GPU_VERTEXELEMENTFORMAT_FLOAT4}}},
		{{q{byte2},          q{SDL_GPU_VERTEXELEMENTFORMAT_BYTE2}}},
		{{q{byte4},          q{SDL_GPU_VERTEXELEMENTFORMAT_BYTE4}}},
		{{q{ubyte2},         q{SDL_GPU_VERTEXELEMENTFORMAT_UBYTE2}}},
		{{q{ubyte4},         q{SDL_GPU_VERTEXELEMENTFORMAT_UBYTE4}}},
		{{q{byte2Norm},      q{SDL_GPU_VERTEXELEMENTFORMAT_BYTE2_NORM}}},
		{{q{byte4Norm},      q{SDL_GPU_VERTEXELEMENTFORMAT_BYTE4_NORM}}},
		{{q{ubyte2Norm},     q{SDL_GPU_VERTEXELEMENTFORMAT_UBYTE2_NORM}}},
		{{q{ubyte4Norm},     q{SDL_GPU_VERTEXELEMENTFORMAT_UBYTE4_NORM}}},
		{{q{short2},         q{SDL_GPU_VERTEXELEMENTFORMAT_SHORT2}}},
		{{q{short4},         q{SDL_GPU_VERTEXELEMENTFORMAT_SHORT4}}},
		{{q{ushort2},        q{SDL_GPU_VERTEXELEMENTFORMAT_USHORT2}}},
		{{q{ushort4},        q{SDL_GPU_VERTEXELEMENTFORMAT_USHORT4}}},
		{{q{short2Norm},     q{SDL_GPU_VERTEXELEMENTFORMAT_SHORT2_NORM}}},
		{{q{short4Norm},     q{SDL_GPU_VERTEXELEMENTFORMAT_SHORT4_NORM}}},
		{{q{ushort2Norm},    q{SDL_GPU_VERTEXELEMENTFORMAT_USHORT2_NORM}}},
		{{q{ushort4Norm},    q{SDL_GPU_VERTEXELEMENTFORMAT_USHORT4_NORM}}},
		{{q{half2},          q{SDL_GPU_VERTEXELEMENTFORMAT_HALF2}}},
		{{q{half4},          q{SDL_GPU_VERTEXELEMENTFORMAT_HALF4}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_GPUVertexInputRate}, members: (){
	EnumMember[] ret = [
		{{q{vertex},      q{SDL_GPU_VERTEXINPUTRATE_VERTEX}}},
		{{q{instance},    q{SDL_GPU_VERTEXINPUTRATE_INSTANCE}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_GPUFillMode}, members: (){
	EnumMember[] ret = [
		{{q{fill},    q{SDL_GPU_FILLMODE_FILL}}},
		{{q{line},    q{SDL_GPU_FILLMODE_LINE}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_GPUCullMode}, members: (){
	EnumMember[] ret = [
		{{q{none},   q{SDL_GPU_CULLMODE_NONE}}},
		{{q{front},  q{SDL_GPU_CULLMODE_FRONT}}},
		{{q{back},   q{SDL_GPU_CULLMODE_BACK}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_GPUFrontFace}, members: (){
	EnumMember[] ret = [
		{{q{antiClockwise},  q{SDL_GPU_FRONTFACE_ANTI_CLOCKWISE}}, aliases: [{q{counterClockwise}, q{SDL_GPU_FRONTFACE_COUNTER_CLOCKWISE}}]},
		{{q{clockwise},      q{SDL_GPU_FRONTFACE_CLOCKWISE}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_GPUCompareOp}, members: (){
	EnumMember[] ret = [
		{{q{invalid},           q{SDL_GPU_COMPAREOP_INVALID}}},
		{{q{never},             q{SDL_GPU_COMPAREOP_NEVER}}},
		{{q{less},              q{SDL_GPU_COMPAREOP_LESS}}},
		{{q{equal},             q{SDL_GPU_COMPAREOP_EQUAL}}},
		{{q{lessOrEqual},       q{SDL_GPU_COMPAREOP_LESS_OR_EQUAL}}},
		{{q{greater},           q{SDL_GPU_COMPAREOP_GREATER}}},
		{{q{notEqual},          q{SDL_GPU_COMPAREOP_NOT_EQUAL}}},
		{{q{greaterOrEqual},    q{SDL_GPU_COMPAREOP_GREATER_OR_EQUAL}}},
		{{q{always},            q{SDL_GPU_COMPAREOP_ALWAYS}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_GPUStencilOp}, members: (){
	EnumMember[] ret = [
		{{q{invalid},              q{SDL_GPU_STENCILOP_INVALID}}},
		{{q{keep},                 q{SDL_GPU_STENCILOP_KEEP}}},
		{{q{zero},                 q{SDL_GPU_STENCILOP_ZERO}}},
		{{q{replace},              q{SDL_GPU_STENCILOP_REPLACE}}},
		{{q{incrementAndClamp},    q{SDL_GPU_STENCILOP_INCREMENT_AND_CLAMP}}},
		{{q{decrementAndClamp},    q{SDL_GPU_STENCILOP_DECREMENT_AND_CLAMP}}},
		{{q{invert},               q{SDL_GPU_STENCILOP_INVERT}}},
		{{q{incrementAndWrap},     q{SDL_GPU_STENCILOP_INCREMENT_AND_WRAP}}},
		{{q{decrementAndWrap},     q{SDL_GPU_STENCILOP_DECREMENT_AND_WRAP}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_GPUBlendOp}, members: (){
	EnumMember[] ret = [
		{{q{invalid},            q{SDL_GPU_BLENDOP_INVALID}}},
		{{q{add},                q{SDL_GPU_BLENDOP_ADD}}},
		{{q{subtract},           q{SDL_GPU_BLENDOP_SUBTRACT}}},
		{{q{reverseSubtract},    q{SDL_GPU_BLENDOP_REVERSE_SUBTRACT}}},
		{{q{min},                q{SDL_GPU_BLENDOP_MIN}}},
		{{q{max},                q{SDL_GPU_BLENDOP_MAX}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_GPUBlendFactor}, members: (){
	EnumMember[] ret = [
		{{q{invalid},                   q{SDL_GPU_BLENDFACTOR_INVALID}}},
		{{q{zero},                      q{SDL_GPU_BLENDFACTOR_ZERO}}},
		{{q{one},                       q{SDL_GPU_BLENDFACTOR_ONE}}},
		{{q{srcColour},                 q{SDL_GPU_BLENDFACTOR_SRC_COLOUR}}, aliases: [{q{srcColor}, q{SDL_GPU_BLENDFACTOR_SRC_COLOR}}]},
		{{q{oneMinusSrcColour},         q{SDL_GPU_BLENDFACTOR_ONE_MINUS_SRC_COLOUR}}, aliases: [{q{oneMinusSrcColor}, q{SDL_GPU_BLENDFACTOR_ONE_MINUS_SRC_COLOR}}]},
		{{q{dstColour},                 q{SDL_GPU_BLENDFACTOR_DST_COLOUR}}, aliases: [{q{dstColor}, q{SDL_GPU_BLENDFACTOR_DST_COLOR}}]},
		{{q{oneMinusDstColour},         q{SDL_GPU_BLENDFACTOR_ONE_MINUS_DST_COLOUR}}, aliases: [{q{oneMinusDstColor}, q{SDL_GPU_BLENDFACTOR_ONE_MINUS_DST_COLOR}}]},
		{{q{srcAlpha},                  q{SDL_GPU_BLENDFACTOR_SRC_ALPHA}}},
		{{q{oneMinusSrcAlpha},          q{SDL_GPU_BLENDFACTOR_ONE_MINUS_SRC_ALPHA}}},
		{{q{dstAlpha},                  q{SDL_GPU_BLENDFACTOR_DST_ALPHA}}},
		{{q{oneMinusDstAlpha},          q{SDL_GPU_BLENDFACTOR_ONE_MINUS_DST_ALPHA}}},
		{{q{constantColour},            q{SDL_GPU_BLENDFACTOR_CONSTANT_COLOUR}}, aliases: [{q{constantColor}, q{SDL_GPU_BLENDFACTOR_CONSTANT_COLOR}}]},
		{{q{oneMinusConstantColour},    q{SDL_GPU_BLENDFACTOR_ONE_MINUS_CONSTANT_COLOUR}}, aliases: [{q{oneMinusConstantColor}, q{SDL_GPU_BLENDFACTOR_ONE_MINUS_CONSTANT_COLOR}}]},
		{{q{srcAlphaSaturate},          q{SDL_GPU_BLENDFACTOR_SRC_ALPHA_SATURATE}}},
	];
	return ret;
}()));

alias SDL_GPUColourComponentFlags_ = ubyte;
mixin(makeEnumBind(q{SDL_GPUColourComponentFlags}, q{SDL_GPUColourComponentFlags_}, aliases: [q{SDL_GPUColourComponent}, q{SDL_GPUColorComponent}, q{SDL_GPUColorComponentFlags}], members: (){
	EnumMember[] ret = [
		{{q{r},  q{SDL_GPU_COLOURCOMPONENT_R}},  q{1U << 0}, aliases: [{c: q{SDL_GPU_COLORCOMPONENT_R}}]},
		{{q{g},  q{SDL_GPU_COLOURCOMPONENT_G}},  q{1U << 1}, aliases: [{c: q{SDL_GPU_COLORCOMPONENT_G}}]},
		{{q{b},  q{SDL_GPU_COLOURCOMPONENT_B}},  q{1U << 2}, aliases: [{c: q{SDL_GPU_COLORCOMPONENT_B}}]},
		{{q{a},  q{SDL_GPU_COLOURCOMPONENT_A}},  q{1U << 3}, aliases: [{c: q{SDL_GPU_COLORCOMPONENT_A}}]},
	];
	return ret;
}()));
alias SDL_GPUColorComponentFlags_ = SDL_GPUColourComponentFlags_;

mixin(makeEnumBind(q{SDL_GPUFilter}, members: (){
	EnumMember[] ret = [
		{{q{nearest},    q{SDL_GPU_FILTER_NEAREST}}},
		{{q{linear},     q{SDL_GPU_FILTER_LINEAR}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_GPUSamplerMipmapMode}, members: (){
	EnumMember[] ret = [
		{{q{nearest},    q{SDL_GPU_SAMPLERMIPMAPMODE_NEAREST}}},
		{{q{linear},     q{SDL_GPU_SAMPLERMIPMAPMODE_LINEAR}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_GPUSamplerAddressMode}, members: (){
	EnumMember[] ret = [
		{{q{repeat},            q{SDL_GPU_SAMPLERADDRESSMODE_REPEAT}}},
		{{q{mirroredRepeat},    q{SDL_GPU_SAMPLERADDRESSMODE_MIRRORED_REPEAT}}},
		{{q{clampToEdge},       q{SDL_GPU_SAMPLERADDRESSMODE_CLAMP_TO_EDGE}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_GPUPresentMode}, members: (){
	EnumMember[] ret = [
		{{q{vsync},      q{SDL_GPU_PRESENTMODE_VSYNC}}},
		{{q{immediate},  q{SDL_GPU_PRESENTMODE_IMMEDIATE}}},
		{{q{mailbox},    q{SDL_GPU_PRESENTMODE_MAILBOX}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_GPUSwapchainComposition}, members: (){
	EnumMember[] ret = [
		{{q{sdr},                  q{SDL_GPU_SWAPCHAINCOMPOSITION_SDR}}},
		{{q{sdrLinear},            q{SDL_GPU_SWAPCHAINCOMPOSITION_SDR_LINEAR}}},
		{{q{hdrExtendedLinear},    q{SDL_GPU_SWAPCHAINCOMPOSITION_HDR_EXTENDED_LINEAR}}},
		{{q{hdr10ST2084},          q{SDL_GPU_SWAPCHAINCOMPOSITION_HDR10_ST2084}}},
	];
	return ret;
}()));

struct SDL_GPUViewport{
	float x=0, y=0, w=0, h=0;
	float minDepth=0;
	float maxDepth=0;
	
	alias min_depth = minDepth;
	alias max_depth = maxDepth;
}

struct SDL_GPUTextureTransferInfo{
	SDL_GPUTransferBuffer* transferBuffer;
	uint offset;
	uint pixelsPerRow;
	uint rowsPerLayer;
	
	alias transfer_buffer = transferBuffer;
	alias pixels_per_row = pixelsPerRow;
	alias rows_per_layer = rowsPerLayer;
}

struct SDL_GPUTransferBufferLocation{
	SDL_GPUTransferBuffer* transferBuffer;
	uint offset;
	
	alias transfer_buffer = transferBuffer;
}

struct SDL_GPUTextureLocation{
	SDL_GPUTexture* texture;
	uint mipLevel;
	uint layer;
	uint x, y, z;
	
	alias mip_level = mipLevel;
}

struct SDL_GPUTextureRegion{
	SDL_GPUTexture* texture;
	uint mipLevel;
	uint layer;
	uint x, y, z, w, h, d;
	
	alias mip_level = mipLevel;
}

struct SDL_GPUBlitRegion{
	SDL_GPUTexture* texture;
	uint mipLevel;
	uint layerOrDepthPlane;
	uint x, y, w, h;
	
	alias mip_level = mipLevel;
	alias layer_or_depth_plane = layerOrDepthPlane;
}

struct SDL_GPUBufferLocation{
	SDL_GPUBuffer* buffer;
	uint offset;
}

struct SDL_GPUBufferRegion{
	SDL_GPUBuffer* buffer;
	uint offset;
	uint size;
}

struct SDL_GPUIndirectDrawCommand{
	uint numVertices;
	uint numInstances;
	uint firstVertex;
	uint firstInstance;
	
	alias num_vertices = numVertices;
	alias num_instances = numInstances;
	alias first_vertex = firstVertex;
	alias first_instance = firstInstance;
}

struct SDL_GPUIndexedIndirectDrawCommand{
	uint numIndices;
	uint numInstances;
	uint firstIndex;
	int vertexOffset;
	uint firstInstance;
	
	alias num_indices = numIndices;
	alias num_instances = numInstances;
	alias first_index = firstIndex;
	alias vertex_offset = vertexOffset;
	alias first_instance = firstInstance;
}

struct SDL_GPUIndirectDispatchCommand{
	uint groupCountX;
	uint groupCountY;
	uint groupCountZ;
	
	alias groupcount_x = groupCountX;
	alias groupcount_y = groupCountY;
	alias groupcount_z = groupCountZ;
}

struct SDL_GPUSamplerCreateInfo{
	SDL_GPUFilter minFilter;
	SDL_GPUFilter magFilter;
	SDL_GPUSamplerMipmapMode mipmapMode;
	SDL_GPUSamplerAddressMode addressModeU;
	SDL_GPUSamplerAddressMode addressModeV;
	SDL_GPUSamplerAddressMode addressModeW;
	float mipLODBias=0;
	float maxAnisotropy=0;
	SDL_GPUCompareOp compareOp;
	float minLOD=0;
	float maxLOD=0;
	bool enableAnisotropy;
	bool enableCompare;
	ubyte padding1;
	ubyte padding2;
	
	SDL_PropertiesID props;
	
	alias min_filter = minFilter;
	alias mag_filter = magFilter;
	alias mipmap_mode = mipmapMode;
	alias address_mode_u = addressModeU;
	alias address_mode_v = addressModeV;
	alias address_mode_w = addressModeW;
	alias mip_lod_bias = mipLODBias;
	alias max_anisotropy = maxAnisotropy;
	alias compare_op = compareOp;
	alias min_lod = minLOD;
	alias max_lod = maxLOD;
	alias enable_anisotropy = enableAnisotropy;
	alias enable_compare = enableCompare;
}

struct SDL_GPUVertexBufferDescription{
	uint slot;
	uint pitch;
	SDL_GPUVertexInputRate inputRate;
	uint instanceStepRate;
	
	alias input_rate = inputRate;
	alias instance_step_rate = instanceStepRate;
}

struct SDL_GPUVertexAttribute{
	uint location;
	uint bufferSlot;
	SDL_GPUVertexElementFormat format;
	uint offset;
	
	alias buffer_slot = bufferSlot;
}

struct SDL_GPUVertexInputState{
	const(SDL_GPUVertexBufferDescription)* vertexBufferDescriptions;
	uint numVertexBuffers;
	const(SDL_GPUVertexAttribute)* vertexAttributes;
	uint numVertexAttributes;
	
	alias vertex_buffer_descriptions = vertexBufferDescriptions;
	alias num_vertex_buffers = numVertexBuffers;
	alias vertex_attributes = vertexAttributes;
	alias num_vertex_attributes = numVertexAttributes;
}

struct SDL_GPUStencilOpState{
	SDL_GPUStencilOp failOp;
	SDL_GPUStencilOp passOp;
	SDL_GPUStencilOp depthFailOp;
	SDL_GPUCompareOp compareOp;
	
	alias fail_op = failOp;
	alias pass_op = passOp;
	alias depth_fail_op = depthFailOp;
	alias compare_op = compareOp;
}

struct SDL_GPUColourTargetBlendState{
	SDL_GPUBlendFactor srcColourBlendFactor;
	SDL_GPUBlendFactor dstColourBlendFactor;
	SDL_GPUBlendOp colourBlendOp;
	SDL_GPUBlendFactor srcAlphaBlendFactor;
	SDL_GPUBlendFactor dstAlphaBlendFactor;
	SDL_GPUBlendOp alphaBlendOp;
	SDL_GPUColourComponentFlags_ colourWriteMask;
	bool enableBlend;
	bool enableColourWriteMask;
	ubyte padding1;
	ubyte padding2;
	
	alias src_colour_blendfactor = srcColourBlendFactor;
	alias src_color_blendfactor = srcColourBlendFactor;
	alias srcColorBlendFactor = srcColourBlendFactor;
	alias dst_colour_blendfactor = dstColourBlendFactor;
	alias dst_color_blendfactor = dstColourBlendFactor;
	alias dstColorBlendFactor = dstColourBlendFactor;
	alias colour_blend_op = colourBlendOp;
	alias color_blend_op = colourBlendOp;
	alias colorBlendOp = colourBlendOp;
	alias src_alpha_blendfactor = srcAlphaBlendFactor;
	alias dst_alpha_blendfactor = dstAlphaBlendFactor;
	alias alpha_blend_op = alphaBlendOp;
	alias colour_write_mask = colourWriteMask;
	alias color_write_mask = colourWriteMask;
	alias colorWriteMask = colourWriteMask;
	alias enable_blend = enableBlend;
	alias enable_colour_write_mask = enableColourWriteMask;
	alias enable_color_write_mask = enableColourWriteMask;
	alias enableColorWriteMask = enableColourWriteMask;
}
alias SDL_GPUColorTargetBlendState = SDL_GPUColourTargetBlendState;

struct SDL_GPUShaderCreateInfo{
	size_t codeSize;
	const(ubyte)* code;
	const(char)* entryPoint;
	SDL_GPUShaderFormat_ format;
	SDL_GPUShaderStage stage;
	uint numSamplers;
	uint numStorageTextures;
	uint numStorageBuffers;
	uint numUniformBuffers;
	
	SDL_PropertiesID props;
	
	alias code_size = codeSize;
	alias entrypoint = entryPoint;
	alias num_samplers = numSamplers;
	alias num_storage_textures = numStorageTextures;
	alias num_storage_buffers = numStorageBuffers;
	alias num_uniform_buffers = numUniformBuffers;
}

struct SDL_GPUTextureCreateInfo{
	SDL_GPUTextureType type;
	SDL_GPUTextureFormat format;
	SDL_GPUTextureUsageFlags_ usage;
	uint width;
	uint height;
	uint layerCountOrDepth;
	uint numLevels;
	SDL_GPUSampleCount sampleCount;
	
	SDL_PropertiesID props;
	
	alias layer_count_or_depth = layerCountOrDepth;
	alias num_levels = numLevels;
	alias sample_count = sampleCount;
}

struct SDL_GPUBufferCreateInfo{
	SDL_GPUBufferUsageFlags_ usage;
	uint size;
	
	SDL_PropertiesID props;
}

struct SDL_GPUTransferBufferCreateInfo{
	SDL_GPUTransferBufferUsage usage;
	uint size;
	
	SDL_PropertiesID props;
}

struct SDL_GPURasteriserState{
	SDL_GPUFillMode fillMode;
	SDL_GPUCullMode cullMode;
	SDL_GPUFrontFace frontFace;
	float depthBiasConstantFactor=0;
	float depthBiasClamp=0;
	float depthBiasSlopeFactor=0;
	bool enableDepthBias;
	bool enableDepthClip;
	ubyte padding1;
	ubyte padding2;
	
	alias fill_mode = fillMode;
	alias cull_mode = cullMode;
	alias front_face = frontFace;
	alias depth_bias_constant_factor = depthBiasConstantFactor;
	alias depth_bias_clamp = depthBiasClamp;
	alias depth_bias_slope_factor = depthBiasSlopeFactor;
	alias enable_depth_bias = enableDepthBias;
	alias enable_depth_clip = enableDepthClip;
}
alias SDL_GPURasterizerState = SDL_GPURasteriserState;

struct SDL_GPUMultisampleState{
	SDL_GPUSampleCount sampleCount;
	uint sampleMask;
	bool enableMask;
	static if(sdlVersion >= Version(3,4,0)){
		bool enableAlphaToCoverage;
		alias enable_alpha_to_coverage = enableAlphaToCoverage;
	}else{
		ubyte padding1;
	}
	ubyte padding2;
	ubyte padding3;
	
	alias sample_count = sampleCount;
	alias sample_mask = sampleMask;
	alias enable_mask = enableMask;
}

struct SDL_GPUDepthStencilState{
	SDL_GPUCompareOp compareOp;
	SDL_GPUStencilOpState backStencilState;
	SDL_GPUStencilOpState frontStencilState;
	ubyte compareMask;
	ubyte writeMask;
	bool enableDepthTest;
	bool enableDepthWrite;
	bool enableStencilTest;
	ubyte padding1;
	ubyte padding2;
	ubyte padding3;
	
	alias compare_op = compareOp;
	alias back_stencil_state = backStencilState;
	alias front_stencil_state = frontStencilState;
	alias compare_mask = compareMask;
	alias write_mask = writeMask;
	alias enable_depth_test = enableDepthTest;
	alias enable_depth_write = enableDepthWrite;
	alias enable_stencil_test = enableStencilTest;
}

struct SDL_GPUColourTargetDescription{
	SDL_GPUTextureFormat format;
	SDL_GPUColourTargetBlendState blendState;
	
	alias blend_state = blendState;
}
alias SDL_GPUColorTargetDescription = SDL_GPUColourTargetDescription;

struct SDL_GPUGraphicsPipelineTargetInfo{
	const(SDL_GPUColourTargetDescription)* colourTargetDescriptions;
	uint numColourTargets;
	SDL_GPUTextureFormat depthStencilFormat;
	bool hasDepthStencilTarget;
	ubyte padding1;
	ubyte padding2;
	ubyte padding3;
	
	alias colour_target_descriptions = colourTargetDescriptions;
	alias color_target_descriptions = colourTargetDescriptions;
	alias colorTargetDescriptions = colourTargetDescriptions;
	alias num_colour_targets = numColourTargets;
	alias num_color_targets = numColourTargets;
	alias numColorTargets = numColourTargets;
	alias depth_stencil_format = depthStencilFormat;
	alias has_depth_stencil_target = hasDepthStencilTarget;
}

struct SDL_GPUGraphicsPipelineCreateInfo{
	SDL_GPUShader* vertexShader;
	SDL_GPUShader* fragmentShader;
	SDL_GPUVertexInputState vertexInputState;
	SDL_GPUPrimitiveType primitiveType;
	SDL_GPURasteriserState rasteriserState;
	SDL_GPUMultisampleState multisampleState;
	SDL_GPUDepthStencilState depthStencilState;
	SDL_GPUGraphicsPipelineTargetInfo targetInfo;
	
	SDL_PropertiesID props;
	
	alias vertex_shader = vertexShader;
	alias fragment_shader = fragmentShader;
	alias vertex_input_state = vertexInputState;
	alias primitive_type = primitiveType;
	alias rasteriser_state = rasteriserState;
	alias rasterizer_state = rasteriserState;
	alias rasterizerState = rasteriserState;
	alias multisample_state = multisampleState;
	alias depth_stencil_state = depthStencilState;
	alias target_info = targetInfo;
}

struct SDL_GPUComputePipelineCreateInfo{
	size_t codeSize;
	const(ubyte)* code;
	const(char)* entryPoint;
	SDL_GPUShaderFormat_ format;
	uint numSamplers;
	uint numReadOnlyStorageTextures;
	uint numReadOnlyStorageBuffers;
	uint numReadWriteStorageTextures;
	uint numReadWriteStorageBuffers;
	uint numUniformBuffers;
	uint threadCountX;
	uint threadCountY;
	uint threadCountZ;
	
	SDL_PropertiesID props;
	
	alias code_size = codeSize;
	alias entrypoint = entryPoint;
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

struct SDL_GPUColourTargetInfo{
	SDL_GPUTexture* texture;
	uint mipLevel;
	uint layerOrDepthPlane;
	SDL_FColour clearColour;
	SDL_GPULoadOp loadOp;
	SDL_GPUStoreOp storeOp;
	SDL_GPUTexture* resolveTexture;
	uint resolveMIPLevel;
	uint resolveLayer;
	bool cycle;
	bool cycleResolveTexture;
	ubyte padding1;
	ubyte padding2;
	
	alias mip_level = mipLevel;
	alias layer_or_depth_plane = layerOrDepthPlane;
	alias clear_colour = clearColour;
	alias clear_color = clearColour;
	alias clearColor = clearColour;
	alias load_op = loadOp;
	alias store_op = storeOp;
	alias resolve_texture = resolveTexture;
	alias resolve_mip_level = resolveMIPLevel;
	alias resolve_layer = resolveLayer;
	alias cycle_resolve_texture = cycleResolveTexture;
}
alias SDL_GPUColorTargetInfo = SDL_GPUColourTargetInfo;

struct SDL_GPUDepthStencilTargetInfo{
	SDL_GPUTexture* texture;
	float clearDepth=0;
	SDL_GPULoadOp loadOp;
	SDL_GPUStoreOp storeOp;
	SDL_GPULoadOp stencilLoadOp;
	SDL_GPUStoreOp stencilStoreOp;
	bool cycle;
	ubyte clearStencil;
	static if(sdlVersion >= Version(3,4,0)){
		ubyte mipLevel;
		alias mip_level = mipLevel;
		ubyte layer;
	}else{
		ubyte padding1;
		ubyte padding2;
	}
	
	alias clear_depth = clearDepth;
	alias load_op = loadOp;
	alias store_op = storeOp;
	alias stencil_load_op = stencilLoadOp;
	alias stencil_store_op = stencilStoreOp;
	alias clear_stencil = clearStencil;
}

struct SDL_GPUBlitInfo{
	SDL_GPUBlitRegion source;
	SDL_GPUBlitRegion destination;
	SDL_GPULoadOp loadOp;
	SDL_FColour clearColour;
	SDL_FlipMode flipMode;
	SDL_GPUFilter filter;
	bool cycle;
	ubyte padding1;
	ubyte padding2;
	ubyte padding3;
	
	alias load_op = loadOp;
	alias clear_colour = clearColour;
	alias clear_color = clearColour;
	alias clearColor = clearColour;
	alias flip_mode = flipMode;
}

struct SDL_GPUBufferBinding{
	SDL_GPUBuffer* buffer;
	uint offset;
}

struct SDL_GPUTextureSamplerBinding{
	SDL_GPUTexture* texture;
	SDL_GPUSampler* sampler;
}

struct SDL_GPUStorageBufferReadWriteBinding{
	SDL_GPUBuffer* buffer;
	bool cycle;
	ubyte padding1;
	ubyte padding2;
	ubyte padding3;
}

struct SDL_GPUStorageTextureReadWriteBinding{
	SDL_GPUTexture* texture;
	uint mipLevel;
	uint layer;
	bool cycle;
	ubyte padding1;
	ubyte padding2;
	ubyte padding3;
	
	alias mip_level = mipLevel;
}

mixin(makeEnumBind(q{SDLProp_GPUDeviceCreate}, q{const(char)*}, members: (){
	EnumMember[] ret = [
		{{q{debugModeBoolean},                                q{SDL_PROP_GPU_DEVICE_CREATE_DEBUGMODE_BOOLEAN}},                               q{"SDL.gpu.device.create.debugmode"}},
		{{q{preferLowPowerBoolean},                           q{SDL_PROP_GPU_DEVICE_CREATE_PREFERLOWPOWER_BOOLEAN}},                          q{"SDL.gpu.device.create.preferlowpower"}},
		{{q{nameString},                                      q{SDL_PROP_GPU_DEVICE_CREATE_NAME_STRING}},                                     q{"SDL.gpu.device.create.name"}},
		{{q{shadersPrivateBoolean},                           q{SDL_PROP_GPU_DEVICE_CREATE_SHADERS_PRIVATE_BOOLEAN}},                         q{"SDL.gpu.device.create.shaders.private"}},
		{{q{shadersSPIRVBoolean},                             q{SDL_PROP_GPU_DEVICE_CREATE_SHADERS_SPIRV_BOOLEAN}},                           q{"SDL.gpu.device.create.shaders.spirv"}},
		{{q{shadersDXBCBoolean},                              q{SDL_PROP_GPU_DEVICE_CREATE_SHADERS_DXBC_BOOLEAN}},                            q{"SDL.gpu.device.create.shaders.dxbc"}},
		{{q{shadersDXILBoolean},                              q{SDL_PROP_GPU_DEVICE_CREATE_SHADERS_DXIL_BOOLEAN}},                            q{"SDL.gpu.device.create.shaders.dxil"}},
		{{q{shadersMSLBoolean},                               q{SDL_PROP_GPU_DEVICE_CREATE_SHADERS_MSL_BOOLEAN}},                             q{"SDL.gpu.device.create.shaders.msl"}},
		{{q{shadersMetallibBoolean},                          q{SDL_PROP_GPU_DEVICE_CREATE_SHADERS_METALLIB_BOOLEAN}},                        q{"SDL.gpu.device.create.shaders.metallib"}},
		{{q{d3d12SemanticNameString},                         q{SDL_PROP_GPU_DEVICE_CREATE_D3D12_SEMANTIC_NAME_STRING}},                      q{"SDL.gpu.device.create.d3d12.semantic"}},
	];
	if(sdlVersion >= Version(3,4,0)){
		EnumMember[] add = [
			{{q{verboseBoolean},                              q{SDL_PROP_GPU_DEVICE_CREATE_VERBOSE_BOOLEAN}},                                 q{"SDL.gpu.device.create.verbose"}},
			{{q{featureClipDistanceBoolean},                  q{SDL_PROP_GPU_DEVICE_CREATE_FEATURE_CLIP_DISTANCE_BOOLEAN}},                   q{"SDL.gpu.device.create.feature.clip_distance"}},
			{{q{featureDepthClampingBoolean},                 q{SDL_PROP_GPU_DEVICE_CREATE_FEATURE_DEPTH_CLAMPING_BOOLEAN}},                  q{"SDL.gpu.device.create.feature.depth_clamping"}},
			{{q{featureIndirectDrawFirstInstanceBoolean},     q{SDL_PROP_GPU_DEVICE_CREATE_FEATURE_INDIRECT_DRAW_FIRST_INSTANCE_BOOLEAN}},    q{"SDL.gpu.device.create.feature.indirect_draw_first_instance"}},
			{{q{featureAnisotropyBoolean},                    q{SDL_PROP_GPU_DEVICE_CREATE_FEATURE_ANISOTROPY_BOOLEAN}},                      q{"SDL.gpu.device.create.feature.anisotropy"}},
			{{q{d3d12AllowFewerResourceSlotsBoolean},         q{SDL_PROP_GPU_DEVICE_CREATE_D3D12_ALLOW_FEWER_RESOURCE_SLOTS_BOOLEAN}},        q{"SDL.gpu.device.create.d3d12.allowtier1resourcebinding"}},
			{{q{vulkanRequireHardwareAccelerationBoolean},    q{SDL_PROP_GPU_DEVICE_CREATE_VULKAN_REQUIRE_HARDWARE_ACCELERATION_BOOLEAN}},    q{"SDL.gpu.device.create.vulkan.requirehardwareacceleration"}},
			{{q{vulkanOptionsPointer},                        q{SDL_PROP_GPU_DEVICE_CREATE_VULKAN_OPTIONS_POINTER}},                          q{"SDL.gpu.device.create.vulkan.options"}},
		];
		ret ~= add;
	}
	return ret;
}()));

struct SDL_GPUVulkanOptions{
	uint vulkanAPIVersion;
	void* featureList;
	void* vulkan10PhysicalDeviceFeatures;
	uint deviceExtensionCount;
	const(char)** deviceExtensionNames;
	uint instanceExtensionCount;
	const(char)** instanceExtensionNames;
	
	alias vulkan_api_version = vulkanAPIVersion;
	alias feature_list = featureList;
	alias vulkan_10_physical_device_features = vulkan10PhysicalDeviceFeatures;
	alias device_extension_count = deviceExtensionCount;
	alias device_extension_names = deviceExtensionNames;
	alias instance_extension_count = instanceExtensionCount;
	alias instance_extension_names = instanceExtensionNames;
}

mixin(makeEnumBind(q{SDLProp_GPUDevice}, q{const(char)*}, members: (){
	EnumMember[] ret = [
		{{q{nameString},             q{SDL_PROP_GPU_DEVICE_NAME_STRING}},              q{"SDL.gpu.device.name"}},
		{{q{driverNameString},       q{SDL_PROP_GPU_DEVICE_DRIVER_NAME_STRING}},       q{"SDL.gpu.device.driver_name"}},
		{{q{driverVersionString},    q{SDL_PROP_GPU_DEVICE_DRIVER_VERSION_STRING}},    q{"SDL.gpu.device.driver_version"}},
		{{q{driverInfoString},       q{SDL_PROP_GPU_DEVICE_DRIVER_INFO_STRING}},       q{"SDL.gpu.device.driver_info"}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDLProp_GPUComputePipelineCreate}, q{const(char)*}, members: (){
	EnumMember[] ret = [
		{{q{nameString},    q{SDL_PROP_GPU_COMPUTEPIPELINE_CREATE_NAME_STRING}},    q{"SDL.gpu.computepipeline.create.name"}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDLProp_GPUGraphicsPipelineCreate}, q{const(char)*}, members: (){
	EnumMember[] ret = [
		{{q{nameString},    q{SDL_PROP_GPU_GRAPHICSPIPELINE_CREATE_NAME_STRING}},    q{"SDL.gpu.graphicspipeline.create.name"}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDLProp_GPUSamplerCreate}, q{const(char)*}, members: (){
	EnumMember[] ret = [
		{{q{nameString},    q{SDL_PROP_GPU_SAMPLER_CREATE_NAME_STRING}},    q{"SDL.gpu.sampler.create.name"}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDLProp_GPUShaderCreate}, q{const(char)*}, members: (){
	EnumMember[] ret = [
		{{q{nameString},    q{SDL_PROP_GPU_SHADER_CREATE_NAME_STRING}},    q{"SDL.gpu.shader.create.name"}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDLProp_GPUTextureCreate}, q{const(char)*}, members: (){
	EnumMember[] ret = [
		{{q{d3d12ClearRFloat},          q{SDL_PROP_GPU_TEXTURE_CREATE_D3D12_CLEAR_R_FLOAT}},          q{"SDL.gpu.createtexture.d3d12.clear.r"}},
		{{q{d3d12ClearGFloat},          q{SDL_PROP_GPU_TEXTURE_CREATE_D3D12_CLEAR_G_FLOAT}},          q{"SDL.gpu.createtexture.d3d12.clear.g"}},
		{{q{d3d12ClearBFloat},          q{SDL_PROP_GPU_TEXTURE_CREATE_D3D12_CLEAR_B_FLOAT}},          q{"SDL.gpu.createtexture.d3d12.clear.b"}},
		{{q{d3d12ClearAFloat},          q{SDL_PROP_GPU_TEXTURE_CREATE_D3D12_CLEAR_A_FLOAT}},          q{"SDL.gpu.createtexture.d3d12.clear.a"}},
		{{q{d3d12ClearDepthFloat},      q{SDL_PROP_GPU_TEXTURE_CREATE_D3D12_CLEAR_DEPTH_FLOAT}},      q{"SDL.gpu.createtexture.d3d12.clear.depth"}},
		{{q{d3d12ClearStencilNumber},   q{SDL_PROP_GPU_TEXTURE_CREATE_D3D12_CLEAR_STENCIL_NUMBER}},   q{"SDL.gpu.createtexture.d3d12.clear.stencil"}, aliases: [{q{d3d12ClearStencilUInt8}, q{SDL_PROP_GPU_TEXTURE_CREATE_D3D12_CLEAR_STENCIL_UINT8}}]},
		{{q{nameString},                q{SDL_PROP_GPU_TEXTURE_CREATE_NAME_STRING}},                  q{"SDL.gpu.texture.create.name"}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDLProp_GPUBufferCreate}, q{const(char)*}, members: (){
	EnumMember[] ret = [
		{{q{nameString},    q{SDL_PROP_GPU_BUFFER_CREATE_NAME_STRING}},    q{"SDL.gpu.buffer.create.name"}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDLProp_GPUTransferBufferCreate}, q{const(char)*}, members: (){
	EnumMember[] ret = [
		{{q{nameString},    q{SDL_PROP_GPU_TRANSFERBUFFER_CREATE_NAME_STRING}},    q{"SDL.gpu.transferbuffer.create.name"}},
	];
	return ret;
}()));

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{bool}, q{SDL_GPUSupportsShaderFormats}, q{SDL_GPUShaderFormat_ formatFlags, const(char)* name}},
		{q{bool}, q{SDL_GPUSupportsProperties}, q{SDL_PropertiesID props}},
		{q{SDL_GPUDevice*}, q{SDL_CreateGPUDevice}, q{SDL_GPUShaderFormat_ formatFlags, bool debugMode, const(char)* name}},
		{q{SDL_GPUDevice*}, q{SDL_CreateGPUDeviceWithProperties}, q{SDL_PropertiesID props}},
		{q{void}, q{SDL_DestroyGPUDevice}, q{SDL_GPUDevice* device}},
		{q{int}, q{SDL_GetNumGPUDrivers}, q{}},
		{q{const(char)*}, q{SDL_GetGPUDriver}, q{int index}},
		{q{const(char)*}, q{SDL_GetGPUDeviceDriver}, q{SDL_GPUDevice* device}},
		{q{SDL_GPUShaderFormat}, q{SDL_GetGPUShaderFormats}, q{SDL_GPUDevice* device}},
		{q{SDL_GPUComputePipeline*}, q{SDL_CreateGPUComputePipeline}, q{SDL_GPUDevice* device, const(SDL_GPUComputePipelineCreateInfo)* createInfo}},
		{q{SDL_GPUGraphicsPipeline*}, q{SDL_CreateGPUGraphicsPipeline}, q{SDL_GPUDevice* device, const(SDL_GPUGraphicsPipelineCreateInfo)* createInfo}},
		{q{SDL_GPUSampler*}, q{SDL_CreateGPUSampler}, q{SDL_GPUDevice* device, const(SDL_GPUSamplerCreateInfo)* createInfo}},
		{q{SDL_GPUShader*}, q{SDL_CreateGPUShader}, q{SDL_GPUDevice* device, const(SDL_GPUShaderCreateInfo)* createInfo}},
		{q{SDL_GPUTexture*}, q{SDL_CreateGPUTexture}, q{SDL_GPUDevice* device, const(SDL_GPUTextureCreateInfo)* createInfo}},
		{q{SDL_GPUBuffer*}, q{SDL_CreateGPUBuffer}, q{SDL_GPUDevice* device, const(SDL_GPUBufferCreateInfo)* createInfo}},
		{q{SDL_GPUTransferBuffer*}, q{SDL_CreateGPUTransferBuffer}, q{SDL_GPUDevice* device, const(SDL_GPUTransferBufferCreateInfo)* createInfo}},
		{q{void}, q{SDL_SetGPUBufferName}, q{SDL_GPUDevice* device, SDL_GPUBuffer* buffer, const(char)* text}},
		{q{void}, q{SDL_SetGPUTextureName}, q{SDL_GPUDevice* device, SDL_GPUTexture* texture, const(char)* text}},
		{q{void}, q{SDL_InsertGPUDebugLabel}, q{SDL_GPUCommandBuffer* commandBuffer, const(char)* text}},
		{q{void}, q{SDL_PushGPUDebugGroup}, q{SDL_GPUCommandBuffer* commandBuffer, const(char)* name}},
		{q{void}, q{SDL_PopGPUDebugGroup}, q{SDL_GPUCommandBuffer* commandBuffer}},
		{q{void}, q{SDL_ReleaseGPUTexture}, q{SDL_GPUDevice* device, SDL_GPUTexture* texture}},
		{q{void}, q{SDL_ReleaseGPUSampler}, q{SDL_GPUDevice* device, SDL_GPUSampler* sampler}},
		{q{void}, q{SDL_ReleaseGPUBuffer}, q{SDL_GPUDevice* device, SDL_GPUBuffer* buffer}},
		{q{void}, q{SDL_ReleaseGPUTransferBuffer}, q{SDL_GPUDevice* device, SDL_GPUTransferBuffer* transferBuffer}},
		{q{void}, q{SDL_ReleaseGPUComputePipeline}, q{SDL_GPUDevice* device, SDL_GPUComputePipeline* computePipeline}},
		{q{void}, q{SDL_ReleaseGPUShader}, q{SDL_GPUDevice* device, SDL_GPUShader* shader}},
		{q{void}, q{SDL_ReleaseGPUGraphicsPipeline}, q{SDL_GPUDevice* device, SDL_GPUGraphicsPipeline* graphicsPipeline}},
		{q{SDL_GPUCommandBuffer*}, q{SDL_AcquireGPUCommandBuffer}, q{SDL_GPUDevice* device}},
		{q{void}, q{SDL_PushGPUVertexUniformData}, q{SDL_GPUCommandBuffer* commandBuffer, uint slotIndex, const(void)* data, uint length}},
		{q{void}, q{SDL_PushGPUFragmentUniformData}, q{SDL_GPUCommandBuffer* commandBuffer, uint slotIndex, const(void)* data, uint length}},
		{q{void}, q{SDL_PushGPUComputeUniformData}, q{SDL_GPUCommandBuffer* commandBuffer, uint slotIndex, const(void)* data, uint length}},
		{q{SDL_GPURenderPass*}, q{SDL_BeginGPURenderPass}, q{SDL_GPUCommandBuffer* command_buffer, const(SDL_GPUColourTargetInfo)* colourTargetInfos, uint numColourTargets, const(SDL_GPUDepthStencilTargetInfo)* depthStencilTargetInfo}},
		{q{void}, q{SDL_BindGPUGraphicsPipeline}, q{SDL_GPURenderPass* renderPass, SDL_GPUGraphicsPipeline* graphicsPipeline}},
		{q{void}, q{SDL_SetGPUViewport}, q{SDL_GPURenderPass* renderPass, const(SDL_GPUViewport)* viewport}},
		{q{void}, q{SDL_SetGPUScissor}, q{SDL_GPURenderPass* renderPass, const(SDL_Rect)* scissor}},
		{q{void}, q{SDL_SetGPUBlendConstants}, q{SDL_GPURenderPass* renderPass, SDL_FColour blendConstants}},
		{q{void}, q{SDL_SetGPUStencilReference}, q{SDL_GPURenderPass* renderPass, ubyte reference}},
		{q{void}, q{SDL_BindGPUVertexBuffers}, q{SDL_GPURenderPass* renderPass, uint firstSlot, const(SDL_GPUBufferBinding)* bindings, uint numBindings}},
		{q{void}, q{SDL_BindGPUIndexBuffer}, q{SDL_GPURenderPass* renderPass, const(SDL_GPUBufferBinding)* binding, SDL_GPUIndexElementSize indexElementSize}},
		{q{void}, q{SDL_BindGPUVertexSamplers}, q{SDL_GPURenderPass* renderPass, uint firstSlot, const(SDL_GPUTextureSamplerBinding)* textureSamplerBindings, uint numBindings}},
		{q{void}, q{SDL_BindGPUVertexStorageTextures}, q{SDL_GPURenderPass* renderPass, uint firstSlot, SDL_GPUTexture** storageTextures, uint numBindings}},
		{q{void}, q{SDL_BindGPUVertexStorageBuffers}, q{SDL_GPURenderPass* renderPass, uint firstSlot, SDL_GPUBuffer** storageBuffers, uint numBindings}},
		{q{void}, q{SDL_BindGPUFragmentSamplers}, q{SDL_GPURenderPass* renderPass, uint firstSlot, const(SDL_GPUTextureSamplerBinding)* textureSamplerBindings, uint numBindings}},
		{q{void}, q{SDL_BindGPUFragmentStorageTextures}, q{SDL_GPURenderPass* renderPass, uint firstSlot, SDL_GPUTexture** storage_textures, uint numBindings}},
		{q{void}, q{SDL_BindGPUFragmentStorageBuffers}, q{SDL_GPURenderPass* renderPass, uint firstSlot, SDL_GPUBuffer** storageBuffers, uint numBindings}},
		{q{void}, q{SDL_DrawGPUIndexedPrimitives}, q{SDL_GPURenderPass* renderPass, uint numIndices, uint numInstances, uint firstIndex, int vertexOffset, uint firstInstance}},
		{q{void}, q{SDL_DrawGPUPrimitives}, q{SDL_GPURenderPass* renderPass, uint numVertices, uint numInstances, uint firstVertex, uint firstInstance}},
		{q{void}, q{SDL_DrawGPUPrimitivesIndirect}, q{SDL_GPURenderPass* renderPass, SDL_GPUBuffer* buffer, uint offset, uint drawCount}},
		{q{void}, q{SDL_DrawGPUIndexedPrimitivesIndirect}, q{SDL_GPURenderPass* renderPass, SDL_GPUBuffer* buffer, uint offset, uint drawCount}},
		{q{void}, q{SDL_EndGPURenderPass}, q{SDL_GPURenderPass* renderPass}},
		{q{SDL_GPUComputePass*}, q{SDL_BeginGPUComputePass}, q{SDL_GPUCommandBuffer* commandBuffer, const(SDL_GPUStorageTextureReadWriteBinding)* storageTextureBindings, uint numStorageTextureBindings, const(SDL_GPUStorageBufferReadWriteBinding)* storageBufferBindings, uint numStorageBufferBindings}},
		{q{void}, q{SDL_BindGPUComputePipeline}, q{SDL_GPUComputePass* computePass, SDL_GPUComputePipeline* computePipeline}},
		{q{void}, q{SDL_BindGPUComputeSamplers}, q{SDL_GPUComputePass* computePass, uint firstSlot, const(SDL_GPUTextureSamplerBinding)* textureSamplerBindings, uint numBindings}},
		{q{void}, q{SDL_BindGPUComputeStorageTextures}, q{SDL_GPUComputePass* computePass, uint firstSlot, SDL_GPUTexture** storageTextures, uint numBindings}},
		{q{void}, q{SDL_BindGPUComputeStorageBuffers}, q{SDL_GPUComputePass* computePass, uint firstSlot, SDL_GPUBuffer** storageBuffers, uint numBindings}},
		{q{void}, q{SDL_DispatchGPUCompute}, q{SDL_GPUComputePass* computePass, uint groupCountX, uint groupCountY, uint groupCountZ}},
		{q{void}, q{SDL_DispatchGPUComputeIndirect}, q{SDL_GPUComputePass* computePass, SDL_GPUBuffer* buffer, uint offset}},
		{q{void}, q{SDL_EndGPUComputePass}, q{SDL_GPUComputePass* computePass}},
		{q{void*}, q{SDL_MapGPUTransferBuffer}, q{SDL_GPUDevice* device, SDL_GPUTransferBuffer* transferBuffer, bool cycle}},
		{q{void}, q{SDL_UnmapGPUTransferBuffer}, q{SDL_GPUDevice* device, SDL_GPUTransferBuffer* transferBuffer}},
		{q{SDL_GPUCopyPass*}, q{SDL_BeginGPUCopyPass}, q{SDL_GPUCommandBuffer* commandBuffer}},
		{q{void}, q{SDL_UploadToGPUTexture}, q{SDL_GPUCopyPass* copyPass, const(SDL_GPUTextureTransferInfo)* source, const(SDL_GPUTextureRegion)* destination, bool cycle}},
		{q{void}, q{SDL_UploadToGPUBuffer}, q{SDL_GPUCopyPass* copyPass, const(SDL_GPUTransferBufferLocation)* source, const(SDL_GPUBufferRegion)* destination, bool cycle}},
		{q{void}, q{SDL_CopyGPUTextureToTexture}, q{SDL_GPUCopyPass* copyPass, const(SDL_GPUTextureLocation)* source, const(SDL_GPUTextureLocation)* destination, uint w, uint h, uint d, bool cycle}},
		{q{void}, q{SDL_CopyGPUBufferToBuffer}, q{SDL_GPUCopyPass* copyPass, const(SDL_GPUBufferLocation)* source, const(SDL_GPUBufferLocation)* destination, uint size, bool cycle}},
		{q{void}, q{SDL_DownloadFromGPUTexture}, q{SDL_GPUCopyPass* copyPass, const(SDL_GPUTextureRegion)* source, const(SDL_GPUTextureTransferInfo)* destination}},
		{q{void}, q{SDL_DownloadFromGPUBuffer}, q{SDL_GPUCopyPass* copyPass, const(SDL_GPUBufferRegion)* source, const(SDL_GPUTransferBufferLocation)* destination}},
		{q{void}, q{SDL_EndGPUCopyPass}, q{SDL_GPUCopyPass* copyPass}},
		{q{void}, q{SDL_GenerateMipmapsForGPUTexture}, q{SDL_GPUCommandBuffer* commandBuffer, SDL_GPUTexture* texture}},
		{q{void}, q{SDL_BlitGPUTexture}, q{SDL_GPUCommandBuffer* commandBuffer, const(SDL_GPUBlitInfo)* info}},
		{q{bool}, q{SDL_WindowSupportsGPUSwapchainComposition}, q{SDL_GPUDevice* device, SDL_Window* window, SDL_GPUSwapchainComposition swapchainComposition}},
		{q{bool}, q{SDL_WindowSupportsGPUPresentMode}, q{SDL_GPUDevice* device, SDL_Window* window, SDL_GPUPresentMode presentMode}},
		{q{bool}, q{SDL_ClaimWindowForGPUDevice}, q{SDL_GPUDevice* device, SDL_Window* window}},
		{q{void}, q{SDL_ReleaseWindowFromGPUDevice}, q{SDL_GPUDevice* device, SDL_Window* window}},
		{q{bool}, q{SDL_SetGPUSwapchainParameters}, q{SDL_GPUDevice* device, SDL_Window* window, SDL_GPUSwapchainComposition swapchainComposition, SDL_GPUPresentMode presentMode}},
		{q{bool}, q{SDL_SetGPUAllowedFramesInFlight}, q{SDL_GPUDevice* device, uint allowedFramesInFlight}},
		{q{SDL_GPUTextureFormat}, q{SDL_GetGPUSwapchainTextureFormat}, q{SDL_GPUDevice* device, SDL_Window* window}},
		{q{bool}, q{SDL_AcquireGPUSwapchainTexture}, q{SDL_GPUCommandBuffer* commandBuffer, SDL_Window* window, SDL_GPUTexture** swapchainTexture, uint* swapchainTextureWidth, uint* swapchainTextureHeight}},
		{q{bool}, q{SDL_WaitForGPUSwapchain}, q{SDL_GPUDevice* device, SDL_Window* window}},
		{q{bool}, q{SDL_WaitAndAcquireGPUSwapchainTexture}, q{SDL_GPUCommandBuffer* commandBuffer, SDL_Window* window, SDL_GPUTexture** swapchainTexture, uint* swapchainTextureWidth, uint* swapchainTextureHeight}},
		{q{bool}, q{SDL_SubmitGPUCommandBuffer}, q{SDL_GPUCommandBuffer* commandBuffer}},
		{q{SDL_GPUFence*}, q{SDL_SubmitGPUCommandBufferAndAcquireFence}, q{SDL_GPUCommandBuffer* commandBuffer}},
		{q{bool}, q{SDL_CancelGPUCommandBuffer}, q{SDL_GPUCommandBuffer* commandBuffer}},
		{q{bool}, q{SDL_WaitForGPUIdle}, q{SDL_GPUDevice* device}},
		{q{bool}, q{SDL_WaitForGPUFences}, q{SDL_GPUDevice* device, bool waitAll, SDL_GPUFence** fences, uint numFences}},
		{q{bool}, q{SDL_QueryGPUFence}, q{SDL_GPUDevice* device, SDL_GPUFence* fence}},
		{q{void}, q{SDL_ReleaseGPUFence}, q{SDL_GPUDevice* device, SDL_GPUFence* fence}},
		{q{uint}, q{SDL_GPUTextureFormatTexelBlockSize}, q{SDL_GPUTextureFormat format}},
		{q{bool}, q{SDL_GPUTextureSupportsFormat}, q{SDL_GPUDevice* device, SDL_GPUTextureFormat format, SDL_GPUTextureType type, SDL_GPUTextureUsageFlags_ usage}},
		{q{bool}, q{SDL_GPUTextureSupportsSampleCount}, q{SDL_GPUDevice* device, SDL_GPUTextureFormat format, SDL_GPUSampleCount sampleCount}},
		{q{uint}, q{SDL_CalculateGPUTextureFormatSize}, q{SDL_GPUTextureFormat format, uint width, uint height, uint depthOrLayerCount}},
	];
	version(GDK){{
		FnBind[] add = [
			{q{void}, q{SDL_GDKSuspendGPU}, q{SDL_GPUDevice* device}},
			{q{void}, q{SDL_GDKResumeGPU}, q{SDL_GPUDevice* device}},
		];
		ret ~= add;
	}}
	if(sdlVersion >= Version(3,4,0)){
		FnBind[] add = [
			{q{SDL_PropertiesID}, q{SDL_GetGPUDeviceProperties}, q{SDL_GPUDevice* device}},
			{q{SDL_PixelFormat}, q{SDL_GetPixelFormatFromGPUTextureFormat}, q{SDL_GPUTextureFormat format}},
			{q{SDL_GPUTextureFormat}, q{SDL_GetGPUTextureFormatFromPixelFormat}, q{SDL_PixelFormat format}},
		];
		ret ~= add;
	}
	return ret;
}()));
