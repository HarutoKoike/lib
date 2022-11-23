;===========================================================+
; ++ NAME ++
PRO idlplotlib::plot_circle, radius, center, fill=fill, angle=angle, _EXTRA=EX 
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
;  H.Koike 
;===========================================================+
COMPILE_OPT IDL2, STATIC
;
IF ~KEYWORD_SET(angle) THEN angle = [0., 360.]
;
n_theta = 60.
n_r     = 50.

r     = FINDGEN(n_r) / FLOAT(n_r-1) * radius 
theta = FINDGEN(n_theta) / FLOAT(n_theta - 1) * $
        (angle[1] - angle[0]) + angle[0]
theta = theta * !DTOR

FOR i = 0, n_theta - 2 DO BEGIN
    FOR j=0, n_r - 2 DO BEGIN
        x = [ $
             r[j]   * COS(theta[i]) , $
             r[j+1] * COS(theta[i]) , $
             r[j+1] * COS(theta[i+1]) , $
             r[j]   * COS(theta[i+1])  $
             ]
        ;
        y = [ $
             r[j]   * SIN(theta[i]) , $
             r[j+1] * SIN(theta[i]) , $
             r[j+1] * SIN(theta[i+1]) , $
             r[j]   * SIN(theta[i+1])  $
             ]
        ;
        x += center[0]
        y += center[1]
        POLYFILL, x, y, _EXTRA=ex
    ENDFOR
ENDFOR

END
