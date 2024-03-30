/*
This example creates an SDL window and renderer, and then draws some
geometry (arbitrary polygons) to it every frame.

This code is public domain. Feel free to use it for any purpose!
*/

import bindbc.sdl;

//We will use this renderer to draw into this window every frame.
SDL_Window* window = null;
SDL_Renderer* renderer = null;
SDL_Texture* texture = null;
int textureWidth = 0;
int textureHeight = 0;

enum windowWidth = 640;
enum windowHeight = 480;

extern(C) nothrow:
mixin(makeSDLMain(dynLoad: q{
	import core.stdc.stdio, bindbc.loader;
	LoadMsg ret = loadSDL();
	if(ret != LoadMsg.success){
		foreach(error; bindbc.loader.errors){
			printf("%s\n", error.message);
		}
	}}));

//This function runs once at startup.
SDL_AppResult SDL_AppInit(void** appState, int argC, char** argV){
	SDL_Surface* surface = null;
	char* bmpPath = null;
	
	if(!SDL_Init(SDL_InitFlags.video)){
		SDL_Log("Couldn't initialise SDL: %s", SDL_GetError());
		return SDL_AppResult.failure;
	}
	
	if(!SDL_CreateWindowAndRenderer("examples/renderer/geometry", windowWidth, windowHeight, 0, &window, &renderer)){
		SDL_Log("Couldn't create window/renderer: %s", SDL_GetError());
		return SDL_AppResult.failure;
	}
	
	/*
	Textures are pixel data that we upload to the video hardware for fast drawing. Lots of 2D
	engines refer to these as "sprites." We'll do a static texture (upload once, draw many
	times) with data from a bitmap file.
	*/
	
	/*
	SDL_Surface is pixel data the CPU can access. SDL_Texture is pixel data the GPU can access.
	Load a .bmp into a surface, move it to a texture from there.
	*/
	SDL_asprintf(&bmpPath, "%s/../assets/sample.bmp", SDL_GetBasePath()); //allocate a string of the full file path
	surface = SDL_LoadBMP(bmpPath);
	if(!surface){
		SDL_Log("Couldn't load bitmap: %s", SDL_GetError());
		return SDL_AppResult.failure;
	}
	
	SDL_free(bmpPath); //done with this, the file is loaded.
	
	textureWidth = surface.w;
	textureHeight = surface.h;
	
	texture = SDL_CreateTextureFromSurface(renderer, surface);
	if(!texture){
		SDL_Log("Couldn't create static texture: %s", SDL_GetError());
		return SDL_AppResult.failure;
	}
	
	SDL_DestroySurface(surface); //done with this, the texture has a copy of the pixels now.
	
	return SDL_AppResult.continue_; //carry on with the program!
}

//This function runs when a new event (mouse input, keypresses, etc) occurs.
SDL_AppResult SDL_AppEvent(void* appState, SDL_Event* event){
	if(event.type == SDL_EventType.quit){
		return SDL_AppResult.success; //end the program, reporting success to the OS.
	}
	return SDL_AppResult.continue_; //carry on with the program!
}

//This function runs once per frame, and is the heart of the program.
SDL_AppResult SDL_AppIterate(void* appState){
	const ulong now = SDL_GetTicks();
	
	//we'll have the triangle grow and shrink over a few seconds.
	const float direction = ((now % 2_000) >= 1_000) ? 1f : -1f;
	const float scale = (cast(float)((cast(int)(now % 1_000)) - 500) / 500f) * direction;
	const float size = 200f + (200f * scale);
	
	SDL_Vertex[4] vertices;
	
	//as you can see from this, rendering draws over whatever was drawn before it.
	SDL_SetRenderDrawColour(renderer, 0, 0, 0, 255); //black, full alpha
	SDL_RenderClear(renderer); //start with a blank canvas.
	
	//Draw a single triangle with a different colour at each vertex. Centre this one and make it grow and shrink.
	//You always draw triangles with this, but you can string triangles together to form polygons.
	vertices[0] = SDL_Vertex(position: SDL_FPoint( cast(float)windowWidth         / 2f, (cast(float)windowHeight - size) / 2f), SDL_FColour(1f, 0f, 0f, 1f));
	vertices[1] = SDL_Vertex(position: SDL_FPoint((cast(float)windowWidth + size) / 2f, (cast(float)windowHeight + size) / 2f), SDL_FColour(0f, 1f, 0f, 1f));
	vertices[2] = SDL_Vertex(position: SDL_FPoint((cast(float)windowWidth - size) / 2f, (cast(float)windowHeight + size) / 2f), SDL_FColour(0f, 0f, 1f, 1f));
	
	SDL_RenderGeometry(renderer, null, &vertices[0], 3, null, 0);
	
	/*
	you can also map a texture to the geometry! Texture coordinates go from 0f to 1f. That will be the location
	in the texture bound to this vertex.
	*/
	(cast(ubyte*)&vertices)[0..vertices.sizeof] = 0;
	vertices[0] = SDL_Vertex(position: SDL_FPoint( 10f,  10f), SDL_FColour(1f, 1f, 1f, 1f), texCoord: SDL_FPoint(0f, 0f));
	vertices[1] = SDL_Vertex(position: SDL_FPoint(150f,  10f), SDL_FColour(1f, 1f, 1f, 1f), texCoord: SDL_FPoint(1f, 0f));
	vertices[2] = SDL_Vertex(position: SDL_FPoint( 10f, 150f), SDL_FColour(1f, 1f, 1f, 1f), texCoord: SDL_FPoint(0f, 1f));
	
	SDL_RenderGeometry(renderer, texture, &vertices[0], 3, null, 0);
	
	/*
	Did that only draw half of the texture? You can do multiple triangles sharing some vertices,
	using indices, to get the whole thing on the screen:
	*/
	
	//Let's just move this over so it doesn't overlap...
	foreach(i; 0..3){
		vertices[i].position.x += 450f;
	}
	//we need one more vertex, since the two triangles can share two of them.
	vertices[3] = SDL_Vertex(position: SDL_FPoint(600f, 150f), SDL_FColour(1f, 1f, 1f, 1f), texCoord: SDL_FPoint(1f, 1f));
	
	//And an index to tell it to reuse some of the vertices between triangles...
	{
		//4 vertices, but 6 actual places they used. Indices need less bandwidth to transfer and can reorder vertices easily!
		const(int)[6] indices = [0, 1, 2, 1, 2, 3];
		SDL_RenderGeometry(renderer, texture, &vertices[0], 4, &indices[0], cast(int)indices.length);
	}
	
	SDL_RenderPresent(renderer); //put it all on the screen!
	
	return SDL_AppResult.continue_; //carry on with the program!
}

//This function runs once at shutdown.
void SDL_AppQuit(void* appState, SDL_AppResult result){
	SDL_DestroyTexture(texture);
	//SDL will clean up the window/renderer for us.
}
