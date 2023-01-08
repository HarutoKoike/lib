;===========================================================+
; ++ NAME ++
FUNCTION cpath, path=path, filename=filename
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
HELP, /LEVEL, OUT=out_str
;
str  = '% At CPATH*'
idx  = WHERE( STRMATCH(out_str, str) ) + 1
info = out_str[idx]
;

;
;*----------   ----------*
;
r = (STRSPLIT(info, ' ', /EXTRACT))[-1]
;
IF KEYWORD_SET(path) THEN BEGIN 
    r = STRSPLIT(r, PATH_SEP(), /EXTRACT)
    help, r
    r = FILEPATH(r[-2], SUBDIR=r[1:-3], ROOT=r[0])
    r = PATH_SEP() + r
ENDIF
;
IF KEYWORD_SET(filename) THEN BEGIN
    r = STRSPLIT(r, PATH_SEP(), /EXTRACT)
    r = r[-1]
ENDIF


RETURN, r
END
