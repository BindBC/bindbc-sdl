/+
+            Copyright 2022 – 2024 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.audio;

import bindbc.sdl.config;
import bindbc.sdl.codegen;

import sdl.rwops;

enum: ushort{
	SDL_AUDIO_MASK_BITSIZE   = 0xFF,
	SDL_AUDIO_MASK_DATATYPE  = 1<<8,
	SDL_AUDIO_MASK_ENDIAN    = 1<<12,
	SDL_AUDIO_MASK_SIGNED    = 1<<15,
}

pragma(inline, true) nothrow @nogc pure @safe{
	SDL_AudioFormat SDL_AUDIO_BITSIZE(SDL_AudioFormat x){ return cast(SDL_AudioFormat)(x & SDL_AUDIO_MASK_BITSIZE); }
	SDL_AudioFormat SDL_AUDIO_ISFLOAT(SDL_AudioFormat x){ return cast(SDL_AudioFormat)(x & SDL_AUDIO_MASK_DATATYPE); }
	SDL_AudioFormat SDL_AUDIO_ISBIGENDIAN(SDL_AudioFormat x){ return cast(SDL_AudioFormat)(x & SDL_AUDIO_MASK_ENDIAN); }
	SDL_AudioFormat SDL_AUDIO_ISSIGNED(SDL_AudioFormat x){ return cast(SDL_AudioFormat)(x & SDL_AUDIO_MASK_SIGNED); }
	bool SDL_AUDIO_ISINT(SDL_AudioFormat x){ return !SDL_AUDIO_ISFLOAT(x); }
	bool SDL_AUDIO_ISLITTLEENDIAN(SDL_AudioFormat x){ return !SDL_AUDIO_ISBIGENDIAN(x); }
	bool SDL_AUDIO_ISUNSIGNED(SDL_AudioFormat x){ return !SDL_AUDIO_ISSIGNED(x); }
}
deprecated("Please use the non-template variant instead"){
	enum SDL_AUDIO_BITSIZE(SDL_AudioFormat x)         = x & SDL_AUDIO_MASK_BITSIZE;
	enum SDL_AUDIO_ISFLOAT(SDL_AudioFormat x)         = x & SDL_AUDIO_MASK_DATATYPE;
	enum SDL_AUDIO_ISBIGENDIAN(SDL_AudioFormat x)     = x & SDL_AUDIO_MASK_ENDIAN;
	enum SDL_AUDIO_ISSIGNED(SDL_AudioFormat x)        = x & SDL_AUDIO_MASK_SIGNED;
	enum SDL_AUDIO_ISINT(SDL_AudioFormat x)           = !SDL_AUDIO_ISFLOAT(x);
	enum SDL_AUDIO_ISLITTLEENDIAN(SDL_AudioFormat x)  = !SDL_AUDIO_ISBIGENDIAN(x);
	enum SDL_AUDIO_ISUNSIGNED(SDL_AudioFormat x)      = !SDL_AUDIO_ISSIGNED(x);
}

alias SDL_AudioFormat = ushort;
enum: SDL_AudioFormat{
	AUDIO_U8      = 0x0008,
	AUDIO_S8      = 0x8008,
	AUDIO_U16LSB  = 0x0010,
	AUDIO_S16LSB  = 0x8010,
	AUDIO_U16MSB  = 0x1010,
	AUDIO_S16MSB  = 0x9010,
	AUDIO_U16     = AUDIO_U16LSB,
	AUDIO_S16     = AUDIO_S16LSB,
	AUDIO_S32LSB  = 0x8020,
	AUDIO_S32MSB  = 0x9020,
	AUDIO_S32     = AUDIO_S32LSB,
	AUDIO_F32LSB  = 0x8120,
	AUDIO_F32MSB  = 0x9120,
	AUDIO_F32     = AUDIO_F32LSB,
}

version(LittleEndian){
	alias AUDIO_U16SYS  = AUDIO_U16LSB;
	alias AUDIO_S16SYS  = AUDIO_S16LSB;
	alias AUDIO_S32SYS  = AUDIO_S32LSB;
	alias AUDIO_F32SYS  = AUDIO_F32LSB;
}else{
	alias AUDIO_U16SYS  = AUDIO_U16MSB;
	alias AUDIO_S16SYS  = AUDIO_S16MSB;
	alias AUDIO_S32SYS  = AUDIO_S32MSB;
	alias AUDIO_F32SYS  = AUDIO_F32MSB;
}

enum{
	SDL_AUDIO_ALLOW_FREQUENCY_CHANGE  = 0x00000001,
	SDL_AUDIO_ALLOW_FORMAT_CHANGE     = 0x00000002,
	SDL_AUDIO_ALLOW_CHANNELS_CHANGE   = 0x00000004,
}
static if(sdlSupport >= SDLSupport.v2_0_9)
enum{
	SDL_AUDIO_ALLOW_SAMPLES_CHANGE    = 0x00000008,
	SDL_AUDIO_ALLOW_ANY_CHANGE        =
		SDL_AUDIO_ALLOW_FREQUENCY_CHANGE | SDL_AUDIO_ALLOW_FORMAT_CHANGE |
		SDL_AUDIO_ALLOW_CHANNELS_CHANGE  | SDL_AUDIO_ALLOW_SAMPLES_CHANGE,
}
else
enum{
	SDL_AUDIO_ALLOW_ANY_CHANGE        =
		SDL_AUDIO_ALLOW_FREQUENCY_CHANGE | SDL_AUDIO_ALLOW_FORMAT_CHANGE |
		SDL_AUDIO_ALLOW_CHANNELS_CHANGE,
}

alias SDL_AudioCallback = extern(C) void function(void* userData, ubyte* stream, int len) nothrow;

struct SDL_AudioSpec{
	int freq;
	SDL_AudioFormat format;
	ubyte channels;
	ubyte silence;
	ushort samples;
	ushort padding;
	uint size;
	SDL_AudioCallback callback;
	void* userdata;
}

//Declared in 2.0.6
enum SDL_AUDIOCVT_MAX_FILTERS = 9;

alias SDL_AudioFilter = extern(C) void function(SDL_AudioCVT* cvt, SDL_AudioFormat format) nothrow;

struct SDL_AudioCVT{
	int needed;
	SDL_AudioFormat src_format;
	SDL_AudioFormat dst_format;
	double rate_incr;
	ubyte* buf;
	int len;
	int len_cvt;
	int len_mult;
	double len_ratio;
	SDL_AudioFilter[SDL_AUDIOCVT_MAX_FILTERS + 1] filters;
	int filter_index;
}

alias SDL_AudioDeviceID = uint;

alias SDL_AudioStatus = int;
enum: SDL_AudioStatus{
	SDL_AUDIO_STOPPED  = 0,
	SDL_AUDIO_PLAYING  = 1,
	SDL_AUDIO_PAUSED   = 2,
}

pragma(inline, true) SDL_AudioSpec* SDL_LoadWAV(const(char)* file, SDL_AudioSpec* spec, ubyte** audioBuf, uint* len) nothrow @nogc{
	return SDL_LoadWAV_RW(SDL_RWFromFile(file, "rb"), 1, spec, audioBuf, len);
}

static if(sdlSupport >= SDLSupport.v2_0_7){
	struct SDL_AudioStream;
}

enum SDL_MIX_MAXVOLUME = 128;

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{int}, q{SDL_GetNumAudioDrivers}, q{}},
		{q{const(char)*}, q{SDL_GetAudioDriver}, q{int index}},
		{q{int}, q{SDL_AudioInit}, q{const(char)* driverName}},
		{q{void}, q{SDL_AudioQuit}, q{}},
		{q{const(char)*}, q{SDL_GetCurrentAudioDriver}, q{}},
		{q{int}, q{SDL_OpenAudio}, q{SDL_AudioSpec* desired, SDL_AudioSpec* obtained}},
		{q{int}, q{SDL_GetNumAudioDevices}, q{int isCapture}},
		{q{const(char)*}, q{SDL_GetAudioDeviceName}, q{int index, int isCapture}},
		{q{SDL_AudioDeviceID}, q{SDL_OpenAudioDevice}, q{const(char)* device, int isCapture, const(SDL_AudioSpec)* desired, SDL_AudioSpec* obtained, int allowedChanges}},
		{q{SDL_AudioStatus}, q{SDL_GetAudioStatus}, q{}},
		{q{SDL_AudioStatus}, q{SDL_GetAudioDeviceStatus}, q{SDL_AudioDeviceID dev}},
		{q{void}, q{SDL_PauseAudio}, q{int pauseOn}},
		{q{void}, q{SDL_PauseAudioDevice}, q{SDL_AudioDeviceID dev, int pauseOn}},
		{q{SDL_AudioSpec*}, q{SDL_LoadWAV_RW}, q{SDL_RWops* src, int freeSrc, SDL_AudioSpec* spec, ubyte** audioBuf, uint* audioLen}},
		{q{void}, q{SDL_FreeWAV}, q{ubyte* audioBuf}},
		{q{int}, q{SDL_BuildAudioCVT}, q{SDL_AudioCVT* cvt, SDL_AudioFormat srcFormat, ubyte srcChannels, int srcRate, SDL_AudioFormat dstFormat, ubyte dstChannels, int dstRate}},
		{q{int}, q{SDL_ConvertAudio}, q{SDL_AudioCVT* cvt}},
		{q{void}, q{SDL_MixAudio}, q{ubyte* dst, const(ubyte)* src, uint len, int volume}},
		{q{void}, q{SDL_MixAudioFormat}, q{ubyte* dst, const(ubyte)* src, SDL_AudioFormat format, uint len, int volume}},
		{q{void}, q{SDL_LockAudio}, q{}},
		{q{void}, q{SDL_LockAudioDevice}, q{SDL_AudioDeviceID dev}},
		{q{void}, q{SDL_UnlockAudio}, q{}},
		{q{void}, q{SDL_UnlockAudioDevice}, q{SDL_AudioDeviceID dev}},
		{q{void}, q{SDL_CloseAudio}, q{}},
		{q{void}, q{SDL_CloseAudioDevice}, q{SDL_AudioDeviceID dev}},
	];
	if(sdlSupport >= SDLSupport.v2_0_4){
		FnBind[] add = [
			{q{int}, q{SDL_QueueAudio}, q{SDL_AudioDeviceID dev, const(void)* data, uint len}},
			{q{int}, q{SDL_ClearQueuedAudio}, q{SDL_AudioDeviceID dev}},
			{q{int}, q{SDL_GetQueuedAudioSize}, q{SDL_AudioDeviceID dev}},
		];
		ret ~= add;
	}
	if(sdlSupport >= SDLSupport.v2_0_5){
		FnBind[] add = [
			{q{uint}, q{SDL_DequeueAudio}, q{SDL_AudioDeviceID dev, void* data, uint len}},
		];
		ret ~= add;
	}
	if(sdlSupport >= SDLSupport.v2_0_7){
		FnBind[] add = [
			{q{SDL_AudioStream*}, q{SDL_NewAudioStream}, q{const SDL_AudioFormat srcFormat, const ubyte srcChannels, const int srcRate, const SDL_AudioFormat dstFormat, const ubyte dstChannels, const int dstRate}},
			{q{int}, q{SDL_AudioStreamPut}, q{SDL_AudioStream* stream, const(void)* buf, int len}},
			{q{int}, q{SDL_AudioStreamGet}, q{SDL_AudioStream* stream, void* buf, int len}},
			{q{int}, q{SDL_AudioStreamAvailable}, q{SDL_AudioStream* stream}},
			{q{int}, q{SDL_AudioStreamFlush}, q{SDL_AudioStream* stream}},
			{q{void}, q{SDL_AudioStreamClear}, q{SDL_AudioStream* stream}},
			{q{void}, q{SDL_FreeAudioStream}, q{SDL_AudioStream* stream}},
		];
		ret ~= add;
	}
	if(sdlSupport >= SDLSupport.v2_0_16){
		FnBind[] add = [
			{q{int}, q{SDL_GetAudioDeviceSpec}, q{int index, int isCapture, SDL_AudioSpec* spec}},
		];
		ret ~= add;
	}
	if(sdlSupport >= SDLSupport.v2_24){
		FnBind[] add = [
			{q{int}, q{SDL_GetDefaultAudioInfo}, q{char** name, SDL_AudioSpec* spec, int isCapture}},
		];
		ret ~= add;
	}
	return ret;
}()));
