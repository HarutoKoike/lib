;===========================================================+
; ++ NAME ++
FUNCTION str::join2, str_list, sep_list, sep_idx 
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
n   = N_ELEMENTS(str_list) + N_ELEMENTS(sep_list)
str = STRARR(n)
;
IF n MOD 2 EQ 0 THEN BEGIN
    idx_even = INDGEN(n / 2) * 2
    idx_odd  = INDGEN(n / 2) * 2 + 1
ENDIF ELSE BEGIN
    idx_even = INDGEN(n/2+1) * 2
    idx_odd  = INDGEN(n/2) * 2 + 1
ENDELSE


IF sep_idx[0] EQ 0 THEN BEGIN 
    str[idx_even] = sep_list    
    str[idx_odd ] = str_list
ENDIF ELSE BEGIN
    str[idx_odd]  = sep_list
    str[idx_even] = str_list
ENDELSE


RETURN, STRJOIN(str)
END
