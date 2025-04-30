#include <stdio.h>

#include "m_argv.h"

#include "doomgeneric.h"
#include "w_wad.h"
#include "z_zone.h"
#include "i_video.h"

// Adjusting color shifts to convert from BGRA to RGBA
#define DG_COLOR_R_SHIFT 16
#define DG_COLOR_G_SHIFT 8
#define DG_COLOR_B_SHIFT 0
#define DG_COLOR_A_SHIFT 24

extern byte *screens[5];  // DOOM's indexed framebuffer

uint32_t* DG_ScreenBuffer = 0;

void M_FindResponseFile(void);
void D_DoomMain (void);


void doomgeneric_Create(int argc, char **argv)
{
	// save arguments
    myargc = argc;
    myargv = argv;

	M_FindResponseFile();

	DG_ScreenBuffer = malloc(DOOMGENERIC_RESX * DOOMGENERIC_RESY * 4);

	DG_Init();

	D_DoomMain ();
}

void DG_DrawFrame(void)
{
    if (!DG_ScreenBuffer)
        return;

    static const byte *palette = NULL;
    if (!palette)
    {
        palette = W_CacheLumpName("PLAYPAL", PU_CACHE);
    }

    byte *src = screens[0];
    uint32_t *dst = DG_ScreenBuffer;

    for (int i = 0; i < SCREENWIDTH * SCREENHEIGHT; ++i)
    {
        byte index = src[i];
        byte r = palette[index * 3 + 2];
        byte g = palette[index * 3 + 1];
        byte b = palette[index * 3 + 0];

        dst[i] = (255 << DG_COLOR_A_SHIFT) |
                 (r << DG_COLOR_R_SHIFT) |
                 (g << DG_COLOR_G_SHIFT) |
                 (b << DG_COLOR_B_SHIFT);
    }
}
