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

enum{
	SDL_Mixer_MajorVersion = sdlMixerVersion.major,
	SDL_Mixer_MinorVersion = sdlMixerVersion.minor,
	SDL_Mixer_MicroVersion = sdlMixerVersion.patch,
	SDL_Mixer_Version = SDL_VERSIONNUM(SDL_Mixer_MajorVersion, SDL_Mixer_MinorVersion, SDL_Mixer_MicroVersion),
	
	SDL_MIXER_MAJOR_VERSION = SDL_Mixer_MajorVersion,
	SDL_MIXER_MINOR_VERSION = SDL_Mixer_MinorVersion,
	SDL_MIXER_MICRO_VERSION = SDL_Mixer_MicroVersion,
	SDL_MIXER_VERSION = SDL_Mixer_Version,
}

pragma(inline,true)
bool SDL_MIXER_VERSION_ATLEAST(uint x, uint y, uint z) nothrow @nogc pure @safe =>
	(SDL_Mixer_MajorVersion >= x) &&
	(SDL_Mixer_MajorVersion >  x || SDL_Mixer_MinorVersion >= y) &&
	(SDL_Mixer_MajorVersion >  x || SDL_Mixer_MinorVersion >  y || SDL_Mixer_MicroVersion >= z);

enum{
	MIX_PropMixerDeviceNumber = "SDL_mixer.mixer.device",
	MIX_PROP_MIXER_DEVICE_NUMBER = MIX_PropMixerDeviceNumber,
	MIX_PropAudioLoadIostreamPointer = "SDL_mixer.audio.load.iostream",
	MIX_PROP_AUDIO_LOAD_IOSTREAM_POINTER = MIX_PropAudioLoadIostreamPointer,
	MIX_PropAudioLoadCloseioBoolean = "SDL_mixer.audio.load.closeio",
	MIX_PROP_AUDIO_LOAD_CLOSEIO_BOOLEAN = MIX_PropAudioLoadCloseioBoolean,
	MIX_PropAudioLoadPredecodeBoolean = "SDL_mixer.audio.load.predecode",
	MIX_PROP_AUDIO_LOAD_PREDECODE_BOOLEAN = MIX_PropAudioLoadPredecodeBoolean,
	MIX_PropAudioLoadPreferredMixerPointer = "SDL_mixer.audio.load.preferred_mixer",
	MIX_PROP_AUDIO_LOAD_PREFERRED_MIXER_POINTER = MIX_PropAudioLoadPreferredMixerPointer,
	MIX_PropAudioLoadSkipMetadataTagsBoolean = "SDL_mixer.audio.load.skip_metadata_tags",
	MIX_PROP_AUDIO_LOAD_SKIP_METADATA_TAGS_BOOLEAN = MIX_PropAudioLoadSkipMetadataTagsBoolean,
	MIX_PropAudioLoadIgnoreLoopsBoolean = "SDL_mixer.audio.load.ignore_loops",
	MIX_PROP_AUDIO_LOAD_IGNORE_LOOPS_BOOLEAN = MIX_PropAudioLoadIgnoreLoopsBoolean,
	MIX_PropAudioDecoderString = "SDL_mixer.audio.decoder",
	MIX_PROP_AUDIO_DECODER_STRING = MIX_PropAudioDecoderString,
	MIX_PropMetadataTitleString = "SDL_mixer.metadata.title",
	MIX_PROP_METADATA_TITLE_STRING = MIX_PropMetadataTitleString,
	MIX_PropMetadataArtistString = "SDL_mixer.metadata.artist",
	MIX_PROP_METADATA_ARTIST_STRING = MIX_PropMetadataArtistString,
	MIX_PropMetadataAlbumString = "SDL_mixer.metadata.album",
	MIX_PROP_METADATA_ALBUM_STRING = MIX_PropMetadataAlbumString,
	MIX_PropMetadataCopyrightString = "SDL_mixer.metadata.copyright",
	MIX_PROP_METADATA_COPYRIGHT_STRING = MIX_PropMetadataCopyrightString,
	MIX_PropMetadataTrackNumber = "SDL_mixer.metadata.track",
	MIX_PROP_METADATA_TRACK_NUMBER = MIX_PropMetadataTrackNumber,
	MIX_PropMetadataTotalTracksNumber = "SDL_mixer.metadata.total_tracks",
	MIX_PROP_METADATA_TOTAL_TRACKS_NUMBER = MIX_PropMetadataTotalTracksNumber,
	MIX_PropMetadataYearNumber = "SDL_mixer.metadata.year",
	MIX_PROP_METADATA_YEAR_NUMBER = MIX_PropMetadataYearNumber,
	MIX_PropMetadataDurationFramesNumber = "SDL_mixer.metadata.duration_frames",
	MIX_PROP_METADATA_DURATION_FRAMES_NUMBER = MIX_PropMetadataDurationFramesNumber,
	MIX_PropMetadataDurationInfiniteBoolean = "SDL_mixer.metadata.duration_infinite",
	MIX_PROP_METADATA_DURATION_INFINITE_BOOLEAN = MIX_PropMetadataDurationInfiniteBoolean,
	MIX_DurationUnknown = -1,
	MIX_DURATION_UNKNOWN = MIX_DurationUnknown,
	MIX_DurationInfinite = -2,
	MIX_DURATION_INFINITE = MIX_DurationInfinite,
	MIX_PropPlayLoopsNumber = "SDL_mixer.play.loops",
	MIX_PROP_PLAY_LOOPS_NUMBER = MIX_PropPlayLoopsNumber,
	MIX_PropPlayMaxFrameNumber = "SDL_mixer.play.max_frame",
	MIX_PROP_PLAY_MAX_FRAME_NUMBER = MIX_PropPlayMaxFrameNumber,
	MIX_PropPlayMaxMillisecondsNumber = "SDL_mixer.play.max_milliseconds",
	MIX_PROP_PLAY_MAX_MILLISECONDS_NUMBER = MIX_PropPlayMaxMillisecondsNumber,
	MIX_PropPlayStartFrameNumber = "SDL_mixer.play.start_frame",
	MIX_PROP_PLAY_START_FRAME_NUMBER = MIX_PropPlayStartFrameNumber,
	MIX_PropPlayStartMillisecondNumber = "SDL_mixer.play.start_millisecond",
	MIX_PROP_PLAY_START_MILLISECOND_NUMBER = MIX_PropPlayStartMillisecondNumber,
	MIX_PropPlayStartOrderNumber = "SDL_mixer.play.start_order",
	MIX_PROP_PLAY_START_ORDER_NUMBER = MIX_PropPlayStartOrderNumber,
	MIX_PropPlayLoopStartFrameNumber = "SDL_mixer.play.loop_start_frame",
	MIX_PROP_PLAY_LOOP_START_FRAME_NUMBER = MIX_PropPlayLoopStartFrameNumber,
	MIX_PropPlayLoopStartMillisecondNumber = "SDL_mixer.play.loop_start_millisecond",
	MIX_PROP_PLAY_LOOP_START_MILLISECOND_NUMBER = MIX_PropPlayLoopStartMillisecondNumber,
	MIX_PropPlayFadeInFramesNumber = "SDL_mixer.play.fade_in_frames",
	MIX_PROP_PLAY_FADE_IN_FRAMES_NUMBER = MIX_PropPlayFadeInFramesNumber,
	MIX_PropPlayFadeInMillisecondsNumber = "SDL_mixer.play.fade_in_milliseconds",
	MIX_PROP_PLAY_FADE_IN_MILLISECONDS_NUMBER = MIX_PropPlayFadeInMillisecondsNumber,
	MIX_PropPlayFadeInStartGainFloat = "SDL_mixer.play.fade_in_start_gain",
	MIX_PROP_PLAY_FADE_IN_START_GAIN_FLOAT = MIX_PropPlayFadeInStartGainFloat,
	MIX_PropPlayAppendSilenceFramesNumber = "SDL_mixer.play.append_silence_frames",
	MIX_PROP_PLAY_APPEND_SILENCE_FRAMES_NUMBER = MIX_PropPlayAppendSilenceFramesNumber,
	MIX_PropPlayAppendSilenceMillisecondsNumber = "SDL_mixer.play.append_silence_milliseconds",
	MIX_PROP_PLAY_APPEND_SILENCE_MILLISECONDS_NUMBER = MIX_PropPlayAppendSilenceMillisecondsNumber,
	MIX_PropPlayHaltWhenExhaustedBoolean = "SDL_mixer.play.halt_when_exhausted",
	MIX_PROP_PLAY_HALT_WHEN_EXHAUSTED_BOOLEAN = MIX_PropPlayHaltWhenExhaustedBoolean,
}

struct MIX_Mixer;
struct MIX_Audio;
struct MIX_Track;
struct MIX_Group;
struct MIX_AudioDecoder;

struct MIX_StereoGains{
	float left;
	float right;
}

struct MIX_Point3D{
	float x;
	float y;
	float z;
}

extern(C) nothrow{
	alias MIX_TrackStoppedCallback = void function(void* userdata, MIX_Track* track);
	alias MIX_TrackMixCallback = void function(void* userdata, MIX_Track* track, const(SDL_AudioSpec)* spec, float* pcm, int samples);
	alias MIX_GroupMixCallback = void function(void* userdata, MIX_Group* group, const(SDL_AudioSpec)* spec, float* pcm, int samples);
	alias MIX_PostMixCallback = void function(void* userdata, MIX_Mixer* mixer, const(SDL_AudioSpec)* spec, float* pcm, int samples);
}

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{int}, q{MIX_Version}, q{}},
		{q{bool}, q{MIX_Init}, q{}},
		{q{void}, q{MIX_Quit}, q{}},
		{q{int}, q{MIX_GetNumAudioDecoders}, q{}},
		{q{const(char)*}, q{MIX_GetAudioDecoder}, q{int index}},
		{q{MIX_Mixer *}, q{MIX_CreateMixerDevice}, q{SDL_AudioDeviceID devid, const(SDL_AudioSpec)* spec}},
		{q{MIX_Mixer *}, q{MIX_CreateMixer}, q{const(SDL_AudioSpec)* spec}},
		{q{void}, q{MIX_DestroyMixer}, q{MIX_Mixer *mixer}},
		{q{SDL_PropertiesID}, q{MIX_GetMixerProperties}, q{MIX_Mixer *mixer}},
		{q{bool}, q{MIX_GetMixerFormat}, q{MIX_Mixer *mixer, SDL_AudioSpec *spec}},
		{q{void}, q{MIX_LockMixer}, q{MIX_Mixer *mixer}},
		{q{void}, q{MIX_UnlockMixer}, q{MIX_Mixer *mixer}},
		{q{MIX_Audio *}, q{MIX_LoadAudio_IO}, q{MIX_Mixer *mixer, SDL_IOStream *io, bool predecode, bool closeio}},
		{q{MIX_Audio *}, q{MIX_LoadAudio}, q{MIX_Mixer *mixer, const(char)* path, bool predecode}},
		{q{MIX_Audio *}, q{MIX_LoadAudioNoCopy}, q{MIX_Mixer *mixer, const(void)* data, size_t datalen, bool free_when_done}},
		{q{MIX_Audio *}, q{MIX_LoadAudioWithProperties}, q{SDL_PropertiesID props}},
		{q{MIX_Audio *}, q{MIX_LoadRawAudio_IO}, q{MIX_Mixer *mixer, SDL_IOStream *io, const(SDL_AudioSpec)* spec, bool closeio}},
		{q{MIX_Audio *}, q{MIX_LoadRawAudio}, q{MIX_Mixer *mixer, const(void)* data, size_t datalen, const(SDL_AudioSpec)* spec}},
		{q{MIX_Audio *}, q{MIX_LoadRawAudioNoCopy}, q{MIX_Mixer *mixer, const(void)* data, size_t datalen, const(SDL_AudioSpec)* spec, bool free_when_done}},
		{q{MIX_Audio *}, q{MIX_CreateSineWaveAudio}, q{MIX_Mixer *mixer, int hz, float amplitude, long ms}},
		{q{SDL_PropertiesID}, q{MIX_GetAudioProperties}, q{MIX_Audio *audio}},
		{q{long}, q{MIX_GetAudioDuration}, q{MIX_Audio *audio}},
		{q{bool}, q{MIX_GetAudioFormat}, q{MIX_Audio *audio, SDL_AudioSpec *spec}},
		{q{void}, q{MIX_DestroyAudio}, q{MIX_Audio *audio}},
		{q{MIX_Track *}, q{MIX_CreateTrack}, q{MIX_Mixer *mixer}},
		{q{void}, q{MIX_DestroyTrack}, q{MIX_Track *track}},
		{q{SDL_PropertiesID}, q{MIX_GetTrackProperties}, q{MIX_Track *track}},
		{q{MIX_Mixer *}, q{MIX_GetTrackMixer}, q{MIX_Track *track}},
		{q{bool}, q{MIX_SetTrackAudio}, q{MIX_Track *track, MIX_Audio *audio}},
		{q{bool}, q{MIX_SetTrackAudioStream}, q{MIX_Track *track, SDL_AudioStream *stream}},
		{q{bool}, q{MIX_SetTrackIOStream}, q{MIX_Track *track, SDL_IOStream *io, bool closeio}},
		{q{bool}, q{MIX_SetTrackRawIOStream}, q{MIX_Track *track, SDL_IOStream *io, const(SDL_AudioSpec)* spec, bool closeio}},
		{q{bool}, q{MIX_TagTrack}, q{MIX_Track *track, const(char)* tag}},
		{q{void}, q{MIX_UntagTrack}, q{MIX_Track *track, const(char)* tag}},
		{q{char**}, q{MIX_GetTrackTags}, q{MIX_Track *track, int *count}},
		{q{MIX_Track **}, q{MIX_GetTaggedTracks}, q{MIX_Mixer *mixer, const(char)* tag, int *count}},
		{q{bool}, q{MIX_SetTrackPlaybackPosition}, q{MIX_Track *track, long frames}},
		{q{long}, q{MIX_GetTrackPlaybackPosition}, q{MIX_Track *track}},
		{q{long}, q{MIX_GetTrackFadeFrames}, q{MIX_Track *track}},
		{q{int}, q{MIX_GetTrackLoops}, q{MIX_Track *track}},
		{q{bool}, q{MIX_SetTrackLoops}, q{MIX_Track *track, int num_loops}},
		{q{MIX_Audio *}, q{MIX_GetTrackAudio}, q{MIX_Track *track}},
		{q{SDL_AudioStream *}, q{MIX_GetTrackAudioStream}, q{MIX_Track *track}},
		{q{long}, q{MIX_GetTrackRemaining}, q{MIX_Track *track}},
		{q{long}, q{MIX_TrackMSToFrames}, q{MIX_Track *track, long ms}},
		{q{long}, q{MIX_TrackFramesToMS}, q{MIX_Track *track, long frames}},
		{q{long}, q{MIX_AudioMSToFrames}, q{MIX_Audio *audio, long ms}},
		{q{long}, q{MIX_AudioFramesToMS}, q{MIX_Audio *audio, long frames}},
		{q{long}, q{MIX_MSToFrames}, q{int sample_rate, long ms}},
		{q{long}, q{MIX_FramesToMS}, q{int sample_rate, long frames}},
		{q{bool}, q{MIX_PlayTrack}, q{MIX_Track *track, SDL_PropertiesID options}},
		{q{bool}, q{MIX_PlayTag}, q{MIX_Mixer *mixer, const(char)* tag, SDL_PropertiesID options}},
		{q{bool}, q{MIX_PlayAudio}, q{MIX_Mixer *mixer, MIX_Audio *audio}},
		{q{bool}, q{MIX_StopTrack}, q{MIX_Track *track, long fade_out_frames}},
		{q{bool}, q{MIX_StopAllTracks}, q{MIX_Mixer *mixer, long fade_out_ms}},
		{q{bool}, q{MIX_StopTag}, q{MIX_Mixer *mixer, const(char)* tag, long fade_out_ms}},
		{q{bool}, q{MIX_PauseTrack}, q{MIX_Track *track}},
		{q{bool}, q{MIX_PauseAllTracks}, q{MIX_Mixer *mixer}},
		{q{bool}, q{MIX_PauseTag}, q{MIX_Mixer *mixer, const(char)* tag}},
		{q{bool}, q{MIX_ResumeTrack}, q{MIX_Track *track}},
		{q{bool}, q{MIX_ResumeAllTracks}, q{MIX_Mixer *mixer}},
		{q{bool}, q{MIX_ResumeTag}, q{MIX_Mixer *mixer, const(char)* tag}},
		{q{bool}, q{MIX_TrackPlaying}, q{MIX_Track *track}},
		{q{bool}, q{MIX_TrackPaused}, q{MIX_Track *track}},
		{q{bool}, q{MIX_SetMixerGain}, q{MIX_Mixer *mixer, float gain}},
		{q{float}, q{MIX_GetMixerGain}, q{MIX_Mixer *mixer}},
		{q{bool}, q{MIX_SetTrackGain}, q{MIX_Track *track, float gain}},
		{q{float}, q{MIX_GetTrackGain}, q{MIX_Track *track}},
		{q{bool}, q{MIX_SetTagGain}, q{MIX_Mixer *mixer, const(char)* tag, float gain}},
		{q{bool}, q{MIX_SetMixerFrequencyRatio}, q{MIX_Mixer *mixer, float ratio}},
		{q{float}, q{MIX_GetMixerFrequencyRatio}, q{MIX_Mixer *mixer}},
		{q{bool}, q{MIX_SetTrackFrequencyRatio}, q{MIX_Track *track, float ratio}},
		{q{float}, q{MIX_GetTrackFrequencyRatio}, q{MIX_Track *track}},
		{q{bool}, q{MIX_SetTrackOutputChannelMap}, q{MIX_Track *track, const(int)* chmap, int count}},
		{q{bool}, q{MIX_SetTrackStereo}, q{MIX_Track *track, const(MIX_StereoGains)* gains}},
		{q{bool}, q{MIX_SetTrack3DPosition}, q{MIX_Track *track, const(MIX_Point3D)* position}},
		{q{bool}, q{MIX_GetTrack3DPosition}, q{MIX_Track *track, MIX_Point3D *position}},
		{q{MIX_Group *}, q{MIX_CreateGroup}, q{MIX_Mixer *mixer}},
		{q{void}, q{MIX_DestroyGroup}, q{MIX_Group *group}},
		{q{SDL_PropertiesID}, q{MIX_GetGroupProperties}, q{MIX_Group *group}},
		{q{MIX_Mixer *}, q{MIX_GetGroupMixer}, q{MIX_Group *group}},
		{q{bool}, q{MIX_SetTrackGroup}, q{MIX_Track *track, MIX_Group *group}},
		{q{bool}, q{MIX_SetTrackStoppedCallback}, q{MIX_Track *track, MIX_TrackStoppedCallback cb, void *userdata}},
		{q{bool}, q{MIX_SetTrackRawCallback}, q{MIX_Track *track, MIX_TrackMixCallback cb, void *userdata}},
		{q{bool}, q{MIX_SetTrackCookedCallback}, q{MIX_Track *track, MIX_TrackMixCallback cb, void *userdata}},
		{q{bool}, q{MIX_SetGroupPostMixCallback}, q{MIX_Group *group, MIX_GroupMixCallback cb, void *userdata}},
		{q{bool}, q{MIX_SetPostMixCallback}, q{MIX_Mixer *mixer, MIX_PostMixCallback cb, void *userdata}},
		{q{int}, q{MIX_Generate}, q{MIX_Mixer *mixer, void *buffer, int buflen}},
		{q{MIX_AudioDecoder *}, q{MIX_CreateAudioDecoder}, q{const(char)* path, SDL_PropertiesID props}},
		{q{MIX_AudioDecoder *}, q{MIX_CreateAudioDecoder_IO}, q{SDL_IOStream *io, bool closeio, SDL_PropertiesID props}},
		{q{void}, q{MIX_DestroyAudioDecoder}, q{MIX_AudioDecoder *audiodecoder}},
		{q{SDL_PropertiesID}, q{MIX_GetAudioDecoderProperties}, q{MIX_AudioDecoder *audiodecoder}},
		{q{bool}, q{MIX_GetAudioDecoderFormat}, q{MIX_AudioDecoder *audiodecoder, SDL_AudioSpec *spec}},
		{q{int}, q{MIX_DecodeAudio}, q{MIX_AudioDecoder *audiodecoder, void *buffer, int buflen, const(SDL_AudioSpec)* spec}},
	];
	return ret;
}()));

static if(!staticBinding):
import bindbc.loader;

mixin(makeDynloadFns("SDLMixer", makeLibPaths(["SDL3_mixer"]), [__MODULE__]));
