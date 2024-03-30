/+
+            Copyright 2022 – 2025 Aya Partridge
+          Copyright 2018 - 2022 Michael D. Parker
+ Distributed under the Boost Software License, Version 1.0.
+     (See accompanying file LICENSE_1_0.txt or copy at
+           http://www.boost.org/LICENSE_1_0.txt)
+/
module bindbc.sdl;

public import bindbc.sdl.config;
public import sdl;
static if(sdlImageVersion) public import sdl_image;
static if(sdlMixerVersion) public import sdl_mixer;
static if(sdlNetVersion) public import sdl_net;
static if(sdlTTFVersion) public import sdl_ttf;
static if(sdlShaderCrossVersion) public import sdl_shadercross;
