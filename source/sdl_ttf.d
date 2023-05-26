/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl_ttf;

import bindbc.sdl.config;
static if(bindSDLTTF):
import bindbc.sdl.codegen;

import sdl.error: SDL_GetError, SDL_SetError;
import sdl.pixels: SDL_Color;
import sdl.rwops: SDL_RWops;
import sdl.surface: SDL_Surface;
import sdl.version_: SDL_version;
import sdl.stdinc: SDL_bool;

enum SDLTTFSupport: SDL_version{
	noLibrary   = SDL_version(0,0,0),
	badLibrary  = SDL_version(0,0,255),
	v2_0_12     = SDL_version(2,0,12),
	v2_0_13     = SDL_version(2,0,13),
	v2_0_14     = SDL_version(2,0,14),
	v2_0_15     = SDL_version(2,0,15),
	v2_0_18     = SDL_version(2,0,18),
	v2_20       = SDL_version(2,20,0),
	
	deprecated("Please use `v2_0_12` instead") sdlTTF2012 = SDL_version(2,0,12),
	deprecated("Please use `v2_0_13` instead") sdlTTF2013 = SDL_version(2,0,13),
	deprecated("Please use `v2_0_14` instead") sdlTTF2014 = SDL_version(2,0,14),
	deprecated("Please use `v2_0_15` instead") sdlTTF2015 = SDL_version(2,0,15),
	deprecated("Please use `v2_0_18` instead") sdlTTF2018 = SDL_version(2,0,18),
}

enum sdlTTFSupport = (){
	version(SDL_TTF_2_20)      return SDLTTFSupport.v2_20;
	else version(SDL_TTF_2018) return SDLTTFSupport.v2_0_18;
	else version(SDL_TTF_2015) return SDLTTFSupport.v2_0_15;
	else version(SDL_TTF_2014) return SDLTTFSupport.v2_0_14;
	else version(SDL_TTF_2013) return SDLTTFSupport.v2_0_13;
	else                       return SDLTTFSupport.v2_0_12;
}();

enum SDL_TTF_MAJOR_VERSION = sdlTTFSupport.major;
enum SDL_TTF_MINOR_VERSION = sdlTTFSupport.minor;
enum SDL_TTF_PATCHLEVEL    = sdlTTFSupport.patch;

pragma(inline, true) void SDL_TTF_VERSION(SDL_version* X) @nogc nothrow pure @safe{
	X.major = SDL_TTF_MAJOR_VERSION;
	X.minor = SDL_TTF_MINOR_VERSION;
	X.patch = SDL_TTF_PATCHLEVEL;
}

deprecated("Please use `SDL_TTF_MAJOR_VERSION` instead") alias TTF_MAJOR_VERSION = SDL_TTF_MAJOR_VERSION;
deprecated("Please use `SDL_TTF_MINOR_VERSION` instead") alias TTF_MINOR_VERSION = SDL_TTF_MINOR_VERSION;
deprecated("Please use `SDL_TTF_PATCHLEVEL` instead")    alias TTF_PATCHLEVEL    = SDL_TTF_PATCHLEVEL;
deprecated("Please use `SDL_TTF_VERSION` instead")       alias TTF_VERSION       = SDL_TTF_VERSION;

bool SDL_TTF_VERSION_ATLEAST(ubyte X, ubyte Y, ubyte Z){ return SDL_version(SDL_TTF_MAJOR_VERSION, SDL_TTF_MINOR_VERSION, SDL_TTF_PATCHLEVEL) >= SDL_version(X, Y, Z); }

enum{
	UNICODE_BOM_NATIVE   = 0xFEFF,
	UNICODE_BOM_SWAPPED  = 0xFFFE,
}

struct TTF_Font;

enum{
	TTF_STYLE_NORMAL         = 0x00,
	TTF_STYLE_BOLD           = 0x01,
	TTF_STYLE_ITALIC         = 0x02,
	TTF_STYLE_UNDERLINE      = 0x04,
	TTF_STYLE_STRIKETHROUGH  = 0x08,
}

enum{
	TTF_HINTING_NORMAL          = 0,
	TTF_HINTING_LIGHT           = 1,
	TTF_HINTING_MONO            = 2,
	TTF_HINTING_NONE            = 3,
}
static if(sdlTTFSupport >= SDLTTFSupport.v2_0_18)
enum{
	TTF_HINTING_LIGHT_SUBPIXEL  = 4,
}

static if(sdlTTFSupport >= SDLTTFSupport.v2_20){
	enum{
		TTF_WRAPPED_ALIGN_LEFT    = 0,
		TTF_WRAPPED_ALIGN_CENTER  = 1,
		TTF_WRAPPED_ALIGN_RIGHT   = 2,
	}
}

alias TTF_SetError = SDL_SetError;

alias TTF_GetError = SDL_GetError;

alias TTF_Direction = int;
enum: TTF_Direction{
	TTF_DIRECTION_LTR  = 0, /* Left to Right */
	TTF_DIRECTION_RTL  = 1, /* Right to Left */
	TTF_DIRECTION_TTB  = 2, /* Top to Bottom */
	TTF_DIRECTION_BTT  = 3, /* Bottom to Top */
};

mixin(joinFnBinds((){
	string[][] ret;
	ret ~= makeFnBinds([
		[q{SDL_version*}, q{TTF_Linked_Version}, q{}],
		[q{void}, q{TTF_ByteSwappedUNICODE}, q{int swapped}],
		[q{int}, q{TTF_Init}, q{}],
		[q{TTF_Font*}, q{TTF_OpenFont}, q{const(char)* file, int ptsize}],
		[q{TTF_Font*}, q{TTF_OpenFontIndex}, q{const(char)* file, int ptsize, c_long index}],
		[q{TTF_Font*}, q{TTF_OpenFontRW}, q{SDL_RWops* src, int freesrc, int ptsize}],
		[q{TTF_Font*}, q{TTF_OpenFontIndexRW}, q{SDL_RWops* src, int freesrc, int ptsize, c_long index}],
		[q{int}, q{TTF_GetFontStyle}, q{const(TTF_Font)* font}],
		[q{void}, q{TTF_SetFontStyle}, q{const(TTF_Font)* font ,int style}],
		[q{int}, q{TTF_GetFontOutline}, q{const(TTF_Font)* font}],
		[q{void}, q{TTF_SetFontOutline}, q{TTF_Font* font, int outline}],
		[q{int}, q{TTF_GetFontHinting}, q{const(TTF_Font)* font}],
		[q{void}, q{TTF_SetFontHinting}, q{TTF_Font* font, int hinting}],
		[q{int}, q{TTF_FontHeight}, q{const(TTF_Font)* font}],
		[q{int}, q{TTF_FontAscent}, q{const(TTF_Font)* font}],
		[q{int}, q{TTF_FontDescent}, q{const(TTF_Font)* font}],
		[q{int}, q{TTF_FontLineSkip}, q{const(TTF_Font)* font}],
		[q{int}, q{TTF_GetFontKerning}, q{const(TTF_Font)* font}],
		[q{void}, q{TTF_SetFontKerning}, q{TTF_Font* font, int allowed}],
		[q{int}, q{TTF_FontFaces}, q{const(TTF_Font)* font}],
		[q{int}, q{TTF_FontFaceIsFixedWidth}, q{const(TTF_Font)* font}],
		[q{char*}, q{TTF_FontFaceFamilyName}, q{const(TTF_Font)* font}],
		[q{char*}, q{TTF_FontFaceStyleName}, q{const(TTF_Font)* font}],
		[q{int}, q{TTF_GlyphIsProvided}, q{const(TTF_Font)* font, ushort ch}],
		[q{int}, q{TTF_GlyphMetrics}, q{TTF_Font* font, ushort ch, int* minx, int* maxx, int* miny, int* maxy, int* advance}],
		[q{int}, q{TTF_SizeText}, q{TTF_Font* font, const(char)* text, int* w, int* h}],
		[q{int}, q{TTF_SizeUTF8}, q{TTF_Font* font, const(char)* text, int* w, int* h}],
		[q{int}, q{TTF_SizeUNICODE}, q{TTF_Font* font, const(ushort)* text, int* w, int* h}],
		[q{SDL_Surface*}, q{TTF_RenderText_Solid}, q{TTF_Font* font, const(char)* text, SDL_Color fg}],
		[q{SDL_Surface*}, q{TTF_RenderUTF8_Solid}, q{TTF_Font* font, const(char)* text, SDL_Color fg}],
		[q{SDL_Surface*}, q{TTF_RenderUNICODE_Solid}, q{TTF_Font* font, const(ushort)* text, SDL_Color fg}],
		[q{SDL_Surface*}, q{TTF_RenderGlyph_Solid}, q{TTF_Font* font, ushort ch, SDL_Color fg}],
		[q{SDL_Surface*}, q{TTF_RenderText_Shaded}, q{TTF_Font* font, const(char)* text, SDL_Color fg, SDL_Color bg}],
		[q{SDL_Surface*}, q{TTF_RenderUTF8_Shaded}, q{TTF_Font* font, const(char)* text, SDL_Color fg, SDL_Color bg}],
		[q{SDL_Surface*}, q{TTF_RenderUNICODE_Shaded}, q{TTF_Font* font, const(ushort)* text, SDL_Color fg, SDL_Color bg}],
		[q{SDL_Surface*}, q{TTF_RenderGlyph_Shaded}, q{TTF_Font* font, ushort ch, SDL_Color fg,SDL_Color bg}],
		[q{SDL_Surface*}, q{TTF_RenderText_Blended}, q{TTF_Font* font, const(char)* text, SDL_Color fg}],
		[q{SDL_Surface*}, q{TTF_RenderUTF8_Blended}, q{TTF_Font* font, const(char)* text, SDL_Color fg}],
		[q{SDL_Surface*}, q{TTF_RenderUNICODE_Blended}, q{TTF_Font* font, const(ushort)* text, SDL_Color fg}],
		[q{SDL_Surface*}, q{TTF_RenderText_Blended_Wrapped}, q{TTF_Font* font, const(char)* text, SDL_Color fg, uint wrapLength}],
		[q{SDL_Surface*}, q{TTF_RenderUTF8_Blended_Wrapped}, q{TTF_Font* font, const(char)* text,SDL_Color fg, uint wrapLength}],
		[q{SDL_Surface*}, q{TTF_RenderUNICODE_Blended_Wrapped}, q{TTF_Font* font, const(ushort)* text, SDL_Color fg, uint wrapLength}],
		[q{SDL_Surface*}, q{TTF_RenderGlyph_Blended}, q{TTF_Font* font, ushort ch, SDL_Color fg}],
		[q{void}, q{TTF_CloseFont}, q{TTF_Font* font}],
		[q{void}, q{TTF_Quit}, q{}],
		[q{int}, q{TTF_WasInit}, q{}],
		[q{int}, q{TTF_GetFontKerningSize}, q{TTF_Font* font, int prev_index, int index}], //NOTE: deprecated
	]);
	static if(sdlTTFSupport >= SDLTTFSupport.v2_0_14){
		ret ~= makeFnBinds([
			[q{int}, q{TTF_GetFontKerningSizeGlyphs}, q{TTF_Font* font, ushort previous_ch, ushort ch}],
		]);
	}
	static if(sdlTTFSupport >= SDLTTFSupport.v2_0_18){
		ret ~= makeFnBinds([
			[q{void}, q{TTF_GetFreeTypeVersion}, q{int* major, int* minor, int* patch}],
			[q{void}, q{TTF_GetHarfBuzzVersion}, q{int* major, int* minor, int* patch}],
			[q{int}, q{TTF_SetFontSDF}, q{TTF_Font* font, SDL_bool on_off}],
			[q{SDL_bool}, q{TTF_GetFontSDF}, q{const(TTF_Font)* font}],
			[q{TTF_Font*}, q{TTF_OpenFontDPI}, q{const(char)* file, int ptsize, uint hdpi, uint vdpi}],
			[q{TTF_Font*}, q{TTF_OpenFontIndexDPI}, q{const(char)*file, int ptsize, long index, uint hdpi, uint vdpi}],
			[q{TTF_Font*}, q{TTF_OpenFontDPIRW}, q{SDL_RWops* src, int freesrc, int ptsize, uint hdpi, uint vdpi}],
			[q{TTF_Font*}, q{TTF_OpenFontIndexDPIRW}, q{SDL_RWops* src, int freesrc, int ptsize, long index, uint hdpi, uint vdpi}],
			[q{int}, q{TTF_SetFontSizeDPI}, q{TTF_Font* font, int ptsize, uint hdpi, uint vdpi}],
			[q{int}, q{TTF_GlyphIsProvided32}, q{TTF_Font* font, uint ch}],
			[q{int}, q{TTF_GlyphMetrics32}, q{TTF_Font* font, uint ch, int* minx, int* maxx, int* miny, int* maxy, int* advance}],
			[q{SDL_Surface*}, q{TTF_RenderGlyph32_Solid}, q{TTF_Font* font, uint ch, SDL_Color fg}],
			[q{SDL_Surface*}, q{TTF_RenderGlyph32_Shaded}, q{TTF_Font* font, uint ch, SDL_Color fg, SDL_Color bg}],
			[q{SDL_Surface*}, q{TTF_RenderGlyph32_Blended}, q{TTF_Font* font, uint ch, SDL_Color fg}],
			[q{int}, q{TTF_GetFontKerningSizeGlyphs32}, q{TTF_Font* font, uint previous_ch, uint ch}],
			[q{int}, q{TTF_SetDirection}, q{int direction}], //NOTE: deprecated
			[q{int}, q{TTF_SetScript}, q{int script}], //NOTE: deprecated
			[q{int}, q{TTF_MeasureText}, q{TTF_Font* font, const(char)* text, int measure_width, int* extent, int* count}],
			[q{int}, q{TTF_MeasureUTF8}, q{TTF_Font* font, const(char)* text, int measure_width, int* extent, int* count}],
			[q{int}, q{TTF_MeasureUNICODE}, q{TTF_Font* font, const(ushort)* text, int measure_width, int* extent, int* count}],
			[q{int}, q{TTF_SetFontSize}, q{TTF_Font* font, int ptsize}],
			[q{SDL_Surface*}, q{TTF_RenderText_Solid_Wrapped}, q{TTF_Font* font, const(char)* text, SDL_Color fg, uint wrapLength}],
			[q{SDL_Surface*}, q{TTF_RenderUTF8_Solid_Wrapped}, q{TTF_Font* font, const(char)* text, SDL_Color fg, uint wrapLength}],
			[q{SDL_Surface*}, q{TTF_RenderUNICODE_Solid_Wrapped}, q{TTF_Font* font, const(ushort)* text, SDL_Color fg, uint wrapLength}],
			[q{SDL_Surface*}, q{TTF_RenderText_Shaded_Wrapped}, q{TTF_Font* font, const(char)* text, SDL_Color fg, SDL_Color bg, uint wrapLength}],
			[q{SDL_Surface*}, q{TTF_RenderUTF8_Shaded_Wrapped}, q{TTF_Font* font, const(char)* text, SDL_Color fg, SDL_Color bg, uint wrapLength}],
			[q{SDL_Surface*}, q{TTF_RenderUNICODE_Shaded_Wrapped}, q{TTF_Font* font, const(ushort)* text, SDL_Color fg, SDL_Color bg, uint wrapLength}],
		]);
	}
	static if(sdlTTFSupport >= SDLTTFSupport.v2_20){
		ret ~= makeFnBinds([
			[q{int}, q{TTF_GetFontWrappedAlign}, q{const(TTF_Font)* font}],
			[q{void}, q{TTF_SetFontWrappedAlign}, q{TTF_Font* font, int align_}],
			[q{SDL_Surface*}, q{TTF_RenderText_LCD}, q{TTF_Font* font, const(char)* text, SDL_Color fg, SDL_Color bg}],
			[q{SDL_Surface*}, q{TTF_RenderUTF8_LCD}, q{TTF_Font* font, const(char)* text, SDL_Color fg, SDL_Color bg}],
			[q{SDL_Surface*}, q{TTF_RenderUNICODE_LCD}, q{TTF_Font* font, const(ushort)* text, SDL_Color fg, SDL_Color bg}],
			[q{SDL_Surface*}, q{TTF_RenderText_LCD_Wrapped}, q{TTF_Font* font, const(char)* text, SDL_Color fg, SDL_Color bg, uint wrapLength}],
			[q{SDL_Surface*}, q{TTF_RenderUTF8_LCD_Wrapped}, q{TTF_Font* font, const(char)* text, SDL_Color fg, SDL_Color bg, uint wrapLength}],
			[q{SDL_Surface*}, q{TTF_RenderUNICODE_LCD_Wrapped}, q{TTF_Font* font, const(ushort)* text, SDL_Color fg, SDL_Color bg, uint wrapLength}],
			[q{SDL_Surface*}, q{TTF_RenderGlyph_LCD}, q{TTF_Font* font, ushort ch, SDL_Color fg, SDL_Color bg}],
			[q{SDL_Surface*}, q{TTF_RenderGlyph32_LCD}, q{TTF_Font* font, uint ch, SDL_Color fg, SDL_Color bg}],
			[q{int}, q{TTF_SetFontDirection}, q{TTF_Font* font, TTF_Direction direction}],
			[q{int}, q{TTF_SetFontScriptName}, q{TTF_Font* font, const(char)* script}],
		]);
	}
	return ret;
}()));

static if(!staticBinding):
import bindbc.loader;

private{
	SharedLib lib;
	SDLTTFSupport loadedVersion;
	enum libNamesCT = (){
		version(Windows){
			return [
				`SDL2_ttf.dll`,
			];
		}else version(OSX){
			return [
				`libSDL2_ttf.dylib`,
				`/opt/homebrew/lib/libSDL2_ttf.dylib`,
				`SDL2_ttf`,
				`/Library/Frameworks/SDL2_ttf.framework/SDL2_ttf`,
				`/System/Library/Frameworks/SDL2_ttf.framework/SDL2_ttf`,
			];
		}else version(Posix){
			return [
				`libSDL2_ttf.so`,
				`libSDL2-2.0_ttf.so`,
				`libSDL2-2.0_ttf.so.0`,
			];
		}else static assert(0, "BindBC-SDL_ttf does not have library search paths set up for this platform");
	}();
}

@nogc nothrow:
deprecated("Please use `TTF_Linked_Version` instead")
	SDLTTFSupport loadedSDLTTFVersion(){ return loadedVersion; }

mixin(bindbc.sdl.codegen.makeDynloadFns("TTF", [__MODULE__]));
