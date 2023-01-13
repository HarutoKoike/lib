;===========================================================+
; ++ NAME ++
PRO aux::constellation, tcut, posnames=posnames
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
IF ~KEYWORD_SET(posnames) THEN BEGIN
    posnames = ['pos_gsm_c1', $
                'pos_gsm_c2', $
                'pos_gsm_c3', $
                'pos_gsm_c4']
ENDIF



get_data, posnames[0], data=p1
get_data, posnames[1], data=p2
get_data, posnames[2], data=p3
get_data, posnames[3], data=p4


idx1 = nn(posnames[0], tcut)
idx2 = nn(posnames[1], tcut)
idx3 = nn(posnames[2], tcut)
idx4 = nn(posnames[3], tcut)
;
p1 = p1.Y[idx1, *]
p2 = p2.Y[idx1, *]
p3 = p3.Y[idx1, *]
p4 = p4.Y[idx1, *]



END
