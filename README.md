<div align="center" width="100%">
	<img alt="BindBC-SDL logo" width="50%" src="https://raw.githubusercontent.com/BindBC/bindbc-branding/master/logo_wide_sdl.png"/>
</div>

# BindBC-SDL
This project provides a set of both static and dynamic bindings to
[SDL (Simple DirectMedia Layer)](https://libsdl.org/) and its official extension libraries. They are compatible with `@nogc` and `nothrow`, and can be compiled with BetterC compatibility. This package is intended to replace [DerelictSDL2](https://github.com/DerelictOrg/DerelictSDL2), which does not provide the same level of compatibility.

| Table of Contents |
|-------------------|
|[License](#license)|
|[SDL documentation](#sdl-documentation)|
|[Quickstart guide](#quickstart-guide)|
|[Configurations](#configurations)|
|[Library versions](#library-versions)|
|[Special platforms](#special-platforms)|
|[Windows: Loading from outside the DLL search path](#windows-loading-from-outside-the-dll-search-path)|

## License

BindBC-SDL&mdash;as well as every other binding in the [BindBC project](https://github.com/BindBC)&mdash;is licensed under the [Boost Software License](https://www.boost.org/LICENSE_1_0.txt).

Bear in mind that you still need to abide by [SDL's license](https://github.com/libsdl-org/SDL/blob/main/LICENSE.txt), and the licenses of any SDL_* libraries that you use through these bindings.

## SDL documentation
This readme describes how to use BindBC-SDL, *not* SDL itself. BindBC-SDL is a direct D binding to the SDL API, so any existing SDL documentation and tutorials can be adapted with only minor modifications.
* [The SDL Wiki](https://wiki.libsdl.org/FrontPage) has official documentation of the SDL API.
* [The SDL 2 tutorials from Lazy Foo' Productions](https://lazyfoo.net/tutorials/SDL/index.php) are a good start for those unfamiliar with the API.

> __Note__
>
> The bindings for `SDL_atomics.h` have not been thoroughly tested. If the `SDL_atomics` binding causes trouble and you don't need to use it, you can supply the version identifier `SDL_No_Atomics` and the module's contents will not be compiled. If it's causing trouble and you need it, please report an issue.

## Quickstart guide
To use BindBC-SDL in your dub project, add it to the list of `dependencies` in your dub configuration file. The easiest way is by running `dub add bindbc-sdl` in your project folder. The result should look like this:

Example __dub.json__
```json
"dependencies": {
	"bindbc-sdl": "~>1.4.0",
},
```
Example __dub.sdl__
```sdl
dependency "bindbc-sdl" version="~>1.4.0"
```

By default, BindBC-SDL is configured to compile as a dynamic binding that is not BetterC-compatible. If you prefer static bindings or need BetterC compatibility, they can be enabled via `subConfigurations` in your dub configuration file. For configuration naming & more details, see [Configurations](#configurations).

Example __dub.json__
```json
"subConfigurations": {
	"bindbc-sdl": "staticBC",
},
```
Example __dub.sdl__
```sdl
subConfiguration "bindbc-sdl" "staticBC"
```

If you need to use the SDL_* libraries, or versions of SDL newer than 2.0.0, then you will have to add the appropriate version identifiers to `versions` in your dub configuration. For a list of library version identifiers, see [Library versions](#library-versions).

If using static bindings, then you will also need to add the name of each library you're using to `libs`.

Example __dub.json__
```json
"versions": [
	"SDL_2016", "SDL_Net_200",
],
"libs": [
	"SDL2", "SDL2_net",
],
```
Example __dub.sdl__
```sdl
versions "SDL_2016" "SDL_Net_200"
libs "SDL2" "SDL2_net"
```

**If you're using static bindings**: `import bindbc.sdl` in your code, and then you can use all of SDL just like you would in C. That's it!
```d
import bindbc.sdl;

void main(){
	SDL_Init(SDL_INIT_VIDEO);
	
	//etc.
	
	SDL_Quit();
}
```

**If you're using dynamic bindings**: you need to load each library you need with the appropriate load function. 

For most use cases, it's best to use BindBC-Loader's [error handling API](https://github.com/BindBC/bindbc-loader#error-handling) to see if there were any errors while loading the libraries. This information can be written to a log file before aborting the program.

The load function will also return a member of the `SDLSupport` enum (or equivalent: e.g. `SDLNetSupport` for SDL_net) which can be used for debugging:

* `noLibrary` means the library couldn't be found.
* `badLibrary` means there was an error while loading the library.
* A version number means that SDL was loaded, however this version number currently **does not** correspond to which version of SDL was loaded. Instead, please use `SDL_GetVersion()` for SDL, `IMG_Linked_Version()` for SDL_image, `Mix_Linked_Version()` for SDL_mixer, `SDLNet_Linked_Version()` for SDL_net, or `TTF_Linked_Version()` for SDL_ttf.

Here's a simple example using only the load function's return value:

```d
import bindbc.sdl;

/*
This code attempts to load the SDL shared library using
well-known variations of the library name for the host system.
`sdlSupport` is an `SDLSupport` version corresponding to the
configured library version. (via SDL_204, SDL_2010 etc.)
*/
SDLSupport ret = loadSDL();
if(ret != sdlSupport){
	/*
	Error handling. For most use cases, it's best to use the error handling API in
	BindBC-Loader to retrieve error messages for logging and then abort.
	If necessary, it's possible to determine the root cause via the return value:
	*/
	if(ret == SDLSupport.noLibrary){
		//The SDL shared library failed to load
	}else if(ret == SDLSupport.badLibrary){
		/*
		One or more symbols failed to load. The likely cause is that
		the shared library is for a lower version than BindBC-SDL was
		configured to load.
		*/
	}
}

/*
This code attempts to load the SDL library using a user-supplied file name.
Usually, the name and/or path used will be platform specific, as in this
example which attempts to load `sdl2.dll` from the `libs` subdirectory,
relative to the executable, only on Windows.
*/
version(Windows) loadSDL("libs/sdl2.dll");
```

[The error handling API](https://github.com/BindBC/bindbc-loader#error-handling) in BindBC-Loader can be used to log error messages:
```d
import bindbc.sdl;

/*
Import the sharedlib module for error handling. Assigning an alias ensures that the
function names do not conflict with other public APIs. This isn't strictly necessary,
but the API names are common enough that they could appear in other packages.
*/
import loader = bindbc.loader.sharedlib;

bool loadLib(){
	LoadMsg ret = loadSDL();
	if(ret != sdlSupport){
		//Log the error info
		foreach(info; loader.errors){
			/*
			A hypothetical logging function. Note that `info.error` and
			`info.message` are `const(char)*`, not `string`.
			*/
			logError(info.error, info.message);
		}
		
		//Optionally construct a user-friendly error message for the user
		string msg;
		if(ret == SDLSupport.noLibrary){
			msg = "This application requires the SDL library.";
		}else{
			SDL_version version;
			SDL_GetVersion(&version);
			msg = "Your SDL version is too low: "~
				itoa(version.major)~"."~
				itoa(version.minor)~"."~
				itoa(version.patch)~
				". Please upgrade to 2.0.16+.";
		}
		//A hypothetical message box function
		showMessageBox(msg);
		return false;
	}
	return true;
}
```

## Configurations
BindBC-SDL has the following configurations:

|     ┌      |  DRuntime  |   BetterC   |
|-------------|------------|-------------|
| **Dynamic** | `dynamic`  | `dynamicBC` |
| **Static**  | `static`   | `staticBC`  |

For projects that don't use dub, if BindBC-SDL is compiled for static bindings then the version identifier `BindSDL_Static` must be passed to your compiler when building your project.

> __Note__
>
> The version identifier `BindBC_Static` can be used to configure all of the _official_ BindBC packages used in your program. (i.e. those maintained in [the BindBC GitHub organization](https://github.com/BindBC)) Some third-party BindBC packages may support it as well.

### Dynamic bindings
The dynamic bindings have no link-time dependency on the SDL libraries, so the SDL shared libraries must be manually loaded at runtime from the shared library search path of the user's system.
On Windows, this is typically handled by distributing the SDL DLLs with your program.
On other systems, it usually means installing the SDL shared libraries through a package manager.

It is recommended that you always select the minimum version you require _and no higher_.
If a lower version is loaded then it's still possible to call functions available in that lower version, but any calls to functions from versions between that version and the one you configured will result in a null pointer access.
For example, if you configured SDL to 2.0.4 (`SDL_204`) but loaded SDL 2.0.2 at runtime, then any function pointers from 2.0.3 and 2.0.4 will be `null`. For this reason, it's recommended to always specify your required version of the SDL library at compile time and unconditionally abort when you receive an `SDLSupport.badLibrary` return value from `loadSDL` (or equivalent).

The function `isSDLLoaded` returns `true` if any version of the shared library has been loaded and `false` if not. `unloadSDL` can be used to unload a successfully loaded shared library. The SDL_* libraries provide similar functions: `isSDLImageLoaded`, `unloadSDLImage`, etc.

### Static bindings
Static _bindings_ do not require static _linking_. The static bindings have a link-time dependency on either the shared _or_ static SDL libraries and any satellite SDL libraries the program uses. On Windows, you can link with the static libraries or, to use the DLLs, the import libraries. On other systems, you can link with either the static libraries or directly with the shared libraries.

When linking with the shared (or import) libraries, there is a runtime dependency on the shared library just as there is when using the dynamic bindings. The difference is that the shared libraries are no longer loaded manually&mdash;loading is handled automatically by the system when the program is launched. Attempting to call `loadSDL` with the static bindings enabled will result in a compilation error.

Static linking requires the SDL development packages be installed on your system. The [SDL download page](https://www.libsdl.org/download-2.0.php) provides development packages for Windows and macOS. You can also install them via your system's package manager. For example, on Debian-based Linux distributions `sudo apt install libsdl2-dev` will install both the development and runtime packages.

When linking with the static libraries, there is no runtime dependency on SDL. The SDL homepage does not distribute pre-compiled static libraries. If you decide to obtain static libraries from another source (usually by compiling them yourself) you will also need to ensure that you link with all of SDL's link-time dependencies (such as the OpenGL library and system API libraries).

## Library Versions
These are the supported versions of each SDL_* library, along with the corresponding version identifiers to add to your dub configuration or pass to the compiler.

> __Note__
>
> If you have `SDL_THREAD_SAFETY_ANALYSIS` support enabled in SDL, you may use version identifier `SDL_ThreadSafetyAnalysis`.

> __Note__
>
> It is necessary to specify only a single version identifier per library. For example, `SDL_Image_204` by itself will activate the SDL_image binding.
>
> Previously, there were identifiers for the SDL_* libraries with no version. (`SDL_Image`, `SDL_TTF`, etc.) These are are now deprecated due to their ambiguity and older projects are encouraged to remove them.

<details>
	<summary><h3>SDL versions</h3></summary>

| Version     |Version identifier|
|-------------|------------------|
| 2.0.0       | (none; default)  |
| 2.0.1       | `SDL_201`        |
| 2.0.2       | `SDL_202`        |
| 2.0.3       | `SDL_203`        |
| 2.0.4       | `SDL_204`        |
| 2.0.5       | `SDL_205`        |
| 2.0.6       | `SDL_206`        |
| 2.0.7       | `SDL_207`        |
| 2.0.8       | `SDL_208`        |
| 2.0.9       | `SDL_209`        |
| 2.0.10      | `SDL_2010`       |
| 2.0.12      | `SDL_2012`       |
| 2.0.14      | `SDL_2014`       |
| 2.0.16      | `SDL_2016`       |
| 2.0.18      | `SDL_2018`       |
| 2.0.20      | `SDL_2020`       |
| 2.0.22      | `SDL_2022`       |
| 2.24.X      | `SDL_2_24`       |
| 2.26.X      | `SDL_2_26`       |
| 2.28.X      | `SDL_2_28`       |

> __Warning__
>
> SDL 2.0.1 on Windows had a bug preventing `SDL_GetPrefPath` from creating a folder when it doesn't exist. It's fine to compile with `SDL_201`, but make sure to ship your app with 2.0.2 or later on Windows and _verify_ that the [linked version](https://wiki.libsdl.org/CategoryVersion) is 2.0.2 or later with `SDL_GetVersion`. Alternatively, compile with `SDL_202` on Windows but `SDL_201` on other platforms, thereby guaranteeing an error on Windows if the user doesn't have SDL 2.0.2 or higher.

> __Note__
>
> Starting from SDL 2.0.10, all even-numbered versions are releases, while all odd-numbered versions are pre-releases—which are not for general use and therefore not supported by BindBC-SDL.
</details>

<details>
	<summary><h3>SDL_image versions</h3></summary>

| Version |Version identifier| Public API changed |
|---------|------------------|--------------------|
| 2.0.0   | `SDL_Image_200`  |                    |
| 2.0.1   | `SDL_Image_201`  | :x:                |
| 2.0.2   | `SDL_Image_202`  | :heavy_check_mark: |
| 2.0.3   | `SDL_Image_203`  | :x:                |
| 2.0.4   | `SDL_Image_204`  | :x:                |
| 2.0.5   | `SDL_Image_205`  | :x:                |
| 2.6.X   | `SDL_Image_2_6`  | :heavy_check_mark: |

> __Note__
>
> Starting from SDL_image 2.6.X, all even-numbered versions are releases, while all odd-numbered versions are pre-releases—which are not for general use and therefore not supported by BindBC-SDL.
</details>

<details>
	<summary><h3>SDL_mixer versions</h3></summary>

| Version |Version identifier| Public API changed |
|---------|------------------|--------------------|
| 2.0.0   | `SDL_Mixer_200`  |                    |
| 2.0.1   | `SDL_Mixer_201`  | :heavy_check_mark: |
| 2.0.2   | `SDL_Mixer_202`  | :heavy_check_mark: |
| 2.0.4   | `SDL_Mixer_204`  | :heavy_check_mark: |
| 2.6.X   | `SDL_Mixer_2_6`  | :heavy_check_mark: |

> __Note__
>
> Starting from SDL_mixer 2.0.4, all even-numbered versions are releases, while all odd-numbered versions are pre-releases—which are not for general use and therefore not supported by BindBC-SDL.
</details>

<details>
	<summary><h3>SDL_net versions</h3></summary>
<background>

| Version |Version identifier| Public API changed |
|---------|------------------|--------------------|
| 2.0.0   | `SDL_Net_200`    |                    |
| 2.0.1   | `SDL_Net_201`    | :x:                |
| 2.2.X   | `SDL_Net_2_2`    | :x:                |

> __Note__
>
> Starting from SDL_net 2.2.X, all even-numbered versions are releases, while all odd-numbered versions are pre-releases—which are not for general use and therefore not supported by BindBC-SDL.
</details>

<details>
	<summary><h3>SDL_ttf versions</h3></summary>

| Version |Version identifier| Public API changed |
|---------|------------------|--------------------|
| 2.0.12  | `SDL_TTF_2012`   |                    |
| 2.0.13  | `SDL_TTF_2013`   | :x:                |
| 2.0.14  | `SDL_TTF_2014`   | :heavy_check_mark: |
| 2.0.15  | `SDL_TTF_2015`   | :x:                |
| 2.0.18  | `SDL_TTF_2018`   | :heavy_check_mark: |
| 2.20.X  | `SDL_TTF_2_20`   | :heavy_check_mark: |

> __Note__
>
> Starting from SDL_ttf 2.0.18, all even-numbered versions are releases, while all odd-numbered versions are pre-releases—which are not for general use and therefore not supported by BindBC-SDL.
</details>

## Special platforms
Some platforms do not have [pre-defined versions in D](https://dlang.org/spec/version.html#predefined-versions), meaning that BindBC-SDL has to use custom version identifiers for them.
If you intend to compile for any of these platforms, please add the corresponding version identifier(s) in your dub recipe's `versions` list, or supply them directly to the compiler.

> __Note__
>
> If you're building on Wayland and you have X11 support disabled in SDL, please add version identifier `SDL_NoX11`.

| Platform                       | Version identifier |
|--------------------------------|--------------------|
| DirectFB                       | `DirectFB`         |
| KMS/DRM                        | `KMSDRM`           |
| Mir-server                     | `Mir`              |
| Operating System/2             | `OS2`              |
| Vivante                        | `Vivante`          |
| Microsoft Game Development Kit | `WinGDK`           |
| Windows Runtime                | `WinRT`            |

## Windows: Loading from outside the DLL search path
The SDL libraries load some dependency DLLs dynamically in the same way that BindBC can load libraries dynamically. There is an issue that can arise on Windows when putting some of the SDL DLLs in a subdirectory of your executable directory. That is, if your executable is (for example) in the directory `myapp`, and the SDL DLLs are in the directory `myapp\libs`, you may find that one or more of the SDL libraries fails to load. To solve or prevent this problem, take the following steps:

First, make sure the non-system libraries on which the SDL libraries depend (such as `zlib.dll`) are in the same directory as the SDL libraries.

Second, you'll want to add your subdirectory path to the Windows DLL search path. This can be accomplished via the function `setCustomLoaderSearchPath` in `BindBC-Loader`. For more details, see ["Default Windows search path"](https://github.com/BindBC/bindbc-loader#default-windows-search-path) from the BindBC-Loader readme.

The idea is that you call the function with the path to all of the DLLs before calling any of the load functions, then call it again with a `null` argument to reset to the default search path. Bear in mind that some of the SDL_* libraries load their dependencies lazily. For example, SDL_image will only load `libpng` when `IMG_Init` is called with the `IMG_INIT_PNG` flag, so the second call should not occur until after the libraries have been initialised.

```d
import bindbc.loader,
	bindbc.sdl;

// Assume the DLLs are stored in the "dlls" subdirectory
version(Windows) setCustomLoaderSearchPath("dlls");

if(loadSDL() < sdlSupport) { /* handle error */ }
if(loadSDLImage() < sdlImageSupport) { /* handle error */ }

// Give SDL_image a chance to load libpng and libjpeg
auto flags = IMG_INIT_PNG | IMG_INIT_JPEG;
if(IMG_Init(flags) != flags) { /* handle error */ }

// Now reset the default loader search path
version(Windows) setCustomLoaderSearchPath(null);
```

It is not strictly necessary to reset the default search path, but doing so can avoid unexpected issues for any other dependencies that may be loaded dynamically by an application's process.

`setCustomLoaderSearchPath` is only implemented on Windows. I know of no way to programmatically manipulate the default search path on Linux or other platforms (please correct me if I'm wrong). Then again, this issue doesn't generally arise on those platforms.
