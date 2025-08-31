<h1 align="center" width="100%"><a href="https://git.sleeping.town/BindBC/bindbc-sdl">
	<img alt="BindBC-SDL logo" width="50%" src="https://git.sleeping.town/BindBC/bindbc-branding/media/branch/trunk/logo_wide_sdl.png"/>
</a></h1>

[Official git repository](https://git.sleeping.town/BindBC/bindbc-sdl)

This project provides a set of both static and dynamic bindings to
[SDL3 (Simple DirectMedia Layer)](https://libsdl.org/) and its official extension libraries. They are compatible with `@nogc` and `nothrow`, and can be compiled with BetterC compatibility.

If you still need SDL2 bindings, they are available in the [SDL2](https://git.sleeping.town/BindBC/bindbc-sdl/src/branch/SDL2) branch with versions tagged 1.X.X.

| Table of Contents |
|-------------------|
|[License](#license)|
|[SDL documentation](#sdl-documentation)|
|[Quickstart guide](#quickstart-guide)|
|[Binding-specific changes](#binding-specific-changes)|
|[Configurations](#configurations)|
|[Library versions](#library-versions)|
|[Special platforms](#special-platforms)|
|[Gesture API](#gesture-api)|
|[Entry points](#entry-points)|

## License
BindBC-SDL&mdash;as well as every other binding in the [BindBC project](https://git.sleeping.town/BindBC)&mdash;is licensed under the [Boost Software License](https://www.boost.org/LICENSE_1_0.txt).

Bear in mind that you still need to abide by [SDL's license](https://github.com/libsdl-org/SDL/blob/main/LICENSE.txt), and the licenses of any SDL_* libraries that you use through these bindings.

## SDL documentation
This readme describes how to use BindBC-SDL, *not* SDL itself. BindBC-SDL is a direct D binding to the SDL3 API, so any existing SDL 3documentation and tutorials can be adapted with only minor modifications.
* [The SDL Wiki](https://wiki.libsdl.org/SDL3/APIByCategory) has official documentation of the SDL API. It also has [a list of tutorials](https://wiki.libsdl.org/SDL3/Tutorials).
* [Layers All The Way Down](https://moonside.games/posts/layers-all-the-way-down/) has a broad explanation of rendering and SDL3's GPU API.
* [How to migrate from SDL 2.0](https://github.com/libsdl-org/SDL/blob/main/docs/README-migration.md).
* [Lazy Foo' Productions' SDL3 tutorials](https://lazyfoo.net/tutorials/SDL3/index.php) are aimed at C++ programmers, and give a good overview of the SDL3 API.

## Quickstart guide
To use BindBC-SDL in your dub project, add it to the list of `dependencies` in your dub configuration file. The easiest way is by running `dub add bindbc-sdl` in your project folder. The result should look like this:

Example __dub.json__
```json
"dependencies": {
	"bindbc-sdl": "~>2.0",
},
```
Example __dub.sdl__
```sdl
dependency "bindbc-sdl" version="~>2.0"
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

If you need to use the SDL_* libraries, or versions of SDL newer than 3.2.0, then you will have to add the appropriate version identifiers to `versions` in your dub configuration. For a list of library version identifiers, see [Library versions](#library-versions).

If you're using static bindings, then you will also need to add the name of each library you're using to `libs`.

Example __dub.json__
```json
"versions": [
	"SDL_3_4", "SDL_Net_3_0",
],
"libs": [
	"SDL3", "SDL3_net",
],
```
Example __dub.sdl__
```sdl
versions "SDL_3_4" "SDL_Net_3_0"
libs "SDL3" "SDL3_net"
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

**If you're using dynamic bindings**: you need to load each library you need with the appropriate load function:
| Function           | Library        |
|--------------------|----------------|
|`loadSDL`           | SDL            |
|`loadSDLImage`      | SDL_image      |
|`loadSDLMixer`      | SDL_mixer      |
|`loadSDLNet`        | SDL_net        |
|`loadSDLTTF`        | SDL_ttf        |
|`loadSDLShaderCross`| SDL_shadercross|

For most use cases, it's best to use BindBC-Loader's [error handling API](https://git.sleeping.town/BindBC/bindbc-loader#error-handling) to see if there were any errors while loading the libraries. This information can be written to a log file before aborting the program.

The load function will also return a member of the `LoadMsg` enum, which can be used for debugging:

- `noLibrary` means the library couldn't be found.
- `badLibrary` means there was an error while loading the library.
- `success` means that the library was loaded without any errors.

You should also check that the desired minimum version of the library was loaded with the appropriate function:
| Function              | Library        |
|-----------------------|----------------|
|`SDL_GetVersion`       | SDL            |
|`IMG_Version`          | SDL_image      |
|`Mix_Version`          | SDL_mixer      |
|`SDLNet_Version`       | SDL_net        |
|`TTF_Version`          | SDL_ttf        |

Unfortunately SDL_shadercross does not provide a function for this.

Here's a simple example using only the load function's return value:

```d
import bindbc.sdl;
import bindbc.loader;

/*
This code attempts to load the SDL shared library using
well-known variations of the library name for the host system.
*/
LoadMsg ret = loadSDL();
if(ret != LoadMsg.success){
	/*
	Error handling. For most use cases, it's best to use the error handling API in
	BindBC-Loader to retrieve error messages for logging and then abort.
	If necessary, it's possible to determine the root cause via the return value:
	*/
	if(ret == LoadMsg.noLibrary){
		//The SDL shared library failed to load
	}else if(ret == LoadMsg.badLibrary){
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
example which attempts to load `sdl3.dll` from the `libs` subdirectory,
relative to the executable, only on Windows.
*/
version(Windows) loadSDL("libs/sdl3.dll");
```

[The error handling API](https://git.sleeping.town/BindBC/bindbc-loader#error-handling) in BindBC-Loader can be used to log error messages:
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
	if(ret != LoadMsg.success){
		//Log the error info
		foreach(info; loader.errors){
			/*
			A hypothetical logging function. Note that `info.error` and
			`info.message` are null-terminated `const(char)*`, not `string`.
			*/
			logError(info.error, info.message);
		}
		
		//Optionally construct a user-friendly error message for the user
		string msg;
		if(ret == LoadMsg.noLibrary){
			msg = "This application requires the SDL library.";
		}else{
			SDL_version version_;
			SDL_GetVersion(&version_);
			msg = "Your SDL version is too low: "~
				itoa(version_.major)~"."~
				itoa(version_.minor)~"."~
				itoa(version_.patch)~
				". Please upgrade to 3.4.0+.";
		}
		//A hypothetical message box function
		showMessageBox(msg);
		return false;
	}
	return true;
}
```

## Binding-specific changes
Enums are available both in their original C-style `UPPER_SNAKE_CASE` form, and as the D-style `PascalCase.camelCase`. Both variants are enabled by default, but can be selectively chosen using the version identifiers `SDL_C_Enums_Only` or `SDL_D_Enums_Only` respectively.

> [!TIP]\
> The version identifiers `BindBC_C_Enums_Only` and `BindBC_D_Enums_Only` can be used to configure all of the applicable _official_ BindBC packages used in your program. Package-specific version identifiers override this.

`camelCase`d variants are available for struct fields using `snake_case` or `lowercase`.

## Configurations
BindBC-SDL has the following configurations:

|      ┌      |  DRuntime  |   BetterC   |
|-------------|------------|-------------|
| **Dynamic** | `dynamic`  | `dynamicBC` |
| **Static**  | `static`   | `staticBC`  |

For projects that don't use dub, if BindBC-SDL is compiled for static bindings then the version identifier `BindSDL_Static` must be passed to your compiler when building your project.

> [!TIP]\
> The version identifier `BindBC_Static` can be used to configure all of the _official_ BindBC packages used in your program. (i.e. those maintained in [the BindBC GitHub organisation](https://git.sleeping.town/BindBC)) Some third-party BindBC packages may support it as well.

### Dynamic bindings
The dynamic bindings have no link-time dependency on the SDL libraries, so the SDL shared libraries must be manually loaded at runtime from the shared library search path of the user's system.
On Windows, this is typically handled by distributing the SDL DLLs with your program.
On other systems, it usually means installing the SDL shared libraries through a package manager.

It is recommended that you always select the minimum version you require _and no higher_.
If a lower version is loaded then it's still possible to call functions available in that lower version, but any calls to functions from versions between that version and the one you configured will result in a null pointer access.
For example, if you configured SDL to 3.6.0 (`SDL_3_6`) but loaded SDL 3.2.0 at runtime, then any function pointers from 3.6.0 and 3.4.0 will be `null`. For this reason, it's recommended to always specify your required version of the SDL library at compile time and unconditionally abort when you receive an `LoadMsg.badLibrary` return value from `loadSDL` (or equivalent).

The function `isSDLLoaded` returns `true` if any version of the shared library has been loaded and `false` if not. `unloadSDL` can be used to unload a successfully loaded shared library. The SDL_* libraries provide similar functions: `isSDLImageLoaded`, `unloadSDLImage`, etc.

### Static bindings
Static _bindings_ do not require static _linking_. The static bindings have a link-time dependency on either the shared _or_ static SDL libraries and any satellite SDL libraries the program uses. On Windows, you can link with the static libraries or, to use the DLLs, the import libraries. On other systems, you can link with either the static libraries or directly with the shared libraries.

When linking with the shared (or import) libraries, there is a runtime dependency on the shared library just as there is when using the dynamic bindings. The difference is that the shared libraries are no longer loaded manually&mdash;loading is handled automatically by the system when the program is launched. Attempting to call `loadSDL` with the static bindings enabled will result in a compilation error.

Static linking requires the SDL development packages be installed on your system. The [SDL releases page](https://github.com/libsdl-org/SDL/releases) provides development packages for Windows and macOS. You can also install them via your system's package manager. For example, on Debian-based Linux distributions `sudo apt install libsdl3-dev` will install both the development and runtime packages.

When linking with the static libraries, there is no runtime dependency on SDL. The SDL homepage does not distribute pre-compiled static libraries. If you decide to obtain static libraries from another source (usually by compiling them yourself) you will also need to ensure that you link with all of SDL's link-time dependencies (such as the OpenGL library and system API libraries).

## Library versions
These are the supported versions of each SDL_* library, along with the corresponding version identifiers to add to your dub recipe's `versions` list, or pass directly to the compiler.

It is necessary to specify only a single version identifier per library. For example, `SDL_Image_3_2` by itself will activate the SDL_image binding.

<details>
	<summary><h3>SDL versions</h3></summary>

| Version     |Version identifier|
|-------------|------------------|
| 3.2.0       | (none; default)  |
| 3.2.4       | `SDL_3_2_4`      |
| 3.2.6       | `SDL_3_2_6`      |
| 3.2.10      | `SDL_3_2_10`     |
| 3.2.12      | `SDL_3_2_12`     |
| 3.2.18      | `SDL_3_2_18`     |

</details>

<details><summary><h3>SDL_image versions</h3></summary>

| Version |Version identifier| Public API updated |
|---------|------------------|--------------------|
| 3.2.0   | `SDL_Image_3_2`  |                    |

</details>

<details><summary><h3>SDL_mixer versions</h3></summary>


> [!NOTE]\
> These bindings are based on [this commit](https://github.com/libsdl-org/SDL_mixer/commit/af6a29df4e14c6ce72608b3ccd49cf35e1014255). SDL_mixer 3.X has not officially released yet. The API of these bindings & the version identifier used to activate them will change when SDL_mixer 3.X is officially released.

| Version |Version identifier| Public API updated |
|---------|------------------|--------------------|
| 3.0.0   | `SDL_Mixer_3_0`  |                    |

</details>

<details><summary><h3>SDL_net versions</h3></summary>


> [!NOTE]\
> These bindings are based on [this commit](https://github.com/libsdl-org/SDL_net/commit/f02213ba76be2f091778b5a9aab5afe218f3ca7f). SDL_net 3.X has not officially released yet. The API of these bindings & the version identifier used to activate them will change when SDL_net 3.X is officially released.

| Version |Version identifier| Public API updated |
|---------|------------------|--------------------|
| 3.0.0   | `SDL_Net_3_0`    |                    |

</details>

<details><summary><h3>SDL_ttf versions</h3></summary>

| Version |Version identifier| Public API updated |
|---------|------------------|--------------------|
| 3.2.0   | `SDL_TTF_3_2`    |                    |
| 3.2.2   | `SDL_TTF_3_2_2`  | :heavy_check_mark: |

</details>

<details><summary><h3>SDL_shadercross versions</h3></summary>


> [!NOTE]\
> These bindings are based on [this commit](https://github.com/libsdl-org/SDL_shadercross/commit/a1bc850a6c32d5186d84dfd00701dd35858e309d). SDL_shadercross has no versioned releases yet. The API of these bindings & the version identifier used to activate them may change if/when SDL_shadercross recieves its first versioned release.

| Version | Version identifier    | Public API updated |
|---------|-----------------------|--------------------|
| 3.0.0   | `SDL_ShaderCross_3_0` |                    |

</details>

## Special platforms
Some platforms do not have [pre-defined versions in D](https://dlang.org/spec/version.html#predefined-versions), meaning that BindBC-SDL has to use custom version identifiers for them. When you wish to compile for one of these platforms, please supply the corresponding version identifier to the compiler.

| Platform                       | Version identifier |
|--------------------------------|--------------------|
| Nintendo 3DS                   | `_3DS`             |
| Microsoft Game Development Kit | `GDK`              |
| Sony Vita                      | `Vita`             |
| Sony PSP                       | `PSP`              |

## Gesture API
SDL2's gesture API was removed from SDL3 and made available as a header-only library called [SDL_gesture](https://github.com/libsdl-org/SDL_gesture). BindBC-SDL contains a full D translation of SDL_gesture, which you can enable by adding the version identifier `SDL_Gesture` in your dub recipe's `versions` list, or by passing it directly to the compiler.

SDL_gesture does not have versioned releases. The D translation of it BindBC-SDL up-to-date with [this commit](https://github.com/libsdl-org/SDL_gesture/commit/91b42083a7dcb60007f15f5e1600f0c04c8e814e).

## Entry points
It is recommended that you read this first: [README-main-functions.md](https://github.com/libsdl-org/SDL/blob/main/docs/README-main-functions.md)

For convenience, `sdl.main` (equivalent to `SDL_main.h`) is imported by default. However, in BindBC-SDL having your entry point replaced by `sdl.main` is opt-*in* rather than opt-*out*. See more information below.

### Replacing the main entry point
If you want SDL to replace your entry point, you will have to wrap your main function's parameter names & body in a mixin of `makeSDLMain`. Doing so is the equivalent of using `#include <SDL3/SDL_main.h>` in C *without* defining `SDL_MAIN_NOIMPL`.
```d
enum dynLoadSDL = q{
	LoadMsg ret = loadSDL();
	if(ret != LoadMsg.success){
		import core.stdc.stdio, bindbc.loader;
		foreach(error; bindbc.loader.errors){
			printf("%s\n", error.message);
		}
	}};
mixin(makeSDLMain(q{argC}, q{argV}, dynLoadSDL, dynLoadSDL~q{
	import core.stdc.stdio;
	foreach(argument; argV[0..argC]){
		printf("%s\n", argument);
	}
	return 0;
}));
```
> [!WARNING]\
> When using this feature, your provided main function will always be `extern(C) nothrow`, take `(int, char**)` as its parameters, and must return `int`. If you're not using BetterC, then an `extern(C)` main function means that DRuntime will not be initialised, and so if you want to use any DRuntime features then you will have to research & re-implement what DRuntime usually does for you before calling your main function. For this reason, using SDL's entry point with DRuntime is not advised for inexperienced programmers.
>
> To learn more, see the [`extern(C) main()` spec](https://dlang.org/spec/function.html#betterc-main).

> [!IMPORTANT]\
> When using dynamic bindings, `makeSDLMain`'s third argument (`dynLoad`) must be a string with code to load SDL (and handle any loader errors). It can be left blank as long as you ONLY use the static bindings. Unless SDL overrides your main function or you're using static bindings, the code in `dynLoad` will be prepended to your main function.

### Callback entry points
If you want to use the callback entry points (or 'main callbacks'), then you also need to use version identifier `SDL_MainUseCallbacks`. When using callback functions, only the `dynLoad` parameter of `makeSDLMain` is used. As a side-effect, this means that you can safely write code in your main body that depends on `SDL_MainUseCallbacks` not being in-use.

Here's an example that initialises & terminates DRuntime, and has basic exception handling.
```
import core.runtime, core.stdc.stdio;

mixin(makeSDLMain(dynLoad: q{
	LoadMsg ret = loadSDL();
	if(ret != LoadMsg.success){
		import core.stdc.stdio, bindbc.loader;
		foreach(error; bindbc.loader.errors){
			printf("%s\n", error.message);
		}
	}})); //makeSDLMain's parameters are optional

version SDL_MainUseCallbacks{
	extern(C) SDL_AppResult SDL_AppInit(void** state, int argC, char** argV) nothrow{
		try{
			if(!rt_init()) return SDL_AppResult.failure;
		}catch(Exception ex){
			return SDL_AppResult.failure;
		}
		return SDL_AppResult.continue_;
	}
	
	extern(C) SDL_AppResult SDL_AppIterate(void* state) nothrow{
		try{
			/*
			Put your code that can throw exceptions here!
			*/
		}catch(Throwable t){
			void sink(in char[] buf) scope nothrow{
				fwrite(buf.ptr, char.sizeof, buf.length, stderr);
			}
			do{
				try t.toString(&sink);
				catch(Exception) return SDL_AppResult.failure;
			}while((t = t.next) !is null);
			printf("\n");
			return SDL_AppResult.failure;
		}
		return SDL_AppResult.success;
	}
	
	extern(C) SDL_AppResult SDL_AppEvent(void* state, SDL_Event* event) nothrow => SDL_AppResult.continue_;
	
	extern(C) void SDL_AppQuit(void*, SDL_AppResult result) nothrow{
		try rt_term();
		catch(Exception ex){}
	}
}
```
> [!NOTE]\
> This example code does **NOT** support unittests, doesn't run any module constructors/destructors, and does not support `--DRT` command-line parameters. Look at how DRuntime implements these features if you need them (or any other DRuntime features) in your project.
