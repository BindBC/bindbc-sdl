/*
 * Logic implementation of the Snake game. It is designed to efficiently
 * represent in memory the state of the game.
 *
 * This code is public domain. Feel free to use it for any purpose!
 */

import bindbc.sdl;

enum stepRateInMilliseconds = 125;
enum snakeBlockSizeInPixels = 24;
enum sdlWindowWidth  = snakeBlockSizeInPixels * snakeGameWidth;
enum sdlWindowHeight = snakeBlockSizeInPixels * snakeGameHeight;

enum snakeGameWidth  = 24U;
enum snakeGameHeight = 18U;

alias CellPos = size_t;

extern(C) nothrow @nogc:
mixin(makeSDLMain(dynLoad: q{
	import core.stdc.stdio, bindbc.loader;
	LoadMsg ret = loadSDL();
	if(ret != LoadMsg.success){
		foreach(error; bindbc.loader.errors){
			printf("%s\n", error.message);
		}
	}}));

enum Cell: ubyte{
	nothing,
	snakeRight, snakeUp,
	snakeLeft, snakeDown,
	food,
}

enum Direction: byte{ right, up, down, left }

Direction flip(Direction dir) @nogc pure @safe =>
	cast(Direction)(dir ^ Direction.max);

Cell toCell(Direction dir) @nogc pure @safe{
	final switch(dir){
		case Direction.right: return Cell.snakeRight;
		case Direction.up:    return Cell.snakeUp;
		case Direction.down:  return Cell.snakeDown;
		case Direction.left:  return Cell.snakeLeft;
	}
}

struct SnakeContext{
	Cell[snakeGameHeight][snakeGameWidth] cells;
	byte headXPos, headYPos;
	byte tailXPos, tailYPos;
	Direction nextDir;
	byte inhibitTailStep;
	uint occupiedCells;
	
	nothrow @nogc:
	
	Cell cellAt(CellPos x, CellPos y) const =>
		cells[x][y];
	
	void putCellAt(CellPos x, CellPos y, Cell ct){
		cells[x][y] = ct;
	}
	
	int areCellsFull() const =>
		occupiedCells == snakeGameWidth * snakeGameHeight;
	
	void newFoodPos(){
		while(true){
			const CellPos x = cast(CellPos)SDL_rand(snakeGameWidth);
			const CellPos y = cast(CellPos)SDL_rand(snakeGameHeight);
			if(cellAt(x, y) == Cell.nothing){
				putCellAt(x, y, Cell.food);
				break;
			}
		}
	}
	
	void initialise(){
		foreach(ref column; cells)
			column[] = Cell.nothing;
		headXPos = tailXPos = snakeGameWidth  / 2;
		headYPos = tailYPos = snakeGameHeight / 2;
		nextDir = Direction.right;
		inhibitTailStep = 4;
		
		enum foodCount = 4;
		occupiedCells = 3 + foodCount;
		putCellAt(tailXPos, tailYPos, Cell.snakeRight);
		foreach(_; 0..foodCount)
			this.newFoodPos();
	}
	
	void snakeReDir(Direction dir){
		Cell ct = cellAt(headXPos, headYPos);
		if(dir.flip().toCell() != ct){
			nextDir = dir;
		}
	}
	
	void step(){
		const Cell dirAsCell = nextDir.toCell();
		Cell ct;
		byte prevXPos;
		byte prevYPos;
		//Move tail forward
		if(--inhibitTailStep == 0){
			++inhibitTailStep;
			ct = cellAt(tailXPos, tailYPos);
			putCellAt(tailXPos, tailYPos, Cell.nothing);
			switch(ct){
				case Cell.snakeRight: tailXPos++; break;
				case Cell.snakeUp:    tailYPos--; break;
				case Cell.snakeDown:  tailYPos++; break;
				case Cell.snakeLeft:  tailXPos--; break;
				default:
			}
			wrapAround(&tailXPos, snakeGameWidth);
			wrapAround(&tailYPos, snakeGameHeight);
		}
		//Move head forward
		prevXPos = headXPos;
		prevYPos = headYPos;
		switch(nextDir){
			case Direction.right: ++headXPos; break;
			case Direction.up:    --headYPos; break;
			case Direction.down:  ++headYPos; break;
			case Direction.left:  --headXPos; break;
			default:
		}
		wrapAround(&headXPos, snakeGameWidth);
		wrapAround(&headYPos, snakeGameHeight);
		//Collisions
		ct = cellAt(headXPos, headYPos);
		if(ct != Cell.nothing && ct != Cell.food){
			initialise();
			return;
		}
		putCellAt(prevXPos, prevYPos, dirAsCell);
		putCellAt(headXPos, headYPos, dirAsCell);
		if(ct == Cell.food){
			if(this.areCellsFull()){
				initialise();
				return;
			}
			this.newFoodPos();
			++inhibitTailStep;
			++occupiedCells;
		}
	}
}

struct AppState{
	SDL_Window* window;
	SDL_Renderer* renderer;
	SDL_TimerID stepTimer;
	SnakeContext snakeCtx;
}

void setRectXY(SDL_FRect* r, size_t x, size_t y){
	r.x = cast(float)(x * snakeBlockSizeInPixels);
	r.y = cast(float)(y * snakeBlockSizeInPixels);
}

void wrapAround(byte* val, byte max){
	if(*val < 0){
		*val = cast(byte)(max - 1);
	}else if(*val > max - 1){
		*val = 0;
	}
}

uint sdlTimerCallback(void* payload, SDL_TimerID timerID, uint interval){
	/* NOTE: snakeStep is not called here directly for multithreaded concerns. */
	SDL_Event event;
	(cast(ubyte*)&event)[0..SDL_Event.sizeof] = 0;
	event.type = SDL_EVENT_USER;
	SDL_PushEvent(&event);
	return interval;
}

int handleKeyEvent(SnakeContext* ctx, SDL_Scancode keyCode){
	switch(keyCode){
		//Quit.
		case SDL_Scancode.escape:
		case SDL_Scancode.q:
			return SDL_AppResult.success;
		//Restart the game as if the program was launched.
		case SDL_Scancode.r:
			ctx.initialise();
			break;
		//Decide new direction of the snake.
		case SDL_Scancode.right: ctx.snakeReDir(Direction.right); break;
		case SDL_Scancode.up:    ctx.snakeReDir(Direction.up); break;
		case SDL_Scancode.left:  ctx.snakeReDir(Direction.left); break;
		case SDL_Scancode.down:  ctx.snakeReDir(Direction.down); break;
		default:
	}
	return SDL_AppResult.continue_;
}

SDL_AppResult SDL_AppIterate(void* appState){
	AppState* as;
	SnakeContext* ctx;
	SDL_FRect r;
	int ct;
	as = cast(AppState*)appState;
	ctx = &as.snakeCtx;
	r.w = r.h = snakeBlockSizeInPixels;
	SDL_SetRenderDrawColour(as.renderer, 0, 0, 0, SDL_AlphaOpaque);
	SDL_RenderClear(as.renderer);
	foreach(CellPos i; 0..snakeGameWidth){
		foreach(CellPos j; 0..snakeGameHeight){
			ct = ctx.cellAt(i, j);
			if(ct == Cell.nothing)
				continue;
			setRectXY(&r, i, j);
			if(ct == Cell.food)
				SDL_SetRenderDrawColour(as.renderer, 80, 80, 255, SDL_AlphaOpaque);
			else /* body */
				SDL_SetRenderDrawColour(as.renderer, 0, 128, 0, SDL_AlphaOpaque);
			SDL_RenderFillRect(as.renderer, &r);
		}
	}
	SDL_SetRenderDrawColour(as.renderer, 255, 255, 0, SDL_AlphaOpaque); /*head*/
	setRectXY(&r, ctx.headXPos, ctx.headYPos);
	SDL_RenderFillRect(as.renderer, &r);
	SDL_RenderPresent(as.renderer);
	return SDL_AppResult.continue_;
}

SDL_AppResult SDL_AppInit(void** appState, int argC, char** argV){
	if(!SDL_SetAppMetadata("Example Snake game", "1.0", "com.example.Snake")){
		return SDL_AppResult.failure;
	}
	
	if(!SDL_Init(SDL_InitFlags.video)){
		return SDL_AppResult.failure;
	}
	
	AppState* as = cast(AppState*)SDL_calloc(1, AppState.sizeof);
	if(!as) return SDL_AppResult.failure;
	*appState = as;
	
	if(!SDL_CreateWindowAndRenderer("examples/game/snake", sdlWindowWidth, sdlWindowHeight, 0, &as.window, &as.renderer)){
		return SDL_AppResult.failure;
	}
	
	as.snakeCtx.initialise();
	
	as.stepTimer = SDL_AddTimer(stepRateInMilliseconds, &sdlTimerCallback, null);
	if(as.stepTimer == 0){
		return SDL_AppResult.failure;
	}
	
	return SDL_AppResult.continue_;
}

SDL_AppResult SDL_AppEvent(void* appState, SDL_Event* event){
	SnakeContext* ctx = &(cast(AppState*)appState).snakeCtx;
	switch(event.type){
		case SDL_EventType.quit:
			return SDL_AppResult.success;
		case SDL_EventType.user:
			ctx.step();
			break;
		case SDL_EventType.keyDown:
			return cast(SDL_AppResult)handleKeyEvent(ctx, event.key.scancode);
		default:
	}
	return SDL_AppResult.continue_;
}

void SDL_AppQuit(void* appState, SDL_AppResult result){
	if(auto as = cast(AppState*)appState){
		SDL_RemoveTimer(as.stepTimer);
		SDL_DestroyRenderer(as.renderer);
		SDL_DestroyWindow(as.window);
		SDL_free(as);
	}
}
