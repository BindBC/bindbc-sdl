/+
+            Copyright 2022 – 2023 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl_mixer;

import bindbc.sdl.config;
static if(bindSDLMixer):
import bindbc.sdl.codegen;

import sdl.audio: AUDIO_S16LSB, SDL_MIX_MAXVOLUME;
import sdl.error: SDL_GetError, SDL_SetError, SDL_ClearError, SDL_OutOfMemory;
import sdl.rwops: SDL_RWops, SDL_RWFromFile;
import sdl.stdinc: SDL_bool;
import sdl.version_: SDL_version, SDL_VERSIONNUM;

enum SDLMixerSupport: SDL_version{
	noLibrary   = SDL_version(0,0,0),
	badLibrary  = SDL_version(0,0,255),
	v2_0_0      = SDL_version(2,0,0),
	v2_0_1      = SDL_version(2,0,1),
	v2_0_2      = SDL_version(2,0,2),
	v2_0_4      = SDL_version(2,0,4),
	v2_6        = SDL_version(2,6,0),
	
	deprecated("Please use `v2_0_0` instead") sdlMixer200 = SDL_version(2,0,0),
	deprecated("Please use `v2_0_1` instead") sdlMixer201 = SDL_version(2,0,1),
	deprecated("Please use `v2_0_2` instead") sdlMixer202 = SDL_version(2,0,2),
	deprecated("Please use `v2_0_4` instead") sdlMixer204 = SDL_version(2,0,4),
	deprecated("Please use `v2_6` instead")   sdlMixer260 = SDL_version(2,6,0),
}

enum sdlMixerSupport = (){
	version(SDL_Mixer_260)      return SDLMixerSupport.v2_6; //NOTE: deprecated, remove this in bindbc-sdl 2.0
	else version(SDL_Mixer_2_6) return SDLMixerSupport.v2_6;
	else version(SDL_Mixer_204) return SDLMixerSupport.v2_0_4;
	else version(SDL_Mixer_202) return SDLMixerSupport.v2_0_2;
	else version(SDL_Mixer_201) return SDLMixerSupport.v2_0_1;
	else                        return SDLMixerSupport.v2_0_0;
}();

enum SDL_MIXER_MAJOR_VERSION = sdlMixerSupport.major;
enum SDL_MIXER_MINOR_VERSION = sdlMixerSupport.minor;
enum SDL_MIXER_PATCHLEVEL    = sdlMixerSupport.patch;

deprecated("Please use `SDL_MIXER_MAJOR_VERSION` instead") alias MIX_MAJOR_VERSION = SDL_MIXER_MAJOR_VERSION;
deprecated("Please use `SDL_MIXER_MINOR_VERSION` instead") alias MIX_MINOR_VERSION = SDL_MIXER_MINOR_VERSION;
deprecated("Please use `SDL_MIXER_PATCHLEVEL` instead")    alias MIX_PATCH_LEVEL   = SDL_MIXER_PATCHLEVEL;

pragma(inline, true) void SDL_MIXER_VERSION(SDL_version* X) @nogc nothrow pure @safe{
	X.major = SDL_MIXER_MAJOR_VERSION;
	X.minor = SDL_MIXER_MINOR_VERSION;
	X.patch = SDL_MIXER_PATCHLEVEL;
}

// These were implemented in SDL_mixer 2.0.2, but are fine for all versions.
deprecated("Please use SDL_MIXER_VERSION_ATLEAST or SDL_MIXER_VERSION instead")
	enum SDL_MIXER_COMPILEDVERSION = SDL_version(SDL_MIXER_MAJOR_VERSION, SDL_MIXER_MINOR_VERSION, SDL_MIXER_PATCHLEVEL);

pragma(inline, true) @nogc nothrow{
	bool SDL_MIXER_VERSION_ATLEAST(ubyte X, ubyte Y, ubyte Z){ return SDL_version(SDL_MIXER_MAJOR_VERSION, SDL_MIXER_MINOR_VERSION, SDL_MIXER_PATCHLEVEL) >= SDL_version(X, Y, Z); }
}
deprecated("Please use the non-template variant instead"){
	enum SDL_MIXER_VERSION_ATLEAST(ubyte X, ubyte Y, ubyte Z) = SDL_version(SDL_MIXER_MAJOR_VERSION, SDL_MIXER_MINOR_VERSION, SDL_MIXER_PATCHLEVEL) >= SDL_version(X, Y, Z);
}

alias Mix_InitFlags = int;
enum: Mix_InitFlags{
	MIX_INIT_FLAC        = 0x0000_0001,
	MIX_INIT_MOD         = 0x0000_0002,
	MIX_INIT_MP3         = 0x0000_0008,
	MIX_INIT_OGG         = 0x0000_0010,
}
static if(sdlMixerSupport < SDLMixerSupport.v2_0_2)
enum: Mix_InitFlags{
	MIX_INIT_MODPLUG     = 0x0000_0004,
	MIX_INIT_FLUIDSYNTH  = 0x0000_0020,
}
else //sdlMixerSupport >= SDLMixerSupport.v2_0_2
enum: Mix_InitFlags{
	MIX_INIT_MID         = 0x0000_0020,
}
static if(sdlMixerSupport >= SDLMixerSupport.v2_0_4)
enum: Mix_InitFlags{
	MIX_INIT_OPUS        = 0x0000_0040,
}

enum MIX_CHANNELS = 8;

enum MIX_DEFAULT_FREQUENCY = (){
	static if(sdlMixerSupport >= SDLMixerSupport.v2_6)
		return 44100;
	else
		return 22050;
}();

enum MIX_DEFAULT_FORMAT = (){
	version(LittleEndian) return AUDIO_S16LSB;
	else                  return AUDIO_S16MSB;
}();

enum MIX_DEFAULT_CHANNELS = 2;

alias MIX_MAX_VOLUME = SDL_MIX_MAXVOLUME;

struct Mix_Chunk{
	int allocated;
	ubyte* abuf;
	uint alen;
	ubyte volume;
}

alias Mix_Fading = int;
enum: Mix_Fading{
	MIX_NO_FADING,
	MIX_FADING_OUT,
	MIX_FADING_IN,
}

alias Mix_MusicType = int;
enum: Mix_MusicType{
	MUS_NONE            = 0,
	MUS_CMD             = 1,
	MUS_WAV             = 2,
	MUS_MOD             = 3,
	MUS_MID             = 4,
	MUS_OGG             = 5,
	MUS_MP3             = 6,
	
	MUS_FLAC            = 8,
}
static if(sdlMixerSupport < SDLMixerSupport.v2_0_2)
enum: Mix_MusicType{
	MUS_MP3_MAD         = 7,
	MUS_MODPLUG         = 9,
}
else //sdlMixerSupport >= SDLMixerSupport.v2_0_2
enum: Mix_MusicType{
	MUS_MP3_MAD_UNUSED  = 7,
	MUS_MODPLUG_UNUSED  = 9,
}
static if(sdlMixerSupport >= SDLMixerSupport.v2_0_4)
enum: Mix_MusicType{
	MUS_OPUS            = 10,
}

struct Mix_Music;

enum MIX_CHANNEL_POST = -2;

enum MIX_EFFECTSMAXSPEED = "MIX_EFFECTSMAXSPEED";

extern(C) nothrow{
	alias Mix_EffectFunc_t = void function(int,void*,int,void*);
	alias Mix_EffectDone_t = void function(int,void*);

	// These aren't in SDL_mixer.h and are just here as a convenient and
	// visible means to add the proper attributes to these callbacks.
	alias callbackVI = void function(int);
	alias callbackVPVPUbI = void function(void*,ubyte*,int);
	alias callbackV = void function();
	alias callbackIPCPV = int function(const(char*),void*);
}

alias Mix_SetError = SDL_SetError;

alias Mix_GetError = SDL_GetError;

alias Mix_ClearError = SDL_ClearError;

alias Mix_OutOfMemory = SDL_OutOfMemory;

static if(sdlMixerSupport < SDLMixerSupport.v2_6){
	pragma(inline, true) @nogc nothrow{
		Mix_Chunk* Mix_LoadWAV(const(char)* file){
			return Mix_LoadWAV_RW(SDL_RWFromFile(file, "rb"), 1);
		}

		int Mix_PlayChannel(int channel, Mix_Chunk* chunk, int loops){
			return Mix_PlayChannelTimed(channel, chunk, loops, -1);
		}

		int Mix_FadeInChannel(int channel, Mix_Chunk* chunk, int loops, int ms){
			return Mix_FadeInChannelTimed(channel, chunk, loops, ms, -1);
		}
	}
}

mixin(joinFnBinds((){
	string[][] ret;
	ret ~= makeFnBinds([
		[q{const(SDL_version)*}, q{Mix_Linked_Version}, q{}],
		[q{int}, q{Mix_Init}, q{int flags}],
		[q{void}, q{Mix_Quit}, q{}],
		[q{int}, q{Mix_OpenAudio}, q{int frequency, ushort format, int channels, int chunksize}],
		[q{int}, q{Mix_AllocateChannels}, q{int numchans}],
		[q{int}, q{Mix_QuerySpec}, q{int* frequency, ushort* format, int* channels}],
		[q{Mix_Chunk*}, q{Mix_LoadWAV_RW}, q{SDL_RWops* src, int freesrc}],
		[q{Mix_Music*}, q{Mix_LoadMUS}, q{const(char)* file}],
		[q{Mix_Music*}, q{Mix_LoadMUS_RW}, q{SDL_RWops* src, int freesrc}],
		[q{Mix_Music*}, q{Mix_LoadMUSType_RW}, q{SDL_RWops* src, Mix_MusicType type, int freesrc}],
		[q{Mix_Chunk*}, q{Mix_QuickLoad_WAV}, q{ubyte* mem}],
		[q{Mix_Chunk*}, q{Mix_QuickLoad_RAW}, q{ubyte* mem, uint len}],
		[q{void}, q{Mix_FreeChunk}, q{Mix_Chunk* chunk}],
		[q{void}, q{Mix_FreeMusic}, q{Mix_Music* music}],
		[q{int}, q{Mix_GetNumChunkDecoders}, q{}],
		[q{const(char)*}, q{Mix_GetChunkDecoder}, q{int index}],
		[q{int}, q{Mix_GetNumMusicDecoders}, q{}],
		[q{const(char)*}, q{Mix_GetMusicDecoder}, q{int index}],
		[q{Mix_MusicType}, q{Mix_GetMusicType}, q{const(Mix_Music)* music}],
		[q{void}, q{Mix_SetPostMix}, q{callbackVPVPUbI mix_func, void* arg}],
		[q{void}, q{Mix_HookMusic}, q{callbackVPVPUbI mix_func, void* arg}],
		[q{void}, q{Mix_HookMusicFinished}, q{callbackV music_finished}],
		[q{void*}, q{Mix_GetMusicHookData}, q{}],
		[q{void}, q{Mix_ChannelFinished}, q{callbackVI channel_finished}],
		[q{int}, q{Mix_RegisterEffect}, q{int chan, Mix_EffectFunc_t f, Mix_EffectDone_t d, void* arg}],
		[q{int}, q{Mix_UnregisterEffect}, q{int channel, Mix_EffectFunc_t f}],
		[q{int}, q{Mix_UnregisterAllEffects}, q{int channel}],
		[q{int}, q{Mix_SetPanning}, q{int channel, ubyte left, ubyte right}],
		[q{int}, q{Mix_SetPosition}, q{int channel, short angle, ubyte distance}],
		[q{int}, q{Mix_SetDistance}, q{int channel, ubyte distance}],
		[q{int}, q{Mix_SetReverseStereo}, q{int channel, int flip}],
		[q{int}, q{Mix_ReserveChannels}, q{int num}],
		[q{int}, q{Mix_GroupChannel}, q{int which, int tag}],
		[q{int}, q{Mix_GroupChannels}, q{int from, int to, int tag}],
		[q{int}, q{Mix_GroupAvailable}, q{int tag}],
		[q{int}, q{Mix_GroupCount}, q{int tag}],
		[q{int}, q{Mix_GroupOldest}, q{int tag}],
		[q{int}, q{Mix_GroupNewer}, q{int tag}],
		[q{int}, q{Mix_PlayChannelTimed}, q{int channel, Mix_Chunk* chunk, int loops, int ticks}],
		[q{int}, q{Mix_PlayMusic}, q{Mix_Music* music, int loops}],
		[q{int}, q{Mix_FadeInMusic}, q{Mix_Music* music, int loops, int ms}],
		[q{int}, q{Mix_FadeInMusicPos}, q{Mix_Music* music, int loops, int ms, double position}],
		[q{int}, q{Mix_FadeInChannelTimed}, q{int channel, Mix_Chunk* chunk, int loops, int ms, int ticks}],
		[q{int}, q{Mix_Volume}, q{int channel, int volume}],
		[q{int}, q{Mix_VolumeChunk}, q{Mix_Chunk* chunk, int volume}],
		[q{int}, q{Mix_VolumeMusic}, q{int volume}],
		[q{int}, q{Mix_HaltChannel}, q{int channel}],
		[q{int}, q{Mix_HaltGroup}, q{int tag}],
		[q{int}, q{Mix_HaltMusic}, q{}],
		[q{int}, q{Mix_ExpireChannel}, q{int channel, int ticks}],
		[q{int}, q{Mix_FadeOutChannel}, q{int which, int ms}],
		[q{int}, q{Mix_FadeOutGroup}, q{int tag, int ms}],
		[q{int}, q{Mix_FadeOutMusic}, q{int ms}],
		[q{Mix_Fading}, q{Mix_FadingMusic}, q{}],
		[q{Mix_Fading}, q{Mix_FadingChannel}, q{int which}],
		[q{void}, q{Mix_Pause}, q{int channel}],
		[q{void}, q{Mix_Resume}, q{int channel}],
		[q{int}, q{Mix_Paused}, q{int channel}],
		[q{void}, q{Mix_PauseMusic}, q{}],
		[q{void}, q{Mix_ResumeMusic}, q{}],
		[q{void}, q{Mix_RewindMusic}, q{}],
		[q{int}, q{Mix_PausedMusic}, q{}],
		[q{int}, q{Mix_SetMusicPosition}, q{double position}],
		[q{int}, q{Mix_Playing}, q{int channel}],
		[q{int}, q{Mix_PlayingMusic}, q{}],
		[q{int}, q{Mix_SetMusicCMD}, q{const(char)* command}],
		[q{int}, q{Mix_SetSynchroValue}, q{int value}],
		[q{int}, q{Mix_GetSynchroValue}, q{}],
		[q{int}, q{Mix_SetSoundFonts}, q{const(char)* paths}],
		[q{const(char)*}, q{Mix_GetSoundFonts}, q{}],
		[q{int}, q{Mix_EachSoundFont}, q{callbackIPCPV function_, void* data}],
		[q{Mix_Chunk*}, q{Mix_GetChunk}, q{int channel}],
		[q{void}, q{Mix_CloseAudio}, q{}],
	]);
	static if(sdlMixerSupport >= SDLMixerSupport.v2_0_2){
		ret ~= makeFnBinds([
			[q{int}, q{Mix_OpenAudioDevice}, q{int frequency, ushort format, int channels, int chunksize, const(char)* device, int allowed_changes}],
			[q{SDL_bool}, q{Mix_HasChunkDecoder}, q{const(char)* name}],
			// Declared in SDL_mixer.h, but not implemented:
			// [q{SDL_bool}, q{Mix_HasMusicDecoder}, q{const(char)*}],
		]);
	}
	static if(sdlMixerSupport >= SDLMixerSupport.v2_6){
		ret ~= makeFnBinds([
			[q{Mix_Chunk*}, q{Mix_LoadWAV}, q{const(char)* file}],
			[q{int}, q{Mix_PlayChannel}, q{int channel, Mix_Chunk* chunk, int loops}],
			[q{int}, q{Mix_FadeInChannel}, q{int channel, Mix_Chunk* chunk, int loops, int ms}],
			[q{SDL_bool}, q{Mix_HasMusicDecoder}, q{const(char)* name}],
			[q{const(char)*}, q{Mix_GetMusicTitle}, q{const(Mix_Music)* music}],
			[q{const(char)*}, q{Mix_GetMusicTitleTag}, q{const(Mix_Music)* music}],
			[q{const(char)*}, q{Mix_GetMusicArtistTag}, q{const(Mix_Music)* music}],
			[q{const(char)*}, q{Mix_GetMusicAlbumTag}, q{const(Mix_Music)* music}],
			[q{const(char)*}, q{Mix_GetMusicCopyrightTag}, q{const(Mix_Music)* music}],
			[q{int}, q{Mix_GetMusicVolume}, q{Mix_Music* music}],
			[q{int}, q{Mix_MasterVolume}, q{int volume}],
			[q{int}, q{Mix_ModMusicJumpToOrder}, q{int order}],
			[q{double}, q{Mix_GetMusicPosition}, q{Mix_Music* music}],
			[q{double}, q{Mix_MusicDuration}, q{Mix_Music* music}],
			[q{double}, q{Mix_GetMusicLoopStartTime}, q{Mix_Music* music}],
			[q{double}, q{Mix_GetMusicLoopEndTime}, q{Mix_Music* music}],
			[q{double}, q{Mix_GetMusicLoopLengthTime}, q{Mix_Music* music}],
			[q{int}, q{Mix_SetTimidityCfg}, q{const(char)* path}],
			[q{const(char)*}, q{Mix_GetTimidityCfg}, q{}],
		]);
	}
	return ret;
}()));

static if(!staticBinding):
import bindbc.loader;

private{
	SharedLib lib;
	SDLMixerSupport loadedVersion;
	enum libNamesCT = (){
		version(Windows){
			return [
				`SDL2_mixer.dll`,
			];
		}else version(OSX){
			return [
				`libSDL2_mixer.dylib`,
				`/opt/homebrew/lib/libSDL2_mixer.dylib`,
				`SDL2_mixer`,
				`/Library/Frameworks/SDL2_mixer.framework/SDL2_mixer`,
				`/System/Library/Frameworks/SDL2_mixer.framework/SDL2_mixer`,
			];
		}else version(Posix){
			return [
				`libSDL2_mixer.so`,
				`libSDL2-2.0_mixer.so`,
				`libSDL2-2.0_mixer.so.0`,
			];
		}else static assert(0, "BindBC-SDL_mixer does not have library search paths set up for this platform");
	}();
}

@nogc nothrow:
deprecated("Please use `Mix_Linked_Version` instead")
	SDLMixerSupport loadedSDLMixerVersion(){ return loadedVersion; }

mixin(bindbc.sdl.codegen.makeDynloadFns("Mixer", [__MODULE__]));
