;===========================================================+
; ++ NAME ++
FUNCTION myspedas::tclip_data, tname, trange, tvar=tvar
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
COMPILE_OPT IDL2, STATIC

catch, err
if err ne 0 then begin
    catch, /cancel
    message, 'Unclear error occured in tclip_data', /continue
    return, !null 
endif

idx = nn(tname, trange)
;

get_data, tname, data=d


s = SIZE(d.y)


IF s[0] EQ 1 THEN $
    data = d.y[idx[0]:idx[1]]
IF s[0] EQ 2 THEN $
    data = d.y[idx[0]:idx[1], *]
IF s[0] EQ 3 THEN $
    data = d.y[idx[0]:idx[1], *, *]
IF s[0] EQ 4 THEN $
    data = d.y[idx[0]:idx[1], *, *]
IF s[0] GE 5 THEN $
    MESSAGE, 'too much dimensions'

IF KEYWORD_SET(tvar) THEN $
    data = {x:d.x[idx[0]:idx[1]], y:data}

RETURN,data
END
