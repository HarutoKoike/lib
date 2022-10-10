;===========================================================+
; ++ NAME ++
FUNCTION str::contain, char, list, partly=partly
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
nl   = N_ELEMENTS(list)
disc = 0
;
FOR i = 0, nl - 1 DO BEGIN
  disc += STRMATCH(char, '*' + list[i] + '*')
ENDFOR


IF KEYWORD_SET(partly) THEN $
  RETURN, disc GE 1
;
RETURN, nl EQ disc
END
