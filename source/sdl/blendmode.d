/+
+            Copyright 2022 – 2024 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.blendmode;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

// SDL_BlendMode
alias SDL_BlendMode = uint;
enum: SDL_BlendMode{
	SDL_BLENDMODE_NONE     = 0x00000000,
	SDL_BLENDMODE_BLEND    = 0x00000001,
	SDL_BLENDMODE_ADD      = 0x00000002,
	SDL_BLENDMODE_MOD      = 0x00000004,
}
static if(sdlSupport >= SDLSupport.v2_0_6)
enum: SDL_BlendMode{
	SDL_BLENDMODE_INVALID  = 0x7FFFFFFF,
}
static if(sdlSupport >= SDLSupport.v2_0_12)
enum: SDL_BlendMode{
	SDL_BLENDMODE_MUL      = 0x00000008,
}

static if(sdlSupport >= SDLSupport.v2_0_6){
	alias SDL_BlendOperation = uint;
	enum: SDL_BlendOperation{
		SDL_BLENDOPERATION_ADD           = 0x1,
		SDL_BLENDOPERATION_SUBTRACT      = 0x2,
		SDL_BLENDOPERATION_REV_SUBTRACT  = 0x3,
		SDL_BLENDOPERATION_MINIMUM       = 0x4,
		SDL_BLENDOPERATION_MAXIMUM       = 0x5,
	}
	
	alias SDL_BlendFactor = uint;
	enum: SDL_BlendFactor{
		SDL_BLENDFACTOR_ZERO                 = 0x1,
		SDL_BLENDFACTOR_ONE                  = 0x2,
		SDL_BLENDFACTOR_SRC_COLOR            = 0x3,
		SDL_BLENDFACTOR_SRC_COLOUR           = SDL_BLENDFACTOR_SRC_COLOR,
		SDL_BLENDFACTOR_ONE_MINUS_SRC_COLOR  = 0x4,
		SDL_BLENDFACTOR_ONE_MINUS_SRC_COLOUR = SDL_BLENDFACTOR_ONE_MINUS_SRC_COLOR,
		SDL_BLENDFACTOR_SRC_ALPHA            = 0x5,
		SDL_BLENDFACTOR_ONE_MINUS_SRC_ALPHA  = 0x6,
		SDL_BLENDFACTOR_DST_COLOR            = 0x7,
		SDL_BLENDFACTOR_DST_COLOUR           = SDL_BLENDFACTOR_DST_COLOR,
		SDL_BLENDFACTOR_ONE_MINUS_DST_COLOR  = 0x8,
		SDL_BLENDFACTOR_ONE_MINUS_DST_COLOUR = SDL_BLENDFACTOR_ONE_MINUS_DST_COLOR,
		SDL_BLENDFACTOR_DST_ALPHA            = 0x9,
		SDL_BLENDFACTOR_ONE_MINUS_DST_ALPHA  = 0xA,
	}
}

mixin(joinFnBinds((){
	FnBind[] ret;
	if(sdlSupport >= SDLSupport.v2_0_6){
		FnBind[] add = [
			{q{SDL_BlendMode}, q{SDL_ComposeCustomBlendMode}, q{SDL_BlendFactor srcColourFactor, SDL_BlendFactor dstColourFactor, SDL_BlendOperation colourOperation, SDL_BlendFactor srcAlphaFactor, SDL_BlendFactor dstAlphaFactor, SDL_BlendOperation alphaOperation}},
		];
		ret ~= add;
	}
	return ret;
}()));
