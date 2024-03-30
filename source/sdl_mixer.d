/+
+               Copyright 2025 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl_mixer;

import bindbc.sdl.config;
static if(sdlMixerVersion):
import bindbc.sdl.codegen;

import sdl.audio: SDL_AudioDeviceID, SDL_AudioFormat, SDL_AudioSpec;
import sdl.iostream: SDL_IOStream;
import sdl.version_: SDL_VERSIONNUM;

enum{
	SDL_MixerMajorVersion = sdlMixerVersion.major,
	SDL_MixerMinorVersion = sdlMixerVersion.minor,
	SDL_MixerMicroVersion = sdlMixerVersion.patch,
	SDL_MixerVersion = SDL_VERSIONNUM(SDL_MixerMajorVersion, SDL_MixerMinorVersion, SDL_MixerMicroVersion),
	
	SDL_MIXER_MAJOR_VERSION = SDL_MixerMajorVersion,
	SDL_MIXER_MINOR_VERSION = SDL_MixerMinorVersion,
	SDL_MIXER_MICRO_VERSION = SDL_MixerMicroVersion,
	SDL_MIXER_VERSION = SDL_MixerVersion,
}

pragma(inline,true)
bool SDL_MIXER_VERSION_ATLEAST(uint x, uint y, uint z) nothrow @nogc pure @safe =>
	(SDL_MixerMajorVersion >= x) &&
	(SDL_MixerMajorVersion >  x || SDL_MixerMinorVersion >= y) &&
	(SDL_MixerMajorVersion >  x || SDL_MixerMinorVersion >  y || SDL_MixerMicroVersion >= z);

alias MIX_InitFlags_ = uint;
mixin(makeEnumBind(q{MIX_InitFlags}, q{MIX_InitFlags_}, aliases: [q{MIX_Init}], members: (){
	EnumMember[] ret = [
		{{q{flac},       q{MIX_INIT_FLAC}},       q{0x0000_0001}},
		{{q{mod},        q{MIX_INIT_MOD}},        q{0x0000_0002}},
		{{q{mp3},        q{MIX_INIT_MP3}},        q{0x0000_0008}},
		{{q{ogg},        q{MIX_INIT_OGG}},        q{0x0000_0010}},
		{{q{mid},        q{MIX_INIT_MID}},        q{0x0000_0020}},
		{{q{opus},       q{MIX_INIT_OPUS}},       q{0x0000_0040}},
		{{q{wavPack},    q{MIX_INIT_WAVPACK}},    q{0x0000_0080}},
	];
	return ret;
}()));

enum{
	MIX_Channels = 8,
	MIX_CHANNELS = MIX_Channels,
}

enum{
	MIX_DefaultFrequency  = 44_100,
	MIX_DefaultFormat     = SDL_AudioFormat.s16,
	MIX_DefaultChannels   = 2,
	MIX_MaxVolume         = 128,
	
	MIX_DEFAULT_FREQUENCY = MIX_DefaultFrequency,
	MIX_DEFAULT_FORMAT = MIX_DefaultFormat,
	MIX_DEFAULT_CHANNELS = MIX_DefaultChannels,
	MIX_MAX_VOLUME = MIX_MaxVolume,
}

struct Mix_Chunk{
	int allocated;
	ubyte* aBuf;
	uint aLen;
	ubyte volume;
	
	alias abuf = aBuf;
	alias alen = aLen;
}

mixin(makeEnumBind(q{Mix_Fading}, members: (){
	EnumMember[] ret = [
		{{q{noFading}, q{MIX_NO_FADING}}},
		{{q{fadingOut}, q{MIX_FADING_OUT}}},
		{{q{fadingIn}, q{MIX_FADING_IN}}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{Mix_MusicType}, aliases: [q{Mus}], members: (){
	EnumMember[] ret = [
		{{q{none},           q{MUS_NONE}}},
		{{q{wav},            q{MUS_WAV}}},
		{{q{mod},            q{MUS_MOD}}},
		{{q{mid},            q{MUS_MID}}},
		{{q{ogg},            q{MUS_OGG}}},
		{{q{mp3},            q{MUS_MP3}}},
		{{q{mp3MADUnused},   q{MUS_MP3_MAD_UNUSED}}},
		{{q{flac},           q{MUS_FLAC}}},
		{{q{modPlugUnused},  q{MUS_MODPLUG_UNUSED}}},
		{{q{opus},           q{MUS_OPUS}}},
		{{q{wavPack},        q{MUS_WAVPACK}}},
		{{q{gme},            q{MUS_GME}}},
	];
	return ret;
}()));

struct Mix_Music;

extern(C) nothrow{
	alias Mix_MixCallback = void function(void* uData, ubyte* stream, int len);
	alias Mix_MusicFinishedCallback = void function();
	alias Mix_ChannelFinishedCallback = void function(int channel);
}

enum{
	MIX_ChannelPost = -2,
	MIX_CHANNEL_POST = MIX_ChannelPost,
}

extern(C) nothrow{
	alias Mix_EffectFunc_t = void function(int chan, void* stream, int len, void* uData);
	alias Mix_EffectDone_t = void function(int chan, void* uData);
}

enum{
	MIX_EffectsMaxSpeed = "MIX_EFFECTSMAXSPEED",
	MIX_EFFECTSMAXSPEED = MIX_EffectsMaxSpeed,
}

alias Mix_EachSoundFontCallback = extern(C) bool function(const(char)*, void*) nothrow;

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{int}, q{Mix_Version}, q{}},
		{q{MIX_InitFlags}, q{Mix_Init}, q{MIX_InitFlags flags}},
		{q{void}, q{Mix_Quit}, q{}},
		{q{bool}, q{Mix_OpenAudio}, q{SDL_AudioDeviceID devID, const(SDL_AudioSpec)* spec}},
		{q{void}, q{Mix_PauseAudio}, q{int pauseOn}},
		{q{bool}, q{Mix_QuerySpec}, q{int* frequency, SDL_AudioFormat* format, int* channels}},
		{q{int}, q{Mix_AllocateChannels}, q{int numChans}},
		{q{Mix_Chunk*}, q{Mix_LoadWAV_IO}, q{SDL_IOStream* src, bool closeIO}},
		{q{Mix_Chunk*}, q{Mix_LoadWAV}, q{const(char)* file}},
		{q{Mix_Music*}, q{Mix_LoadMUS}, q{const(char)* file}},
		{q{Mix_Music*}, q{Mix_LoadMUS_IO}, q{SDL_IOStream* src, bool closeIO}},
		{q{Mix_Music*}, q{Mix_LoadMUSType_IO}, q{SDL_IOStream* src, Mix_MusicType type, bool closeIO}},
		{q{Mix_Chunk*}, q{Mix_QuickLoad_WAV}, q{ubyte* mem}},
		{q{Mix_Chunk*}, q{Mix_QuickLoad_RAW}, q{ubyte* mem, uint len}},
		{q{void}, q{Mix_FreeChunk}, q{Mix_Chunk* chunk}},
		{q{void}, q{Mix_FreeMusic}, q{Mix_Music* music}},
		{q{int}, q{Mix_GetNumChunkDecoders}, q{}},
		{q{const(char)*}, q{Mix_GetChunkDecoder}, q{int index}},
		{q{bool}, q{Mix_HasChunkDecoder}, q{const(char)* name}},
		{q{int}, q{Mix_GetNumMusicDecoders}, q{}},
		{q{const(char)*}, q{Mix_GetMusicDecoder}, q{int index}},
		{q{bool}, q{Mix_HasMusicDecoder}, q{const(char)* name}},
		{q{Mix_MusicType}, q{Mix_GetMusicType}, q{const(Mix_Music)* music}},
		{q{const(char)*}, q{Mix_GetMusicTitle}, q{const(Mix_Music)* music}},
		{q{const(char)*}, q{Mix_GetMusicTitleTag}, q{const(Mix_Music)* music}},
		{q{const(char)*}, q{Mix_GetMusicArtistTag}, q{const(Mix_Music)* music}},
		{q{const(char)*}, q{Mix_GetMusicAlbumTag}, q{const(Mix_Music)* music}},
		{q{const(char)*}, q{Mix_GetMusicCopyrightTag}, q{const(Mix_Music)* music}},
		{q{void}, q{Mix_SetPostMix}, q{Mix_MixCallback mixFunc, void* arg}},
		{q{void}, q{Mix_HookMusic}, q{Mix_MixCallback mixFunc, void* arg}},
		{q{void}, q{Mix_HookMusicFinished}, q{Mix_MusicFinishedCallback musicFinished}},
		{q{void*}, q{Mix_GetMusicHookData}, q{}},
		{q{void}, q{Mix_ChannelFinished}, q{Mix_ChannelFinishedCallback channelFinished}},
		{q{bool}, q{Mix_RegisterEffect}, q{int chan, Mix_EffectFunc_t f, Mix_EffectDone_t d, void* arg}},
		{q{bool}, q{Mix_UnregisterEffect}, q{int channel, Mix_EffectFunc_t f}},
		{q{bool}, q{Mix_UnregisterAllEffects}, q{int channel}},
		{q{bool}, q{Mix_SetPanning}, q{int channel, ubyte left, ubyte right}},
		{q{bool}, q{Mix_SetPosition}, q{int channel, short angle, ubyte distance}},
		{q{bool}, q{Mix_SetDistance}, q{int channel, ubyte distance}},
		{q{bool}, q{Mix_SetReverseStereo}, q{int channel, int flip}},
		{q{int}, q{Mix_ReserveChannels}, q{int num}},
		{q{bool}, q{Mix_GroupChannel}, q{int which, int tag}},
		{q{bool}, q{Mix_GroupChannels}, q{int from, int to, int tag}},
		{q{int}, q{Mix_GroupAvailable}, q{int tag}},
		{q{int}, q{Mix_GroupCount}, q{int tag}},
		{q{int}, q{Mix_GroupOldest}, q{int tag}},
		{q{int}, q{Mix_GroupNewer}, q{int tag}},
		{q{int}, q{Mix_PlayChannel}, q{int channel, Mix_Chunk* chunk, int loops}},
		{q{int}, q{Mix_PlayChannelTimed}, q{int channel, Mix_Chunk* chunk, int loops, int ticks}},
		{q{bool}, q{Mix_PlayMusic}, q{Mix_Music* music, int loops}},
		{q{bool}, q{Mix_FadeInMusic}, q{Mix_Music* music, int loops, int ms}},
		{q{bool}, q{Mix_FadeInMusicPos}, q{Mix_Music* music, int loops, int ms, double position}},
		{q{int}, q{Mix_FadeInChannel}, q{int channel, Mix_Chunk* chunk, int loops, int ms}},
		{q{int}, q{Mix_FadeInChannelTimed}, q{int channel, Mix_Chunk* chunk, int loops, int ms, int ticks}},
		{q{int}, q{Mix_Volume}, q{int channel, int volume}},
		{q{int}, q{Mix_VolumeChunk}, q{Mix_Chunk* chunk, int volume}},
		{q{int}, q{Mix_VolumeMusic}, q{int volume}},
		{q{int}, q{Mix_GetMusicVolume}, q{Mix_Music* music}},
		{q{int}, q{Mix_MasterVolume}, q{int volume}},
		{q{void}, q{Mix_HaltChannel}, q{int channel}},
		{q{void}, q{Mix_HaltGroup}, q{int tag}},
		{q{void}, q{Mix_HaltMusic}, q{}},
		{q{int}, q{Mix_ExpireChannel}, q{int channel, int ticks}},
		{q{int}, q{Mix_FadeOutChannel}, q{int which, int ms}},
		{q{int}, q{Mix_FadeOutGroup}, q{int tag, int ms}},
		{q{bool}, q{Mix_FadeOutMusic}, q{int ms}},
		{q{Mix_Fading}, q{Mix_FadingMusic}, q{}},
		{q{Mix_Fading}, q{Mix_FadingChannel}, q{int which}},
		{q{void}, q{Mix_Pause}, q{int channel}},
		{q{void}, q{Mix_PauseGroup}, q{int tag}},
		{q{void}, q{Mix_Resume}, q{int channel}},
		{q{void}, q{Mix_ResumeGroup}, q{int tag}},
		{q{int}, q{Mix_Paused}, q{int channel}},
		{q{void}, q{Mix_PauseMusic}, q{}},
		{q{void}, q{Mix_ResumeMusic}, q{}},
		{q{void}, q{Mix_RewindMusic}, q{}},
		{q{bool}, q{Mix_PausedMusic}, q{}},
		{q{bool}, q{Mix_ModMusicJumpToOrder}, q{int order}},
		{q{bool}, q{Mix_StartTrack}, q{Mix_Music* music, int track}},
		{q{int}, q{Mix_GetNumTracks}, q{Mix_Music* music}},
		{q{bool}, q{Mix_SetMusicPosition}, q{double position}},
		{q{double}, q{Mix_GetMusicPosition}, q{Mix_Music* music}},
		{q{double}, q{Mix_MusicDuration}, q{Mix_Music* music}},
		{q{double}, q{Mix_GetMusicLoopStartTime}, q{Mix_Music* music}},
		{q{double}, q{Mix_GetMusicLoopEndTime}, q{Mix_Music* music}},
		{q{double}, q{Mix_GetMusicLoopLengthTime}, q{Mix_Music* music}},
		{q{int}, q{Mix_Playing}, q{int channel}},
		{q{bool}, q{Mix_PlayingMusic}, q{}},
		{q{bool}, q{Mix_SetSoundFonts}, q{const(char)* paths}},
		{q{const(char)*}, q{Mix_GetSoundFonts}, q{}},
		{q{bool}, q{Mix_EachSoundFont}, q{Mix_EachSoundFontCallback function_, void* data}},
		{q{bool}, q{Mix_SetTimidityCfg}, q{const(char)* path}},
		{q{const(char)*}, q{Mix_GetTimidityCfg}, q{}},
		{q{Mix_Chunk*}, q{Mix_GetChunk}, q{int channel}},
		{q{void}, q{Mix_CloseAudio}, q{}},
	];
	return ret;
}()));

static if(!staticBinding):
import bindbc.loader;

mixin(makeDynloadFns("SDLMixer", makeLibPaths(["SDL3_mixer"]), [__MODULE__]));
