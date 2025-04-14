/+
+            Copyright 2024 – 2025 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.pixels;

import bindbc.sdl.config, bindbc.sdl.codegen;

import sdl.stdinc: SDL_FOURCC;

enum{
	SDL_AlphaOpaque = 255,
	SDL_AlphaOpaqueFloat = 1f,
	SDL_AlphaTransparent = 0,
	SDL_AlphaTransparentFloat = 0f,
	
	SDL_ALPHA_OPAQUE = SDL_AlphaOpaque,
	SDL_ALPHA_OPAQUE_FLOAT = SDL_AlphaOpaqueFloat,
	SDL_ALPHA_TRANSPARENT = SDL_AlphaTransparent,
	SDL_ALPHA_TRANSPARENT_FLOAT = SDL_AlphaTransparentFloat,
}

mixin(makeEnumBind(q{SDL_PixelType}, members: (){
	EnumMember[] ret = [
		{{q{unknown},   q{SDL_PIXELTYPE_UNKNOWN}}},
		{{q{index1},    q{SDL_PIXELTYPE_INDEX1}}},
		{{q{index4},    q{SDL_PIXELTYPE_INDEX4}}},
		{{q{index8},    q{SDL_PIXELTYPE_INDEX8}}},
		{{q{packed8},   q{SDL_PIXELTYPE_PACKED8}}},
		{{q{packed16},  q{SDL_PIXELTYPE_PACKED16}}},
		{{q{packed32},  q{SDL_PIXELTYPE_PACKED32}}},
		{{q{arrayU8},   q{SDL_PIXELTYPE_ARRAYU8}}},
		{{q{arrayU16},  q{SDL_PIXELTYPE_ARRAYU16}}},
		{{q{arrayU32},  q{SDL_PIXELTYPE_ARRAYU32}}},
		{{q{arrayF16},  q{SDL_PIXELTYPE_ARRAYF16}}},
		{{q{arrayF32},  q{SDL_PIXELTYPE_ARRAYF32}}},
		{{q{index2},    q{SDL_PIXELTYPE_INDEX2}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_BitmapOrder}, members: (){
	EnumMember[] ret = [
		{{q{none},   q{SDL_BITMAPORDER_NONE}}},
		{{q{_4321},  q{SDL_BITMAPORDER_4321}}},
		{{q{_1234},  q{SDL_BITMAPORDER_1234}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_PackedOrder}, members: (){
	EnumMember[] ret = [
		{{q{none},  q{SDL_PACKEDORDER_NONE}}},
		{{q{xrgb},  q{SDL_PACKEDORDER_XRGB}}},
		{{q{rgbx},  q{SDL_PACKEDORDER_RGBX}}},
		{{q{argb},  q{SDL_PACKEDORDER_ARGB}}},
		{{q{rgba},  q{SDL_PACKEDORDER_RGBA}}},
		{{q{xbgr},  q{SDL_PACKEDORDER_XBGR}}},
		{{q{bgrx},  q{SDL_PACKEDORDER_BGRX}}},
		{{q{abgr},  q{SDL_PACKEDORDER_ABGR}}},
		{{q{bgra},  q{SDL_PACKEDORDER_BGRA}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_ArrayOrder}, members: (){
	EnumMember[] ret = [
		{{q{none},  q{SDL_ARRAYORDER_NONE}}},
		{{q{rgb},   q{SDL_ARRAYORDER_RGB}}},
		{{q{rgba},  q{SDL_ARRAYORDER_RGBA}}},
		{{q{argb},  q{SDL_ARRAYORDER_ARGB}}},
		{{q{bgr},   q{SDL_ARRAYORDER_BGR}}},
		{{q{bgra},  q{SDL_ARRAYORDER_BGRA}}},
		{{q{abgr},  q{SDL_ARRAYORDER_ABGR}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_PackedLayout}, members: (){
	EnumMember[] ret = [
		{{q{none},      q{SDL_PACKEDLAYOUT_NONE}}},
		{{q{_332},      q{SDL_PACKEDLAYOUT_332}}},
		{{q{_4444},     q{SDL_PACKEDLAYOUT_4444}}},
		{{q{_1555},     q{SDL_PACKEDLAYOUT_1555}}},
		{{q{_5551},     q{SDL_PACKEDLAYOUT_5551}}},
		{{q{_565},      q{SDL_PACKEDLAYOUT_565}}},
		{{q{_8888},     q{SDL_PACKEDLAYOUT_8888}}},
		{{q{_2101010},  q{SDL_PACKEDLAYOUT_2101010}}},
		{{q{_1010102},  q{SDL_PACKEDLAYOUT_1010102}}},
	];
	return ret;
}()));

pragma(inline,true) nothrow @nogc pure @safe{
	uint SDL_DEFINE_PIXELFOURCC(char a, char b, char c, char d) =>
		SDL_FOURCC(a, b, c, d);
	
	uint SDL_DEFINE_PIXELFORMAT(SDL_PixelType type, int order, int layout, uint bits, uint bytes) =>
		(1 << 28) | (type << 24) | (order << 20) | (layout << 16) | (bits << 8) | bytes;
	
	ubyte SDL_PIXELFLAG(uint format)   => cast(ubyte)((format >> 28) & 0x0F);
	ubyte SDL_PIXELTYPE(uint format)   => cast(ubyte)((format >> 24) & 0x0F);
	ubyte SDL_PIXELORDER(uint format)  => cast(ubyte)((format >> 20) & 0x0F);
	ubyte SDL_PIXELLAYOUT(uint format) => cast(ubyte)((format >> 16) & 0x0F);
	
	ubyte SDL_BITSPERPIXEL(uint format) =>
		SDL_ISPIXELFORMAT_FOURCC(format) ? 0 : cast(ubyte)((format >> 8) & 0xFF);
	
	ubyte SDL_BYTESPERPIXEL(uint format) =>
		SDL_ISPIXELFORMAT_FOURCC(format) ? (
			format == SDL_PixelFormat.yuy2 ||
			format == SDL_PixelFormat.uyvy ||
			format == SDL_PixelFormat.yvyu ||
			format == SDL_PixelFormat.p010
			? 2 : 1
		) : cast(ubyte)(format & 0xFF);
	
	bool SDL_ISPIXELFORMAT_INDEXED(uint format) =>
		!SDL_ISPIXELFORMAT_FOURCC(format) && (
			SDL_PIXELTYPE(format) == SDL_PixelType.index1 ||
			SDL_PIXELTYPE(format) == SDL_PixelType.index2 ||
			SDL_PIXELTYPE(format) == SDL_PixelType.index4 ||
			SDL_PIXELTYPE(format) == SDL_PixelType.index8
		);
	
	bool SDL_ISPIXELFORMAT_PACKED(uint format) =>
		!SDL_ISPIXELFORMAT_FOURCC(format) && (
			SDL_PIXELTYPE(format) == SDL_PixelType.packed8  ||
			SDL_PIXELTYPE(format) == SDL_PixelType.packed16 ||
			SDL_PIXELTYPE(format) == SDL_PixelType.packed32
		);
	
	bool SDL_ISPIXELFORMAT_ARRAY(uint format) =>
		!SDL_ISPIXELFORMAT_FOURCC(format) && (
			SDL_PIXELTYPE(format) == SDL_PixelType.arrayU8  ||
			SDL_PIXELTYPE(format) == SDL_PixelType.arrayU16 ||
			SDL_PIXELTYPE(format) == SDL_PixelType.arrayU32 ||
			SDL_PIXELTYPE(format) == SDL_PixelType.arrayF16 ||
			SDL_PIXELTYPE(format) == SDL_PixelType.arrayF32
		);
	
	bool SDL_ISPIXELFORMAT_10BIT(uint format) =>
		!SDL_ISPIXELFORMAT_FOURCC(format) && (
			SDL_PIXELTYPE(format)   == SDL_PixelType.packed32 &&
			SDL_PIXELLAYOUT(format) == SDL_PackedLayout._2101010
		);
	
	bool SDL_ISPIXELFORMAT_FLOAT(uint format) =>
		!SDL_ISPIXELFORMAT_FOURCC(format) && (
			SDL_PIXELTYPE(format) == SDL_PixelType.arrayF16 ||
			SDL_PIXELTYPE(format) == SDL_PixelType.arrayF32
		);
	
	bool SDL_ISPIXELFORMAT_ALPHA(uint format) => (
		SDL_ISPIXELFORMAT_PACKED(format) && (
			SDL_PIXELORDER(format) == SDL_PackedOrder.argb ||
			SDL_PIXELORDER(format) == SDL_PackedOrder.rgba ||
			SDL_PIXELORDER(format) == SDL_PackedOrder.abgr ||
			SDL_PIXELORDER(format) == SDL_PackedOrder.bgra
		)
	) || (
		SDL_ISPIXELFORMAT_ARRAY(format) && (
			SDL_PIXELORDER(format) == SDL_ArrayOrder.argb ||
			SDL_PIXELORDER(format) == SDL_ArrayOrder.rgba ||
			SDL_PIXELORDER(format) == SDL_ArrayOrder.abgr ||
			SDL_PIXELORDER(format) == SDL_ArrayOrder.bgra
		)
	);
	
	bool SDL_ISPIXELFORMAT_FOURCC(uint format) =>
		format && SDL_PIXELFLAG(format) != 1;
}

mixin(makeEnumBind(q{SDL_PixelFormat}, members: (){
	EnumMember[] ret = [
		{{q{unknown},         q{SDL_PIXELFORMAT_UNKNOWN}},          q{0}},
		{{q{index1LSB},       q{SDL_PIXELFORMAT_INDEX1LSB}},        q{0x1110_0100U}},
		{{q{index1MSB},       q{SDL_PIXELFORMAT_INDEX1MSB}},        q{0x1120_0100U}},
		{{q{index2LSB},       q{SDL_PIXELFORMAT_INDEX2LSB}},        q{0x1C10_0200U}},
		{{q{index2MSB},       q{SDL_PIXELFORMAT_INDEX2MSB}},        q{0x1C20_0200U}},
		{{q{index4LSB},       q{SDL_PIXELFORMAT_INDEX4LSB}},        q{0x1210_0400U}},
		{{q{index4MSB},       q{SDL_PIXELFORMAT_INDEX4MSB}},        q{0x1220_0400U}},
		{{q{index8},          q{SDL_PIXELFORMAT_INDEX8}},           q{0x1300_0801U}},
		{{q{rgb332},          q{SDL_PIXELFORMAT_RGB332}},           q{0x1411_0801U}},
		{{q{xrgb4444},        q{SDL_PIXELFORMAT_XRGB4444}},         q{0x1512_0C02U}},
		{{q{xbgr4444},        q{SDL_PIXELFORMAT_XBGR4444}},         q{0x1552_0C02U}},
		{{q{xrgb1555},        q{SDL_PIXELFORMAT_XRGB1555}},         q{0x1513_0F02U}},
		{{q{xbgr1555},        q{SDL_PIXELFORMAT_XBGR1555}},         q{0x1553_0F02U}},
		{{q{argb4444},        q{SDL_PIXELFORMAT_ARGB4444}},         q{0x1532_1002U}},
		{{q{rgba4444},        q{SDL_PIXELFORMAT_RGBA4444}},         q{0x1542_1002U}},
		{{q{abgr4444},        q{SDL_PIXELFORMAT_ABGR4444}},         q{0x1572_1002U}},
		{{q{bgra4444},        q{SDL_PIXELFORMAT_BGRA4444}},         q{0x1582_1002U}},
		{{q{argb1555},        q{SDL_PIXELFORMAT_ARGB1555}},         q{0x1533_1002U}},
		{{q{rgba5551},        q{SDL_PIXELFORMAT_RGBA5551}},         q{0x1544_1002U}},
		{{q{abgr1555},        q{SDL_PIXELFORMAT_ABGR1555}},         q{0x1573_1002U}},
		{{q{bgra5551},        q{SDL_PIXELFORMAT_BGRA5551}},         q{0x1584_1002U}},
		{{q{rgb565},          q{SDL_PIXELFORMAT_RGB565}},           q{0x1515_1002U}},
		{{q{bgr565},          q{SDL_PIXELFORMAT_BGR565}},           q{0x1555_1002U}},
		{{q{rgb24},           q{SDL_PIXELFORMAT_RGB24}},            q{0x1710_1803U}},
		{{q{bgr24},           q{SDL_PIXELFORMAT_BGR24}},            q{0x1740_1803U}},
		{{q{xrgb8888},        q{SDL_PIXELFORMAT_XRGB8888}},         q{0x1616_1804U}},
		{{q{rgbx8888},        q{SDL_PIXELFORMAT_RGBX8888}},         q{0x1626_1804U}},
		{{q{xbgr8888},        q{SDL_PIXELFORMAT_XBGR8888}},         q{0x1656_1804U}},
		{{q{bgrx8888},        q{SDL_PIXELFORMAT_BGRX8888}},         q{0x1666_1804U}},
		{{q{argb8888},        q{SDL_PIXELFORMAT_ARGB8888}},         q{0x1636_2004U}},
		{{q{rgba8888},        q{SDL_PIXELFORMAT_RGBA8888}},         q{0x1646_2004U}},
		{{q{abgr8888},        q{SDL_PIXELFORMAT_ABGR8888}},         q{0x1676_2004U}},
		{{q{bgra8888},        q{SDL_PIXELFORMAT_BGRA8888}},         q{0x1686_2004U}},
		{{q{xrgb2101010},     q{SDL_PIXELFORMAT_XRGB2101010}},      q{0x1617_2004U}},
		{{q{xbgr2101010},     q{SDL_PIXELFORMAT_XBGR2101010}},      q{0x1657_2004U}},
		{{q{argb2101010},     q{SDL_PIXELFORMAT_ARGB2101010}},      q{0x1637_2004U}},
		{{q{abgr2101010},     q{SDL_PIXELFORMAT_ABGR2101010}},      q{0x1677_2004U}},
		{{q{rgb48},           q{SDL_PIXELFORMAT_RGB48}},            q{0x1810_3006U}},
		{{q{bgr48},           q{SDL_PIXELFORMAT_BGR48}},            q{0x1840_3006U}},
		{{q{rgba64},          q{SDL_PIXELFORMAT_RGBA64}},           q{0x1820_4008U}},
		{{q{argb64},          q{SDL_PIXELFORMAT_ARGB64}},           q{0x1830_4008U}},
		{{q{bgra64},          q{SDL_PIXELFORMAT_BGRA64}},           q{0x1850_4008U}},
		{{q{abgr64},          q{SDL_PIXELFORMAT_ABGR64}},           q{0x1860_4008U}},
		{{q{rgb48Float},      q{SDL_PIXELFORMAT_RGB48_FLOAT}},      q{0x1A10_3006U}},
		{{q{bgr48Float},      q{SDL_PIXELFORMAT_BGR48_FLOAT}},      q{0x1A40_3006U}},
		{{q{rgba64Float},     q{SDL_PIXELFORMAT_RGBA64_FLOAT}},     q{0x1A20_4008U}},
		{{q{argb64Float},     q{SDL_PIXELFORMAT_ARGB64_FLOAT}},     q{0x1A30_4008U}},
		{{q{bgra64Float},     q{SDL_PIXELFORMAT_BGRA64_FLOAT}},     q{0x1A50_4008U}},
		{{q{abgr64Float},     q{SDL_PIXELFORMAT_ABGR64_FLOAT}},     q{0x1A60_4008U}},
		{{q{rgb96Float},      q{SDL_PIXELFORMAT_RGB96_FLOAT}},      q{0x1B10_600CU}},
		{{q{bgr96Float},      q{SDL_PIXELFORMAT_BGR96_FLOAT}},      q{0x1B40_600CU}},
		{{q{rgba128Float},    q{SDL_PIXELFORMAT_RGBA128_FLOAT}},    q{0x1B20_8010U}},
		{{q{argb128Float},    q{SDL_PIXELFORMAT_ARGB128_FLOAT}},    q{0x1B30_8010U}},
		{{q{bgra128Float},    q{SDL_PIXELFORMAT_BGRA128_FLOAT}},    q{0x1B50_8010U}},
		{{q{abgr128Float},    q{SDL_PIXELFORMAT_ABGR128_FLOAT}},    q{0x1B60_8010U}},
		{{q{yv12},            q{SDL_PIXELFORMAT_YV12}},             q{0x3231_5659U}},
		{{q{iyuv},            q{SDL_PIXELFORMAT_IYUV}},             q{0x5655_5949U}},
		{{q{yuy2},            q{SDL_PIXELFORMAT_YUY2}},             q{0x3259_5559U}},
		{{q{uyvy},            q{SDL_PIXELFORMAT_UYVY}},             q{0x5956_5955U}},
		{{q{yvyu},            q{SDL_PIXELFORMAT_YVYU}},             q{0x5559_5659U}},
		{{q{nv12},            q{SDL_PIXELFORMAT_NV12}},             q{0x3231_564EU}},
		{{q{nv21},            q{SDL_PIXELFORMAT_NV21}},             q{0x3132_564EU}},
		{{q{p010},            q{SDL_PIXELFORMAT_P010}},             q{0x3031_3050U}},
		{{q{externalOES},     q{SDL_PIXELFORMAT_EXTERNAL_OES}},     q{0x2053_454FU}},
	];
	version(BigEndian){{
		EnumMember[] add = [
			{{q{rgba32},    q{SDL_PIXELFORMAT_RGBA32}},    q{SDL_PixelFormat.rgba8888}},
			{{q{argb32},    q{SDL_PIXELFORMAT_ARGB32}},    q{SDL_PixelFormat.argb8888}},
			{{q{bgra32},    q{SDL_PIXELFORMAT_BGRA32}},    q{SDL_PixelFormat.bgra8888}},
			{{q{abgr32},    q{SDL_PIXELFORMAT_ABGR32}},    q{SDL_PixelFormat.abgr8888}},
			{{q{rgbx32},    q{SDL_PIXELFORMAT_RGBX32}},    q{SDL_PixelFormat.rgbx8888}},
			{{q{xrgb32},    q{SDL_PIXELFORMAT_XRGB32}},    q{SDL_PixelFormat.xrgb8888}},
			{{q{bgrx32},    q{SDL_PIXELFORMAT_BGRX32}},    q{SDL_PixelFormat.bgrx8888}},
			{{q{xbgr32},    q{SDL_PIXELFORMAT_XBGR32}},    q{SDL_PixelFormat.xbgr8888}},
		];
		ret ~= add;
	}}else{{
		EnumMember[] add = [
			{{q{rgba32},    q{SDL_PIXELFORMAT_RGBA32}},    q{SDL_PixelFormat.abgr8888}},
			{{q{argb32},    q{SDL_PIXELFORMAT_ARGB32}},    q{SDL_PixelFormat.bgra8888}},
			{{q{bgra32},    q{SDL_PIXELFORMAT_BGRA32}},    q{SDL_PixelFormat.argb8888}},
			{{q{abgr32},    q{SDL_PIXELFORMAT_ABGR32}},    q{SDL_PixelFormat.rgba8888}},
			{{q{rgbx32},    q{SDL_PIXELFORMAT_RGBX32}},    q{SDL_PixelFormat.xbgr8888}},
			{{q{xrgb32},    q{SDL_PIXELFORMAT_XRGB32}},    q{SDL_PixelFormat.bgrx8888}},
			{{q{bgrx32},    q{SDL_PIXELFORMAT_BGRX32}},    q{SDL_PixelFormat.xrgb8888}},
			{{q{xbgr32},    q{SDL_PIXELFORMAT_XBGR32}},    q{SDL_PixelFormat.rgbx8888}},
		];
		ret ~= add;
	}}
	if(sdlVersion >= Version(3,2,6)){
		EnumMember[] add = [
			{{q{mjpg},      q{SDL_PIXELFORMAT_MJPG}},      q{0x47504A4DU}},
		];
		ret ~= add;
	}
	return ret;
}()));

mixin(makeEnumBind(q{SDL_ColourType}, aliases: [q{SDL_ColorType}], members: (){
	EnumMember[] ret = [
		{{q{unknown},    q{SDL_COLOUR_TYPE_UNKNOWN}},    q{0}, aliases: [{c: q{SDL_COLOR_TYPE_UNKNOWN}}]},
		{{q{rgb},        q{SDL_COLOUR_TYPE_RGB}},        q{1}, aliases: [{c: q{SDL_COLOR_TYPE_RGB}}]},
		{{q{ycbcr},      q{SDL_COLOUR_TYPE_YCBCR}},      q{2}, aliases: [{c: q{SDL_COLOR_TYPE_YCBCR}}]},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_ColourRange}, aliases: [q{SDL_ColorRange}], members: (){
	EnumMember[] ret = [
		{{q{unknown},    q{SDL_COLOUR_RANGE_UNKNOWN}},    q{0}, aliases: [{c: q{SDL_COLOR_RANGE_UNKNOWN}}]},
		{{q{limited},    q{SDL_COLOUR_RANGE_LIMITED}},    q{1}, aliases: [{c: q{SDL_COLOR_RANGE_LIMITED}}]},
		{{q{full},       q{SDL_COLOUR_RANGE_FULL}},       q{2}, aliases: [{c: q{SDL_COLOR_RANGE_FULL}}]},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_ColourPrimaries}, aliases: [q{SDL_ColorPrimaries}], members: (){
	EnumMember[] ret = [
		{{q{unknown},        q{SDL_COLOUR_PRIMARIES_UNKNOWN}},         q{0}, aliases: [{c: q{SDL_COLOR_PRIMARIES_UNKNOWN}}]},
		{{q{bt709},          q{SDL_COLOUR_PRIMARIES_BT709}},           q{1}, aliases: [{c: q{SDL_COLOR_PRIMARIES_BT709}}]},
		{{q{unspecified},    q{SDL_COLOUR_PRIMARIES_UNSPECIFIED}},     q{2}, aliases: [{c: q{SDL_COLOR_PRIMARIES_UNSPECIFIED}}]},
		{{q{bt470M},         q{SDL_COLOUR_PRIMARIES_BT470M}},          q{4}, aliases: [{c: q{SDL_COLOR_PRIMARIES_BT470M}}]},
		{{q{bt470BG},        q{SDL_COLOUR_PRIMARIES_BT470BG}},         q{5}, aliases: [{c: q{SDL_COLOR_PRIMARIES_BT470BG}}]},
		{{q{bt601},          q{SDL_COLOUR_PRIMARIES_BT601}},           q{6}, aliases: [{c: q{SDL_COLOR_PRIMARIES_BT601}}]},
		{{q{smpte240},       q{SDL_COLOUR_PRIMARIES_SMPTE240}},        q{7}, aliases: [{c: q{SDL_COLOR_PRIMARIES_SMPTE240}}]},
		{{q{genericFilm},    q{SDL_COLOUR_PRIMARIES_GENERIC_FILM}},    q{8}, aliases: [{c: q{SDL_COLOR_PRIMARIES_GENERIC_FILM}}]},
		{{q{bt2020},         q{SDL_COLOUR_PRIMARIES_BT2020}},          q{9}, aliases: [{c: q{SDL_COLOR_PRIMARIES_BT2020}}]},
		{{q{xyz},            q{SDL_COLOUR_PRIMARIES_XYZ}},             q{10}, aliases: [{c: q{SDL_COLOR_PRIMARIES_XYZ}}]},
		{{q{smpte431},       q{SDL_COLOUR_PRIMARIES_SMPTE431}},        q{11}, aliases: [{c: q{SDL_COLOR_PRIMARIES_SMPTE431}}]},
		{{q{smpte432},       q{SDL_COLOUR_PRIMARIES_SMPTE432}},        q{12}, aliases: [{c: q{SDL_COLOR_PRIMARIES_SMPTE432}}]},
		{{q{ebu3213},        q{SDL_COLOUR_PRIMARIES_EBU3213}},         q{22}, aliases: [{c: q{SDL_COLOR_PRIMARIES_EBU3213}}]},
		{{q{custom},         q{SDL_COLOUR_PRIMARIES_CUSTOM}},          q{31}, aliases: [{c: q{SDL_COLOR_PRIMARIES_CUSTOM}}]},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_TransferCharacteristics}, members: (){
	EnumMember[] ret = [
		{{q{unknown},         q{SDL_TRANSFER_CHARACTERISTICS_UNKNOWN}},          q{0}},
		{{q{bt709},           q{SDL_TRANSFER_CHARACTERISTICS_BT709}},            q{1}},
		{{q{unspecified},     q{SDL_TRANSFER_CHARACTERISTICS_UNSPECIFIED}},      q{2}},
		{{q{gamma22},         q{SDL_TRANSFER_CHARACTERISTICS_GAMMA22}},          q{4}},
		{{q{gamma28},         q{SDL_TRANSFER_CHARACTERISTICS_GAMMA28}},          q{5}},
		{{q{bt601},           q{SDL_TRANSFER_CHARACTERISTICS_BT601}},            q{6}},
		{{q{smpte240},        q{SDL_TRANSFER_CHARACTERISTICS_SMPTE240}},         q{7}},
		{{q{linear},          q{SDL_TRANSFER_CHARACTERISTICS_LINEAR}},           q{8}},
		{{q{log100},          q{SDL_TRANSFER_CHARACTERISTICS_LOG100}},           q{9}},
		{{q{log100Sqrt10},    q{SDL_TRANSFER_CHARACTERISTICS_LOG100_SQRT10}},    q{10}},
		{{q{iec61966},        q{SDL_TRANSFER_CHARACTERISTICS_IEC61966}},         q{11}},
		{{q{bt1361},          q{SDL_TRANSFER_CHARACTERISTICS_BT1361}},           q{12}},
		{{q{srgb},            q{SDL_TRANSFER_CHARACTERISTICS_SRGB}},             q{13}},
		{{q{bt2020_10Bit},    q{SDL_TRANSFER_CHARACTERISTICS_BT2020_10BIT}},     q{14}},
		{{q{bt2020_12Bit},    q{SDL_TRANSFER_CHARACTERISTICS_BT2020_12BIT}},     q{15}},
		{{q{pq},              q{SDL_TRANSFER_CHARACTERISTICS_PQ}},               q{16}},
		{{q{smpte428},        q{SDL_TRANSFER_CHARACTERISTICS_SMPTE428}},         q{17}},
		{{q{hlg},             q{SDL_TRANSFER_CHARACTERISTICS_HLG}},              q{18}},
		{{q{custom},          q{SDL_TRANSFER_CHARACTERISTICS_CUSTOM}},           q{31}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_MatrixCoefficients}, members: (){
	EnumMember[] ret = [
		{{q{identity},          q{SDL_MATRIX_COEFFICIENTS_IDENTITY}},            q{0}},
		{{q{bt709},             q{SDL_MATRIX_COEFFICIENTS_BT709}},               q{1}},
		{{q{unspecified},       q{SDL_MATRIX_COEFFICIENTS_UNSPECIFIED}},         q{2}},
		{{q{fcc},               q{SDL_MATRIX_COEFFICIENTS_FCC}},                 q{4}},
		{{q{bt470BG},           q{SDL_MATRIX_COEFFICIENTS_BT470BG}},             q{5}},
		{{q{bt601},             q{SDL_MATRIX_COEFFICIENTS_BT601}},               q{6}},
		{{q{smpte240},          q{SDL_MATRIX_COEFFICIENTS_SMPTE240}},            q{7}},
		{{q{ycgco},             q{SDL_MATRIX_COEFFICIENTS_YCGCO}},               q{8}},
		{{q{bt2020NCL},         q{SDL_MATRIX_COEFFICIENTS_BT2020_NCL}},          q{9}},
		{{q{bt2020CL},          q{SDL_MATRIX_COEFFICIENTS_BT2020_CL}},           q{10}},
		{{q{smpte2085},         q{SDL_MATRIX_COEFFICIENTS_SMPTE2085}},           q{11}},
		{{q{chromaDerivedNCL},  q{SDL_MATRIX_COEFFICIENTS_CHROMA_DERIVED_NCL}},  q{12}},
		{{q{chromaDerivedCL},   q{SDL_MATRIX_COEFFICIENTS_CHROMA_DERIVED_CL}},   q{13}},
		{{q{ictcp},             q{SDL_MATRIX_COEFFICIENTS_ICTCP}},               q{14}},
		{{q{custom},            q{SDL_MATRIX_COEFFICIENTS_CUSTOM}},              q{31}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_ChromaLocation}, members: (){
	EnumMember[] ret = [
		{{q{none},     q{SDL_CHROMA_LOCATION_NONE}},     q{0}},
		{{q{left},     q{SDL_CHROMA_LOCATION_LEFT}},     q{1}},
		{{q{centre},   q{SDL_CHROMA_LOCATION_CENTRE}},   q{2}, aliases: [{q{center}, q{SDL_CHROMA_LOCATION_CENTER}}]},
		{{q{topLeft},  q{SDL_CHROMA_LOCATION_TOPLEFT}},  q{3}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_Colourspace}, aliases: [q{SDL_Colorspace}], members: (){
	EnumMember[] ret = [
		{{q{unknown},          q{SDL_COLOURSPACE_UNKNOWN}},           q{0}, aliases: [{c: q{SDL_COLORSPACE_UNKNOWN}}]},
		{{q{srgb},             q{SDL_COLOURSPACE_SRGB}},              q{0x1200_05A0U}, aliases: [{c: q{SDL_COLORSPACE_SRGB}}]},
		{{q{srgbLinear},       q{SDL_COLOURSPACE_SRGB_LINEAR}},       q{0x1200_0500U}, aliases: [{c: q{SDL_COLORSPACE_SRGB_LINEAR}}]},
		{{q{hdr10},            q{SDL_COLOURSPACE_HDR10}},             q{0x1200_2600U}, aliases: [{c: q{SDL_COLORSPACE_HDR10}}]},
		{{q{jpeg},             q{SDL_COLOURSPACE_JPEG}},              q{0x2200_04C6U}, aliases: [{c: q{SDL_COLORSPACE_JPEG}}]},
		{{q{bt601Limited},     q{SDL_COLOURSPACE_BT601_LIMITED}},     q{0x2110_18C6U}, aliases: [{c: q{SDL_COLORSPACE_BT601_LIMITED}}]},
		{{q{bt601Full},        q{SDL_COLOURSPACE_BT601_FULL}},        q{0x2210_18C6U}, aliases: [{c: q{SDL_COLORSPACE_BT601_FULL}}]},
		{{q{bt709Limited},     q{SDL_COLOURSPACE_BT709_LIMITED}},     q{0x2110_0421U}, aliases: [{c: q{SDL_COLORSPACE_BT709_LIMITED}}]},
		{{q{bt709Full},        q{SDL_COLOURSPACE_BT709_FULL}},        q{0x2210_0421U}, aliases: [{c: q{SDL_COLORSPACE_BT709_FULL}}]},
		{{q{bt2020Limited},    q{SDL_COLOURSPACE_BT2020_LIMITED}},    q{0x2110_2609U}, aliases: [{c: q{SDL_COLORSPACE_BT2020_LIMITED}}]},
		{{q{bt2020Full},       q{SDL_COLOURSPACE_BT2020_FULL}},       q{0x2210_2609U}, aliases: [{c: q{SDL_COLORSPACE_BT2020_FULL}}]},
		{{q{rgbDefault},       q{SDL_COLOURSPACE_RGB_DEFAULT}},       q{srgb}, aliases: [{c: q{SDL_COLORSPACE_RGB_DEFAULT}}]},
		{{q{yuvDefault},       q{SDL_COLOURSPACE_YUV_DEFAULT}},       q{jpeg}, aliases: [{c: q{SDL_COLORSPACE_YUV_DEFAULT}}]},
	];
	return ret;
}()));

pragma(inline,true) nothrow @nogc pure @safe{
	uint SDL_DEFINE_COLOURSPACE(SDL_ColourType type, SDL_ColourRange range, SDL_ColourPrimaries primaries, SDL_TransferCharacteristics transfer, SDL_MatrixCoefficients matrix, SDL_ChromaLocation chroma) =>
		(type << 28) | (range << 24) | (chroma << 20) | (primaries << 10) | (transfer << 5) | matrix;
	
	SDL_ColourType SDL_COLOURSPACETYPE(SDL_Colourspace cspace) =>
		cast(SDL_ColourType)((cspace >> 28) & 0x0F);
	
	SDL_ColourRange SDL_COLOURSPACERANGE(SDL_Colourspace cspace) =>
		cast(SDL_ColourRange)((cspace >> 24) & 0x0F);
	
	SDL_ChromaLocation SDL_COLOURSPACECHROMA(SDL_Colourspace cspace) =>
		cast(SDL_ChromaLocation)((cspace >> 20) & 0x0F);
	
	SDL_ColourPrimaries SDL_COLOURSPACEPRIMARIES(SDL_Colourspace cspace) =>
		cast(SDL_ColourPrimaries)((cspace >> 10) & 0x1F);
	
	SDL_TransferCharacteristics SDL_COLOURSPACETRANSFER(SDL_Colourspace cspace) =>
		cast(SDL_TransferCharacteristics)((cspace >>  5) & 0x1F);
	
	SDL_MatrixCoefficients SDL_COLOURSPACEMATRIX(SDL_Colourspace cspace) =>
		cast(SDL_MatrixCoefficients)(cspace & 0x1F);
	
	bool SDL_ISCOLOURSPACE_MATRIX_BT601(SDL_Colourspace cspace) =>
		SDL_COLOURSPACEMATRIX(cspace) == SDL_MatrixCoefficients.bt601 ||
		SDL_COLOURSPACEMATRIX(cspace) == SDL_MatrixCoefficients.bt470BG;
	
	bool SDL_ISCOLOURSPACE_MATRIX_BT709(SDL_Colourspace cspace) =>
		SDL_COLOURSPACEMATRIX(cspace) == SDL_MatrixCoefficients.bt709;
	
	bool SDL_ISCOLOURSPACE_MATRIX_BT2020_NCL(SDL_Colourspace cspace) =>
		SDL_COLOURSPACEMATRIX(cspace) == SDL_MatrixCoefficients.bt2020NCL;
	
	bool SDL_ISCOLOURSPACE_LIMITED_RANGE(SDL_Colourspace cspace) =>
		SDL_COLOURSPACERANGE(cspace) != SDL_ColourRange.full;
	
	bool SDL_ISCOLOURSPACE_FULL_RANGE(SDL_Colourspace cspace) =>
		SDL_COLOURSPACERANGE(cspace) == SDL_ColourRange.full;
	
	alias SDL_DEFINE_COLORSPACE = SDL_DEFINE_COLOURSPACE;
	alias SDL_COLORSPACETYPE = SDL_COLOURSPACETYPE;
	alias SDL_COLORSPACERANGE = SDL_COLOURSPACERANGE;
	alias SDL_COLORSPACECHROMA = SDL_COLOURSPACECHROMA;
	alias SDL_COLORSPACEPRIMARIES = SDL_COLOURSPACEPRIMARIES;
	alias SDL_COLORSPACETRANSFER = SDL_COLOURSPACETRANSFER;
	alias SDL_COLORSPACEMATRIX = SDL_COLOURSPACEMATRIX;
	alias SDL_ISCOLORSPACE_MATRIX_BT601 = SDL_ISCOLOURSPACE_MATRIX_BT601;
	alias SDL_ISCOLORSPACE_MATRIX_BT709 = SDL_ISCOLOURSPACE_MATRIX_BT709;
	alias SDL_ISCOLORSPACE_MATRIX_BT2020_NCL = SDL_ISCOLOURSPACE_MATRIX_BT2020_NCL;
	alias SDL_ISCOLORSPACE_LIMITED_RANGE = SDL_ISCOLOURSPACE_LIMITED_RANGE;
	alias SDL_ISCOLORSPACE_FULL_RANGE = SDL_ISCOLOURSPACE_FULL_RANGE;
}

struct SDL_Colour{
	ubyte r, g, b, a;
}
alias SDL_Color = SDL_Colour;

struct SDL_FColour{
	float r, g, b, a;
}
alias SDL_FColor = SDL_FColour;

struct SDL_Palette{
	int nColours;
	SDL_Colour* colours;
	uint version_;
	int refCount;
	
	alias ncolours = nColours;
	alias ncolors = nColours;
	alias nColors = nColours;
	alias colors = colours;
	alias refcount = refCount;
}

struct SDL_PixelFormatDetails{
	SDL_PixelFormat format;
	ubyte bitsPerPixel, bytesPerPixel;
	ubyte[2] padding;
	uint rMask, gMask, bMask, aMask;
	ubyte rBits, gBits, bBits, aBits;
	ubyte rShift, gShift, bShift, aShift;
	
	alias bits_per_pixel = bitsPerPixel;
	alias bytes_per_pixel = bytesPerPixel;
	alias Rmask = rMask;
	alias Gmask = gMask;
	alias Bmask = bMask;
	alias Amask = aMask;
	alias Rbits = rBits;
	alias Gbits = gBits;
	alias Bbits = bBits;
	alias Abits = aBits;
	alias Rshift = rShift;
	alias Gshift = gShift;
	alias Bshift = bShift;
	alias Ashift = aShift;
}

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{const(char)*}, q{SDL_GetPixelFormatName}, q{SDL_PixelFormat format}},
		{q{bool}, q{SDL_GetMasksForPixelFormat}, q{SDL_PixelFormat format, int* bpp, uint* rMask, uint* gMask, uint* bMask, uint* aMask}},
		{q{SDL_PixelFormat}, q{SDL_GetPixelFormatForMasks}, q{int bpp, uint rMask, uint gMask, uint bMask, uint aMask}},
		{q{const(SDL_PixelFormatDetails)*}, q{SDL_GetPixelFormatDetails}, q{SDL_PixelFormat format}},
		{q{SDL_Palette*}, q{SDL_CreatePalette}, q{int nColours}},
		{q{bool}, q{SDL_SetPaletteColors}, q{SDL_Palette* palette, const(SDL_Colour)* colours, int firstColour, int nColours}},
		{q{void}, q{SDL_DestroyPalette}, q{SDL_Palette* palette}},
		{q{uint}, q{SDL_MapRGB}, q{const(SDL_PixelFormatDetails)* format, const(SDL_Palette)* palette, ubyte r, ubyte g, ubyte b}},
		{q{uint}, q{SDL_MapRGBA}, q{const(SDL_PixelFormatDetails)* format, const(SDL_Palette)* palette, ubyte r, ubyte g, ubyte b, ubyte a}},
		{q{void}, q{SDL_GetRGB}, q{uint pixel, const(SDL_PixelFormatDetails)* format, const(SDL_Palette)* palette, ubyte* r, ubyte* g, ubyte* b}},
		{q{void}, q{SDL_GetRGBA}, q{uint pixel, const(SDL_PixelFormatDetails)* format, const(SDL_Palette)* palette, ubyte* r, ubyte* g, ubyte* b, ubyte* a}},
	];
	return ret;
}()));
