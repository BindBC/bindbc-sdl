/+
+            Copyright 2024 – 2025 Aya Partridge
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module sdl.video;

import bindbc.sdl.config, bindbc.sdl.codegen;

import sdl.pixels;
import sdl.properties;
import sdl.rect: SDL_Rect, SDL_Point;
import sdl.stdinc: SDL_FunctionPointer;
import sdl.surface: SDL_Surface;

alias SDL_DisplayID = uint;

alias SDL_WindowID = uint;

mixin(makeEnumBind(q{SDLProp_GlobalVideo}, q{const(char)*}, members: (){
	EnumMember[] ret = [
		{{q{waylandWlDisplayPointer},    q{SDL_PROP_GLOBAL_VIDEO_WAYLAND_WL_DISPLAY_POINTER}},    q{"SDL.video.wayland.wl_display"}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_SystemTheme}, members: (){
	EnumMember[] ret = [
		{{q{unknown},  q{SDL_SYSTEM_THEME_UNKNOWN}}},
		{{q{light},    q{SDL_SYSTEM_THEME_LIGHT}}},
		{{q{dark},     q{SDL_SYSTEM_THEME_DARK}}},
	];
	return ret;
}()));

struct SDL_DisplayModeData;

struct SDL_DisplayMode{
	SDL_DisplayID displayID;
	SDL_PixelFormat format;
	int w, h;
	float pixelDensity;
	float refreshRate;
	int refreshRateNumerator;
	int refreshRateDenominator;
	
	SDL_DisplayModeData* internal;
	
	alias pixel_density = pixelDensity;
	alias refresh_rate = refreshRate;
	alias refresh_rate_numerator = refreshRateNumerator;
	alias refresh_rate_denominator = refreshRateDenominator;
}

mixin(makeEnumBind(q{SDL_DisplayOrientation}, aliases: [q{SDL_Orientation}], members: (){
	EnumMember[] ret = [
		{{q{unknown},           q{SDL_ORIENTATION_UNKNOWN}}},
		{{q{landscape},         q{SDL_ORIENTATION_LANDSCAPE}}},
		{{q{landscapeFlipped},  q{SDL_ORIENTATION_LANDSCAPE_FLIPPED}}},
		{{q{portrait},          q{SDL_ORIENTATION_PORTRAIT}}},
		{{q{portraitFlipped},   q{SDL_ORIENTATION_PORTRAIT_FLIPPED}}},
	];
	return ret;
}()));

struct SDL_Window;

alias SDL_WindowFlags_ = ulong;
mixin(makeEnumBind(q{SDL_WindowFlags}, q{SDL_WindowFlags_}, members: (){
	EnumMember[] ret = [
		{{q{fullscreen},           q{SDL_WINDOW_FULLSCREEN}},             q{0x0000_0000_0000_0001UL}},
		{{q{openGL},               q{SDL_WINDOW_OPENGL}},                 q{0x0000_0000_0000_0002UL}},
		{{q{occluded},             q{SDL_WINDOW_OCCLUDED}},               q{0x0000_0000_0000_0004UL}},
		{{q{hidden},               q{SDL_WINDOW_HIDDEN}},                 q{0x0000_0000_0000_0008UL}},
		{{q{borderless},           q{SDL_WINDOW_BORDERLESS}},             q{0x0000_0000_0000_0010UL}},
		{{q{resizable},            q{SDL_WINDOW_RESIZABLE}},              q{0x0000_0000_0000_0020UL}},
		{{q{minimized},            q{SDL_WINDOW_MINIMIZED}},              q{0x0000_0000_0000_0040UL}},
		{{q{maximized},            q{SDL_WINDOW_MAXIMIZED}},              q{0x0000_0000_0000_0080UL}},
		{{q{mouseGrabbed},         q{SDL_WINDOW_MOUSE_GRABBED}},          q{0x0000_0000_0000_0100UL}},
		{{q{inputFocus},           q{SDL_WINDOW_INPUT_FOCUS}},            q{0x0000_0000_0000_0200UL}},
		{{q{mouseFocus},           q{SDL_WINDOW_MOUSE_FOCUS}},            q{0x0000_0000_0000_0400UL}},
		{{q{external},             q{SDL_WINDOW_EXTERNAL}},               q{0x0000_0000_0000_0800UL}},
		{{q{modal},                q{SDL_WINDOW_MODAL}},                  q{0x0000_0000_0000_1000UL}},
		{{q{highPixelDensity},     q{SDL_WINDOW_HIGH_PIXEL_DENSITY}},     q{0x0000_0000_0000_2000UL}},
		{{q{mouseCapture},         q{SDL_WINDOW_MOUSE_CAPTURE}},          q{0x0000_0000_0000_4000UL}},
		{{q{mouseRelativeMode},    q{SDL_WINDOW_MOUSE_RELATIVE_MODE}},    q{0x0000_0000_0000_8000UL}},
		{{q{alwaysOnTop},          q{SDL_WINDOW_ALWAYS_ON_TOP}},          q{0x0000_0000_0001_0000UL}},
		{{q{utility},              q{SDL_WINDOW_UTILITY}},                q{0x0000_0000_0002_0000UL}},
		{{q{tooltip},              q{SDL_WINDOW_TOOLTIP}},                q{0x0000_0000_0004_0000UL}},
		{{q{popupMenu},            q{SDL_WINDOW_POPUP_MENU}},             q{0x0000_0000_0008_0000UL}},
		{{q{keyboardGrabbed},      q{SDL_WINDOW_KEYBOARD_GRABBED}},       q{0x0000_0000_0010_0000UL}},
		{{q{vulkan},               q{SDL_WINDOW_VULKAN}},                 q{0x0000_0000_1000_0000UL}},
		{{q{metal},                q{SDL_WINDOW_METAL}},                  q{0x0000_0000_2000_0000UL}},
		{{q{transparent},          q{SDL_WINDOW_TRANSPARENT}},            q{0x0000_0000_4000_0000UL}},
		{{q{notFocusable},         q{SDL_WINDOW_NOT_FOCUSABLE}},          q{0x0000_0000_8000_0000UL}},
	];
	return ret;
}()));

enum{
	SDL_WindowPosUndefinedMask = 0x1FFF_0000U,
	SDL_WindowPosUndefined = SDL_WINDOWPOS_UNDEFINED_DISPLAY(0),
	
	SDL_WINDOWPOS_UNDEFINED_MASK = SDL_WindowPosUndefinedMask,
	SDL_WINDOWPOS_UNDEFINED = SDL_WindowPosUndefined,
}
pragma(inline,true) nothrow @nogc pure @safe{
	int SDL_WINDOWPOS_UNDEFINED_DISPLAY(int x) => SDL_WindowPosUndefinedMask | x;
	bool SDL_WINDOWPOS_ISUNDEFINED(int x) => (x & 0xFFFF_0000) == SDL_WindowPosUndefinedMask;
}

enum{
	SDL_WindowPosCentredMask = 0x2FFF_0000U,
	SDL_WindowPosCentred = SDL_WINDOWPOS_CENTERED_DISPLAY(0),
	
	SDL_WINDOWPOS_CENTRED_MASK = SDL_WindowPosCentredMask,
	SDL_WINDOWPOS_CENTRED = SDL_WindowPosCentred,
	SDL_WINDOWPOS_CENTERED_MASK = SDL_WindowPosCentredMask,
	SDL_WINDOWPOS_CENTERED = SDL_WindowPosCentred,
	SDL_WindowPosCenteredMask = SDL_WindowPosCentredMask,
	SDL_WindowPosCentered = SDL_WindowPosCentred,
}
pragma(inline,true) nothrow @nogc pure @safe{
	int SDL_WINDOWPOS_CENTRED_DISPLAY(int x) => SDL_WindowPosCentredMask | x;
	bool SDL_WINDOWPOS_ISCENTRED(int x) => (x & 0xFFFF0000) == SDL_WindowPosCentredMask;
	
	alias SDL_WINDOWPOS_CENTERED_DISPLAY = SDL_WINDOWPOS_CENTRED_DISPLAY;
	alias SDL_WINDOWPOS_ISCENTERED = SDL_WINDOWPOS_ISCENTRED;
}

mixin(makeEnumBind(q{SDL_FlashOperation}, aliases: [q{SDL_Flash}], members: (){
	EnumMember[] ret = [
		{{q{cancel},          q{SDL_FLASH_CANCEL}}},
		{{q{briefly},         q{SDL_FLASH_BRIEFLY}}},
		{{q{untilFocused},    q{SDL_FLASH_UNTIL_FOCUSED}}},
	];
	return ret;
}()));

struct SDL_GLContextState;
alias SDL_GLContext = SDL_GLContextState*;

alias SDL_EGLDisplay = void*;

alias SDL_EGLConfig = void*;

alias SDL_EGLSurface = void*;

alias SDL_EGLAttrib = ptrdiff_t;

alias SDL_EGLint = int;

extern(C) nothrow{
	alias SDL_EGLAttribArrayCallback = SDL_EGLAttrib function(void* userData);
	alias SDL_EGLIntArrayCallback = SDL_EGLint function(void* userData, SDL_EGLDisplay display, SDL_EGLConfig config);
}

mixin(makeEnumBind(q{SDL_GLAttr}, aliases: [q{SDL_GL}], members: (){
	EnumMember[] ret = [
		{{q{redSize},                     q{SDL_GL_RED_SIZE}}},
		{{q{greenSize},                   q{SDL_GL_GREEN_SIZE}}},
		{{q{blueSize},                    q{SDL_GL_BLUE_SIZE}}},
		{{q{alphaSize},                   q{SDL_GL_ALPHA_SIZE}}},
		{{q{bufferSize},                  q{SDL_GL_BUFFER_SIZE}}},
		{{q{doubleBuffer},                q{SDL_GL_DOUBLEBUFFER}}},
		{{q{depthSize},                   q{SDL_GL_DEPTH_SIZE}}},
		{{q{stencilSize},                 q{SDL_GL_STENCIL_SIZE}}},
		{{q{accumRedSize},                q{SDL_GL_ACCUM_RED_SIZE}}},
		{{q{accumGreenSize},              q{SDL_GL_ACCUM_GREEN_SIZE}}},
		{{q{accumBlueSize},               q{SDL_GL_ACCUM_BLUE_SIZE}}},
		{{q{accumAlphaSize},              q{SDL_GL_ACCUM_ALPHA_SIZE}}},
		{{q{stereo},                      q{SDL_GL_STEREO}}},
		{{q{multiSampleBuffers},          q{SDL_GL_MULTISAMPLEBUFFERS}}},
		{{q{multiSampleSamples},          q{SDL_GL_MULTISAMPLESAMPLES}}},
		{{q{acceleratedVisual},           q{SDL_GL_ACCELERATED_VISUAL}}},
		{{q{retainedBacking},             q{SDL_GL_RETAINED_BACKING}}},
		{{q{contextMajorVersion},         q{SDL_GL_CONTEXT_MAJOR_VERSION}}},
		{{q{contextMinorVersion},         q{SDL_GL_CONTEXT_MINOR_VERSION}}},
		{{q{contextFlags},                q{SDL_GL_CONTEXT_FLAGS}}},
		{{q{contextProfileMask},          q{SDL_GL_CONTEXT_PROFILE_MASK}}},
		{{q{shareWithCurrentContext},     q{SDL_GL_SHARE_WITH_CURRENT_CONTEXT}}},
		{{q{framebufferSRGBCapable},      q{SDL_GL_FRAMEBUFFER_SRGB_CAPABLE}}},
		{{q{contextReleaseBehaviour},     q{SDL_GL_CONTEXT_RELEASE_BEHAVIOUR}}, aliases: [{q{contextReleaseBehavior}, q{SDL_GL_CONTEXT_RELEASE_BEHAVIOR}}]},
		{{q{contextResetNotification},    q{SDL_GL_CONTEXT_RESET_NOTIFICATION}}},
		{{q{contextNoError},              q{SDL_GL_CONTEXT_NO_ERROR}}},
		{{q{floatBuffers},                q{SDL_GL_FLOATBUFFERS}}},
		{{q{eglPlatform},                 q{SDL_GL_EGL_PLATFORM}}},
	];
	return ret;
}()));

alias SDL_GLProfile_ = uint;
mixin(makeEnumBind(q{SDL_GLProfile}, q{SDL_GLProfile_}, aliases: [q{SDL_GLContextProfile}], members: (){
	EnumMember[] ret = [
		{{q{core},             q{SDL_GL_CONTEXT_PROFILE_CORE}},             q{0x0001}},
		{{q{compatibility},    q{SDL_GL_CONTEXT_PROFILE_COMPATIBILITY}},    q{0x0002}},
		{{q{es},               q{SDL_GL_CONTEXT_PROFILE_ES}},               q{0x0004}},
	];
	return ret;
}()));

alias SDL_GLContextFlag_ = uint;
mixin(makeEnumBind(q{SDL_GLContextFlag}, q{SDL_GLContextFlag_}, members: (){
	EnumMember[] ret = [
		{{q{debugFlag},                q{SDL_GL_CONTEXT_DEBUG_FLAG}},                 q{0x0001}},
		{{q{forwardCompatibleFlag},    q{SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG}},    q{0x0002}},
		{{q{robustAccessFlag},         q{SDL_GL_CONTEXT_ROBUST_ACCESS_FLAG}},         q{0x0004}},
		{{q{resetIsolationFlag},       q{SDL_GL_CONTEXT_RESET_ISOLATION_FLAG}},       q{0x0008}},
	];
	return ret;
}()));

alias SDL_GLContextReleaseFlag_ = uint;
mixin(makeEnumBind(q{SDL_GLContextReleaseFlag}, q{SDL_GLContextReleaseFlag_}, aliases: [q{SDL_GLContextReleaseBehaviour}, q{SDL_GLContextReleaseBehavior}, q{SDL_GLcontextReleaseFlag}], members: (){
	EnumMember[] ret = [
		{{q{none},     q{SDL_GL_CONTEXT_RELEASE_BEHAVIOR_NONE}},     q{0x0000}},
		{{q{flush},    q{SDL_GL_CONTEXT_RELEASE_BEHAVIOR_FLUSH}},    q{0x0001}},
	];
	return ret;
}()));

alias SDL_GLContextResetNotification_ = uint;
mixin(makeEnumBind(q{SDL_GLContextResetNotification}, q{SDL_GLContextResetNotification_}, aliases: [q{SDL_GLContextReset}], members: (){
	EnumMember[] ret = [
		{{q{noNotification},    q{SDL_GL_CONTEXT_RESET_NO_NOTIFICATION}},    q{0x0000}},
		{{q{loseContext},       q{SDL_GL_CONTEXT_RESET_LOSE_CONTEXT}},       q{0x0001}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDLProp_Display}, q{const(char)*}, members: (){
	EnumMember[] ret = [
		{{q{hdrEnabledBoolean},               q{SDL_PROP_DISPLAY_HDR_ENABLED_BOOLEAN}},                q{"SDL.display.HDR_enabled"}},
		{{q{kmsDRMPanelOrientationNumber},    q{SDL_PROP_DISPLAY_KMSDRM_PANEL_ORIENTATION_NUMBER}},    q{"SDL.display.KMSDRM.panel_orientation"}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDLProp_WindowCreate}, q{const(char)*}, members: (){
	EnumMember[] ret = [
		{{q{alwaysOnTopBoolean},                 q{SDL_PROP_WINDOW_CREATE_ALWAYS_ON_TOP_BOOLEAN}},                  q{"SDL.window.create.always_on_top"}},
		{{q{borderlessBoolean},                  q{SDL_PROP_WINDOW_CREATE_BORDERLESS_BOOLEAN}},                     q{"SDL.window.create.borderless"}},
		{{q{focusableBoolean},                   q{SDL_PROP_WINDOW_CREATE_FOCUSABLE_BOOLEAN}},                      q{"SDL.window.create.focusable"}},
		{{q{externalGraphicsContextBoolean},     q{SDL_PROP_WINDOW_CREATE_EXTERNAL_GRAPHICS_CONTEXT_BOOLEAN}},      q{"SDL.window.create.external_graphics_context"}},
		{{q{flagsNumber},                        q{SDL_PROP_WINDOW_CREATE_FLAGS_NUMBER}},                           q{"SDL.window.create.flags"}},
		{{q{fullscreenBoolean},                  q{SDL_PROP_WINDOW_CREATE_FULLSCREEN_BOOLEAN}},                     q{"SDL.window.create.fullscreen"}},
		{{q{heightNumber},                       q{SDL_PROP_WINDOW_CREATE_HEIGHT_NUMBER}},                          q{"SDL.window.create.height"}},
		{{q{hiddenBoolean},                      q{SDL_PROP_WINDOW_CREATE_HIDDEN_BOOLEAN}},                         q{"SDL.window.create.hidden"}},
		{{q{highPixelDensityBoolean},            q{SDL_PROP_WINDOW_CREATE_HIGH_PIXEL_DENSITY_BOOLEAN}},             q{"SDL.window.create.high_pixel_density"}},
		{{q{maximisedBoolean},                   q{SDL_PROP_WINDOW_CREATE_MAXIMISED_BOOLEAN}},                      q{"SDL.window.create.maximized"}, aliases: [{q{maximizedBoolean}, q{SDL_PROP_WINDOW_CREATE_MAXIMIZED_BOOLEAN}}]},
		{{q{menuBoolean},                        q{SDL_PROP_WINDOW_CREATE_MENU_BOOLEAN}},                           q{"SDL.window.create.menu"}},
		{{q{metalBoolean},                       q{SDL_PROP_WINDOW_CREATE_METAL_BOOLEAN}},                          q{"SDL.window.create.metal"}},
		{{q{minimisedBoolean},                   q{SDL_PROP_WINDOW_CREATE_MINIMISED_BOOLEAN}},                      q{"SDL.window.create.minimized"}, aliases: [{q{minimizedBoolean}, q{SDL_PROP_WINDOW_CREATE_MINIMIZED_BOOLEAN}}]},
		{{q{modalBoolean},                       q{SDL_PROP_WINDOW_CREATE_MODAL_BOOLEAN}},                          q{"SDL.window.create.modal"}},
		{{q{mouseGrabbedBoolean},                q{SDL_PROP_WINDOW_CREATE_MOUSE_GRABBED_BOOLEAN}},                  q{"SDL.window.create.mouse_grabbed"}},
		{{q{openGLBoolean},                      q{SDL_PROP_WINDOW_CREATE_OPENGL_BOOLEAN}},                         q{"SDL.window.create.opengl"}},
		{{q{parentPointer},                      q{SDL_PROP_WINDOW_CREATE_PARENT_POINTER}},                         q{"SDL.window.create.parent"}},
		{{q{resizableBoolean},                   q{SDL_PROP_WINDOW_CREATE_RESIZABLE_BOOLEAN}},                      q{"SDL.window.create.resizable"}},
		{{q{titleString},                        q{SDL_PROP_WINDOW_CREATE_TITLE_STRING}},                           q{"SDL.window.create.title"}},
		{{q{transparentBoolean},                 q{SDL_PROP_WINDOW_CREATE_TRANSPARENT_BOOLEAN}},                    q{"SDL.window.create.transparent"}},
		{{q{tooltipBoolean},                     q{SDL_PROP_WINDOW_CREATE_TOOLTIP_BOOLEAN}},                        q{"SDL.window.create.tooltip"}},
		{{q{utilityBoolean},                     q{SDL_PROP_WINDOW_CREATE_UTILITY_BOOLEAN}},                        q{"SDL.window.create.utility"}},
		{{q{vulkanBoolean},                      q{SDL_PROP_WINDOW_CREATE_VULKAN_BOOLEAN}},                         q{"SDL.window.create.vulkan"}},
		{{q{widthNumber},                        q{SDL_PROP_WINDOW_CREATE_WIDTH_NUMBER}},                           q{"SDL.window.create.width"}},
		{{q{xNumber},                            q{SDL_PROP_WINDOW_CREATE_X_NUMBER}},                               q{"SDL.window.create.x"}},
		{{q{yNumber},                            q{SDL_PROP_WINDOW_CREATE_Y_NUMBER}},                               q{"SDL.window.create.y"}},
		{{q{cocoaWindowPointer},                 q{SDL_PROP_WINDOW_CREATE_COCOA_WINDOW_POINTER}},                   q{"SDL.window.create.cocoa.window"}},
		{{q{cocoaViewPointer},                   q{SDL_PROP_WINDOW_CREATE_COCOA_VIEW_POINTER}},                     q{"SDL.window.create.cocoa.view"}},
		{{q{waylandSurfaceRoleCustomBoolean},    q{SDL_PROP_WINDOW_CREATE_WAYLAND_SURFACE_ROLE_CUSTOM_BOOLEAN}},    q{"SDL.window.create.wayland.surface_role_custom"}},
		{{q{waylandCreateEGLWindowBoolean},      q{SDL_PROP_WINDOW_CREATE_WAYLAND_CREATE_EGL_WINDOW_BOOLEAN}},      q{"SDL.window.create.wayland.create_egl_window"}},
		{{q{waylandWlSurfacePointer},            q{SDL_PROP_WINDOW_CREATE_WAYLAND_WL_SURFACE_POINTER}},             q{"SDL.window.create.wayland.wl_surface"}},
		{{q{win32HWNDPointer},                   q{SDL_PROP_WINDOW_CREATE_WIN32_HWND_POINTER}},                     q{"SDL.window.create.win32.hwnd"}},
		{{q{win32PixelFormatHWNDPointer},        q{SDL_PROP_WINDOW_CREATE_WIN32_PIXEL_FORMAT_HWND_POINTER}},        q{"SDL.window.create.win32.pixel_format_hwnd"}},
		{{q{x11WindowNumber},                    q{SDL_PROP_WINDOW_CREATE_X11_WINDOW_NUMBER}},                      q{"SDL.window.create.x11.window"}},
	];
	if(sdlVersion >= Version(3,2,18)){
		EnumMember[] add = [
			{{q{constrainPopupBoolean},          q{SDL_PROP_WINDOW_CREATE_CONSTRAIN_POPUP_BOOLEAN}},                q{"SDL.window.create.constrain_popup"}},
		];
		ret ~= add;
	}
	return ret;
}()));

mixin(makeEnumBind(q{SDLProp_Window}, q{const(char)*}, members: (){
	EnumMember[] ret = [
		{{q{shapePointer},                            q{SDL_PROP_WINDOW_SHAPE_POINTER}},                                q{"SDL.window.shape"}},
		{{q{hdrEnabledBoolean},                       q{SDL_PROP_WINDOW_HDR_ENABLED_BOOLEAN}},                          q{"SDL.window.HDR_enabled"}},
		{{q{sdrWhiteLevelFloat},                      q{SDL_PROP_WINDOW_SDR_WHITE_LEVEL_FLOAT}},                        q{"SDL.window.SDR_white_level"}},
		{{q{hdrHeadroomFloat},                        q{SDL_PROP_WINDOW_HDR_HEADROOM_FLOAT}},                           q{"SDL.window.HDR_headroom"}},
		{{q{androidWindowPointer},                    q{SDL_PROP_WINDOW_ANDROID_WINDOW_POINTER}},                       q{"SDL.window.android.window"}},
		{{q{androidSurfacePointer},                   q{SDL_PROP_WINDOW_ANDROID_SURFACE_POINTER}},                      q{"SDL.window.android.surface"}},
		{{q{uikitWindowPointer},                      q{SDL_PROP_WINDOW_UIKIT_WINDOW_POINTER}},                         q{"SDL.window.uikit.window"}},
		{{q{uikitMetalViewTagNumber},                 q{SDL_PROP_WINDOW_UIKIT_METAL_VIEW_TAG_NUMBER}},                  q{"SDL.window.uikit.metal_view_tag"}},
		{{q{uikitOpenGLFramebufferNumber},            q{SDL_PROP_WINDOW_UIKIT_OPENGL_FRAMEBUFFER_NUMBER}},              q{"SDL.window.uikit.opengl.framebuffer"}},
		{{q{uikitOpenGLRenderbufferNumber},           q{SDL_PROP_WINDOW_UIKIT_OPENGL_RENDERBUFFER_NUMBER}},             q{"SDL.window.uikit.opengl.renderbuffer"}},
		{{q{uikitOpenGLResolveFramebufferNumber},     q{SDL_PROP_WINDOW_UIKIT_OPENGL_RESOLVE_FRAMEBUFFER_NUMBER}},      q{"SDL.window.uikit.opengl.resolve_framebuffer"}},
		{{q{kmsDRMDeviceIndexNumber},                 q{SDL_PROP_WINDOW_KMSDRM_DEVICE_INDEX_NUMBER}},                   q{"SDL.window.kmsdrm.dev_index"}},
		{{q{kmsDRMDRMFDNumber},                       q{SDL_PROP_WINDOW_KMSDRM_DRM_FD_NUMBER}},                         q{"SDL.window.kmsdrm.drm_fd"}},
		{{q{kmsDRMGBMDevicePointer},                  q{SDL_PROP_WINDOW_KMSDRM_GBM_DEVICE_POINTER}},                    q{"SDL.window.kmsdrm.gbm_dev"}},
		{{q{cocoaWindowPointer},                      q{SDL_PROP_WINDOW_COCOA_WINDOW_POINTER}},                         q{"SDL.window.cocoa.window"}},
		{{q{cocoaMetalViewTagNumber},                 q{SDL_PROP_WINDOW_COCOA_METAL_VIEW_TAG_NUMBER}},                  q{"SDL.window.cocoa.metal_view_tag"}},
		{{q{openVROverlayID},                         q{SDL_PROP_WINDOW_OPENVR_OVERLAY_ID}},                            q{"SDL.window.openvr.overlay_id"}},
		{{q{vivanteDisplayPointer},                   q{SDL_PROP_WINDOW_VIVANTE_DISPLAY_POINTER}},                      q{"SDL.window.vivante.display"}},
		{{q{vivanteWindowPointer},                    q{SDL_PROP_WINDOW_VIVANTE_WINDOW_POINTER}},                       q{"SDL.window.vivante.window"}},
		{{q{vivanteSurfacePointer},                   q{SDL_PROP_WINDOW_VIVANTE_SURFACE_POINTER}},                      q{"SDL.window.vivante.surface"}},
		{{q{win32HWNDPointer},                        q{SDL_PROP_WINDOW_WIN32_HWND_POINTER}},                           q{"SDL.window.win32.hwnd"}},
		{{q{win32HDCPointer},                         q{SDL_PROP_WINDOW_WIN32_HDC_POINTER}},                            q{"SDL.window.win32.hdc"}},
		{{q{win32InstancePointer},                    q{SDL_PROP_WINDOW_WIN32_INSTANCE_POINTER}},                       q{"SDL.window.win32.instance"}},
		{{q{waylandDisplayPointer},                   q{SDL_PROP_WINDOW_WAYLAND_DISPLAY_POINTER}},                      q{"SDL.window.wayland.display"}},
		{{q{waylandSurfacePointer},                   q{SDL_PROP_WINDOW_WAYLAND_SURFACE_POINTER}},                      q{"SDL.window.wayland.surface"}},
		{{q{waylandViewportPointer},                  q{SDL_PROP_WINDOW_WAYLAND_VIEWPORT_POINTER}},                     q{"SDL.window.wayland.viewport"}},
		{{q{waylandEGLWindowPointer},                 q{SDL_PROP_WINDOW_WAYLAND_EGL_WINDOW_POINTER}},                   q{"SDL.window.wayland.egl_window"}},
		{{q{waylandXDGSurfacePointer},                q{SDL_PROP_WINDOW_WAYLAND_XDG_SURFACE_POINTER}},                  q{"SDL.window.wayland.xdg_surface"}},
		{{q{waylandXDGToplevelPointer},               q{SDL_PROP_WINDOW_WAYLAND_XDG_TOPLEVEL_POINTER}},                 q{"SDL.window.wayland.xdg_toplevel"}},
		{{q{waylandXDGToplevelExportHandleString},    q{SDL_PROP_WINDOW_WAYLAND_XDG_TOPLEVEL_EXPORT_HANDLE_STRING}},    q{"SDL.window.wayland.xdg_toplevel_export_handle"}},
		{{q{waylandXDGPopupPointer},                  q{SDL_PROP_WINDOW_WAYLAND_XDG_POPUP_POINTER}},                    q{"SDL.window.wayland.xdg_popup"}},
		{{q{waylandXDGPositionerPointer},             q{SDL_PROP_WINDOW_WAYLAND_XDG_POSITIONER_POINTER}},               q{"SDL.window.wayland.xdg_positioner"}},
		{{q{x11DisplayPointer},                       q{SDL_PROP_WINDOW_X11_DISPLAY_POINTER}},                          q{"SDL.window.x11.display"}},
		{{q{x11ScreenNumber},                         q{SDL_PROP_WINDOW_X11_SCREEN_NUMBER}},                            q{"SDL.window.x11.screen"}},
		{{q{x11WindowNumber},                         q{SDL_PROP_WINDOW_X11_WINDOW_NUMBER}},                            q{"SDL.window.x11.window"}},
	];
	return ret;
}()));

alias SDL_WindowSurfaceVSync_ = int;
mixin(makeEnumBind(q{SDL_WindowSurfaceVSync}, q{SDL_WindowSurfaceVSync_}, members: (){
	EnumMember[] ret = [
		{{q{disabled},    q{SDL_WINDOW_SURFACE_VSYNC_DISABLED}},    q{ 0}},
		{{q{adaptive},    q{SDL_WINDOW_SURFACE_VSYNC_ADAPTIVE}},    q{-1}},
	];
	return ret;
}()));

mixin(makeEnumBind(q{SDL_HitTestResult}, members: (){
	EnumMember[] ret = [
		{{q{normal},             q{SDL_HITTEST_NORMAL}}},
		{{q{draggable},          q{SDL_HITTEST_DRAGGABLE}}},
		{{q{resizeTopLeft},      q{SDL_HITTEST_RESIZE_TOPLEFT}}},
		{{q{resizeTop},          q{SDL_HITTEST_RESIZE_TOP}}},
		{{q{resizeTopRight},     q{SDL_HITTEST_RESIZE_TOPRIGHT}}},
		{{q{resizeRight},        q{SDL_HITTEST_RESIZE_RIGHT}}},
		{{q{resizeBottomRight},  q{SDL_HITTEST_RESIZE_BOTTOMRIGHT}}},
		{{q{resizeBottom},       q{SDL_HITTEST_RESIZE_BOTTOM}}},
		{{q{resizeBottomLeft},   q{SDL_HITTEST_RESIZE_BOTTOMLEFT}}},
		{{q{resizeLeft},         q{SDL_HITTEST_RESIZE_LEFT}}},
	];
	return ret;
}()));

alias SDL_HitTest = extern(C) SDL_HitTestResult function(SDL_Window* win, const(SDL_Point)* area, void* data) nothrow;

mixin(joinFnBinds((){
	FnBind[] ret = [
		{q{int}, q{SDL_GetNumVideoDrivers}, q{}},
		{q{const(char)*}, q{SDL_GetVideoDriver}, q{int index}},
		{q{const(char)*}, q{SDL_GetCurrentVideoDriver}, q{}},
		{q{SDL_SystemTheme}, q{SDL_GetSystemTheme}, q{}},
		{q{SDL_DisplayID*}, q{SDL_GetDisplays}, q{int* count}},
		{q{SDL_DisplayID}, q{SDL_GetPrimaryDisplay}, q{}},
		{q{SDL_PropertiesID}, q{SDL_GetDisplayProperties}, q{SDL_DisplayID displayID}},
		{q{const(char)*}, q{SDL_GetDisplayName}, q{SDL_DisplayID displayID}},
		{q{bool}, q{SDL_GetDisplayBounds}, q{SDL_DisplayID displayID, SDL_Rect* rect}},
		{q{bool}, q{SDL_GetDisplayUsableBounds}, q{SDL_DisplayID displayID, SDL_Rect* rect}},
		{q{SDL_DisplayOrientation}, q{SDL_GetNaturalDisplayOrientation}, q{SDL_DisplayID displayID}},
		{q{SDL_DisplayOrientation}, q{SDL_GetCurrentDisplayOrientation}, q{SDL_DisplayID displayID}},
		{q{float}, q{SDL_GetDisplayContentScale}, q{SDL_DisplayID displayID}},
		{q{SDL_DisplayMode**}, q{SDL_GetFullscreenDisplayModes}, q{SDL_DisplayID displayID, int* count}},
		{q{bool}, q{SDL_GetClosestFullscreenDisplayMode}, q{SDL_DisplayID displayID, int w, int h, float refreshRate, bool includeHighDensityModes, SDL_DisplayMode* closest}},
		{q{const(SDL_DisplayMode)*}, q{SDL_GetDesktopDisplayMode}, q{SDL_DisplayID displayID}},
		{q{const(SDL_DisplayMode)*}, q{SDL_GetCurrentDisplayMode}, q{SDL_DisplayID displayID}},
		{q{SDL_DisplayID}, q{SDL_GetDisplayForPoint}, q{const(SDL_Point)* point}},
		{q{SDL_DisplayID}, q{SDL_GetDisplayForRect}, q{const(SDL_Rect)* rect}},
		{q{SDL_DisplayID}, q{SDL_GetDisplayForWindow}, q{SDL_Window* window}},
		{q{float}, q{SDL_GetWindowPixelDensity}, q{SDL_Window* window}},
		{q{float}, q{SDL_GetWindowDisplayScale}, q{SDL_Window* window}},
		{q{bool}, q{SDL_SetWindowFullscreenMode}, q{SDL_Window* window, const(SDL_DisplayMode)* mode}},
		{q{const(SDL_DisplayMode)*}, q{SDL_GetWindowFullscreenMode}, q{SDL_Window* window}},
		{q{void*}, q{SDL_GetWindowICCProfile}, q{SDL_Window* window, size_t* size}},
		{q{SDL_PixelFormat}, q{SDL_GetWindowPixelFormat}, q{SDL_Window* window}},
		{q{SDL_Window**}, q{SDL_GetWindows}, q{int* count}},
		{q{SDL_Window*}, q{SDL_CreateWindow}, q{const(char)* title, int w, int h, SDL_WindowFlags_ flags}},
		{q{SDL_Window*}, q{SDL_CreatePopupWindow}, q{SDL_Window* parent, int offsetX, int offsetY, int w, int h, SDL_WindowFlags_ flags}},
		{q{SDL_Window*}, q{SDL_CreateWindowWithProperties}, q{SDL_PropertiesID props}},
		{q{SDL_WindowID}, q{SDL_GetWindowID}, q{SDL_Window* window}},
		{q{SDL_Window*}, q{SDL_GetWindowFromID}, q{SDL_WindowID id}},
		{q{SDL_Window*}, q{SDL_GetWindowParent}, q{SDL_Window* window}},
		{q{SDL_PropertiesID}, q{SDL_GetWindowProperties}, q{SDL_Window* window}},
		{q{SDL_WindowFlags}, q{SDL_GetWindowFlags}, q{SDL_Window* window}},
		{q{bool}, q{SDL_SetWindowTitle}, q{SDL_Window* window, const(char)* title}},
		{q{const(char)*}, q{SDL_GetWindowTitle}, q{SDL_Window* window}},
		{q{bool}, q{SDL_SetWindowIcon}, q{SDL_Window* window, SDL_Surface* icon}},
		{q{bool}, q{SDL_SetWindowPosition}, q{SDL_Window* window, int x, int y}},
		{q{bool}, q{SDL_GetWindowPosition}, q{SDL_Window* window, int* x, int* y}},
		{q{bool}, q{SDL_SetWindowSize}, q{SDL_Window* window, int w, int h}},
		{q{bool}, q{SDL_GetWindowSize}, q{SDL_Window* window, int* w, int* h}},
		{q{bool}, q{SDL_GetWindowSafeArea}, q{SDL_Window* window, SDL_Rect* rect}},
		{q{bool}, q{SDL_SetWindowAspectRatio}, q{SDL_Window* window, float minAspect, float maxAspect}},
		{q{bool}, q{SDL_GetWindowAspectRatio}, q{SDL_Window* window, float* minAspect, float* maxAspect}},
		{q{bool}, q{SDL_GetWindowBordersSize}, q{SDL_Window* window, int* top, int* left, int* bottom, int* right}},
		{q{bool}, q{SDL_GetWindowSizeInPixels}, q{SDL_Window* window, int* w, int* h}},
		{q{bool}, q{SDL_SetWindowMinimumSize}, q{SDL_Window* window, int minW, int minH}},
		{q{bool}, q{SDL_GetWindowMinimumSize}, q{SDL_Window* window, int* w, int* h}},
		{q{bool}, q{SDL_SetWindowMaximumSize}, q{SDL_Window* window, int maxW, int maxH}},
		{q{bool}, q{SDL_GetWindowMaximumSize}, q{SDL_Window* window, int* w, int* h}},
		{q{bool}, q{SDL_SetWindowBordered}, q{SDL_Window* window, bool bordered}},
		{q{bool}, q{SDL_SetWindowResizable}, q{SDL_Window* window, bool resizable}},
		{q{bool}, q{SDL_SetWindowAlwaysOnTop}, q{SDL_Window* window, bool onTop}},
		{q{bool}, q{SDL_ShowWindow}, q{SDL_Window* window}},
		{q{bool}, q{SDL_HideWindow}, q{SDL_Window* window}},
		{q{bool}, q{SDL_RaiseWindow}, q{SDL_Window* window}},
		{q{bool}, q{SDL_MaximizeWindow}, q{SDL_Window* window}},
		{q{bool}, q{SDL_MinimizeWindow}, q{SDL_Window* window}},
		{q{bool}, q{SDL_RestoreWindow}, q{SDL_Window* window}},
		{q{bool}, q{SDL_SetWindowFullscreen}, q{SDL_Window* window, bool fullscreen}},
		{q{bool}, q{SDL_SyncWindow}, q{SDL_Window* window}},
		{q{bool}, q{SDL_WindowHasSurface}, q{SDL_Window* window}},
		{q{SDL_Surface*}, q{SDL_GetWindowSurface}, q{SDL_Window* window}},
		{q{bool}, q{SDL_SetWindowSurfaceVSync}, q{SDL_Window* window, SDL_WindowSurfaceVSync_ vsync}},
		{q{bool}, q{SDL_GetWindowSurfaceVSync}, q{SDL_Window* window, SDL_WindowSurfaceVSync_* vsync}},
		{q{bool}, q{SDL_UpdateWindowSurface}, q{SDL_Window* window}},
		{q{bool}, q{SDL_UpdateWindowSurfaceRects}, q{SDL_Window* window, const(SDL_Rect)* rects, int numRects}},
		{q{bool}, q{SDL_DestroyWindowSurface}, q{SDL_Window* window}},
		{q{bool}, q{SDL_SetWindowKeyboardGrab}, q{SDL_Window* window, bool grabbed}},
		{q{bool}, q{SDL_SetWindowMouseGrab}, q{SDL_Window* window, bool grabbed}},
		{q{bool}, q{SDL_GetWindowKeyboardGrab}, q{SDL_Window* window}},
		{q{bool}, q{SDL_GetWindowMouseGrab}, q{SDL_Window* window}},
		{q{SDL_Window*}, q{SDL_GetGrabbedWindow}, q{}},
		{q{bool}, q{SDL_SetWindowMouseRect}, q{SDL_Window* window, const(SDL_Rect)* rect}},
		{q{const(SDL_Rect)*}, q{SDL_GetWindowMouseRect}, q{SDL_Window* window}},
		{q{bool}, q{SDL_SetWindowOpacity}, q{SDL_Window* window, float opacity}},
		{q{float}, q{SDL_GetWindowOpacity}, q{SDL_Window* window}},
		{q{bool}, q{SDL_SetWindowParent}, q{SDL_Window* window, SDL_Window* parent}},
		{q{bool}, q{SDL_SetWindowModal}, q{SDL_Window* window, bool modal}},
		{q{bool}, q{SDL_SetWindowFocusable}, q{SDL_Window* window, bool focusable}},
		{q{bool}, q{SDL_ShowWindowSystemMenu}, q{SDL_Window* window, int x, int y}},
		{q{bool}, q{SDL_SetWindowHitTest}, q{SDL_Window* window, SDL_HitTest callback, void* callbackData}},
		{q{bool}, q{SDL_SetWindowShape}, q{SDL_Window* window, SDL_Surface* shape}},
		{q{bool}, q{SDL_FlashWindow}, q{SDL_Window* window, SDL_FlashOperation operation}},
		{q{void}, q{SDL_DestroyWindow}, q{SDL_Window* window}},
		{q{bool}, q{SDL_ScreenSaverEnabled}, q{}},
		{q{bool}, q{SDL_EnableScreenSaver}, q{}},
		{q{bool}, q{SDL_DisableScreenSaver}, q{}},
		{q{bool}, q{SDL_GL_LoadLibrary}, q{const(char)* path}},
		{q{SDL_FunctionPointer}, q{SDL_GL_GetProcAddress}, q{const(char)* proc}},
		{q{SDL_FunctionPointer}, q{SDL_EGL_GetProcAddress}, q{const(char)* proc}},
		{q{void}, q{SDL_GL_UnloadLibrary}, q{}},
		{q{bool}, q{SDL_GL_ExtensionSupported}, q{const(char)* extension}},
		{q{void}, q{SDL_GL_ResetAttributes}, q{}},
		{q{bool}, q{SDL_GL_SetAttribute}, q{SDL_GLAttr attr, int value}},
		{q{bool}, q{SDL_GL_GetAttribute}, q{SDL_GLAttr attr, int* value}},
		{q{SDL_GLContext}, q{SDL_GL_CreateContext}, q{SDL_Window* window}},
		{q{bool}, q{SDL_GL_MakeCurrent}, q{SDL_Window* window, SDL_GLContext context}},
		{q{SDL_Window*}, q{SDL_GL_GetCurrentWindow}, q{}},
		{q{SDL_GLContext}, q{SDL_GL_GetCurrentContext}, q{}},
		{q{SDL_EGLDisplay}, q{SDL_EGL_GetCurrentDisplay}, q{}},
		{q{SDL_EGLConfig}, q{SDL_EGL_GetCurrentConfig}, q{}},
		{q{SDL_EGLSurface}, q{SDL_EGL_GetWindowSurface}, q{SDL_Window* window}},
		{q{void}, q{SDL_EGL_SetAttributeCallbacks}, q{SDL_EGLAttribArrayCallback platformAttribCallback, SDL_EGLIntArrayCallback surfaceAttribCallback, SDL_EGLIntArrayCallback contextAttribCallback, void* userData}},
		{q{bool}, q{SDL_GL_SetSwapInterval}, q{int interval}},
		{q{bool}, q{SDL_GL_GetSwapInterval}, q{int* interval}},
		{q{bool}, q{SDL_GL_SwapWindow}, q{SDL_Window* window}},
		{q{bool}, q{SDL_GL_DestroyContext}, q{SDL_GLContext context}},
	];
	return ret;
}()));
