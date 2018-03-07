module bindbc.sdl.bind.sdlsystem;

import bindbc.sdl.config;
import bindbc.sdl.bind.sdlrender : SDL_Renderer;
import bindbc.sdl.bind.sdlstdinc : SDL_bool;

version(Android) {
    enum int SDL_ANDROID_EXTERNAL_STORAGE_READ  = 0x01;
    enum int SDL_ANDROID_EXTERNAL_STORAGE_WRITE = 0x02;
}

static if(sdlSupport >= SDLSupport.sdl201) {
    version(Windows) struct IDirect3DDevice9;
}

static if(sdlSupport >= SDLSupport.sdl204) {
    version(Windows) {
        extern(C) nothrow alias SDL_WindowsMessageHook = void function(void*,void*,uint,ulong,long);
    }
}

version(BindSDL_Static) {
    extern(C) @nogc nothrow {
        version(Android) {
            void* SDL_AndroidGetJNIEnv();
            void* SDL_AndroidGetActivity();
            const(char)* SDL_AndroidGetInternalStoragePath();
            int SDL_AndroidGetInternalStorageState();
            const(char)* SDL_AndroidGetExternalStoragePath();

            static if(sdlSupport >= SDLSupport.sdl208) {
                SDL_bool SDL_IsAndroidTV();
            }
        }

        version(Windows) {
            static if(sdlSupport >= SDLSupport.sdl201) {
                int SDL_Direct3D9GetAdapterIndex(int);
                IDirect3DDevice9* SDL_RenderGetD3D9Device(SDL_Renderer*);
            }

            static if(sdlSupport >= SDLSupport.sdl202) {
                SDL_bool SDL_DXGIGetOutputInfo(int,int*,int*);
            }

            static if(sdlSupport >= SDLSupport.sdl204) {
                void SDL_SetWindowsMessageHook(SDL_WindowsMessageHook,void*);
            }
        }
    }
}
else {
    version(Android) {
        extern(C) @nogc nothrow {
            alias pSDL_AndroidGetJNIEnv = void* function();
            alias pSDL_AndroidGetActivity = void* function();
            alias pSDL_AndroidGetInternalStoragePath = const(char)* function();
            alias pSDL_AndroidGetInternalStorageState = int function();
            alias pSDL_AndroidGetExternalStoragePath = const(char)* function();
        }

        __gshared {
            pSDL_AndroidGetJNIEnv SDL_AndroidGetJNIEnv;
            pSDL_AndroidGetActivity SDL_AndroidGetActivity;

            pSDL_AndroidGetInternalStoragePath SDL_AndroidGetInternalStoragePath;
            pSDL_AndroidGetInternalStorageState SDL_AndroidGetInternalStorageState;
            pSDL_AndroidGetExternalStoragePath SDL_AndroidGetExternalStoragePath;
        }

        static if(sdlSupport >= SDLSupport.sdl208) {
            extern(C) @nogc nothrow {
                alias pSDL_IsAndroidTV = SDL_bool function();
            }

            __gshared {
                pSDL_IsAndroidTV SDL_IsAndroidTV;
            }
        }
    }

    version(Windows) {
        static if(sdlSupport >= SDLSupport.sdl201) {
            extern(C) @nogc nothrow {
                alias pSDL_Direct3D9GetAdapterIndex = int function(int);
                alias pSDL_RenderGetD3D9Device = IDirect3DDevice9* function(SDL_Renderer*);
            }

            __gshared {
                pSDL_Direct3D9GetAdapterIndex SDL_Direct3D9GetAdapterIndex ;
                pSDL_RenderGetD3D9Device SDL_RenderGetD3D9Device;
            }
        }

        static if(sdlSupport >= SDLSupport.sdl202) {
            extern(C) @nogc nothrow {
                alias pSDL_DXGIGetOutputInfo = SDL_bool function(int,int*,int*);
            }

            __gshared {
                pSDL_DXGIGetOutputInfo SDL_DXGIGetOutputInfo;
            }
        }

        static if(sdlSupport >= SDLSupport.sdl204) {
            extern(C) @nogc nothrow {
                alias pSDL_SetWindowsMessageHook = void function(SDL_WindowsMessageHook,void*);
            }

            __gshared {
                pSDL_SetWindowsMessageHook SDL_SetWindowsMessageHook;
            }
        }
    }
}