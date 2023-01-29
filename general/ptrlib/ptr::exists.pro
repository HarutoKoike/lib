;===========================================================+
; ++ NAME ++
FUNCTION ptr::exists, vname
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
COMPILE_OPT IDL2
;
exist  = BYTARR(N_ELEMENTS(vname))
;
FOR i = 0, N_ELEMENTS(vname) - 1 DO BEGIN
    dum = WHERE(STRMATCH( *(!PTR.VNAME), vname[i]) EQ 1, count)
    exist[i] = count EQ 1
ENDFOR

RETURN, exist
END
