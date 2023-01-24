;===========================================================+
; ++ NAME ++
PRO cdf::varinfo, varname=varname, info_out
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
;===========================================================+
COMPILE_OPT IDL2
;
varnames = ( *(self.info) ).varnames
nvars    = N_ELEMENTS(varnames)
;

;
;*----------   ----------*
;
IF ~ISA(varname) THEN GOTO, SKIP
;
IF ISA(varname, 'INT') AND varname EQ 0 THEN $
    varname = varnames[0]

vn = varname
IF ISA(varname, 'INT') THEN vn = varnames[varname] 
;
idx      = WHERE(STRMATCH(varnames, vn)) 
IF idx EQ -1 THEN RETURN
;
info_out = ((*(self.info)).variables)[idx] 
info_out = *(info_out[0])

RETURN




;
;*----------   ----------*
;
SKIP:
FOR i = 0, nvars - 1 DO BEGIN
    info = *(( *(self.info) ).variables)[i]
    ;
    ;
    PRINT, ''
    PRINT, ''
    PRINT, '=============================================='
    PRINT, ' Variable Name : "' + varnames[i] + '"'
    PRINT, '=============================================='
    tags   = TAG_NAMES(info)
    maxlen = MAX( STRLEN(tags) )
    FOR j = 0, N_TAGS(info) - 1 DO BEGIN
        tn = tags[j] + STRJOIN( REPLICATE(' ', maxlen + 1 - STRLEN(tags[j])) ) 
        PRINT, tn, ' : ', info.(j)
    ENDFOR
ENDFOR


END
