#ifdef _MSC_VER
#define _CRT_SECURE_NO_WARNINGS
#endif
#define _USE_MATH_DEFINES
#include <math.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <stdlib.h>

extern "C" {
#include"./SDL2-2.0.10/include/SDL.h"
#include"./SDL2-2.0.10/include/SDL_main.h"
}


///////////////////////////////////////// DEFINES ////////////////////////////////////////////////////


#define SCREEN_WIDTH	640
#define SCREEN_HEIGHT	480
#define MILISECONDS 0.001
#define FPS_FREQUENCE 0.5
#define LEFT -1
#define RIGHT 1
#define STRAIGHT 0
#define CAR_POSITION SCREEN_HEIGHT/2
#define IMAGE1_COORDINATES SCREEN_WIDTH/2, int(tools.position) + SCREEN_HEIGHT/2
#define IMAGE2_COORDINATES SCREEN_WIDTH / 2, int(tools.position) - SCREEN_HEIGHT / 2
#define YES 1
#define NO 0
#define LEFT -1
#define RIGHT 1
#define HOW_MANY_BULLETS 20
#define BULLET_SPEED 100
#define BULLET_LIFETIME 2 //seconds
#define SHOTPOINTS 200
#define STUNE 5 //seconds of stopping adding points
#define STARTING_LIFES 3
#define GET_NEW_LIFE 3000
#define POINTS 0
#define TIME 1


///////////////////////////////////////// STRUCTURES /////////////////////////////////////////////////

typedef struct car
{
	SDL_Surface* surface = NULL;
	double X;
	double Y;
};

typedef struct powerup
{
	SDL_Surface* surface = NULL;
	double X;
	double Y;
};
typedef struct plot
{
	SDL_Event event;
	SDL_Surface* screen = NULL;
	SDL_Surface* charset = NULL;
	SDL_Surface* eti = NULL;
	SDL_Surface* background = NULL;
	SDL_Texture* scrtex = NULL;
	SDL_Window* window = NULL;
	SDL_Renderer* renderer = NULL;
};

typedef struct character
{
	int carx;
	int cary = CAR_POSITION;
	int direction = STRAIGHT;
	double etiSpeed;
	double stune = 3;
	int lifes = STARTING_LIFES;
	int nextLife = 1;
	int bountyShots = 0;
};

typedef struct toolsfps
{
	int t1;
	int t2;
	int frames;
	double points;
	double fpsTimer;
	double fps;
	double delta;
};

typedef struct toolsgame
{
	char text[128];
	int quit;
	double worldTime;
	double distance;
	int tmpPoints;
	double position;
};

typedef struct npc
{
	car enemy1;
	car ally1;
	car enemy2;
	car enemy3;
	car ally2;
};

typedef struct bullet
{
	int X = 0;
	double Y = 0;
	int occupied = NO;
	double distance = 0;
};


///////////////////////////////////////// TEMPLATE FUNCTIONS /////////////////////////////////////////


// draw a text txt on surface screen, starting from the point (x, y) charset is a 128x128 bitmap containing character images
void DrawString(SDL_Surface* screen, int x, int y, const char* text,
	SDL_Surface* charset) {
	int px, py, c;
	SDL_Rect s, d;
	s.w = 8;
	s.h = 8;
	d.w = 8;
	d.h = 8;
	while (*text) {
		c = *text & 255;
		px = (c % 16) * 8;
		py = (c / 16) * 8;
		s.x = px;
		s.y = py;
		d.x = x;
		d.y = y;
		SDL_BlitSurface(charset, &s, screen, &d);
		x += 8;
		text++;
	};
};

// draw a surface sprite on a surface screen in point (x, y) (x, y) is the center of sprite on screen
void DrawSurface(SDL_Surface* screen, SDL_Surface* sprite, int x, int y) {
	SDL_Rect dest;
	dest.x = x - sprite->w / 2;
	dest.y = y - sprite->h / 2;
	dest.w = sprite->w;
	dest.h = sprite->h;
	SDL_BlitSurface(sprite, NULL, screen, &dest);
};

// draw a single pixel
void DrawPixel(SDL_Surface* surface, int x, int y, Uint32 color) {
	int bpp = surface->format->BytesPerPixel;
	Uint8* p = (Uint8*)surface->pixels + y * surface->pitch + x * bpp;
	*(Uint32*)p = color;
};

// draw a vertical (when dx = 0, dy = 1) or horizontal (when dx = 1, dy = 0) line
void DrawLine(SDL_Surface* screen, int x, int y, int l, int dx, int dy, Uint32 color) {
	for (int i = 0; i < l; i++) {
		DrawPixel(screen, x, y, color);
		x += dx;
		y += dy;
	};
};

// draw a rectangle of size l by k
void DrawRectangle(SDL_Surface* screen, int x, int y, int l, int k,
	Uint32 outlineColor, Uint32 fillColor) {
	int i;
	DrawLine(screen, x, y, k, 0, 1, outlineColor);
	DrawLine(screen, x + l - 1, y, k, 0, 1, outlineColor);
	DrawLine(screen, x, y, l, 1, 0, outlineColor);
	DrawLine(screen, x, y + k - 1, l, 1, 0, outlineColor);
	for (i = y + 1; i < y + k - 1; i++)
		DrawLine(screen, x + 1, i, l - 2, 1, 0, fillColor);
};

///////////////////////////////////////// MY FUNCTIONS ///////////////////////////////////////////////


///////////////////////////////////////// STARTING FUNCTIONS /////////////////////////////////////////

double distance(int x1, int y1, int x2, int y2)
{
	double m = x1 - x2;
	double n = y1 - y2;
	return sqrt(m * m + n * n);
}

void movingNPC(npc* npcs)
{
	while (distance(npcs->ally1.X, npcs->ally1.Y, npcs->enemy2.X, npcs->enemy2.Y) < 52)
	{
		npcs->ally1.X = rand() % 50 + 340;
		npcs->ally1.Y = rand() % 480;
	}
	while (
		(distance(npcs->ally2.X, npcs->ally2.Y, npcs->enemy3.X, npcs->enemy3.Y) < 52) ||
		(distance(npcs->ally2.X, npcs->ally2.Y, npcs->enemy1.X, npcs->enemy1.Y) < 52) ||
		(distance(npcs->enemy3.X, npcs->enemy3.Y, npcs->enemy1.X, npcs->enemy1.Y) < 52)
		)
	{
		npcs->enemy3.X = rand() % 50 + 250;
		npcs->enemy3.Y = rand() % 480;
		npcs->enemy1.X = rand() % 50 + 250;
		npcs->enemy1.Y = rand() % 480;
	}
};

void resetBullets(bullet bullets[])
{
	for (int i = 0; i < HOW_MANY_BULLETS; i++)
	{
		bullets[i].X = 0;
		bullets[i].Y = 0;
		bullets[i].occupied = NO;
		bullets[i].distance = 0;
	}
}

void resetVariables(character* maincar, toolsfps* fpstools, toolsgame* tools, npc* npcs, bullet bullets[HOW_MANY_BULLETS], powerup* turbine)
{
	fpstools->frames = 0;
	fpstools->fpsTimer = 0;
	fpstools->fps = 0;
	fpstools->points = 0;
	tools->quit = NO;
	tools->worldTime = 0;
	tools->distance = 0;
	tools->position = 0;
	tools->distance = 0;
	maincar->etiSpeed = 1;
	maincar->carx = SCREEN_WIDTH / 2;
	maincar->direction = STRAIGHT;
	maincar->stune = 3;
	maincar->lifes = STARTING_LIFES;
	maincar->nextLife = 1;
	maincar->bountyShots = 0;
	srand(time(NULL));
	turbine->X = rand() % 140 + 250;
	turbine->Y = 0;
	resetBullets(bullets);
	srand(time(NULL));
	npcs->enemy1.X = rand() % 50 + 250;
	npcs->enemy1.Y = rand() % 480;
	npcs->ally1.X = rand() % 50 + 340;
	npcs->ally1.Y = rand() % 480;
	npcs->enemy2.X = rand() % 50 + 340;
	npcs->enemy2.Y = rand() % 480;
	npcs->enemy3.X = rand() % 50 + 250;
	npcs->enemy3.Y = rand() % 480;
	npcs->ally2.X = rand() % 50 + 250;
	npcs->ally2.Y = rand() % 480;
	movingNPC(npcs);
};

///////////////////////////////////////// MOVING FUNCTIONS////////////////////////////////////////////

void turbineMove(powerup* turbine, character* maincar, double delta)
{
	if (turbine->Y < 1000)
		turbine->Y += delta * 100 * maincar->etiSpeed;
	else
	{
		srand(time(NULL));
		turbine->X = rand() % 140 + 250;
		turbine->Y = 0;
	}
	if ((maincar->carx >= (turbine->X - 18)) &&
		(maincar->carx <= (turbine->X + 18)) &&
		(maincar->cary <= (turbine->Y + 18)) &&
		(maincar->cary >= (turbine->Y - 18)))
	{
		maincar->bountyShots = 20;
		srand(time(NULL));
		turbine->X = rand() % 140 + 250;
		turbine->Y = 0;
	}
}
void move(character* maincar, double* points, double delta, double* position, int* lifes, int* nextLife, powerup* turbine)
{
	turbineMove(turbine, maincar, delta);
	if (int((*points) - fmod((*points), GET_NEW_LIFE)) / GET_NEW_LIFE == (*nextLife))
	{
		(*lifes)++;
		(*nextLife)++;
	}
	if (maincar->stune > 0)
		maincar->stune -= delta;
	if (maincar->direction == LEFT)
	{
		if (maincar->carx > 20)
			maincar->carx += maincar->direction * 10;
	}
	else if (maincar->direction == RIGHT)
	{
		if (maincar->carx < (SCREEN_WIDTH - 20))
			maincar->carx += maincar->direction * 10;
	}
	maincar->direction = 0;
	if ((maincar->carx > 240) && (maincar->carx < 400))
	{
		if (maincar->stune <= 0)
			*points += delta * 50 * maincar->etiSpeed;
	}
	else if ((maincar->carx < 190) || (maincar->carx > 450))
		maincar->lifes = 0;
	*position += maincar->etiSpeed * delta * 300;
	if (*position > SCREEN_HEIGHT)
		*position -= SCREEN_HEIGHT;
}

///////////////////////////////////////// LOAD FROM FILE /////////////////////////////////////////////

void loadFromFileScreen(plot surfaces, char text[128], int czerwony, int niebieski, int* quit, int page, int lines)
{
	DrawRectangle(surfaces.screen, 4, 100, SCREEN_WIDTH - 8, 100, czerwony, niebieski);
	sprintf(text, "LOAD FROM FILE [ENTER - choose game, ESC - quit, \032 and\033 - picking page]");
	DrawString(surfaces.screen, surfaces.screen->w / 2 - strlen(text) * 8 / 2, 120, text, surfaces.charset);
	FILE* saves = fopen("saves.txt", "r");
	if (saves == NULL)
	{
		*quit = YES;
	}
	else
	{
		fseek(saves, 0, SEEK_SET);
		for (int i = 1; i <= page; i++)
		{
			char buffor[100];
			int carbuff, lifesbuff;
			double points, worldTime;
			car car1, car2, car3, car4, car5;//car buffors
			if (i < page)
			{
				fscanf(saves, "%s %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %d %d /n", buffor, &points, &worldTime, &car1.X, &car1.Y, &car2.X, &car2.Y, &car3.X, &car3.Y, &car4.X, &car4.Y, &car5.X, &car5.Y, &carbuff, &lifesbuff);
			}
			else
			{
				fscanf(saves, "%s %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %d %d /n", buffor, &points, &worldTime, &car1.X, &car1.Y, &car2.X, &car2.Y, &car3.X, &car3.Y, &car4.X, &car4.Y, &car5.X, &car5.Y, &carbuff, &lifesbuff);
				sprintf(text, "DATE: %s   POINTS: %.0lf   TIME: %.1lf   LIFES: %d", buffor, points, worldTime, lifesbuff);
				DrawString(surfaces.screen, surfaces.screen->w / 2 - strlen(text) * 8 / 2, 158, text, surfaces.charset);
			}
		}
		sprintf(text, "PAGE %d OF %d", page, lines);
		DrawString(surfaces.screen, surfaces.screen->w / 2 - strlen(text) * 8 / 2, 176, text, surfaces.charset);
	}
	fclose(saves);
	SDL_UpdateTexture(surfaces.scrtex, NULL, surfaces.screen->pixels, surfaces.screen->pitch);
	SDL_RenderClear(surfaces.renderer);
	SDL_RenderCopy(surfaces.renderer, surfaces.scrtex, NULL, NULL);
	SDL_RenderPresent(surfaces.renderer);
}

void loadGame(double* points, double* worldTime, int page, npc* npcs, int* carx, int* lifes)
{
	FILE* saves = fopen("saves.txt", "r");
	for (int i = 1; i <= page; i++)
	{
		char bufforx[100];
		if (i < page)
		{
			fscanf(saves, "%s %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %d %d /n", bufforx, points, worldTime, &npcs->enemy1.X, &npcs->enemy1.Y, &npcs->enemy2.X, &npcs->enemy2.Y, &npcs->enemy3.X, &npcs->enemy3.Y, &npcs->ally1.X, &npcs->ally1.Y, &npcs->ally2.X, &npcs->ally2.Y, carx, lifes);
		}
		else
		{
			fscanf(saves, "%s %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %d %d /n", bufforx, points, worldTime, &npcs->enemy1.X, &npcs->enemy1.Y, &npcs->enemy2.X, &npcs->enemy2.Y, &npcs->enemy3.X, &npcs->enemy3.Y, &npcs->ally1.X, &npcs->ally1.Y, &npcs->ally2.X, &npcs->ally2.Y, carx, lifes);
		}
	}
	fclose(saves);
}

void loadFromFile(int* quit, plot surfaces, char text[128], int czerwony, int niebieski, int* t1, int* t2, double* points, double* worldTime, npc* npcs, int* carx, int* lifes)
{
	int quitting = NO;
	int page = 1;
	while ((!(*quit)) && (!quitting))
	{
		FILE* saves = fopen("saves.txt", "r");
		int lines = 0;
		for (char c = getc(saves); c != EOF; c = getc(saves))
			if (c == '\n')
				lines++;
		fclose(saves);

		loadFromFileScreen(surfaces, text, czerwony, niebieski, quit, page, lines);
		*t2 = SDL_GetTicks();
		*t1 = *t2;
		while (SDL_PollEvent(&surfaces.event)) {
			switch (surfaces.event.type) {
			case SDL_KEYDOWN:
				if (surfaces.event.key.keysym.sym == SDLK_RETURN)
				{
					loadGame(points, worldTime, page, npcs, carx, lifes);
					quitting = YES;
				}
				else if (surfaces.event.key.keysym.sym == SDLK_ESCAPE)
					quitting = YES;
				else if (surfaces.event.key.keysym.sym == SDLK_LEFT)
				{
					if (page != 1)
						page--;
				}
				else if (surfaces.event.key.keysym.sym == SDLK_RIGHT)
				{
					if (page != lines)
						page++;
				}
				break;
			case SDL_QUIT:
				*quit = YES;
				break;
			};
		};
	}
}

///////////////////////////////////////// NPC CONTROLLERS ////////////////////////////////////////////

bool isTouchingCar(car car, int carx, int cary)
{
	// position of middle of our car is (carx,cary)
	if ((carx >= (car.X - 18)) && (carx <= (car.X + 18)) && (cary <= (car.Y + 48)) && (cary >= (car.Y - 48)))
		return YES;
	return NO;
}

bool isTouching(int carx, npc npcs)
{
	if (isTouchingCar(npcs.enemy1, carx, CAR_POSITION))
		return YES;
	if (isTouchingCar(npcs.enemy3, carx, CAR_POSITION))
		return YES;
	if (isTouchingCar(npcs.enemy2, carx, CAR_POSITION))
		return YES;
	if (isTouchingCar(npcs.ally1, carx, CAR_POSITION))
		return YES;
	if (isTouchingCar(npcs.ally2, carx, CAR_POSITION))
		return YES;
	return NO;
}

bool willHit(car* cars, car* other1, car* other2, car* other3, car* other4)

{
	if (isTouchingCar(*other1, cars->X, cars->Y))
		return YES;
	if (isTouchingCar(*other2, cars->X, cars->Y))
		return YES;
	if (isTouchingCar(*other3, cars->X, cars->Y))
		return YES;
	if (isTouchingCar(*other4, cars->X, cars->Y))
		return YES;
	return NO;
}

void attackingNpc(car* cars, int carx, double delta, car* other1, car* other2, car* other3, car* other4)
{
	if (((cars->Y) >= (CAR_POSITION - 24)) && ((cars->Y) <= (CAR_POSITION + 24)))
	{
		if (((cars->X) >= carx) && ((cars->X) > 250))
		{
			(cars->X) -= delta * 30;
			if (willHit(cars, other1, other2, other3, other4))
				(cars->X) += delta * 30;
		}
		else if (((cars->X) <= carx) && ((cars->X) < 390))
		{
			(cars->X) += delta * 30;
			if (willHit(cars, other1, other2, other3, other4))
				(cars->X) -= delta * 30;
		}
	}
}

void positionNpc(car* car, double delta, double etispeed)
{
	if (car->Y < -100)
		car->Y = 600;
	else if (car->Y > 700)
		car->Y = 50;
	else
		(car->Y) = (car->Y) + etispeed * delta * 200 - 1.2 * delta * 200;
}

void npcmove(npc* npcs, double delta, double etispeed, int carx)
{
	positionNpc(&npcs->enemy1, delta, etispeed);
	positionNpc(&npcs->enemy2, delta, etispeed);
	positionNpc(&npcs->enemy3, delta, etispeed);
	positionNpc(&npcs->ally1, delta, etispeed);
	positionNpc(&npcs->ally2, delta, etispeed);

	attackingNpc(&npcs->enemy1, carx, delta, &npcs->ally1, &npcs->enemy2, &npcs->enemy3, &npcs->ally2);
	attackingNpc(&npcs->enemy2, carx, delta, &npcs->ally1, &npcs->enemy1, &npcs->enemy3, &npcs->ally2);
	attackingNpc(&npcs->enemy3, carx, delta, &npcs->ally1, &npcs->enemy2, &npcs->enemy1, &npcs->ally2);
}

///////////////////////////////////////// PLOT CREATING FUNCTIONS ////////////////////////////////////

void createMenu(SDL_Surface* screen, toolsgame tools, SDL_Surface* charset, double fps, int czarny, int niebieski, int czerwony, int bulletNumber, int lifes, int bountyShots)
{
	DrawRectangle(screen, 4, 4, SCREEN_WIDTH - 8, 72, czerwony, niebieski);
	sprintf(tools.text, "Gra SpyHunter by Tomasz Sankowski s193363");
	DrawString(screen, screen->w / 2 - strlen(tools.text) * 8 / 2, 10, tools.text, charset);
	sprintf(tools.text, "Esc - wyjscie, n - nowa gra, p - pauza/kontynuuj, f - koniec gry");
	DrawString(screen, screen->w / 2 - strlen(tools.text) * 8 / 2, 26, tools.text, charset);
	sprintf(tools.text, "\030 - przyspieszenie, \031 - zwolnienie, \032 - skret w lewo, \033 - skret w prawo");
	DrawString(screen, screen->w / 2 - strlen(tools.text) * 8 / 2, 42, tools.text, charset);
	sprintf(tools.text, "Game time:  %.1lf s    Points: %.0ld  FPS:  %.0lf", tools.worldTime, tools.tmpPoints, fps);
	DrawString(screen, screen->w / 2 - strlen(tools.text) * 8 / 2, 58, tools.text, charset);
	DrawRectangle(screen, SCREEN_WIDTH * 2 / 3 - 3, SCREEN_HEIGHT - 11, SCREEN_WIDTH / 3, 10, czarny, niebieski);
	sprintf(tools.text, "a,b,c,d,e,f,g,i,j,k,m,n,o");
	DrawString(screen, SCREEN_WIDTH * 2 / 3, SCREEN_HEIGHT - 10, tools.text, charset);
	DrawRectangle(screen, 20, SCREEN_HEIGHT / 2, 130, 60, czarny, niebieski);
	sprintf(tools.text, "bullets: %d/%d", HOW_MANY_BULLETS - bulletNumber, HOW_MANY_BULLETS);
	DrawString(screen, 23, SCREEN_HEIGHT / 2 + 5, tools.text, charset);
	sprintf(tools.text, "Bounty shots: %d", bountyShots);
	DrawString(screen, 23, SCREEN_HEIGHT / 2 + 25, tools.text, charset);
	sprintf(tools.text, "Lifes: %d", lifes);
	DrawString(screen, 23, SCREEN_HEIGHT / 2 + 45, tools.text, charset);
}

void cleanSDL(plot* surfaces, npc* npcs, powerup* turbine)
{
	SDL_FreeSurface(surfaces->background);
	SDL_FreeSurface(surfaces->charset);
	SDL_FreeSurface(surfaces->screen);
	SDL_DestroyTexture(surfaces->scrtex);
	SDL_DestroyWindow(surfaces->window);
	SDL_DestroyRenderer(surfaces->renderer);
	SDL_FreeSurface(npcs->enemy1.surface);
	SDL_FreeSurface(npcs->enemy2.surface);
	SDL_FreeSurface(npcs->enemy3.surface);
	SDL_FreeSurface(npcs->ally1.surface);
	SDL_FreeSurface(npcs->ally2.surface);
	SDL_FreeSurface(turbine->surface);
	SDL_Quit();
}

bool createPlot(plot* surfaces, npc* npcs, powerup* turbine)
{
	surfaces->charset = SDL_LoadBMP("./cs8x8.bmp");
	if (surfaces->charset == NULL) {
		printf("SDL_LoadBMP(cs8x8.bmp) error: %s\n", SDL_GetError());
		cleanSDL(surfaces, npcs, turbine);
		return YES;
	};
	SDL_SetColorKey(surfaces->charset, true, 0x000000);

	surfaces->eti = SDL_LoadBMP("./carbmp.bmp");
	if (surfaces->eti == NULL) {
		printf("SDL_LoadBMP(carbmp.bmp) error: %s\n", SDL_GetError());
		cleanSDL(surfaces, npcs, turbine);
		return YES;
	};

	surfaces->background = SDL_LoadBMP("./grass.bmp");
	if (surfaces->background == NULL) {
		printf("SDL_LoadBMP(background.bmp) error: %s\n", SDL_GetError());
		cleanSDL(surfaces, npcs, turbine);
		return YES;
	};

	npcs->enemy1.surface = SDL_LoadBMP("./enemycar.bmp");
	if (npcs->enemy1.surface == NULL) {
		printf("SDL_LoadBMP(enemycar.bmp) error: %s\n", SDL_GetError());
		cleanSDL(surfaces, npcs, turbine);
		return YES;
	};

	npcs->enemy2.surface = SDL_LoadBMP("./enemycar.bmp");
	if (npcs->enemy2.surface == NULL) {
		printf("SDL_LoadBMP(enemycar.bmp) error: %s\n", SDL_GetError());
		cleanSDL(surfaces, npcs, turbine);
		return YES;
	};

	npcs->enemy3.surface = SDL_LoadBMP("./enemycar.bmp");
	if (npcs->enemy3.surface == NULL) {
		printf("SDL_LoadBMP(enemycar.bmp) error: %s\n", SDL_GetError());
		cleanSDL(surfaces, npcs, turbine);
		SDL_Quit();
		return YES;
	};

	npcs->ally1.surface = SDL_LoadBMP("./goodcar.bmp");
	if (npcs->ally1.surface == NULL) {
		printf("SDL_LoadBMP(enemycar.bmp) error: %s\n", SDL_GetError());
		cleanSDL(surfaces, npcs, turbine);
		return YES;
	};

	npcs->ally2.surface = SDL_LoadBMP("./goodcar.bmp");
	if (npcs->ally2.surface == NULL) {
		printf("SDL_LoadBMP(enemycar.bmp) error: %s\n", SDL_GetError());
		cleanSDL(surfaces, npcs, turbine);
		return YES;
	};

	turbine->surface = SDL_LoadBMP("./turbine.bmp");
	if (npcs->ally2.surface == NULL) {
		printf("SDL_LoadBMP(turbine.bmp) error: %s\n", SDL_GetError());
		cleanSDL(surfaces, npcs, turbine);
		return YES;
	};

	return NO;
}

bool setting(plot* surfaces)
{
	if (SDL_Init(SDL_INIT_EVERYTHING) != 0)
	{
		printf("SDL_Init error: %s\n", SDL_GetError());
		return YES;
	}

	if (SDL_CreateWindowAndRenderer(SCREEN_WIDTH, SCREEN_HEIGHT, 0, &surfaces->window, &surfaces->renderer) != 0)
	{
		SDL_Quit();
		printf("SDL_CreateWindowAndRenderer error: %s\n", SDL_GetError());
		return YES;
	};

	SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, "linear");
	SDL_RenderSetLogicalSize(surfaces->renderer, SCREEN_WIDTH, SCREEN_HEIGHT);
	SDL_SetRenderDrawColor(surfaces->renderer, 0, 0, 0, 255);
	SDL_SetWindowTitle(surfaces->window, "SpyHunter by Tomasz Sankowski 193363");

	surfaces->screen = SDL_CreateRGBSurface(0, SCREEN_WIDTH, SCREEN_HEIGHT, 32, 0x00FF0000, 0x0000FF00, 0x000000FF, 0xFF000000);
	surfaces->scrtex = SDL_CreateTexture(surfaces->renderer, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_STREAMING, SCREEN_WIDTH, SCREEN_HEIGHT);
	SDL_ShowCursor(SDL_DISABLE);
	return NO;
}

///////////////////////////////////////// PAUSE FUNCTION /////////////////////////////////////////////

void pauza(plot surfaces, char text[], int czerwony, int niebieski, int* quit, int* t1, int* t2)
{
	int quitting = NO;
	while ((!(*quit)) && (!quitting))
	{
		*t2 = SDL_GetTicks();
		*t1 = *t2;
		DrawRectangle(surfaces.screen, SCREEN_WIDTH / 2 - 250, SCREEN_HEIGHT / 2 - 20, 500, 40, czerwony, niebieski);
		sprintf(text, "GAME STOPPED! [ESC - exit, p - continue]");
		DrawString(surfaces.screen, SCREEN_WIDTH / 2 - strlen(text) * 8 / 2, SCREEN_HEIGHT / 2 - 4, text, surfaces.charset);
		SDL_UpdateTexture(surfaces.scrtex, NULL, surfaces.screen->pixels, surfaces.screen->pitch);
		SDL_RenderClear(surfaces.renderer);
		SDL_RenderCopy(surfaces.renderer, surfaces.scrtex, NULL, NULL);
		SDL_RenderPresent(surfaces.renderer);
		while (SDL_PollEvent(&surfaces.event)) {
			switch (surfaces.event.type) {
			case SDL_KEYDOWN:
				if (surfaces.event.key.keysym.sym == SDLK_p)
					quitting = YES;
				if (surfaces.event.key.keysym.sym == SDLK_ESCAPE)
					*quit = YES;
				break;
			case SDL_QUIT:
				*quit = YES;
				break;
			};
		};
	}
};

///////////////////////////////////////// SAVE TO FILE ///////////////////////////////////////////////

void saveToFile(npc npcs, int carx, int lifes, double points, double worldTime, int* quit)
{
	time_t t = time(NULL);
	struct tm tm = *localtime(&t);
	char file[40];
	sprintf(file, "%d-%02d-%02d-%02d-%02d-%02d", tm.tm_mday, tm.tm_mon + 1, tm.tm_year + 1900, tm.tm_hour, tm.tm_min, tm.tm_sec);
	FILE* saves = fopen("saves.txt", "a");
	if (saves == NULL)
	{
		*quit = YES;
	}
	else
	{
		fprintf(saves, "%s %lf %lf ", file, points, worldTime);
		fprintf(saves, "%lf %lf %lf %lf %lf %lf ", npcs.enemy1.X, npcs.enemy1.Y, npcs.enemy2.X, npcs.enemy2.Y, npcs.enemy3.X, npcs.enemy3.Y);
		fprintf(saves, "%lf %lf %lf %lf %d %d\n", npcs.ally1.X, npcs.ally1.Y, npcs.ally2.X, npcs.ally2.Y, carx, lifes);
	}
	fclose(saves);
	FILE* board = fopen("leaderboard.txt", "a");
	if (board == NULL)
	{
		*quit = YES;
	}
	else
	{
		fprintf(board, "%lf %lf \n", points, worldTime);
	}
	fclose(board);
}

void save(plot surfaces, char text[128], int czerwony, int niebieski, int* quit, double points, double worldTime, npc npcs, int carx, int* t1, int* t2, int lifes)
{
	int quitting = NO;
	while ((!(*quit)) && (!quitting))
	{
		*t2 = SDL_GetTicks();
		*t1 = *t2;
		DrawRectangle(surfaces.screen, SCREEN_WIDTH / 2 - 250, SCREEN_HEIGHT / 2 - 20, 500, 40, czerwony, niebieski);
		sprintf(text, "SAVE GAME! [ESC - exit, ENTER - save and continue]");
		DrawString(surfaces.screen, SCREEN_WIDTH / 2 - strlen(text) * 8 / 2, SCREEN_HEIGHT / 2 - 4, text, surfaces.charset);
		SDL_UpdateTexture(surfaces.scrtex, NULL, surfaces.screen->pixels, surfaces.screen->pitch);
		SDL_RenderClear(surfaces.renderer);
		SDL_RenderCopy(surfaces.renderer, surfaces.scrtex, NULL, NULL);
		SDL_RenderPresent(surfaces.renderer);
		while (SDL_PollEvent(&surfaces.event)) {
			switch (surfaces.event.type) {
			case SDL_KEYDOWN:
				if (surfaces.event.key.keysym.sym == SDLK_RETURN)
				{
					quitting = YES;
					saveToFile(npcs, carx, lifes, points, worldTime, quit);
				}
				if (surfaces.event.key.keysym.sym == SDLK_ESCAPE)
					quitting = YES;
				break;
			case SDL_QUIT:
				*quit = YES;
				break;
			};
		};
	}
}

///////////////////////////////////////// PVE MANEGMENT //////////////////////////////////////////////

void shot(character maincar, bullet bullets[HOW_MANY_BULLETS], int* bountyShots)
{
	bool found = NO;
	if ( (*bountyShots) >= 2)
	{
		(*bountyShots)-=2;
		for (int i = 0; i < HOW_MANY_BULLETS; i++)
		{
			if ((bullets[i].occupied == NO) && (found == 0))
			{

				bullets[i].occupied = YES;
				bullets[i].X = maincar.carx-8;
				bullets[i].Y = maincar.cary - 30;
				bullets[i].distance = 0;
				for (int i = 0; i < HOW_MANY_BULLETS; i++)
				{
					if ((bullets[i].occupied == NO) && (found == NO))
					{

						bullets[i].occupied = YES;
						bullets[i].X = maincar.carx+8;
						bullets[i].Y = maincar.cary - 30;
						bullets[i].distance = 0;
						found = YES;
					}
				}
			}
		}
	}
	else
	{
		for (int i = 0; i < HOW_MANY_BULLETS; i++)
		{
			if ((bullets[i].occupied == NO) && (found == NO))
			{

				bullets[i].occupied = YES;
				bullets[i].X = maincar.carx;
				bullets[i].Y = maincar.cary - 30;
				bullets[i].distance = 0;
				found = YES;
			}
		}
	}
}

void bulletsFlow(bullet bullets[HOW_MANY_BULLETS], double delta, SDL_Surface* screen, int czerwony)
{
	for (int i = 0; i < HOW_MANY_BULLETS; i++)
	{
		if (bullets[i].occupied == YES)
		{
			bullets[i].distance += delta;
			bullets[i].Y -= delta * BULLET_SPEED;
			if (bullets[i].distance > BULLET_LIFETIME)
			{
				bullets[i].distance = 0;
				bullets[i].occupied = NO;
			}
			else
			{
				DrawLine(screen, bullets[i].X, int(bullets[i].Y), 5, 0, 1, czerwony);
			}
		}
	}
}

bool isShooting(car enemy1, bullet bullets)
{
	if ((bullets.X <= (enemy1.X + 9)) && (bullets.X >= (enemy1.X - 9)) && ((bullets.Y) <= (enemy1.Y + 24)) && ((bullets.Y + 5) >= (enemy1.Y - 24)))
		return YES;
	else
		return NO;
}

void newPosition(car* rat, car car1, car car2, car car3, car car4, character car5)
{
	rat->X = rand() % 140 + 250;
	rat->Y = rand() % 480;
	while (
		(distance(rat->X, rat->Y, car1.X, car1.Y) < 52) ||
		(distance(rat->X, rat->Y, car2.X, car2.Y) < 52) ||
		(distance(rat->X, rat->Y, car3.X, car3.Y) < 52) ||
		(distance(rat->X, rat->Y, car4.X, car4.Y) < 52) ||
		(distance(rat->X, rat->Y, car5.carx, car5.cary) < 200))
	{
		rat->X = rand() % 140 + 250;
		rat->Y = rand() % 480;
	}
}

void shottedEnemy(character* maincar, double* points, bullet* bullets)
{
	if (maincar->stune <= 0)
		*points += SHOTPOINTS;
	bullets->occupied = NO;
	bullets->distance = 0;
}
void shottedAlly(character* maincar, bullet* bullets)
{
	maincar->stune += 5.0;
	bullets->occupied = NO;
	bullets->distance = 0;
}
void shootingKills(bullet* bullets, npc* npcs, double* points, character* maincar)
{
	for (int i = 0; i < HOW_MANY_BULLETS; i++)
	{
		if (bullets[i].occupied == YES)
		{
			if (isShooting(npcs->enemy1, bullets[i]))
			{
				shottedEnemy(maincar, points, &bullets[i]);
				newPosition(&npcs->enemy1, npcs->enemy2, npcs->enemy3, npcs->ally1, npcs->ally2, *maincar);
			}
			if (isShooting(npcs->enemy2, bullets[i]))
			{
				shottedEnemy(maincar, points, &bullets[i]);
				newPosition(&npcs->enemy2, npcs->enemy1, npcs->enemy3, npcs->ally1, npcs->ally2, *maincar);
			}
			if (isShooting(npcs->enemy3, bullets[i]))
			{
				shottedEnemy(maincar, points, &bullets[i]);
				newPosition(&npcs->enemy3, npcs->enemy1, npcs->enemy2, npcs->ally1, npcs->ally2, *maincar);
			}
			if (isShooting(npcs->ally1, bullets[i]))
			{
				shottedAlly(maincar, &bullets[i]);
				newPosition(&npcs->ally1, npcs->enemy2, npcs->enemy3, npcs->enemy1, npcs->ally2, *maincar);
			}
			if (isShooting(npcs->ally2, bullets[i]))
			{
				shottedAlly(maincar, &bullets[i]);
				newPosition(&npcs->ally2, npcs->enemy2, npcs->enemy3, npcs->ally1, npcs->enemy1, *maincar);
			}
		}
	}
}

void colisionFunction(character* maincar, npc npcs)
{
	if ((isTouching(maincar->carx, npcs) == YES) && (maincar->stune < 0))
	{
		maincar->carx = SCREEN_WIDTH / 2;
		maincar->stune += 3;
		maincar->lifes--;
	}
}

///////////////////////////////////////// LEADERBOARD AND ENDGAME SCREEN /////////////////////////////

void sortArrays(double arr1[], double arr2[], int lines)//sort by values of arr1
{
	for (int i = 0; i < lines; ++i)
	{
		for (int j = i + 1; j < lines; ++j)
		{
			if (arr1[i] < arr1[j])
			{
				int tmp = arr1[i];
				arr1[i] = arr1[j];
				arr1[j] = tmp;
				tmp = arr2[i];
				arr2[i] = arr2[j];
				arr2[j] = tmp;
			}
		}
	}
}

void deleteLine(int pointed, int lines)
{
	char filename[] = "leaderboard.txt";
	char tmpfilename[] = "tmpleaderboard.txt";
	FILE* file = fopen(filename, "r");
	FILE* tmpfile = fopen(tmpfilename, "w");
	char buffor[255];
	if (file != NULL || tmpfile != NULL)
	{
		for (int i = 1; i <= lines; i++)
		{

			fgets(buffor, 255, file);
			if (i != pointed)
				fputs(buffor, tmpfile);
		}
		fclose(file);
		fclose(tmpfile);
		remove(filename);
		rename(tmpfilename, filename);
	}
}

void saveLeaderboard(double points[], double lenghts[], int lines)
{
	remove("leaderboard.txt");
	FILE* file = fopen("leaderboard.txt", "w");
	char buffor[150];
	if (file != NULL)
	{
		for (int i = 0; i < lines; i++)
		{
			fprintf(file, "%lf %lf \n", points[i], lenghts[i]);
		}
		fclose(file);
	}
}
void drawLeaderboard(int czerwony, int niebieski, plot surfaces, char text[], int page, int lines, double points[], double lenghts[], int pointed, int pages)
	{
		DrawRectangle(surfaces.screen, 4, 100, SCREEN_WIDTH - 8, 300, czerwony, niebieski);
		sprintf(text, "LEADERBOARD: [SPACEBAR TO DELETE]");
		DrawString(surfaces.screen, SCREEN_WIDTH / 2 - strlen(text) * 8 / 2, 110, text, surfaces.charset);
		sprintf(text, "No.");
		DrawString(surfaces.screen, 40, 130, text, surfaces.charset);
		sprintf(text, "Points:");
		DrawString(surfaces.screen, 100, 130, text, surfaces.charset);
		sprintf(text, "Time:");
		DrawString(surfaces.screen, 200, 130, text, surfaces.charset);
		for (int i = 1; i <= 10; i++)
		{
			int j = (page - 1) * 10 + i;
			if (j <= lines)
			{
				sprintf(text, "%d :", j);
				DrawString(surfaces.screen, 40, (130 + 20 * i), text, surfaces.charset);
				sprintf(text, "%.0lf", points[j - 1]);
				DrawString(surfaces.screen, 100, (130 + 20 * i), text, surfaces.charset);
				sprintf(text, "%.0lf", lenghts[j - 1]);
				DrawString(surfaces.screen, 200, (130 + 20 * i), text, surfaces.charset);
			}
			if (i == pointed)
			{
				sprintf(text, "->");
				DrawString(surfaces.screen, 10, (130 + 20 * i), text, surfaces.charset);
			}
		}
		sprintf(text, "p-list sorted by points, t-list sorted by time, arrows-move between records");
		DrawString(surfaces.screen, surfaces.screen->w / 2 - strlen(text) * 8 / 2, 350, text, surfaces.charset);
		sprintf(text, "PAGE %d OF %d", page, pages);
		DrawString(surfaces.screen, surfaces.screen->w / 2 - strlen(text) * 8 / 2, 370, text, surfaces.charset);
		SDL_UpdateTexture(surfaces.scrtex, NULL, surfaces.screen->pixels, surfaces.screen->pitch);
		SDL_RenderClear(surfaces.renderer);
		SDL_RenderCopy(surfaces.renderer, surfaces.scrtex, NULL, NULL);
		SDL_RenderPresent(surfaces.renderer);
	}

void leaderboardScreen(plot surfaces, char text[], int czerwony, int niebieski, int* quit, int* t1, int* t2)
{
	int quitting = NO;
	int pointed = 1;
	int page = 1;
	int lines = 0;
	int pages = ceil((double)lines / 10);
	while ((!(*quit)) && (!(quitting)))
	{
		*t2 = SDL_GetTicks();
		*t1 = *t2;
		FILE* leaderboard = fopen("leaderboard.txt", "r");
		lines = 0;
		for (char c = getc(leaderboard); c != EOF; c = getc(leaderboard))
			if (c == '\n')
				lines++;
		fseek(leaderboard, 0, SEEK_SET);
		double* points = (double*)malloc(sizeof(double) * lines);
		double* lenghts = (double*)malloc(sizeof(double) * lines);
		for (int i = 0; i < lines; i++)
		{
			fscanf(leaderboard, "%lf %lf /n", &points[i], &lenghts[i]);
		}
		fclose(leaderboard);
		pages = ceil((double)lines / 10);
		drawLeaderboard(czerwony, niebieski, surfaces, text, page, lines, points, lenghts, pointed, pages);
		while (SDL_PollEvent(&surfaces.event)) {
			switch (surfaces.event.type) {
			case SDL_KEYDOWN:
				if (surfaces.event.key.keysym.sym == SDLK_p)
				{
					sortArrays(points, lenghts, lines);
					saveLeaderboard(points, lenghts, lines);
				}
				else if (surfaces.event.key.keysym.sym == SDLK_t)
				{
					sortArrays(lenghts, points, lines);
					saveLeaderboard(points, lenghts, lines);
				}
				else if (surfaces.event.key.keysym.sym == SDLK_ESCAPE)
					quitting = YES;
				else if (surfaces.event.key.keysym.sym == SDLK_RETURN)
				{
					deleteLine(pointed, lines);
				}
				else if (surfaces.event.key.keysym.sym == SDLK_LEFT)
				{
					if (page != 1)
						page--;
				}
				else if (surfaces.event.key.keysym.sym == SDLK_RIGHT)
				{
					if (page != pages)
						page++;
				}
				else if (surfaces.event.key.keysym.sym == SDLK_UP)
				{
					if (pointed != 1)
						pointed--;
				}
				else if (surfaces.event.key.keysym.sym == SDLK_DOWN)
				{
					if (pointed != 10)
						pointed++;
				}
				break;
			case SDL_QUIT:
				*quit = YES;
				break;
			};
		};
	}
};

void endScreen(plot surfaces, char text[], int czerwony, int niebieski, int* quit, int* t1, int* t2, double points, double worldTime, npc npcs, int carx, int lifes, int czarny, bool isDead)
{
	int quitting = NO;
	while ((!(*quit)) && (!quitting))
	{
		*t2 = SDL_GetTicks();
		*t1 = *t2;
		DrawRectangle(surfaces.screen, 0, 0, 640, 480, czerwony, czarny);
		DrawRectangle(surfaces.screen, 10, SCREEN_HEIGHT / 2 - 20, 620, 40, czerwony, niebieski);
		if(isDead)
			sprintf(text, "GAME ENDED! [ENTER - save and quit, L - leaderboards ESC- quit]");
		else
			sprintf(text, "GAME ENDED! [ENTER - save and quit, L - leaderboards ESC- back to game]");
		DrawString(surfaces.screen, SCREEN_WIDTH / 2 - strlen(text) * 8 / 2, SCREEN_HEIGHT / 2 - 4, text, surfaces.charset);
		SDL_UpdateTexture(surfaces.scrtex, NULL, surfaces.screen->pixels, surfaces.screen->pitch);
		SDL_RenderClear(surfaces.renderer);
		SDL_RenderCopy(surfaces.renderer, surfaces.scrtex, NULL, NULL);
		SDL_RenderPresent(surfaces.renderer);
		while (SDL_PollEvent(&surfaces.event)) {
			switch (surfaces.event.type) {
			case SDL_KEYDOWN:
				if (surfaces.event.key.keysym.sym == SDLK_ESCAPE)
				{
					if (isDead)
					{
						saveToFile(npcs, carx, lifes, points, worldTime, quit);
						*quit = YES;
					}
					else
						quitting = YES;
				}
				if (surfaces.event.key.keysym.sym == SDLK_RETURN)
				{
					saveToFile(npcs, carx, lifes, points, worldTime, quit);
					*quit = YES;
				}
				if (surfaces.event.key.keysym.sym == SDLK_l)
				{
					leaderboardScreen(surfaces, text, czerwony, niebieski, quit, t1, t2);
				}
				break;
			case SDL_QUIT:
				*quit = YES;
				break;
			};
		};
	}
}



///////////////////////////////////////// MAIN FUNCTIONS /////////////////////////////////////////////


#ifdef __cplusplus
extern "C"
#endif
int main(int argc, char** argv) {
	npc npcs;
	powerup turbine;
	toolsfps fpstools;
	toolsgame tools;
	character maincar;
	bullet bullets[HOW_MANY_BULLETS];
	plot surfaces;
	/////////////////////////////////////////// setting game /////////////////////
	if (setting(&surfaces))
		return 1;
	if (createPlot(&surfaces, &npcs, &turbine))
		return 1;

	int czarny = SDL_MapRGB(surfaces.screen->format, 0x00, 0x00, 0x00);
	int zielony = SDL_MapRGB(surfaces.screen->format, 0x00, 0xFF, 0x00);
	int czerwony = SDL_MapRGB(surfaces.screen->format, 0xFF, 0x00, 0x00);
	int niebieski = SDL_MapRGB(surfaces.screen->format, 0x11, 0x11, 0xCC);
	int szary = SDL_MapRGB(surfaces.screen->format, 105, 105, 105);
	int zolty = SDL_MapRGB(surfaces.screen->format, 255, 255, 000);

	fpstools.t1 = SDL_GetTicks();
	resetVariables(&maincar, &fpstools, &tools, &npcs, bullets, &turbine);
	/////////////////////////////////////////// frame service //////////////////
	while (!tools.quit) {
		////////////////////////////////////// fps and stuff ///////////////////
		if(maincar.lifes<=0)
			endScreen(surfaces, tools.text, czerwony, niebieski, &tools.quit, &fpstools.t1, &fpstools.t2, fpstools.points, tools.worldTime, npcs, maincar.carx, maincar.lifes, czarny, YES);
		fpstools.t2 = SDL_GetTicks();
		fpstools.delta = (fpstools.t2 - fpstools.t1) * MILISECONDS;
		fpstools.t1 = fpstools.t2;
		tools.worldTime += fpstools.delta;
		tools.distance += maincar.etiSpeed * fpstools.delta;
		fpstools.fpsTimer += fpstools.delta;
		if (fpstools.fpsTimer > FPS_FREQUENCE) {
			fpstools.fps = fpstools.frames / FPS_FREQUENCE;
			fpstools.frames = 0;
			fpstools.fpsTimer -= FPS_FREQUENCE;
		};
		///////////////////////////////////// every-tick functions /////////////
		colisionFunction(&maincar, npcs);
		move(&maincar, &fpstools.points, fpstools.delta, &tools.position, &maincar.lifes, &maincar.nextLife, &turbine);
		npcmove(&npcs, fpstools.delta, maincar.etiSpeed, maincar.carx);
		shootingKills(bullets, &npcs, &fpstools.points, &maincar);
		tools.tmpPoints = int(fpstools.points) - (int(fpstools.points) % 50);
		int bulletNumber = 0;
		for (int i = 0; i < HOW_MANY_BULLETS; i++)
			if (bullets[i].occupied == YES)
				bulletNumber++;
		////////////////////////////////////// drawing plot ////////////////////
		SDL_FillRect(surfaces.screen, NULL, zielony);
		DrawSurface(surfaces.screen, surfaces.background, IMAGE1_COORDINATES);
		DrawSurface(surfaces.screen, surfaces.background, IMAGE2_COORDINATES);

		if ((maincar.stune > 0) && (maincar.stune <= 1))
			DrawRectangle(surfaces.screen, SCREEN_WIDTH / 2 - 80, 0, 160, SCREEN_HEIGHT, czerwony, szary);
		else if (maincar.stune > 1)
			DrawRectangle(surfaces.screen, SCREEN_WIDTH / 2 - 80, 0, 160, SCREEN_HEIGHT, zolty, szary);
		else
			DrawRectangle(surfaces.screen, SCREEN_WIDTH / 2 - 80, 0, 160, SCREEN_HEIGHT, czarny, szary);

		DrawSurface(surfaces.screen, turbine.surface, turbine.X, turbine.Y);
		DrawSurface(surfaces.screen, surfaces.eti, maincar.carx, maincar.cary);
		DrawSurface(surfaces.screen, npcs.enemy1.surface, npcs.enemy1.X, npcs.enemy1.Y);
		DrawSurface(surfaces.screen, npcs.ally1.surface, npcs.ally1.X, npcs.ally1.Y);
		DrawSurface(surfaces.screen, npcs.enemy2.surface, npcs.enemy2.X, npcs.enemy2.Y);
		DrawSurface(surfaces.screen, npcs.ally2.surface, npcs.ally2.X, npcs.ally2.Y);
		DrawSurface(surfaces.screen, npcs.enemy3.surface, npcs.enemy3.X, npcs.enemy3.Y);

		createMenu(surfaces.screen, tools, surfaces.charset, fpstools.fps, czarny, niebieski, czerwony, bulletNumber, maincar.lifes, maincar.bountyShots);

		bulletsFlow(bullets, fpstools.delta, surfaces.screen, czerwony);
		SDL_UpdateTexture(surfaces.scrtex, NULL, surfaces.screen->pixels, surfaces.screen->pitch);
		SDL_RenderClear(surfaces.renderer);
		SDL_RenderCopy(surfaces.renderer, surfaces.scrtex, NULL, NULL);
		SDL_RenderPresent(surfaces.renderer);
		////////////////////////////////////// handling events /////////////////
		while (SDL_PollEvent(&surfaces.event)) {
			switch (surfaces.event.type) {
			case SDL_KEYDOWN:
				if (surfaces.event.key.keysym.sym == SDLK_ESCAPE)
					tools.quit = YES;
				else if (surfaces.event.key.keysym.sym == SDLK_n)
					resetVariables(&maincar, &fpstools, &tools, &npcs, bullets, &turbine);
				else if (surfaces.event.key.keysym.sym == SDLK_p)
					pauza(surfaces, tools.text, czerwony, niebieski, &tools.quit, &fpstools.t1, &fpstools.t2);
				else if (surfaces.event.key.keysym.sym == SDLK_s)
					save(surfaces, tools.text, czerwony, niebieski, &tools.quit, fpstools.points, tools.worldTime, npcs, maincar.carx, &fpstools.t1, &fpstools.t2, maincar.lifes);
				else if (surfaces.event.key.keysym.sym == SDLK_l) {
					loadFromFile(&tools.quit, surfaces, tools.text, czerwony, niebieski, &fpstools.t1, &fpstools.t2, &fpstools.points, &tools.worldTime, &npcs, &maincar.carx, &maincar.lifes);
					maincar.stune = 3;
					resetBullets(bullets);
				}
				else if (surfaces.event.key.keysym.sym == SDLK_f)
					endScreen(surfaces, tools.text, czerwony, niebieski, &tools.quit, &fpstools.t1, &fpstools.t2, fpstools.points, tools.worldTime, npcs, maincar.carx, maincar.lifes, czarny, NO);
				else if (surfaces.event.key.keysym.sym == SDLK_UP)
					maincar.etiSpeed = 2.0;
				else if (surfaces.event.key.keysym.sym == SDLK_DOWN)
					maincar.etiSpeed = 0.5;
				else if (surfaces.event.key.keysym.sym == SDLK_LEFT)
					maincar.direction = LEFT;
				else if (surfaces.event.key.keysym.sym == SDLK_RIGHT)
					maincar.direction = RIGHT;
				else if (surfaces.event.key.keysym.sym == SDLK_SPACE)
					shot(maincar, bullets, &maincar.bountyShots);
				break;
			case SDL_KEYUP:
				maincar.etiSpeed = 1.0;
				break;
			case SDL_QUIT:
				tools.quit = YES;
				break;
			};
		};
		fpstools.frames++;
	};
	cleanSDL(&surfaces, &npcs, &turbine);//free memory
	return 0;
};