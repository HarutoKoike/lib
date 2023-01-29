;===========================================================+
; ++ NAME ++
FUNCTION date::format_list
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
list = ['%Y', '%y', '%m', '%d', '%H', '%M', '%S']
RETURN, list
END
