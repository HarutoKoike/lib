;===========================================================+
; ++ NAME ++
PRO idlplotlib::horizontal_error, x, xerr, y, _EXTRA=ex
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
;
COMPILE_OPT IDL2, STATIC
;
FOR i = 0, N_ELEMENTS(x) - 1 DO BEGIN
    ; x bar
    PLOTS, [x[i] - xerr[i], x[i] + xerr[i]], $
           [y[i], y[i]], _EXTRA=ex, /DATA
ENDFOR

END
