
;===========================================================+
; ++ NAME ++
PRO mycolorbar, min, max, xcor=xcor, ycor=ycor, $
								nlevels=nlevels, log=log,top=top , $
								caption=caption, format=format,   $
								cgap=cgap, n_minor=n_minor,       $
								cmax=cmax, cmin=cmin, rev=rev
;
; ++ PURPOSE ++
;  -->
;
; ++ POSITIONAL ARGUMENTS ++
;  -->
;
; ++ KEYWORDS ++
; -->
;
; ++ CALLING SEQUENCE ++
;  -->
;
; ++ HISTORY ++
;  H.Koike 1/9,2021
;===========================================================+


!P.NOERASE=1
;
xmargin = !X.MARGIN[1] * !D.X_CH_SIZE / FLOAT(!D.X_VSIZE)
ycharsize = !D.Y_CH_SIZE / FLOAT(!D.Y_VSIZE)
xcharsize = !D.X_CH_SIZE / FLOAT(!D.X_VSIZE)
;
;*---------- frame  ----------*
;
;
IF ~KEYWORD_SET(xcor) THEN BEGIN
		IF !Y.TICKLEN LE 0 THEN $
			xoffset = (1. - !P.POSITION[2]) * 0.2 
		IF !Y.TICKLEN GT 0 THEN xoffset = ABS(!Y.TICKLEN)
		xcor0 = !P.POSITION[2] + xoffset	 	 
		xcor1 = xcor0 	 
		wid   = (1. - !P.POSITION[2])*.3
		xcor2 = xcor0 + wid 
		xcor3 = xcor2
ENDIF
;
IF ~KEYWORD_SET(ycor) THEN BEGIN
		ycor0 = !P.POSITION[1]	 	 
		ycor1 = !P.POSITION[3] 	 
		ycor2 = ycor1 
		ycor3 = ycor0
ENDIF
;
;
IF ISA(xcor0) THEN GOTO, jump1
IF N_ELEMENTS(xcor) NE 4 OR N_ELEMENTS(ycor) NE 4 THEN BEGIN 
	PRINT, '% xcor and ycor must be 4 elemnts array'
	RETURN
ENDIF ELSE BEGIN
	xcor0 = xcor[0]
	xcor1 = xcor[1]
	xcor2 = xcor[2]
	xcor3 = xcor[3]
	ycor0 = ycor[0]
	ycor1 = ycor[1]
	ycor2 = ycor[2]
	ycor3 = ycor[3]
	wid   = xcor[3] - xcor[0]
ENDELSE
;


jump1:
;
;*---------- fill ----------*
;
IF ~KEYWORD_SET(nlevels) THEN nlevels=50
colors = BYTSCL(INDGEN(nlevels), TOP=top)
IF KEYWORD_SET(rev) THEN colors = 255 - colors
;
;
dhei = (ycor1 - ycor0) / nlevels
xcor = [xcor0, xcor1, xcor2, xcor3]
ycor = [ycor0, ycor0+dhei, ycor0+dhei, ycor0]
;
FOR i = 0, nlevels - 1 DO BEGIN 
  ;
	IF KEYWORD_SET(cmin) AND i EQ 0 THEN BEGIN
		DEVICE, DECOMPOSED=1
		POLYFILL, xcor, ycor, COLOR=cmin, /NORMAL
		DEVICE, DECOMPOSED=0
		CONTINUE
	ENDIF
	;
	IF KEYWORD_SET(cmax) AND i EQ nlevels - 1 THEN BEGIN
		DEVICE, DECOMPOSED=1
		POLYFILL, xcor, ycor, COLOR=cmax, /NORMAL
		DEVICE, DECOMPOSED=0
		CONTINUE
	ENDIF
	;
	POLYFILL, xcor, ycor, COLOR=colors[i], /NORMAL
	ycor += dhei
ENDFOR





DEVICE, GET_DECOMPOSED=dec
DEVICE, DECOMPOSED=1
;
hei = ycor1 - ycor0
;-------------------------------------------------+
;  linear scale
;-------------------------------------------------+
IF KEYWORD_SET(log) THEN GOTO, jump2
IF ~KEYWORD_SET(format) THEN format='(F8.2)'
IF ~KEYWORD_SET(n_minor) THEN n_minor=4
;
scale_interval, [min, max], n_minor=n_minor, $
								major=major, minor=minor
a = (ycor1 - ycor0) / (max - min)
;
;*---------- major ----------*
;
major_tick_len = wid * 0.4
;
y_major_ticks = (major - min) * a + ycor0 
;
FOR i = 0, N_ELEMENTS(major) - 1 DO BEGIN
	IF y_major_ticks[i] LT ycor0 OR $
	   y_major_ticks[i] GT ycor1 THEN CONTINUE
	PLOTS, [xcor2, xcor2-major_tick_len], $
				 [y_major_ticks[i], y_major_ticks[i]], $
				 COLOR='000000'x, /NORMAL
	;
	label = STRING(major[i], FORMAT=format) 
  label = STRCOMPRESS(label, /REMOVE_ALL)
	XYOUTS, xcor2+xcharsize*0.5, $
					y_major_ticks[i] - ycharsize*0.5, label,$
					/NORMAL, COLOR='000000'x 
ENDFOR
;
;*---------- minor tick  ----------*
;
minor_tick_len = wid * 0.2
;
y_minor_ticks = (minor - min) * a + ycor0 
;
FOR i = 0, N_ELEMENTS(minor) - 1 DO BEGIN
	IF y_minor_ticks[i] LT ycor0 OR $
	   y_minor_ticks[i] GT ycor1 THEN CONTINUE
	PLOTS, [xcor2, xcor2 - minor_tick_len],     $
 				 [y_minor_ticks[i], y_minor_ticks[i]],$
 				 COLOR='000000'x, /NORMAL
ENDFOR
;
 




;-------------------------------------------------+
; logarithmic scale
;-------------------------------------------------+
jump2:
IF ~KEYWORD_SET(log) THEN GOTO, jump3
;
fmax  = ALOG10(max)
fmin  = ALOG10(min)
pmin = CEIL(fmin)
pmax = FLOOR(fmax)
;
df  = fmax - fmin
a   = (ycor1 - ycor0) / df
;
;
;
;*---------- major tick  ----------*
;
major_tick_len = wid * 0.4
n_major = pmax - pmin + 1  
f_tick = FINDGEN(n_major) + pmin 
y_major_ticks = (f_tick - fmin)*a + ycor0
;
FOR i = 0, n_major - 1 DO BEGIN
	PLOTS, [xcor2, xcor2-major_tick_len], $
				 [y_major_ticks[i], y_major_ticks[i]], $
				 COLOR='000000'x, /NORMAL
	;
	label = '10!U' + STRING(f_tick[i], FORMAT='(I3)') + '!N'
  label = STRCOMPRESS(label, /REMOVE_ALL)
	XYOUTS, xcor2, y_major_ticks[i] - ycharsize*0.5, label,$
					/NORMAL, COLOR='000000'x 
ENDFOR

;
;*---------- minor tick  ----------*
;
minor_tick_len = wid * 0.2
;
deci = [0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]
;
FOR p = pmin, pmax+1 DO BEGIN
	f_tick = ALOG10(10^FLOAT(p)*deci)
	count = 1
	;
	IF p EQ pmin THEN $
		f_tick = f_tick[ WHERE(f_tick GE fmin, count) ]
	IF p EQ pmax+1 THEN $
		f_tick = f_tick[ WHERE(f_tick LE fmax, count) ]
	;
	IF count EQ 0 THEN CONTINUE 
	;
 	y_minor_ticks = (f_tick - fmin)*a + ycor0
  FOR i = 0, N_ELEMENTS(f_tick) - 1 DO $
		PLOTS, [xcor2, xcor2 - minor_tick_len],    $
					 [y_minor_ticks[i], y_minor_ticks[i]],$
					 COLOR='000000'x, /NORMAL

ENDFOR




jump3:
;
;*---------- frame  ----------*
;
PLOTS, [XCOR0, XCOR1], [YCOR0, YCOR1], /NORMAL, COLOR='000000'x
PLOTS, [XCOR1, XCOR2], [YCOR1, YCOR2], /NORMAL, COLOR='000000'x
PLOTS, [XCOR2, XCOR3], [YCOR2, YCOR3], /NORMAL, COLOR='000000'x
PLOTS, [XCOR3, XCOR0], [YCOR3, YCOR0], /NORMAL, COLOR='000000'x 


;
;*---------- caption  ----------*
;
cs = 1.
IF !P.CHARSIZE NE 0 THEN cs = !P.CHARSIZE
IF !P.CHARSIZE EQ 0 THEN cs = 1
;
IF ~KEYWORD_SET(cgap) THEN cgap = 4.
;
IF KEYWORD_SET(caption) THEN BEGIN
	ycap = (ycor0 + ycor1) / 2.
	xcap = xcor2 + xcharsize * cgap * cs
 	XYOUTS, xcap, ycap, caption, ORIENTATION=90, $
	       	COLOR='000000'x, /NORMAL, ALIGNMENT=0.5
ENDIF


DEVICE, DECOMPOSED=dec
!P.NOERASE=0

END


