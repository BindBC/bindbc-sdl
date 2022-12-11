/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module bindbc.sdl.bind.sdlblendmode;

import bindbc.sdl.config;

// SDL_BlendMode
alias SDL_BlendMode = int;
enum: SDL_BlendMode{
	SDL_BLENDMODE_NONE     = 0x00000000,
	SDL_BLENDMODE_BLEND    = 0x00000001,
	SDL_BLENDMODE_ADD      = 0x00000002,
	SDL_BLENDMODE_MOD      = 0x00000004,
}
static if(sdlSupport >= SDLSupport.sdl206)
enum: SDL_BlendMode{
	SDL_BLENDMODE_INVALID  = 0x7FFFFFFF,
};
static if(sdlSupport >= SDLSupport.sdl2012)
enum: SDL_BlendMode{
	SDL_BLENDMODE_MUL      = 0x00000008,
};

static if(sdlSupport >= SDLSupport.sdl206){
	alias SDL_BlendOperation = int;
	enum: SDL_BlendOperation{
		SDL_BLENDOPERATION_ADD           = 0x1,
		SDL_BLENDOPERATION_SUBTRACT      = 0x2,
		SDL_BLENDOPERATION_REV_SUBTRACT  = 0x3,
		SDL_BLENDOPERATION_MINIMUM       = 0x4,
		SDL_BLENDOPERATION_MAXIMUM       = 0x5,
	}
	
	alias SDL_BlendFactor = int;
	enum: SDL_BlendFactor{
		SDL_BLENDFACTOR_ZERO                 = 0x1,
		SDL_BLENDFACTOR_ONE                  = 0x2,
		SDL_BLENDFACTOR_SRC_COLOR            = 0x3,
		SDL_BLENDFACTOR_ONE_MINUS_SRC_COLOR  = 0x4,
		SDL_BLENDFACTOR_SRC_ALPHA            = 0x5,
		SDL_BLENDFACTOR_ONE_MINUS_SRC_ALPHA  = 0x6,
		SDL_BLENDFACTOR_DST_COLOR            = 0x7,
		SDL_BLENDFACTOR_ONE_MINUS_DST_COLOR  = 0x8,
		SDL_BLENDFACTOR_DST_ALPHA            = 0x9,
		SDL_BLENDFACTOR_ONE_MINUS_DST_ALPHA  = 0xA,
	}
}

mixin(joinFnBinds((){
	string[][] ret;
	static if(sdlSupport >= SDLSupport.sdl206){
		ret ~= makeFnBinds([
			[q{SDL_BlendMode}, q{SDL_ComposeCustomBlendMode}, q{SDL_BlendFactor srcColorFactor, SDL_BlendFactor dstColorFactor, SDL_BlendOperation colorOperation, SDL_BlendFactor srcAlphaFactor, SDL_BlendFactor dstAlphaFactor, SDL_BlendOperation alphaOperation}],
		]);
	}
	return ret;
}()));
