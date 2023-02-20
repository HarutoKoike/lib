PRO write_png_background, xsize, ysize
SET_PLOT, 'Z'
loadct, 39, /silent
!p.color=0
!p.background=255
!p.charsize=0.8
DEVICE, SET_PIXEL_DEPTH=24
DEVICE, SET_RESOLUTION=[xsize, ysize]
DEVICE, DECOMPOSED=0
ERASE, 255
END
