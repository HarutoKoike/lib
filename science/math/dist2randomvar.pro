;===========================================================+
; ++ NAME ++
FUNCTION dist2randomvar, dist 
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
n = N_ELEMENTS(dist)
;
fi  = dist/TOTAL(dist)
idx = WHERE(fi GT 0., count)
IF count EQ 0 THEN RETURN, 0

ni  = REFORM( CEIL(fi / MIN(fi[idx]) ) )

IF ni[0] LT 0 THEN RETURN, 0

x = []
FOR i = 0, n - 2 DO BEGIN
    IF ni[i] EQ 0 THEN CONTINUE
    xi = RANDOMU(134123120, ni[i]) + i
    xi = FINDGEN(ni[i]) / FLOAT(ni[i] - 1) + i
    x  = [x, xi]
ENDFOR


RETURN, x
END
