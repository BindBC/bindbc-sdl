module bindbc.sdl;

public import bindbc.sdl.config,
              bindbc.sdl.bind;

version(BindSDL_Static) {}
else {
    public import bindbc.sdl.dynload;
}