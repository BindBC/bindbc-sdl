/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.rwops;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

version(WebAssembly){
}else import core.stdc.stdio: FILE;
import sdl.stdinc: SDL_bool;

enum: uint{
	SDL_RWOPS_UNKNOWN    = 0U,
	SDL_RWOPS_WINFILE    = 1U,
	SDL_RWOPS_STDFILE    = 2U,
	SDL_RWOPS_JNIFILE    = 3U,
	SDL_RWOPS_MEMORY     = 4U,
	SDL_RWOPS_MEMORY_RO  = 5U,
}

struct SDL_RWops{
	extern(C) @nogc nothrow{
		long function(SDL_RWops*) size;
		long function(SDL_RWops*, long, int) seek;
		size_t function(SDL_RWops*, void*, size_t, size_t) read;
		size_t function(SDL_RWops*, const(void)*, size_t, size_t) write;
		int function(SDL_RWops*) close;
	}
	uint type;
	union Hidden_{
		version(Android){
			struct AndroidIO_{
				void* asset;
			}
			AndroidIO_ androidio;
		}else static if((){
			version(Windows)      return true;
			else version(WinGDK)  return true;
			else return false;
		}()){
			struct WindowsIO_{
				SDL_bool append;
				void* h;
				struct Buffer_{
					void* data;
					size_t size;
					size_t left;
				}
				Buffer_ buffer;
			}
			WindowsIO_ windowsio;
		}
		
		version(WebAssembly){
		}else{
			struct StdIO_{
				int autoclose;
				FILE* fp;
			}
			StdIO_ stdio;
		}
		
		struct Mem_{
			ubyte* base;
			ubyte* here;
			ubyte* stop;
		}
		Mem_ mem;
		
		struct Unknown_{
			void* data1;
			void* data2;
		}
		Unknown_ unknown;
	}
	Hidden_ hidden;
}

enum{
	RW_SEEK_SET = 0,
	RW_SEEK_CUR = 1,
	RW_SEEK_END = 2,
}

pragma(inline, true) @nogc nothrow{
	static if(sdlSupport < SDLSupport.v2_0_10){
		long SDL_RWsize(SDL_RWops* ctx){ return ctx.size(ctx); }
		long SDL_RWseek(SDL_RWops* ctx, long offset, int whence){ return ctx.seek(ctx, offset, whence); }
		long SDL_RWtell(SDL_RWops* ctx){ return ctx.seek(ctx, 0, RW_SEEK_CUR); }
		size_t SDL_RWread(SDL_RWops* ctx, void* ptr, size_t size, size_t n){ return ctx.read(ctx, ptr, size, n); }
		size_t SDL_RWwrite(SDL_RWops* ctx, const(void)* ptr, size_t size, size_t n){ return ctx.write(ctx, ptr, size, n); }
		int SDL_RWclose(SDL_RWops* ctx){ return ctx.close(ctx); }
	}
	static if(sdlSupport >= SDLSupport.v2_0_6){
		void* SDL_LoadFile(const(char)* filename, size_t datasize){
			return SDL_LoadFile_RW(SDL_RWFromFile(filename, "rb"), datasize, 1);
		}
	}
}

mixin(joinFnBinds((){
	string[][] ret;
	ret ~= makeFnBinds([
		[q{SDL_RWops*}, q{SDL_RWFromFile}, q{const(char)* file, const(char)* mode}],
		[q{SDL_RWops*}, q{SDL_RWFromMem}, q{void* mem, int size}],
		[q{SDL_RWops*}, q{SDL_RWFromConstMem}, q{const(void)* mem, int size}],
		[q{SDL_RWops*}, q{SDL_AllocRW}, q{}],
		[q{void}, q{SDL_FreeRW}, q{SDL_RWops* context}],
		[q{ubyte}, q{SDL_ReadU8}, q{SDL_RWops* context}],
		[q{ushort}, q{SDL_ReadLE16}, q{SDL_RWops* context}],
		[q{ushort}, q{SDL_ReadBE16}, q{SDL_RWops* context}],
		[q{uint}, q{SDL_ReadLE32}, q{SDL_RWops* context}],
		[q{uint}, q{SDL_ReadBE32}, q{SDL_RWops* context}],
		[q{ulong}, q{SDL_ReadLE64}, q{SDL_RWops* context}],
		[q{ulong}, q{SDL_ReadBE64}, q{SDL_RWops* context}],
		[q{size_t}, q{SDL_WriteU8}, q{SDL_RWops* context, ubyte value}],
		[q{size_t}, q{SDL_WriteLE16}, q{SDL_RWops* context, ushort value}],
		[q{size_t}, q{SDL_WriteBE16}, q{SDL_RWops* context, ushort value}],
		[q{size_t}, q{SDL_WriteLE32}, q{SDL_RWops* context, uint value}],
		[q{size_t}, q{SDL_WriteBE32}, q{SDL_RWops* context, uint value}],
		[q{size_t}, q{SDL_WriteLE64}, q{SDL_RWops* context, ulong value}],
		[q{size_t}, q{SDL_WriteBE64}, q{SDL_RWops* context, ulong value}],
	]);
	version(WebAssembly){
	}else{
		ret ~= makeFnBinds([
			[q{SDL_RWops*}, q{SDL_RWFromFP}, q{FILE* ffp, SDL_bool autoclose}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_6){
		ret ~= makeFnBinds([
			[q{void*}, q{SDL_LoadFile_RW}, q{SDL_RWops* context, size_t datasize, int freesrc}],
		]);
	}
	static if(sdlSupport >= SDLSupport.v2_0_10){
		ret ~= makeFnBinds([
			[q{long}, q{SDL_RWsize}, q{SDL_RWops* context}],
			[q{long}, q{SDL_RWseek}, q{SDL_RWops* context, long offset, int whence}],
			[q{long}, q{SDL_RWtell}, q{SDL_RWops* context}],
			[q{size_t}, q{SDL_RWread}, q{SDL_RWops* context, void* ptr, size_t size, size_t maxnum}],
			[q{size_t}, q{SDL_RWwrite}, q{SDL_RWops* context, const(void)* ptr, size_t size, size_t num}],
			[q{int}, q{SDL_RWclose}, q{SDL_RWops* context}],
		]);
	}
	return ret;
}()));
