;===========================================================+
; ++ NAME ++
FUNCTION str::split2, str, separator, _EXTRA=ex
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
sep = separator

dummy = 'a'
IF STREGEX(dummy, sep, /BOOLEAN) THEN $
    dummy = 'b'

str0  = dummy + str + dummy
;
idx = STRSPLIT(str0, sep, _EXTRA=ex)
spl = STRSPLIT(str0, sep, /EXTRACT)

IF STRMATCH(spl[0],dummy+str+dummy) THEN RETURN, 0 

;
seplist = []
FOR i = 0, N_ELEMENTS(idx) - 2 DO BEGIN
    seplen = (idx[i+1] - idx[i]) - STRLEN(spl[i]) 
    sep0 = STRMID(str0, idx[i+1] - seplen, seplen)  
    seplist = [seplist, sep0]
ENDFOR



;
;*----------   ----------*
;
first = 0 
IF ~STRMATCH(spl[0], dummy) THEN BEGIN
    spl[0] = STRMID(spl[0], STRLEN(dummy), $
                    STRLEN(spl[0]) - STRLEN(dummy) )
ENDIF ELSE BEGIN
    spl = spl[1:-1]
    first = 1
ENDELSE

;
last = 0
IF ~STRMATCH(spl[-1], dummy) THEN BEGIN
    spl[-1] = STRMID(spl[-1], 0, $
                     STRLEN(spl[-1]) - STRLEN(dummy) )
ENDIF ELSE BEGIN
    spl = spl[0:-2]
    last = 1
ENDELSE


sep_pos = INDGEN(N_ELEMENTS(spl) + 1)
;
IF ~first THEN $
    sep_pos = sep_pos[1:-1]
IF ~last THEN $
    sep_pos = sep_pos[0:-2]

RETURN, list(spl, seplist, sep_pos)
END
