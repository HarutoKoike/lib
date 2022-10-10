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
;
str = source
;
dum = '@'
IF STRMATCH(dum, pre) THEN dum = '&'
;
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

RETURN, str
END
