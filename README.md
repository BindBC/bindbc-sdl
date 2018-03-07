# bindbc-sdl
This project provides both static and dynamic bindings to the [Simple Direct Media Library (SDL)](https://libsdl.org/) and its satellite libraries. The dynamic bindings are `@nogc` and `nothrow` compatible and and both types of bindings are configured to always compile with `-betterC`. It is intended as a replacement of [DerelictSDL2](), which is not compatible with `@nogc`,  `nothrow`, or BetterC when configured as a dynamic binding.

## Usage
By default, bindbc-sdl is configured to compile as a dyanmic binding, meaning it has no link-time dependency on the SDL library -- the SDL shared library must be manually loaded at runtime. When using DUB to manage your project, the static binding can be enabled via a DUB `subConfiguration` statement in your project's package file and the minimum required version of SDL can be configured via a `versions` statement in the same file. 

To use any of the supported SDL libraries, add the appropriate package name(s) as a dependency to your project's package config file:

__dub.json__
```
dependencies {
    "bindbc-sdl:sdl": "~>0.1.0",
    "bindbc-sdl:image": "~>0.1.0",
}
```

__dub.sdl__
```
dependency "bindbc-sdl:sdl" version="~>0.1.0"
dependency "bindbc-sdl:image" version="~>0.1.0"
```

Note that all of the satellite library bindings have an implicit dependency upon `bindbc-sdl:sdl`.

### The dynamic binding
The dynamic bindings require no special configuration when using DUB to manage your project. To load the shared libraries, you need to call the appropriate load function.

```d
import bindbc.sdl;

/*
The satellite libraries are optional and are only included here for
demonstration. If they are not being used, they need be neither 
imported nor loaded.
*/
import bindbc.sdl.image;            // SDL_image binding

/*
This version attempts to load the SDL shared library using well-known variations
of the library name for the host system.
*/
if(!loadSDL()) {
    // handle error;
}
/*
This version attempts to load the SDL library using a user-supplied file name. 
Usually, the name and/or path used will be platform specific, as in this example
which attempts to load `SDL2.dll` from the `libs` subdirectory, relative
to the executable, only on Windows.
*/
// version(Windows) loadSDL("libs/SDL2.dll")

/*
The satellite library loaders also have the same two versions of the load functions,
named according to the library name. Only the parameterless versions are shown
here.
*/
loadSDLImage();
```

Note that all of the `load*` functions will return `false` only if the shared library is not found. If any of the functions in the library fail to load, the `load*` functions will _still return true_. It's possible for the binding to be compiled for a higher version of a shared library than the version on the user's system, in which case it's still safe to use the library if none of the missing functions are called.

## The static bindings
The static bindings do not require a manual load at runtime. Instead, they have a link-time dependency on the SDL library and any statellite libraries that are use in the program. Either the static libraries or the shared libraries can be used (i.e. to use the shared libraries, link with the import libraries on Windows and directly with the shared libraries elsewhere). Enabling the static binding can be done in two ways.

### Via the compiler's `-version` switch or DUB's `versions` directive
Pass the `BindBC_Static` version to the compiler and link with the appropriate libraries. 

When using the compiler command line or a build system that doesn't support DUB, this is the only option. The `-version=BindSDL_Static` option should be passed to the compiler when building your program. All of the requried C libraries, as well as the BindBC static libraries, must also be passed to the compiler on the command line or via your build system's configuration. 

When using DUB, its `versions` directive is an option:

__dub.json__
```

```

__dub.sdl__
```
dependency "bindbc-sdl:sdl" version="~>0.1.0"
dependency "bindbc-sdl:image" version="~>0.1.0"
versions "BindSDL_Static"
libs "SDL2" "SDL2_image"
```

### Via DUB subconfigurations
Instead of using DUB's `versions` directive, a `subConfiguration` can be used. Enable the `static` subconfiguration for each of the bindbc-sdl dependencies.

__dub.json__
```

```

__dub.sdl__
```
dependency "bindbc-sdl:sdl" version="~>0.1.0"
dependency "bindbc-sdl:image" version="~>0.1.0"
subConfiguration "bindbc-sdl:sdl" "static"
subConfiguration "bindbc-sdl:image" "static"
```

This will ensure the appropriate `BindBC*_Static` versoins are given to the compiler. It also has the benefit that it completely excludes from the build all of the source modules related to the dynamic bindings, i.e. they will never be passed to the compiler. When using DUB, prefer this approach over the `versions` directive.

## The minimum required SDL version
By default, each bindbc-sdl package is configured to compile bindings for the lowest supported version of the C libraries. This ensures the widest level of compatibility at runtime. This behavior can be overridden via the `-version` compiler switch and the `versions` DUB directive. 

It is recommended that you always select the minimum version you require _and no higher_. In this example, the SDL dynamic binding is compiled to support SDL 2.0.2.

__dub.json__
```

```

__dub.sdl__
```
dependency "bindbc-sdl:sdl" version="~>0.1.0"
dependency "bindbc-sdl:image" version="~>0.1.0"
versions "SDL_202"
```

When you call `loadSDL`, if SDL 2.0.2 or later is installed on the user's system, the library will load without error. Following are the supported versions of each SDL library and the corresponding version IDs to pass to the compiler.

|  Library & Version | Version ID       |
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
|--                  | --               |
|SDL_Image 2.0.0     | Default          |
|SDL_Image 2.0.1     | SDL_Image_201    |
|SDL_Image 2.0.2     | SDL_Image_202    |

__Note__: SDL's [Filesystem](https://wiki.libsdl.org/CategoryFilesystem) API was added in SDL 2.0.1. However, there was a bug on Windows that prevented `SDL_GetPrefPath` from creating the path when it doesn't exist. When using this API on Windows, it's fine to compile with `SDL_201` -- just make sure to ship SDL 2.0.2 or later with your app and _verify_ that [the loaded SDL version](https://wiki.libsdl.org/CategoryVersion) is 2.0.2 or later via the `SDL_GetVersion` function. Alternatively, you can compile your app with version `SDL_202` on Windows and `SDL_201` on other platforms. This will guarantee you have at least SDL 2.0.2 or higher on Windows.