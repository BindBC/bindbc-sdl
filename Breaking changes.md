# BindBC SDL 1.3.0
The newest update to BindBC SDL includes a *lot* of internal changes, and updates every SDL_* library's support to the latest version.
Once SDL3 comes out, I plan to evaluate whether older versions of SDL still need to be supported. This will be _highly_ dependant on SDL3's backwards compatibility and API changes. It might even be most desirable for me to make a "BindBC SDL3" and retroactively change the existing parts of the library to "BindBC SDL2".

## Breaking Changes
A great deal of care has gone into keeping the number of user-side breaking changes as low as possible for this release. However, there are a few notable breaking changes:

- `sdl[*]Support` variables (`sdlSupport`, `sdlImageSupport`, `sdlTTFSupport`, etc.) and `SDL[*]Support` enums now use `SDL_version` instead of numeric values. For now, `noLibrary` and `badLibrary` are still part of the `SDL[*]Support` enum, but _I plan to separate them into a `bindbc.loader.LibError` enum in BindBC SDL 2.0_. Please do not rely on their current implementation if possible.
- `loadedSDL[*]Version` now return the _compile-time-linked version_ of the SDL_* library (the same as `SDL[_*]_VERSION` & `sdl[*]Support`), rather than an approximation of the _dynamically-linked version_ of the SDL_* library. To see the _dynamically-linked version_, please use `SDL_GetVersion`, `IMG_Linked_Version`, `Mix_Linked_Version`, `SDLNet_Linked_Version` or `TTF_Linked_Version` for the respective SDL_* libraries instead.
- Version identifiers `BindSDL_Image`, `BindSDL_Mixer`, `BindSDL_Net` and `BindSDL_TTF` no longer work. As far as I know they were only ever intended for internal use, but I've seen some people using them (rather than the deprecated variants without the `Bind` prefix) in the wild.
- `SDL_[SomeEnumType].[someEnumTypeMember]` will no longer work because all enum types are now type aliases. Use just `[someEnumTypeMember]` instead.
- SDL_net functions use always use `TCPsocket` and `UDPsocket`, instead of sometimes replacing them with `void*`.
- Dynamic function bindings no longer expose function pointers (except for variadic functions, but this may change in the future). For example, `auto x = SDL_Init;` will now call `SDL_Init` and will make `typeof(x)` be `int` instead of `int function(uint)`. If you relied on getting references this way in your code, please use use the address-of operator (`&`) instead. (e.g. `auto x = &SDL_Init;`) This also means that if your code manually set the function pointers (i.e. `SDL_Init = &myFn;`) then it will no longer work.
- Dynamic bindings' type aliases (e.g. `pSDL_Init`) no longer exist.
- All internal SDL binding files are now in `sdl.*` instead of `bindbc.sdl.bind.*`. This should not affect most users.
- Fixed the signature of `SDL_IntersectFRectAndLine` by changing the `int` positions to `float`s.
- Fixed the signature of `SDL_HintCallback` by adding the missing `const(char)*` parameter at the end.
- `SDL_CompilerBarrier`, `SDL_MemoryBarrierRelease` and `SDL_MemoryBarrierAcquire` are no longer aliases to `core.atomic.atomicFence!()`.

## Other Changes

- Added many previously missing functions to `sdl.stdinc`.
- Support for SDL 2.26.X and 2.24.X.
- Support for SDL_image 2.6.X.
- Support for SDL_net 2.2.X.
- Support for SDL_ttf 2.20.X;
- Added deprecation warnings to functions officially deprecated by libsdl.org.
- Deprecated templates that were based on `#define`s. You can now use the CTFE-able function-equivalents instead.
- Deprecated versionless `SDL_*` library version identifiers. (e.g. `SDL_Mixer`, `SDL_TTF`, etc.) Please use library version identifiers with versions instead. (e.g. `SDL_Mixer_200`, `SDL_TTF_2012`, etc.) Support for the old library version identifiers will be removed in BindBC SDL version 2.0.
- Deprecated `SDL[*]Support.sdl[version]` enum members (e.g. `SDLImageSupport.sdlImage205`) in favour of `SDL[*]Support.v[version]`. (e.g. `SDLImageSupport.v2_0_5`) The old members will be removed in BindBC SDL version 2.0.
- Added a deprecation warning to `expandEnum`, which I plan to move into another library. Possibly `bindbc-loader`.
