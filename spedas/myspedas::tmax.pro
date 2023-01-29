;===========================================================+
; ++ NAME ++
FUNCTION myspedas::tmax, tname, trange=trange, _EXTRA=e
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

;
IF ~KEYWORD_SET(trange) THEN get_timespan, trange
myspedas->trange_clip, tname, trange, newname=tname+'_cliped'
get_data, tname+'_cliped', data=d 
;
S = SIZE(d.y)
IF s[0] EQ 1 THEN $
  RETURN, MAX(d.Y, _EXTRA=e)
;
IF s[0] EQ 2 THEN BEGIN
  x = 0
  FOR i = 0, s[2] - 1 DO BEGIN
    x += d.Y[*, i]^2  
  ENDFOR
  x = SQRT(x)
  RETURN, MAX(x, _EXTRA=e)
ENDIF
;
END 
