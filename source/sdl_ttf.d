/+
+               Copyright 2025 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl_ttf;

import bindbc.sdl.config;
static if(sdlTTFVersion):
import bindbc.sdl.codegen;

import sdl.gpu: SDL_GPUDevice, SDL_GPUTexture;
import sdl.iostream: SDL_IOStream;
import sdl.pixels: SDL_Colour, SDL_FColour;
import sdl.properties: SDL_PropertiesID;
import sdl.rect: SDL_FPoint, SDL_Rect;
import sdl.render: SDL_Renderer;
import sdl.surface: SDL_Surface;
import sdl.version_: SDL_VERSIONNUM;

enum{
	SDL_TTF_MajorVersion = sdlTTFVersion.major,
	SDL_TTF_MinorVersion = sdlTTFVersion.minor,
	SDL_TTF_MicroVersion = sdlTTFVersion.patch,
	SDL_TTF_Version = SDL_VERSIONNUM(SDL_TTF_MajorVersion, SDL_TTF_MinorVersion, SDL_TTF_MicroVersion),
	
	SDL_TTF_MAJOR_VERSION = SDL_TTF_MajorVersion,
	SDL_TTF_MINOR_VERSION = SDL_TTF_MinorVersion,
	SDL_TTF_MICRO_VERSION = SDL_TTF_MicroVersion,
	SDL_TTF_VERSION = SDL_TTF_Version,
}

pragma(inline,true)
bool SDL_TTF_VERSION_ATLEAST(uint x, uint y, uint z) nothrow @nogc pure @safe =>
	(SDL_TTF_MajorVersion >= x) &&
	(SDL_TTF_MajorVersion  > x || SDL_TTF_MinorVersion >= y) &&
	(SDL_TTF_MajorVersion  > x || SDL_TTF_MinorVersion >  y || SDL_TTF_MicroVersion >= z);

struct TTF_Font;

mixin(makeEnumBind(q{TTFProp_FontCreate}, q{const(char)*}, members: (){
	EnumMember[] ret = [
		{{q{filenameString},              q{TTF_PROP_FONT_CREATE_FILENAME_STRING}},               q{"SDL_ttf.font.create.filename"}},
		{{q{ioStreamPointer},             q{TTF_PROP_FONT_CREATE_IOSTREAM_POINTER}},              q{"SDL_ttf.font.create.iostream"}},
		{{q{ioStreamOffsetNumber},        q{TTF_PROP_FONT_CREATE_IOSTREAM_OFFSET_NUMBER}},        q{"SDL_ttf.font.create.iostream.offset"}},
		{{q{ioStreamAutoCloseBoolean},    q{TTF_PROP_FONT_CREATE_IOSTREAM_AUTOCLOSE_BOOLEAN}},    q{"SDL_ttf.font.create.iostream.autoclose"}},
		{{q{sizeFloat},                   q{TTF_PROP_FONT_CREATE_SIZE_FLOAT}},                    q{"SDL_ttf.font.create.size"}},
		{{q{faceNumber},                  q{TTF_PROP_FONT_CREATE_FACE_NUMBER}},                   q{"SDL_ttf.font.create.face"}},
		{{q{horizontalDPINumber},         q{TTF_PROP_FONT_CREATE_HORIZONTAL_DPI_NUMBER}},         q{"SDL_ttf.font.create.hdpi"}},
		{{q{verticalDPINumber},           q{TTF_PROP_FONT_CREATE_VERTICAL_DPI_NUMBER}},           q{"SDL_ttf.font.create.vdpi"}},
		{{q{existingFont},                q{TTF_PROP_FONT_CREATE_EXISTING_FONT}},                 q{"SDL_ttf.font.create.existing_font"}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{TTFProp_FontOutline}, q{const(char)*}, members: (){
	EnumMember[] ret = [
		{{q{lineCapNumber},       q{TTF_PROP_FONT_OUTLINE_LINE_CAP_NUMBER}},       q{"SDL_ttf.font.outline.line_cap"}},
		{{q{lineJoinNumber},      q{TTF_PROP_FONT_OUTLINE_LINE_JOIN_NUMBER}},      q{"SDL_ttf.font.outline.line_join"}},
		{{q{mitreLimitNumber},    q{TTF_PROP_FONT_OUTLINE_MITRE_LIMIT_NUMBER}},    q{"SDL_ttf.font.outline.miter_limit"}, aliases: [{q{miterLimitNumber}, q{TTF_PROP_FONT_OUTLINE_MITER_LIMIT_NUMBER}},]},
	];
	return ret;
}()));

alias TTF_FontStyleFlags_ = uint;
mixin(makeEnumBind(q{TTF_FontStyleFlags}, q{TTF_FontStyleFlags_}, aliases: [q{TTF_Style}], members: (){
	EnumMember[] ret = [
		{{q{normal},         q{TTF_STYLE_NORMAL}},         q{0x00}},
		{{q{bold},           q{TTF_STYLE_BOLD}},           q{0x01}},
		{{q{italic},         q{TTF_STYLE_ITALIC}},         q{0x02}},
		{{q{underline},      q{TTF_STYLE_UNDERLINE}},      q{0x04}},
		{{q{strikethrough},  q{TTF_STYLE_STRIKETHROUGH}},  q{0x08}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{TTF_HintingFlags}, aliases: [q{TTF_Hinting}], members: (){
	EnumMember[] ret;
	if(sdlTTFVersion >= Version(3,2,2)){
		EnumMember[] add = [
			{{q{invalid},        q{TTF_HINTING_INVALID}}, q{-1}},
		];
		ret ~= add;
	}
	{
		EnumMember[] add = [
			{{q{normal},         q{TTF_HINTING_NORMAL}}, q{0}},
			{{q{light},          q{TTF_HINTING_LIGHT}}},
			{{q{mono},           q{TTF_HINTING_MONO}}},
			{{q{none},           q{TTF_HINTING_NONE}}},
			{{q{lightSubpixel},  q{TTF_HINTING_LIGHT_SUBPIXEL}}},
		];
		ret ~= add;
	}
	return ret;
}()));

static if(sdlTTFVersion >= Version(3,2,2)){
	mixin(makeEnumBind(q{TTF_FontWeight}, q{int}, members: (){
		EnumMember[] ret = [
			{{q{thin},        q{TTF_FONT_WEIGHT_THIN}},         q{100}},
			{{q{extraLight},  q{TTF_FONT_WEIGHT_EXTRA_LIGHT}},  q{200}},
			{{q{light},       q{TTF_FONT_WEIGHT_LIGHT}},        q{300}},
			{{q{normal},      q{TTF_FONT_WEIGHT_NORMAL}},       q{400}},
			{{q{medium},      q{TTF_FONT_WEIGHT_MEDIUM}},       q{500}},
			{{q{semiBold},    q{TTF_FONT_WEIGHT_SEMI_BOLD}},    q{600}},
			{{q{bold},        q{TTF_FONT_WEIGHT_BOLD}},         q{700}},
			{{q{extraBold},   q{TTF_FONT_WEIGHT_EXTRA_BOLD}},   q{800}},
			{{q{black},       q{TTF_FONT_WEIGHT_BLACK}},        q{900}},
			{{q{extraBlack},  q{TTF_FONT_WEIGHT_EXTRA_BLACK}},  q{950}},
		];
		return ret;
	}()));
}

mixin(makeEnumBind(q{TTF_HorizontalAlignment}, aliases: [q{TTF_HorizontalAlign}], members: (){
	EnumMember[] ret = [
		{{q{invalid},  q{TTF_HORIZONTAL_ALIGN_INVALID}}, q{-1}},
		{{q{left},     q{TTF_HORIZONTAL_ALIGN_LEFT}}},
		{{q{centre},   q{TTF_HORIZONTAL_ALIGN_CENTRE}}, aliases: [{q{center}, q{TTF_HORIZONTAL_ALIGN_CENTER}}]},
		{{q{right},    q{TTF_HORIZONTAL_ALIGN_RIGHT}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{TTF_Direction}, members: (){
	EnumMember[] ret = [
		{{q{invalid},  q{TTF_DIRECTION_INVALID}},  q{0}},
		{{q{ltr},      q{TTF_DIRECTION_LTR}},      q{4}},
		{{q{rtl},      q{TTF_DIRECTION_RTL}}},
		{{q{ttb},      q{TTF_DIRECTION_TTB}}},
		{{q{btt},      q{TTF_DIRECTION_BTT}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{TTF_ImageType}, members: (){
	EnumMember[] ret = [
		{{q{invalid}, q{TTF_IMAGE_INVALID}}},
		{{q{alpha}, q{TTF_IMAGE_ALPHA}}},
		{{q{colour}, q{TTF_IMAGE_COLOUR}}, aliases: [{q{color}, q{TTF_IMAGE_COLOR}}]},
		{{q{sdf}, q{TTF_IMAGE_SDF}}},
	];
	return ret;
}()));

struct TTF_Text{
	char* text;
	int numLines;
	int refCount;
	TTF_TextData* internal;
	
	alias num_lines = numLines;
	alias refcount = refCount;
}

mixin(makeEnumBind(q{TTFProp_RendererTextEngineCreate}, q{const(char)*}, aliases: [q{TTFProp_RendererTextEngine}], members: (){
	EnumMember[] ret = [
		{{q{renderer},            q{TTF_PROP_RENDERER_TEXT_ENGINE_RENDERER}},              q{"SDL_ttf.renderer_text_engine.create.renderer"}},
		{{q{atlasTextureSize},    q{TTF_PROP_RENDERER_TEXT_ENGINE_ATLAS_TEXTURE_SIZE}},    q{"SDL_ttf.renderer_text_engine.create.atlas_texture_size"}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{TTFProp_GPUTextEngineCreate}, q{const(char)*}, aliases: [q{TTFProp_GPUTextEngine}], members: (){
	EnumMember[] ret = [
		{{q{device},              q{TTF_PROP_GPU_TEXT_ENGINE_DEVICE}},                q{"SDL_ttf.gpu_text_engine.create.device"}},
		{{q{atlasTextureSize},    q{TTF_PROP_GPU_TEXT_ENGINE_ATLAS_TEXTURE_SIZE}},    q{"SDL_ttf.gpu_text_engine.create.atlas_texture_size"}},
	];
	return ret;
}()));

struct TTF_GPUAtlasDrawSequence{
	SDL_GPUTexture* atlasTexture;
	SDL_FPoint* xy, uv;
	int numVertices;
	int* indices;
	int numIndices;
	TTF_ImageType imageType;
	TTF_GPUAtlasDrawSequence* next;
	
	alias atlas_texture = atlasTexture;
	alias num_vertices = numVertices;
	alias num_indices = numIndices;
	alias image_type = imageType;
}

mixin(makeEnumBind(q{TTF_GPUTextEngineWinding}, members: (){
	EnumMember[] ret = [
		{{q{invalid},       q{TTF_GPU_TEXTENGINE_WINDING_INVALID}}, q{-1}},
		{{q{clockwise},     q{TTF_GPU_TEXTENGINE_WINDING_CLOCKWISE}}},
		{{q{antiClockwise}, q{TTF_GPU_TEXTENGINE_WINDING_ANTI_CLOCKWISE}}, aliases: [{q{counterClockwise}, q{TTF_GPU_TEXTENGINE_WINDING_COUNTER_CLOCKWISE}}]},
	];
	return ret;
}()));

alias TTF_SubStringFlags_ = uint;

mixin(makeEnumBind(q{TTF_SubStringFlags}, q{TTF_SubStringFlags_}, members: (){
	EnumMember[] ret = [
		{{q{directionMask},    q{TTF_SUBSTRING_DIRECTION_MASK}},    q{0x0000_00FF}},
		{{q{textStart},        q{TTF_SUBSTRING_TEXT_START}},        q{0x0000_0100}},
		{{q{lineStart},        q{TTF_SUBSTRING_LINE_START}},        q{0x0000_0200}},
		{{q{lineEnd},          q{TTF_SUBSTRING_LINE_END}},          q{0x0000_0400}},
		{{q{textEnd},          q{TTF_SUBSTRING_TEXT_END}},          q{0x0000_0800}},
	];
	return ret;
}()));

struct TTF_SubString{
	TTF_SubStringFlags_ flags;
	int offset, length;
	int lineIndex, clusterIndex;
	SDL_Rect rect;
	
	alias line_index = lineIndex;
	alias cluster_index = clusterIndex;
}

//SDL_textengine.h:

mixin(makeEnumBind(q{TTF_DrawCommand}, members: (){
	EnumMember[] ret = [
		{{q{noOp}, q{TTF_DRAW_COMMAND_NOOP}}},
		{{q{fill}, q{TTF_DRAW_COMMAND_FILL}}},
		{{q{copy}, q{TTF_DRAW_COMMAND_COPY}}},
	];
	return ret;
}()));

struct TTF_FillOperation{
	TTF_DrawCommand cmd;
	SDL_Rect rect;
}

struct TTF_CopyOperation{
	TTF_DrawCommand cmd;
	int textOffset;
	TTF_Font* glyphFont;
	uint glyphIndex;
	SDL_Rect src, dst;
	void* reserved;
	
	alias text_offset = textOffset;
	alias glyph_font = glyphFont;
	alias glyph_index = glyphIndex;
}

union TTF_DrawOperation{
	TTF_DrawCommand cmd;
	TTF_FillOperation fill;
	TTF_CopyOperation copy;
}

struct TTF_TextLayout;

struct TTF_TextData{
	TTF_Font* font;
	SDL_FColour colour;
	bool needsLayoutUpdate;
	TTF_TextLayout* layout;
	int x, y, w, h;
	int numOps;
	TTF_DrawOperation* ops;
	int numClusters;
	TTF_SubString* clusters;
	SDL_PropertiesID props;
	bool needsEngineUpdate;
	TTF_TextEngine* engine;
	void* engineText;
	
	alias color = colour;
	alias needs_layout_update = needsLayoutUpdate;
	alias num_ops = numOps;
	alias num_clusters = numClusters;
	alias needs_engine_update = needsEngineUpdate;
	alias engine_text = engineText;
}

struct TTF_TextEngine{
	uint version_;
	void* userData;
	private extern(C) nothrow{
		alias CreateTextFn = bool function(void* userData, TTF_Text* text);
		alias DestroyTextFn = void function(void* userData, TTF_Text* text);
	}
	CreateTextFn createText;
	DestroyTextFn destroyText;
	
	alias userdata = userData;
	alias CreateText = createText;
	alias DestroyText = destroyText;
}

static assert(
	((void*).sizeof == 4 && TTF_TextEngine.sizeof == 16) ||
	((void*).sizeof == 8 && TTF_TextEngine.sizeof == 32)
);

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{int}, q{TTF_Version}, q{}},
		{q{void}, q{TTF_GetFreeTypeVersion}, q{int* major, int* minor, int* patch}},
		{q{void}, q{TTF_GetHarfBuzzVersion}, q{int* major, int* minor, int* patch}},
		{q{bool}, q{TTF_Init}, q{}},
		{q{TTF_Font*}, q{TTF_OpenFont}, q{const(char)* file, float ptSize}},
		{q{TTF_Font*}, q{TTF_OpenFontIO}, q{SDL_IOStream* src, bool closeIO, float ptSize}},
		{q{TTF_Font*}, q{TTF_OpenFontWithProperties}, q{SDL_PropertiesID props}},
		{q{TTF_Font*}, q{TTF_CopyFont}, q{TTF_Font* existingFont}},
		{q{SDL_PropertiesID}, q{TTF_GetFontProperties}, q{TTF_Font* font}},
		{q{uint}, q{TTF_GetFontGeneration}, q{TTF_Font* font}},
		{q{bool}, q{TTF_AddFallbackFont}, q{TTF_Font* font, TTF_Font* fallback}},
		{q{void}, q{TTF_RemoveFallbackFont}, q{TTF_Font* font, TTF_Font* fallback}},
		{q{void}, q{TTF_ClearFallbackFonts}, q{TTF_Font* font}},
		{q{bool}, q{TTF_SetFontSize}, q{TTF_Font* font, float ptSize}},
		{q{bool}, q{TTF_SetFontSizeDPI}, q{TTF_Font* font, float ptSize, int hdpi, int vdpi}},
		{q{float}, q{TTF_GetFontSize}, q{TTF_Font* font}},
		{q{bool}, q{TTF_GetFontDPI}, q{TTF_Font* font, int* hdpi, int* vdpi}},
		{q{void}, q{TTF_SetFontStyle}, q{TTF_Font* font, TTF_FontStyleFlags_ style}},
		{q{TTF_FontStyleFlags}, q{TTF_GetFontStyle}, q{const(TTF_Font)* font}},
		{q{bool}, q{TTF_SetFontOutline}, q{TTF_Font* font, int outline}},
		{q{int}, q{TTF_GetFontOutline}, q{const(TTF_Font)* font}},
		{q{void}, q{TTF_SetFontHinting}, q{TTF_Font* font, TTF_HintingFlags hinting}},
		{q{int}, q{TTF_GetNumFontFaces}, q{const(TTF_Font)* font}},
		{q{TTF_HintingFlags}, q{TTF_GetFontHinting}, q{const(TTF_Font)* font}},
		{q{bool}, q{TTF_SetFontSDF}, q{TTF_Font* font, bool enabled}},
		{q{bool}, q{TTF_GetFontSDF}, q{const(TTF_Font)* font}},
		{q{void}, q{TTF_SetFontWrapAlignment}, q{TTF_Font* font, TTF_HorizontalAlignment align_}},
		{q{TTF_HorizontalAlignment}, q{TTF_GetFontWrapAlignment}, q{const(TTF_Font)* font}},
		{q{int}, q{TTF_GetFontHeight}, q{const(TTF_Font)* font}},
		{q{int}, q{TTF_GetFontAscent}, q{const(TTF_Font)* font}},
		{q{int}, q{TTF_GetFontDescent}, q{const(TTF_Font)* font}},
		{q{void}, q{TTF_SetFontLineSkip}, q{TTF_Font* font, int lineSkip}},
		{q{int}, q{TTF_GetFontLineSkip}, q{const(TTF_Font)* font}},
		{q{void}, q{TTF_SetFontKerning}, q{TTF_Font* font, bool enabled}},
		{q{bool}, q{TTF_GetFontKerning}, q{const(TTF_Font)* font}},
		{q{bool}, q{TTF_FontIsFixedWidth}, q{const(TTF_Font)* font}},
		{q{bool}, q{TTF_FontIsScalable}, q{const(TTF_Font)* font}},
		{q{const(char)*}, q{TTF_GetFontFamilyName}, q{const(TTF_Font)* font}},
		{q{const(char)*}, q{TTF_GetFontStyleName}, q{const(TTF_Font)* font}},
		{q{bool}, q{TTF_SetFontDirection}, q{TTF_Font* font, TTF_Direction direction}},
		{q{TTF_Direction}, q{TTF_GetFontDirection}, q{TTF_Font* font}},
		{q{uint}, q{TTF_StringToTag}, q{const(char)* string}},
		{q{void}, q{TTF_TagToString}, q{uint tag, char* string, size_t size}},
		{q{bool}, q{TTF_SetFontScript}, q{TTF_Font* font, uint script}},
		{q{uint}, q{TTF_GetFontScript}, q{TTF_Font* font}},
		{q{uint}, q{TTF_GetGlyphScript}, q{uint ch}},
		{q{bool}, q{TTF_SetFontLanguage}, q{TTF_Font* font, const(char)* languageBCP47}},
		{q{bool}, q{TTF_FontHasGlyph}, q{TTF_Font* font, uint ch}},
		{q{SDL_Surface*}, q{TTF_GetGlyphImage}, q{TTF_Font* font, uint ch, TTF_ImageType* imageType}},
		{q{SDL_Surface*}, q{TTF_GetGlyphImageForIndex}, q{TTF_Font* font, uint glyphIndex, TTF_ImageType* imageType}},
		{q{bool}, q{TTF_GetGlyphMetrics}, q{TTF_Font* font, uint ch, int* minX, int* maxX, int* minY, int* maxY, int* advance}},
		{q{bool}, q{TTF_GetGlyphKerning}, q{TTF_Font* font, uint previousCh, uint ch, int* kerning}},
		{q{bool}, q{TTF_GetStringSize}, q{TTF_Font* font, const(char)* text, size_t length, int* w, int* h}},
		{q{bool}, q{TTF_GetStringSizeWrapped}, q{TTF_Font* font, const(char)* text, size_t length, int wrapWidth, int* w, int* h}},
		{q{bool}, q{TTF_MeasureString}, q{TTF_Font* font, const(char)* text, size_t length, int maxWidth, int* measuredWidth, size_t* measuredLength}},
		{q{SDL_Surface*}, q{TTF_RenderText_Solid}, q{TTF_Font* font, const(char)* text, size_t length, SDL_Colour fg}},
		{q{SDL_Surface*}, q{TTF_RenderText_Solid_Wrapped}, q{TTF_Font* font, const(char)* text, size_t length, SDL_Colour fg, int wrapLength}},
		{q{SDL_Surface*}, q{TTF_RenderGlyph_Solid}, q{TTF_Font* font, uint ch, SDL_Colour fg}},
		{q{SDL_Surface*}, q{TTF_RenderText_Shaded}, q{TTF_Font* font, const(char)* text, size_t length, SDL_Colour fg, SDL_Colour bg}},
		{q{SDL_Surface*}, q{TTF_RenderText_Shaded_Wrapped}, q{TTF_Font* font, const(char)* text, size_t length, SDL_Colour fg, SDL_Colour bg, int wrapWidth}},
		{q{SDL_Surface*}, q{TTF_RenderGlyph_Shaded}, q{TTF_Font* font, uint ch, SDL_Colour fg, SDL_Colour bg}},
		{q{SDL_Surface*}, q{TTF_RenderText_Blended}, q{TTF_Font* font, const(char)* text, size_t length, SDL_Colour fg}},
		{q{SDL_Surface*}, q{TTF_RenderText_Blended_Wrapped}, q{TTF_Font* font, const(char)* text, size_t length, SDL_Colour fg, int wrapWidth}},
		{q{SDL_Surface*}, q{TTF_RenderGlyph_Blended}, q{TTF_Font* font, uint ch, SDL_Colour fg}},
		{q{SDL_Surface*}, q{TTF_RenderText_LCD}, q{TTF_Font* font, const(char)* text, size_t length, SDL_Colour fg, SDL_Colour bg}},
		{q{SDL_Surface*}, q{TTF_RenderText_LCD_Wrapped}, q{TTF_Font* font, const(char)* text, size_t length, SDL_Colour fg, SDL_Colour bg, int wrapWidth}},
		{q{SDL_Surface*}, q{TTF_RenderGlyph_LCD}, q{TTF_Font* font, uint ch, SDL_Colour fg, SDL_Colour bg}},
		{q{TTF_TextEngine*}, q{TTF_CreateSurfaceTextEngine}, q{}},
		{q{bool}, q{TTF_DrawSurfaceText}, q{TTF_Text* text, int x, int y, SDL_Surface* surface}},
		{q{void}, q{TTF_DestroySurfaceTextEngine}, q{TTF_TextEngine* engine}},
		{q{TTF_TextEngine*}, q{TTF_CreateRendererTextEngine}, q{SDL_Renderer* renderer}},
		{q{TTF_TextEngine*}, q{TTF_CreateRendererTextEngineWithProperties}, q{SDL_PropertiesID props}},
		{q{bool}, q{TTF_DrawRendererText}, q{TTF_Text* text, float x, float y}},
		{q{void}, q{TTF_DestroyRendererTextEngine}, q{TTF_TextEngine* engine}},
		{q{TTF_TextEngine*}, q{TTF_CreateGPUTextEngine}, q{SDL_GPUDevice* device}},
		{q{TTF_TextEngine*}, q{TTF_CreateGPUTextEngineWithProperties}, q{SDL_PropertiesID props}},
		{q{TTF_GPUAtlasDrawSequence*}, q{TTF_GetGPUTextDrawData}, q{TTF_Text* text}},
		{q{void}, q{TTF_DestroyGPUTextEngine}, q{TTF_TextEngine* engine}},
		{q{void}, q{TTF_SetGPUTextEngineWinding}, q{TTF_TextEngine* engine, TTF_GPUTextEngineWinding winding}},
		{q{TTF_GPUTextEngineWinding}, q{TTF_GetGPUTextEngineWinding}, q{const(TTF_TextEngine)* engine}},
		{q{TTF_Text*}, q{TTF_CreateText}, q{TTF_TextEngine* engine, TTF_Font* font, const(char)* text, size_t length}},
		{q{SDL_PropertiesID}, q{TTF_GetTextProperties}, q{TTF_Text* text}},
		{q{bool}, q{TTF_SetTextEngine}, q{TTF_Text* text, TTF_TextEngine* engine}},
		{q{TTF_TextEngine*}, q{TTF_GetTextEngine}, q{TTF_Text* text}},
		{q{bool}, q{TTF_SetTextFont}, q{TTF_Text* text, TTF_Font* font}},
		{q{TTF_Font*}, q{TTF_GetTextFont}, q{TTF_Text* text}},
		{q{bool}, q{TTF_SetTextDirection}, q{TTF_Text* text, TTF_Direction direction}},
		{q{TTF_Direction}, q{TTF_GetTextDirection}, q{TTF_Text* text}},
		{q{bool}, q{TTF_SetTextScript}, q{TTF_Text* text, uint script}},
		{q{uint}, q{TTF_GetTextScript}, q{TTF_Text* text}},
		{q{bool}, q{TTF_SetTextColor}, q{TTF_Text* text, ubyte r, ubyte g, ubyte b, ubyte a}},
		{q{bool}, q{TTF_SetTextColorFloat}, q{TTF_Text* text, float r, float g, float b, float a}},
		{q{bool}, q{TTF_GetTextColor}, q{TTF_Text* text, ubyte* r, ubyte* g, ubyte* b, ubyte* a}},
		{q{bool}, q{TTF_GetTextColorFloat}, q{TTF_Text* text, float* r, float* g, float* b, float* a}},
		{q{bool}, q{TTF_SetTextPosition}, q{TTF_Text* text, int x, int y}},
		{q{bool}, q{TTF_GetTextPosition}, q{TTF_Text* text, int* x, int* y}},
		{q{bool}, q{TTF_SetTextWrapWidth}, q{TTF_Text* text, int wrapWidth}},
		{q{bool}, q{TTF_GetTextWrapWidth}, q{TTF_Text* text, int* wrapWidth}},
		{q{bool}, q{TTF_SetTextWrapWhitespaceVisible}, q{TTF_Text* text, bool visible}},
		{q{bool}, q{TTF_TextWrapWhitespaceVisible}, q{TTF_Text* text}},
		{q{bool}, q{TTF_SetTextString}, q{TTF_Text* text, const(char)* string, size_t length}},
		{q{bool}, q{TTF_InsertTextString}, q{TTF_Text* text, int offset, const(char)* string, size_t length}},
		{q{bool}, q{TTF_AppendTextString}, q{TTF_Text* text, const(char)* string, size_t length}},
		{q{bool}, q{TTF_DeleteTextString}, q{TTF_Text* text, int offset, int length}},
		{q{bool}, q{TTF_GetTextSize}, q{TTF_Text* text, int* w, int* h}},
		{q{bool}, q{TTF_GetTextSubString}, q{TTF_Text* text, int offset, TTF_SubString* subString}},
		{q{bool}, q{TTF_GetTextSubStringForLine}, q{TTF_Text* text, int line, TTF_SubString* subString}},
		{q{TTF_SubString**}, q{TTF_GetTextSubStringsForRange}, q{TTF_Text* text, int offset, int length, int* count}},
		{q{bool}, q{TTF_GetTextSubStringForPoint}, q{TTF_Text* text, int x, int y, TTF_SubString* subString}},
		{q{bool}, q{TTF_GetPreviousTextSubString}, q{TTF_Text* text, const(TTF_SubString)* subString, TTF_SubString* previous}},
		{q{bool}, q{TTF_GetNextTextSubString}, q{TTF_Text* text, const(TTF_SubString)* subString, TTF_SubString* next}},
		{q{bool}, q{TTF_UpdateText}, q{TTF_Text* text}},
		{q{void}, q{TTF_DestroyText}, q{TTF_Text* text}},
		{q{void}, q{TTF_CloseFont}, q{TTF_Font* font}},
		{q{void}, q{TTF_Quit}, q{}},
		{q{int}, q{TTF_WasInit}, q{}},
	];
	if(sdlTTFVersion >= Version(3,2,2)){
		FnBind[] add = [
			{q{int}, q{TTF_GetFontWeight}, q{const(TTF_Font)* font}},
		];
		ret ~= add;
	}
	return ret;
}()));

static if(!staticBinding):
import bindbc.loader;

mixin(makeDynloadFns("SDLTTF", makeLibPaths(["SDL3_ttf"]), [__MODULE__]));
