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

;catch, err
;if err ne 0 then begin
;    catch, /cancel
;    message, 'Unclear error occured in tclip_data', /continue
;    return, !null 
;endif


;
;*---------   ----------*
;
nt = n_elements(trange)
;
if (nt ne 1) and (nt ne 2) then $
    message, 'trange must be 1 or 2 element '



;
;*--------- get  ----------*
;
idx = nn(tname, trange)
get_data, tname, data=d


if nt eq 2 then begin
    idx0 = idx[0]
    idx1 = idx[1]
endif

if nt eq 1 then begin
    idx0 = idx[0]
    idx1 = idx[0]
endif

s = SIZE(d.y)


IF s[0] EQ 1 THEN $
    data = d.y[idx0:idx1]
IF s[0] EQ 2 THEN $
    data = d.y[idx0:idx1, *]
IF s[0] EQ 3 THEN $
    data = d.y[idx0:idx1, *, *]
IF s[0] EQ 4 THEN $
    data = d.y[idx0:idx1, *, *]
IF s[0] GE 5 THEN $
    MESSAGE, 'too much dimensions'

data = reform(data)

IF KEYWORD_SET(tvar) THEN $
    data = {x:d.x[idx0:idx1], y:data}

RETURN, data
END
