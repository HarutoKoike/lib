;===========================================================+
; ++ NAME ++
PRO idlplotlib::polar_fill, color, theta_grid, r_grid,  _EXTRA=e
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
COMPILE_OPT IDL2, STATIC

n_theta = N_ELEMENTS(theta_grid) - 1
n_r     = N_ELEMENTS(r_grid) - 1
;
r = r_grid
theta = theta_grid

FOR i = 0, n_theta - 1 DO BEGIN
    FOR j = 0, n_r - 1 DO BEGIN
         x  = [                          $
                    r[j] * COS(theta[i])    , $
                    r[j+1] * COS(theta[i])  , $
                    r[j+1] * COS(theta[i+1]), $
                    r[j] * COS(theta[i+1])    $
                    ]
         ;
         y  = [                          $
                    r[j] * SIN(theta[i])    , $
                    r[j+1] * SIN(theta[i])  , $
                    r[j+1] * SIN(theta[i+1]), $
                    r[j] * SIN(theta[i+1])    $
                    ]
         POLYFILL, x, y, COLOR=color[i, j], /DATA, _EXTRA=e
    ENDFOR
ENDFOR


END
