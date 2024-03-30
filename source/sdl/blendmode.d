/+
+            Copyright 2024 – 2025 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.blendmode;

import bindbc.sdl.config, bindbc.sdl.codegen;

alias SDL_BlendMode_ = uint;
mixin(makeEnumBind(q{SDL_BlendMode}, q{SDL_BlendMode_}, members: (){
	EnumMember[] ret = [
		{{q{none},                  q{SDL_BLENDMODE_NONE}},                   q{0x00000000U}},
		{{q{blend},                 q{SDL_BLENDMODE_BLEND}},                  q{0x00000001U}},
		{{q{blendPreMultiplied},    q{SDL_BLENDMODE_BLEND_PREMULTIPLIED}},    q{0x00000010U}},
		{{q{add},                   q{SDL_BLENDMODE_ADD}},                    q{0x00000002U}},
		{{q{addPreMultiplied},      q{SDL_BLENDMODE_ADD_PREMULTIPLIED}},      q{0x00000020U}},
		{{q{mod},                   q{SDL_BLENDMODE_MOD}},                    q{0x00000004U}},
		{{q{mul},                   q{SDL_BLENDMODE_MUL}},                    q{0x00000008U}},
		{{q{invalid},               q{SDL_BLENDMODE_INVALID}},                q{0x7FFFFFFFU}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_BlendOperation}, members: (){
	EnumMember[] ret = [
		{{q{add},          q{SDL_BLENDOPERATION_ADD}},           q{0x1}},
		{{q{subtract},     q{SDL_BLENDOPERATION_SUBTRACT}},      q{0x2}},
		{{q{revSubtract},  q{SDL_BLENDOPERATION_REV_SUBTRACT}},  q{0x3}},
		{{q{minimum},      q{SDL_BLENDOPERATION_MINIMUM}},       q{0x4}},
		{{q{maximum},      q{SDL_BLENDOPERATION_MAXIMUM}},       q{0x5}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_BlendFactor}, members: (){
	EnumMember[] ret = [
		{{q{zero},                 q{SDL_BLENDFACTOR_ZERO}},                   q{0x1}},
		{{q{one},                  q{SDL_BLENDFACTOR_ONE}},                    q{0x2}},
		{{q{srcColour},            q{SDL_BLENDFACTOR_SRC_COLOUR}},             q{0x3}, aliases: [{q{srcColor}, q{SDL_BLENDFACTOR_SRC_COLOR}}]},
		{{q{oneMinusSrcColour},    q{SDL_BLENDFACTOR_ONE_MINUS_SRC_COLOUR}},   q{0x4}, aliases: [{q{oneMinusSrcColor}, q{SDL_BLENDFACTOR_ONE_MINUS_SRC_COLOR}}]},
		{{q{srcAlpha},             q{SDL_BLENDFACTOR_SRC_ALPHA}},              q{0x5}},
		{{q{oneMinusSrcAlpha},     q{SDL_BLENDFACTOR_ONE_MINUS_SRC_ALPHA}},    q{0x6}},
		{{q{dstColour},            q{SDL_BLENDFACTOR_DST_COLOUR}},             q{0x7}, aliases: [{q{dstColor}, q{SDL_BLENDFACTOR_DST_COLOR}}]},
		{{q{oneMinusDstColour},    q{SDL_BLENDFACTOR_ONE_MINUS_DST_COLOUR}},   q{0x8}, aliases: [{q{oneMinusDstColor}, q{SDL_BLENDFACTOR_ONE_MINUS_DST_COLOR}}]},
		{{q{dstAlpha},             q{SDL_BLENDFACTOR_DST_ALPHA}},              q{0x9}},
		{{q{oneMinusDstAlpha},     q{SDL_BLENDFACTOR_ONE_MINUS_DST_ALPHA}},    q{0xA}},
	];
	return ret;
}()));

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{SDL_BlendMode}, q{SDL_ComposeCustomBlendMode}, q{SDL_BlendFactor srcColourFactor, SDL_BlendFactor dstColourFactor, SDL_BlendOperation colourOperation, SDL_BlendFactor srcAlphaFactor, SDL_BlendFactor dstAlphaFactor, SDL_BlendOperation alphaOperation}},
	];
	return ret;
}()));
