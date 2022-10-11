;===========================================================+
; ++ NAME ++
FUNCTION str::replace, source, pre, post 
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
IF SIZE(source, /TYPE) NE 7 THEN $
    MESSAGE, 'argument must be string'
IF SIZE(pre, /TYPE) NE 7 THEN $
    MESSAGE, 'argument must be string'
IF SIZE(post, /TYPE) NE 7 THEN $
    MESSAGE, 'argument must be string'
;
str_arr = source
;
dum = '@'
IF STRMATCH(dum, pre) THEN dum = '&'
;
idx = 0
FOREACH str, str_arr DO BEGIN
    WHILE 1 DO BEGIN
        i = STRPOS(str, pre)
        IF i EQ -1 THEN BREAK
        ;
        str   = dum + str + dum
        i     = STRPOS(str, pre)
        l     = STRLEN(str)
        l_pre = STRLEN(pre)
        str0  = STRMID(str, 0, i)
        str1  = STRMID(str, i + l_pre, l - i - l_pre)
        str   = str0 + post + str1
        str   = STRMID(str, 1, STRLEN(str) - 2)
    ENDWHILE
    ;
    str_arr[idx] = str
    idx ++
ENDFOREACH

RETURN, str_arr
END
