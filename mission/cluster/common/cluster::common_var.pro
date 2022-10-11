


;===========================================================+
; ++ NAME ++
PRO cluster::common_var, re=re
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
;  H.Koike 1/9,2021
;===========================================================+
COMPILE_OPT IDL2, STATIC

IF ARG_PRESENT(re) THEN re = 6371.2  ; earth radius in kirometer




END
