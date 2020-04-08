# bindbc-sdl
This project provides both static and dynamic bindings to the [Simple Direct Media Library (SDL)](https://libsdl.org/) and its satellite libraries. They are compatible with `@nogc` and `nothrow` and can be compiled with `-betterC` compatibility. This package is intended as a replacement of [DerelictSDL2](https://github.com/DerelictOrg/DerelictSDL2), which does not provide the same level of compatibility.

## Usage
By default, `bindbc-sdl` is configured to compile as dynamic bindings that are not `-betterC` compatible. The dynamic bindings have no link-time dependency on the SDL libraries, so the SDL shared libraries must be manually loaded at runtime. When configured as static bindings, there is a link-time dependency on the SDL libraries -- either the static libraries or the appropriate files for linking with shared libraries on your system (see below).

When using DUB to manage your project, the static bindings can be enabled via a DUB `subConfiguration` statement in your project's package file. `-betterC` compatibility is also enabled via subconfigurations.

To use any of the supported SDL libraries, add `bindbc-sdl` as a dependency to your project's package config file and include the appropriate version for any of the satellite libraries you want to use. For example, the following is configured to use `SDL_image` and `SDL_ttf` in addition to the base SDL binding, as dynamic bindings that are not `-betterC` compatible:

__dub.json__
```
dependencies {
    "bindbc-sdl": "~>0.1.0",
}
"versions": [
    "BindSDL_Image",
    "BindSDL_TTF"
],
```

__dub.sdl__
```
dependency "bindbc-sdl" version="~>0.1.0"
versions "BindSDL_Image" "BindSDL_TTF"
```

### The dynamic bindings
The dynamic bindings require no special configuration when using DUB to manage your project. There is no link-time dependency. At runtime, the SDL shared libraries are required to be on the shared library search path of the user's system. On Windows, this is typically handled by distributing the SDL DLLs with your program. On other systems, it usually means installing the SDL runtime libraries through a package manager.

To load the shared libraries, you need to call the appropriate load function. The load functions return a binding-specific value indicating either that the library failed to load (it couldn't be found), one or more symbols failed to load, or a version number that matches a global enum value based on the compile-time configuration.

```d
import bindbc.sdl;

/*
The satellite libraries are optional and are only included here for
demonstration. If they are not being used, they need be neither
imported nor loaded.
*/
import bindbc.sdl.image;            // SDL_image binding
import bindbc.sdl.mixer;            // SDL_mixer binding
import bindbc.sdl.ttf;              // SDL_ttf binding

/*
This version attempts to load the SDL shared library using well-known variations
of the library name for the host system.
*/
SDLSupport ret = loadSDL();
if(ret != sdlSupport) {
    // Handle error. For most use cases, this is enough. The error handling API in
    // bindbc-loader can be used for error messages. If necessary, it's  possible
    // to determine the primary cause programmtically:

    if(ret == SDLSupport.noLibrary) {
        // SDL shared library failed to load
    }
    else if(SDLSupport.badLibrary) {
        // One or more symbols failed to load. The likely cause is that the
        // shared library is for a lower version than bindbc-sdl was configured
        // to load (via SDL_201, SDL_202, etc.)
    }
}
/*
This version attempts to load the SDL library using a user-supplied file name.
Usually, the name and/or path used will be platform specific, as in this example
which attempts to load `SDL2.dll` from the `libs` subdirectory, relative
to the executable, only on Windows. It has the same return values.
*/
// version(Windows) loadSDL("libs/SDL2.dll")

/*
The satellite library loaders also have the same two versions of the load functions,
named according to the library name. Only the parameterless versions are shown
here. These return similar values as loadSDL, but in an enum namespace that matches
the library name: SDLImageSupport, SDLMixerSupport, and SDLTTFSupport.
*/
if(loadSDLImage() != sdlImageSupport) {
    /* handle error */
}
if(loadSDLMixer() != sdlMixerSupport) {
    /* handle error */
}
if(loadSDLTTF() != sdlTTFSupport) {
    /* handle error */
}
```
By default, each `bindbc-sdl` binding is configured to compile bindings for the lowest supported version of the C libraries. This ensures the widest level of compatibility at runtime. This behavior can be overridden via the `-version` compiler switch or the `versions` DUB directive.

It is recommended that you always select the minimum version you require _and no higher_. In this example, the SDL dynamic binding is compiled to support SDL 2.0.4.

__dub.json__
```
"dependencies": {
    "bindbc-sdl": "~>0.1.0"
},
"versions": ["SDL_204"]
```

__dub.sdl__
```
dependency "bindbc-sdl" version="~>0.1.0"
versions "SDL_204"
```

When `bindbc-sdl` is configured with `SDL_202`, then `sdlSupport == SDLSupport.sdl202` and `loadSDL` will return `SDLSupport.sdl202` on a successful load. However, it's possible for the binding to be compiled for a higher version of SDL than that on the user's system. In that
case, `loadSDL` will return `SDLSupport.badLibrary`. It's still possible to use that version of the library as long as you remember not to call any of the unloaded functions from the higher version. To determine the version actually loaded, call the function `loadedSDLVersion`.
The function `isSDLLoaded` returns `true` if any version of the shared library has been loaded and `false` if not. (See [the README for `bindbc.loader`](https://github.com/BindBC/bindbc-loader/blob/master/README.md) for the error handling API.)

```d
SDLSupport ret = loadSDL();
if(ret != sdlSupport) {
    if(SDLSupport.badLibrary) {
        // Let's say we've configured to support SDL 2.0.5, but we are happy to also
        // support 2.0.4:
        if(loadedSDLVersion < SDLSupport.sdl204) {
            // Version to low. Handle the error.
        }
    }
    else {
        // No library. Handle the error.
    }
}
```

The satellite libraries provide similar functions: `loadedSDLImageVersion`, `loadedSDLMixerVersion`, and `loadedSDLTTFVersion`.

Following are the supported versions of each SDL library and the corresponding version IDs to pass to the compiler.



| Library & Version  | Version ID       |
|--------------------|------------------|
|SDL 2.0.0           | Default          |
|SDL 2.0.1           | SDL_201          |
|SDL 2.0.2           | SDL_202          |
|SDL 2.0.3           | SDL_203          |
|SDL 2.0.4           | SDL_204          |
|SDL 2.0.5           | SDL_205          |
|SDL 2.0.6           | SDL_206          |
|SDL 2.0.7           | SDL_207          |
|SDL 2.0.8           | SDL_208          |
|SDL 2.0.9           | SDL_209          |
|SDL 2.0.10          | SDL_2010         |
|SDL 2.0.12          | SDL_2012         |
|--                  | --               |
|SDL_image 2.0.0     | Default          |
|SDL_image 2.0.1     | SDL_Image_201    |
|SDL_image 2.0.2     | SDL_Image_202    |
|SDL_image 2.0.3     | SDL_Image_203    |
|SDL_image 2.0.4     | SDL_Image_204    |
|SDL_image 2.0.5     | SDL_Image_205    |
|--                  | --               |
|SDL_mixer 2.0.0     | Default          |
|SDL_mixer 2.0.1     | SDL_Mixer_201    |
|SDL_mixer 2.0.2     | SDL_Mixer_202    |
|SDL_mixer 2.0.4     | SDL_Mixer_204    |
|--                  | --               |
|SDL_ttf 2.0.12      | Default          |
|SDL_ttf 2.0.13      | SDL_TTF_2013     |
|SDL_ttf 2.0.14      | SDL_TTF_2014     |

__Note__: Beginning with SDL 2.0.10, all releases have even numbered (2.0.12, 2.0.14, etc.). Odd number versions beginning with 2.0.11 are development versions, which are not supported by `bindbc-sdl`. The same is true for SDL_mixer beginning with version 2.0.4 (there is no public release of SDL_mixer 2.0.3).

__Note__: There are no differences in the public API between SDL_image versions 2.0.0 and 2.0.1, and then between versions 2.0.2, 2.0.3, 2.0.4, and 2.0.5, other than the value of `SDL_IMAGE_PATCHLEVEL`.

__Note__: SDL's [Filesystem](https://wiki.libsdl.org/CategoryFilesystem) API was added in SDL 2.0.1. However, there was a bug on Windows that prevented `SDL_GetPrefPath` from creating the path when it doesn't exist. When using this API on Windows, it's fine to compile with `SDL_201` -- just make sure to ship SDL 2.0.2 or later with your app on Windows and _verify_ that [the loaded SDL version](https://wiki.libsdl.org/CategoryVersion) is 2.0.2 or later via the `SDL_GetVersion` function. Alternatively, you can compile your app with version `SDL_202` on Windows and `SDL_201` on other platforms, thereby guaranteeing errors if the user does not have at least SDL 2.0.2 or higher on Windows.

## The static bindings
The static bindings have a link-time dependency on either the shared or static libraries for SDL and any satellite SDL libraries the program uses. On Windows, you can link with the static libraries or, to use the DLLs, the import libraries. On other systems, you can link with either the static libraries or directly with the shared libraries.

This requires the SDL development packages be installed on your system at compile time. When linking with the static libraries, there is no runtime dependency on SDL. When linking with the shared libraries, the runtime dependency is the same as the dynamic bindings, the difference being that the shared libraries are no longer loaded manually -- loading is handled automatically by the system when the program is launched.

Enabling the static bindings can be done in two ways.

### Via the compiler's `-version` switch or DUB's `versions` directive
Pass the `BindSDL_Static` version to the compiler and link with the appropriate libraries. Note that `BindSDL_Static` will also enable the static binding for any satellite libraries used.

When using the compiler command line or a build system that doesn't support DUB, this is the only option. The `-version=BindSDL_Static` option should be passed to the compiler when building your program. All of the required C libraries, as well as the `bindbc-sdl` and `bindbc-loader` static libraries, must also be passed to the compiler on the command line or via your build system's configuration.

When using DUB, its `versions` directive is an option. For example, when using the static bindings for SDL and SDL_image:

__dub.json__
```
"dependencies": {
    "bindbc-sdl": "~>0.1.0"
},
"versions": ["BindSDL_Static", "BindSDL_Image"],
"libs": ["SDL2", "SDL2_image"]
```

__dub.sdl__
```
dependency "bindbc-sdl" version="~>0.1.0"
versions "BindSDL_Static" "BindSDL_Image"
libs "SDL2" "SDL2_image"
```

### Via DUB subconfigurations
Instead of using DUB's `versions` directive, a `subConfiguration` can be used. Enable the `static` subconfiguration for the `bindbc-sdl` dependency:

__dub.json__
```
"dependencies": {
    "bindbc-sdl": "~>0.1.0"
},
"subConfigurations": {
    "bindbc-sdl": "static"
},
"versions": [
    "BindSDL_Image"
],
"libs": ["SDL2", "SDL2_image"]
```

__dub.sdl__
```
dependency "bindbc-sdl" version="~>0.1.0"
subConfiguration "bindbc-sdl" "static"
versions "BindSDL_Image"
libs "SDL2" "SDL2_image"
```

This has the benefit that it completely excludes from the build any source modules related to the dynamic bindings, i.e. they will never be passed to the compiler.

## `-betterC` support

`-betterC` support is enabled via the `dynamicBC` and `staticBC` subconfigurations, for dynamic and static bindings respectively. To enable the static bindings with `-betterC` support:

__dub.json__
```
"dependencies": {
    "bindbc-sdl": "~>0.1.0"
},
"subConfigurations": {
    "bindbc-sdl": "staticBC"
},
"versions": [
    "BindSDL_Image"
],
"libs": ["SDL2", "SDL2_image"]
```

__dub.sdl__
```
dependency "bindbc-sdl" version="~>0.1.0"
subConfiguration "bindbc-sdl" "staticBC"
versions "BindSDL_Image"
libs "SDL2" "SDL2_image"
```

When not using DUB to manage your project, first use DUB to compile the BindBC libraries with the `dynamicBC` or `staticBC` configuration, then pass `-betterC` to the compiler when building your project.

## Known Issues
The SDL libraries tend to load dependent DLLs dynamically in the same way that BindBC loads libraries dynamically. Due to the way it goes about it, there is an issue that can arise on Windows when putting some of the SDL DLLs in a subdirectory of your executable directory. That is, if your executable is in e.g., the directory `myapp`, and the SDL DLLs are in e.g., the directory `myapp\libs`, you may encounter find that one or more of the SDL libraries fail to load.

First, make sure the non-system libraries on which the SDL libraries depend (such as `zlib.dll`) are in the same directory as the SDL libraries. Then, you'll want to add your subdirectory path to the Windows DLL search path. This is done via the `SetDLLDirectory` function. You can make this function available by importing `core.sys.windows` and adding `Windows7` to your list of versions in your `dub.sdl/json` or on the compiler command line with `-version`.

Assuming the `lib` subdirectory, the code looks like this:

```d
version(Windows) {
    import core.sys.windows;
    void myLoadSDL() {
        // Add the lib subdirectory to the DLL search path
        SetDLLDirectoryA(".\\lib");

        // Load all the SDL libraries you need
        loadSDL("libs\\SDL2.dll");
        loadSDLTTF("libs\\SDL2_ttf.dll");
        ...

        // Reset the DLL search path to the default
        SetDLLDirectoryA(null);
    }
}
```

For robustness, the paths you pass to `SetDLLDirectoryA` and in the `load*` functions should account for the case when the application is opened in a working directory that is not the same as the executable directory. (This is true for any relative paths from which you load resources.) If `Runtime.args[0]` (from `core.runtime`) is simply the application name with no path, then you need do nothing more. If it contains a path, you can strip the application name from it and append the relative path to your libraries. Use the result in the function calls.


