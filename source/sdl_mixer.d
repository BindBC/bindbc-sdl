/+
+            Copyright 2025 – 2026 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl_mixer;

import bindbc.sdl.config;
static if(sdlMixerVersion):
import bindbc.sdl.codegen;

import sdl.audio: SDL_AudioDeviceID, SDL_AudioFormat, SDL_AudioSpec, SDL_AudioStream;
import sdl.iostream: SDL_IOStream;
import sdl.properties: SDL_PropertiesID;
import sdl.version_: SDL_VERSIONNUM;

struct MIX_Mixer;

struct MIX_Audio;

struct MIX_Track;

struct MIX_Group;

enum{
	majorVersion = sdlMixerVersion.major,
	minorVersion = sdlMixerVersion.minor,
	microVersion = sdlMixerVersion.patch,
	versionNum = SDL_VERSIONNUM(majorVersion, minorVersion, microVersion),
	
	SDL_MIXER_MAJOR_VERSION = majorVersion,
	SDL_MIXER_MINOR_VERSION = minorVersion,
	SDL_MIXER_MICRO_VERSION = microVersion,
	SDL_MIXER_VERSION = versionNum,
}

pragma(inline,true)
bool versionAtLeast(uint x, uint y, uint z) nothrow @nogc pure @safe =>
	(majorVersion >= x) &&
	(majorVersion >  x || minorVersion >= y) &&
	(majorVersion >  x || minorVersion >  y || microVersion >= z);
alias SDL_MIXER_VERSION_ATLEAST = versionAtLeast;

mixin(makeEnumBind(q{MIXProp_Mixer}, members: (){
	EnumMember[] ret = [
		{{q{deviceNumber},    q{MIX_PROP_MIXER_DEVICE_NUMBER}},    q{"SDL_mixer.mixer.device"}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{MIXProp_Audio}, members: (){
	EnumMember[] ret = [
		{{q{loadIOStreamPointer},            q{MIX_PROP_AUDIO_LOAD_IOSTREAM_POINTER}},              q{"SDL_mixer.audio.load.iostream"}},
		{{q{loadCloseIOBoolean},             q{MIX_PROP_AUDIO_LOAD_CLOSEIO_BOOLEAN}},               q{"SDL_mixer.audio.load.closeIO"}},
		{{q{loadPreDecodeBoolean},           q{MIX_PROP_AUDIO_LOAD_PREDECODE_BOOLEAN}},             q{"SDL_mixer.audio.load.preDecode"}},
		{{q{loadPreferredMixerPointer},      q{MIX_PROP_AUDIO_LOAD_PREFERRED_MIXER_POINTER}},       q{"SDL_mixer.audio.load.preferred_mixer"}},
		{{q{loadSkipMetadataTagsBoolean},    q{MIX_PROP_AUDIO_LOAD_SKIP_METADATA_TAGS_BOOLEAN}},    q{"SDL_mixer.audio.load.skip_metadata_tags"}},
		{{q{decoderString},                  q{MIX_PROP_AUDIO_DECODER_STRING}},                     q{"SDL_mixer.audio.decoder"}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{MIXProp_Metadata}, members: (){
	EnumMember[] ret = [
		{{q{titleString},                q{MIX_PROP_METADATA_TITLE_STRING}},                 q{"SDL_mixer.metadata.title"}},
		{{q{artistString},               q{MIX_PROP_METADATA_ARTIST_STRING}},                q{"SDL_mixer.metadata.artist"}},
		{{q{albumString},                q{MIX_PROP_METADATA_ALBUM_STRING}},                 q{"SDL_mixer.metadata.album"}},
		{{q{copyrightString},            q{MIX_PROP_METADATA_COPYRIGHT_STRING}},             q{"SDL_mixer.metadata.copyright"}},
		{{q{trackNumber},                q{MIX_PROP_METADATA_TRACK_NUMBER}},                 q{"SDL_mixer.metadata.track"}},
		{{q{totalTracksNumber},          q{MIX_PROP_METADATA_TOTAL_TRACKS_NUMBER}},          q{"SDL_mixer.metadata.total_tracks"}},
		{{q{yearNumber},                 q{MIX_PROP_METADATA_YEAR_NUMBER}},                  q{"SDL_mixer.metadata.year"}},
		{{q{durationFramesNumber},       q{MIX_PROP_METADATA_DURATION_FRAMES_NUMBER}},       q{"SDL_mixer.metadata.duration_frames"}},
		{{q{durationInfiniteBoolean},    q{MIX_PROP_METADATA_DURATION_INFINITE_BOOLEAN}},    q{"SDL_mixer.metadata.duration_infinite"}},
	];
	return ret;
}()));

enum: long{
	MIX_Duration_Unknown = -1,
	MIX_Duration_Infinite = -2,
	
	MIX_DURATION_UNKNOWN = MIX_Duration_Unknown,
	MIX_DURATION_INFINITE = MIX_Duration_Infinite,
}

mixin(makeEnumBind(q{MIXProp_Play}, members: (){
	EnumMember[] ret = [
		{{q{loopsNumber},                        q{MIX_PROP_PLAY_LOOPS_NUMBER}},                          q{"SDL_mixer.play.loops"}},
		{{q{maxFrameNumber},                     q{MIX_PROP_PLAY_MAX_FRAME_NUMBER}},                      q{"SDL_mixer.play.max_frame"}},
		{{q{maxMillisecondsNumber},              q{MIX_PROP_PLAY_MAX_MILLISECONDS_NUMBER}},               q{"SDL_mixer.play.max_milliseconds"}},
		{{q{startFrameNumber},                   q{MIX_PROP_PLAY_START_FRAME_NUMBER}},                    q{"SDL_mixer.play.start_frame"}},
		{{q{startMillisecondNumber},             q{MIX_PROP_PLAY_START_MILLISECOND_NUMBER}},              q{"SDL_mixer.play.start_millisecond"}},
		{{q{loopStartFrameNumber},               q{MIX_PROP_PLAY_LOOP_START_FRAME_NUMBER}},               q{"SDL_mixer.play.loop_start_frame"}},
		{{q{loopStartMillisecondNumber},         q{MIX_PROP_PLAY_LOOP_START_MILLISECOND_NUMBER}},         q{"SDL_mixer.play.loop_start_millisecond"}},
		{{q{fadeInFramesNumber},                 q{MIX_PROP_PLAY_FADE_IN_FRAMES_NUMBER}},                 q{"SDL_mixer.play.fade_in_frames"}},
		{{q{fadeInMillisecondsNumber},           q{MIX_PROP_PLAY_FADE_IN_MILLISECONDS_NUMBER}},           q{"SDL_mixer.play.fade_in_milliseconds"}},
		{{q{fadeInStartGainFloat},               q{MIX_PROP_PLAY_FADE_IN_START_GAIN_FLOAT}},              q{"SDL_mixer.play.fade_in_start_gain"}},
		{{q{appendSilenceFramesNumber},          q{MIX_PROP_PLAY_APPEND_SILENCE_FRAMES_NUMBER}},          q{"SDL_mixer.play.append_silence_frames"}},
		{{q{appendSilenceMillisecondsNumber},    q{MIX_PROP_PLAY_APPEND_SILENCE_MILLISECONDS_NUMBER}},    q{"SDL_mixer.play.append_silence_milliseconds"}},
		{{q{haltWhenExhaustedBoolean},           q{MIX_PROP_PLAY_HALT_WHEN_EXHAUSTED_BOOLEAN}},           q{"SDL_mixer.play.halt_when_exhausted"}},
	];
	if(sdlMixerVersion >= Version(3,2,2)){
		EnumMember add =
			{{q{startOrderNumber},               q{MIX_PROP_PLAY_START_ORDER_NUMBER}},                    q{"SDL_mixer.play.start_order"}};
		ret ~= add;
	}
	return ret;
}()));

struct MIX_StereoGains{
	float left, right;
}

struct MIX_Point3D{
	float x, y, z;
}

extern(C) nothrow{
	alias MIX_TrackStoppedCallback = void function(void* userData, MIX_Track* track);
	alias MIX_TrackMixCallback = void function(void* userData, MIX_Track* track, const(SDL_AudioSpec)* spec, float* pcm, int samples);
	alias MIX_GroupMixCallback = void function(void* userData, MIX_Group* group, const(SDL_AudioSpec)* spec, float* pcm, int samples);
	alias MIX_PostMixCallback = void function(void* userData, MIX_Mixer* mixer, const(SDL_AudioSpec)* spec, float* pcm, int samples);
}

struct MIX_AudioDecoder;

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{int}, q{MIX_Version}, q{}},
		{q{bool}, q{MIX_Init}, q{}},
		{q{void}, q{MIX_Quit}, q{}},
		{q{int}, q{MIX_GetNumAudioDecoders}, q{}},
		{q{const(char)*}, q{MIX_GetAudioDecoder}, q{int index}},
		{q{MIX_Mixer*}, q{MIX_CreateMixerDevice}, q{SDL_AudioDeviceID devID, const(SDL_AudioSpec)* spec}},
		{q{MIX_Mixer*}, q{MIX_CreateMixer}, q{const(SDL_AudioSpec)* spec}},
		{q{void}, q{MIX_DestroyMixer}, q{MIX_Mixer* mixer}},
		{q{SDL_PropertiesID}, q{MIX_GetMixerProperties}, q{MIX_Mixer* mixer}},
		{q{bool}, q{MIX_GetMixerFormat}, q{MIX_Mixer* mixer, SDL_AudioSpec* spec}},
		{q{void}, q{MIX_LockMixer}, q{MIX_Mixer* mixer}},
		{q{void}, q{MIX_UnlockMixer}, q{MIX_Mixer* mixer}},
		{q{MIX_Audio*}, q{MIX_LoadAudio_IO}, q{MIX_Mixer* mixer, SDL_IOStream* io, bool preDecode, bool closeIO}},
		{q{MIX_Audio*}, q{MIX_LoadAudio}, q{MIX_Mixer* mixer, const(char)* path, bool preDecode}},
		{q{MIX_Audio*}, q{MIX_LoadAudioNoCopy}, q{MIX_Mixer* mixer, const(void)* data, size_t dataLen, bool freeWhenDone}},
		{q{MIX_Audio*}, q{MIX_LoadAudioWithProperties}, q{SDL_PropertiesID props}},
		{q{MIX_Audio*}, q{MIX_LoadRawAudio_IO}, q{MIX_Mixer* mixer, SDL_IOStream* io, const(SDL_AudioSpec)* spec, bool closeIO}},
		{q{MIX_Audio*}, q{MIX_LoadRawAudio}, q{MIX_Mixer* mixer, const(void)* data, size_t dataLen, const(SDL_AudioSpec)* spec}},
		{q{MIX_Audio*}, q{MIX_LoadRawAudioNoCopy}, q{MIX_Mixer* mixer, const(void)* data, size_t dataLen, const(SDL_AudioSpec)* spec, bool freeWhenDone}},
		{q{MIX_Audio*}, q{MIX_CreateSineWaveAudio}, q{MIX_Mixer* mixer, int hz, float amplitude, long ms}},
		{q{SDL_PropertiesID}, q{MIX_GetAudioProperties}, q{MIX_Audio* audio}},
		{q{long}, q{MIX_GetAudioDuration}, q{MIX_Audio* audio}},
		{q{bool}, q{MIX_GetAudioFormat}, q{MIX_Audio* audio, SDL_AudioSpec* spec}},
		{q{void}, q{MIX_DestroyAudio}, q{MIX_Audio* audio}},
		{q{MIX_Track*}, q{MIX_CreateTrack}, q{MIX_Mixer* mixer}},
		{q{void}, q{MIX_DestroyTrack}, q{MIX_Track* track}},
		{q{SDL_PropertiesID}, q{MIX_GetTrackProperties}, q{MIX_Track* track}},
		{q{MIX_Mixer*}, q{MIX_GetTrackMixer}, q{MIX_Track* track}},
		{q{bool}, q{MIX_SetTrackAudio}, q{MIX_Track* track, MIX_Audio* audio}},
		{q{bool}, q{MIX_SetTrackAudioStream}, q{MIX_Track* track, SDL_AudioStream* stream}},
		{q{bool}, q{MIX_SetTrackIOStream}, q{MIX_Track* track, SDL_IOStream* io, bool closeIO}},
		{q{bool}, q{MIX_SetTrackRawIOStream}, q{MIX_Track* track, SDL_IOStream* io, const(SDL_AudioSpec)* spec, bool closeIO}},
		{q{bool}, q{MIX_TagTrack}, q{MIX_Track* track, const(char)* tag}},
		{q{void}, q{MIX_UntagTrack}, q{MIX_Track* track, const(char)* tag}},
		{q{char**}, q{MIX_GetTrackTags}, q{MIX_Track* track, int* count}},
		{q{MIX_Track**}, q{MIX_GetTaggedTracks}, q{MIX_Mixer* mixer, const(char)* tag, int* count}},
		{q{bool}, q{MIX_SetTrackPlaybackPosition}, q{MIX_Track* track, long frames}},
		{q{long}, q{MIX_GetTrackPlaybackPosition}, q{MIX_Track* track}},
		{q{long}, q{MIX_GetTrackFadeFrames}, q{MIX_Track* track}},
		{q{int}, q{MIX_GetTrackLoops}, q{MIX_Track* track}},
		{q{bool}, q{MIX_SetTrackLoops}, q{MIX_Track* track, int numLoops}},
		{q{MIX_Audio*}, q{MIX_GetTrackAudio}, q{MIX_Track* track}},
		{q{SDL_AudioStream*}, q{MIX_GetTrackAudioStream}, q{MIX_Track* track}},
		{q{long}, q{MIX_GetTrackRemaining}, q{MIX_Track* track}},
		{q{long}, q{MIX_TrackMSToFrames}, q{MIX_Track* track, long ms}},
		{q{long}, q{MIX_TrackFramesToMS}, q{MIX_Track* track, long frames}},
		{q{long}, q{MIX_AudioMSToFrames}, q{MIX_Audio* audio, long ms}},
		{q{long}, q{MIX_AudioFramesToMS}, q{MIX_Audio* audio, long frames}},
		{q{long}, q{MIX_MSToFrames}, q{int sample_rate, long ms}},
		{q{long}, q{MIX_FramesToMS}, q{int sample_rate, long frames}},
		{q{bool}, q{MIX_PlayTrack}, q{MIX_Track* track, SDL_PropertiesID options}},
		{q{bool}, q{MIX_PlayTag}, q{MIX_Mixer* mixer, const(char)* tag, SDL_PropertiesID options}},
		{q{bool}, q{MIX_PlayAudio}, q{MIX_Mixer* mixer, MIX_Audio* audio}},
		{q{bool}, q{MIX_StopTrack}, q{MIX_Track* track, long fadeOutFrames}},
		{q{bool}, q{MIX_StopAllTracks}, q{MIX_Mixer* mixer, long fadeOutMS}},
		{q{bool}, q{MIX_StopTag}, q{MIX_Mixer* mixer, const(char)* tag, long fadeOutMS}},
		{q{bool}, q{MIX_PauseTrack}, q{MIX_Track* track}},
		{q{bool}, q{MIX_PauseAllTracks}, q{MIX_Mixer* mixer}},
		{q{bool}, q{MIX_PauseTag}, q{MIX_Mixer* mixer, const(char)* tag}},
		{q{bool}, q{MIX_ResumeTrack}, q{MIX_Track* track}},
		{q{bool}, q{MIX_ResumeAllTracks}, q{MIX_Mixer* mixer}},
		{q{bool}, q{MIX_ResumeTag}, q{MIX_Mixer* mixer, const(char)* tag}},
		{q{bool}, q{MIX_TrackPlaying}, q{MIX_Track* track}},
		{q{bool}, q{MIX_TrackPaused}, q{MIX_Track* track}},
		{q{bool}, q{MIX_SetMixerGain}, q{MIX_Mixer* mixer, float gain}},
		{q{float}, q{MIX_GetMixerGain}, q{MIX_Mixer* mixer}},
		{q{bool}, q{MIX_SetTrackGain}, q{MIX_Track* track, float gain}},
		{q{float}, q{MIX_GetTrackGain}, q{MIX_Track* track}},
		{q{bool}, q{MIX_SetTagGain}, q{MIX_Mixer* mixer, const(char)* tag, float gain}},
		{q{bool}, q{MIX_SetMixerFrequencyRatio}, q{MIX_Mixer* mixer, float ratio}},
		{q{float}, q{MIX_GetMixerFrequencyRatio}, q{MIX_Mixer* mixer}},
		{q{bool}, q{MIX_SetTrackFrequencyRatio}, q{MIX_Track* track, float ratio}},
		{q{float}, q{MIX_GetTrackFrequencyRatio}, q{MIX_Track* track}},
		{q{bool}, q{MIX_SetTrackOutputChannelMap}, q{MIX_Track* track, const(int)* chMap, int count}},
		{q{bool}, q{MIX_SetTrackStereo}, q{MIX_Track* track, const(MIX_StereoGains)* gains}},
		{q{bool}, q{MIX_SetTrack3DPosition}, q{MIX_Track* track, const(MIX_Point3D)* position}},
		{q{bool}, q{MIX_GetTrack3DPosition}, q{MIX_Track* track, MIX_Point3D* position}},
		{q{MIX_Group*}, q{MIX_CreateGroup}, q{MIX_Mixer* mixer}},
		{q{void}, q{MIX_DestroyGroup}, q{MIX_Group* group}},
		{q{SDL_PropertiesID}, q{MIX_GetGroupProperties}, q{MIX_Group* group}},
		{q{MIX_Mixer*}, q{MIX_GetGroupMixer}, q{MIX_Group* group}},
		{q{bool}, q{MIX_SetTrackGroup}, q{MIX_Track* track, MIX_Group* group}},
		{q{bool}, q{MIX_SetTrackStoppedCallback}, q{MIX_Track* track, MIX_TrackStoppedCallback cb, void* userData}},
		{q{bool}, q{MIX_SetTrackRawCallback}, q{MIX_Track* track, MIX_TrackMixCallback cb, void* userData}},
		{q{bool}, q{MIX_SetTrackCookedCallback}, q{MIX_Track* track, MIX_TrackMixCallback cb, void* userData}},
		{q{bool}, q{MIX_SetGroupPostMixCallback}, q{MIX_Group* group, MIX_GroupMixCallback cb, void* userData}},
		{q{bool}, q{MIX_SetPostMixCallback}, q{MIX_Mixer* mixer, MIX_PostMixCallback cb, void* userData}},
		{q{int}, q{MIX_Generate}, q{MIX_Mixer* mixer, void* buffer, int bufLen}},
		{q{MIX_AudioDecoder*}, q{MIX_CreateAudioDecoder}, q{const(char)* path, SDL_PropertiesID props}},
		{q{MIX_AudioDecoder*}, q{MIX_CreateAudioDecoder_IO}, q{SDL_IOStream* io, bool closeIO, SDL_PropertiesID props}},
		{q{void}, q{MIX_DestroyAudioDecoder}, q{MIX_AudioDecoder* audioDecoder}},
		{q{SDL_PropertiesID}, q{MIX_GetAudioDecoderProperties}, q{MIX_AudioDecoder* audioDecoder}},
		{q{bool}, q{MIX_GetAudioDecoderFormat}, q{MIX_AudioDecoder* audioDecoder, SDL_AudioSpec* spec}},
		{q{int}, q{MIX_DecodeAudio}, q{MIX_AudioDecoder* audioDecoder, void* buffer, int bufLen, const(SDL_AudioSpec)* spec}},
	];
	return ret;
}()));

static if(!staticBinding):
import bindbc.loader;

mixin(makeDynloadFns("SDLMixer", makeLibPaths(["SDL3_mixer"]), [__MODULE__]));
