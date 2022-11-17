FUNCTION str::split_one, char
COMPILE_OPT IDL2
;
arr = STRARR(STRLEN(char))
FOR i = 0, STRLEN(char) - 1 DO BEGIN
    arr[i] = STRMID(char, i, 1)
ENDFOR
RETURN, arr
;
END



;===========================================================+
; ++ NAME ++
FUNCTION str::replace, source, pre, post, complete=complete 
;
; ++ PURPOSE ++
;  --> replace words into other words
;
; ++ POSITIONAL ARGUMENTS ++
;  --> source(STRING): scalar or array of string to be modified 
;  --> pre(STRING): 1 element string to be replaced
;  --> post(string): 1 element string to replace
;
; ++ KEYWORDS ++
; -->
;
; ++ CALLING SEQUENCE ++
;  --> str_new = str->replace(['hoge', 'foo'], 'o', 'ee'
;      >> ['heege', 'feeee']
;
; ++ HISTORY ++
;  H.Koike 
;===========================================================+
COMPILE_OPT IDL2
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
IF KEYWORD_SET(complete) THEN BEGIN
    FOR i = 0, N_ELEMENTS(str_arr) - 1 DO BEGIN
        IF STRMATCH(str_arr[i], pre) THEN $
            str_arr[i] = post
    ENDFOR
    RETURN, str_arr
ENDIF

;
;
FOR i = 0, N_ELEMENTS(source) - 1 DO BEGIN
    str = source[i] 
    ;
    str_done = []
    str_res  = str
    ;
    WHILE 1 DO BEGIN
        pos = STRPOS(str_res, pre)
        IF pos EQ -1 THEN BEGIN 
            str_done = [str_done, str_res]
            BREAK
        ENDIF
        ;
        ; replace
        str_rep  = STRMID(str_res, 0, pos) + post
        str_done = [str_done, str_rep] 
        ;
        str_res  = STRMID(str_res, pos + STRLEN(pre), $
                          STRLEN(str_res) - pos - 1)
    ENDWHILE
    str_arr[i] = STRJOIN(str_done)
ENDFOR

RETURN, str_arr
END
