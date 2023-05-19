;===========================================================+
; ++ NAME ++
FUNCTION myspedas::tmax, tname, tmax, trange=trange, _EXTRA=e
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
IF ~KEYWORD_SET(trange) THEN get_timespan, trange
data = myspedas->tclip_data(tname, trange, /tvar)
;
s = SIZE(data.y)
IF s[0] EQ 1 THEN BEGIN
    dmax = MIN(data.y, im, _EXTRA=e)
    tmax = data.x[im]
    RETURN, dmax
ENDIF
;
;IF s[0] EQ 2 THEN BEGIN
;  x = 0
;  FOR i = 0, s[2] - 1 DO BEGIN
;    x += d.Y[*, i]^2  
;  ENDFOR
;  x = SQRT(x)
;  RETURN, MAX(x, _EXTRA=e)
;ENDIF
;
RETURN, 0
END 
