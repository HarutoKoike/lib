;===========================================================+
; ++ NAME ++
PRO myspedas::trange_clip, tname, trange, newname=newname
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

idx1 = nn(tname, trange[0])
idx2 = nn(tname, trange[1])
;
get_data, tname, data=d
;
;
IF ~KEYWORD_SET(newname) THEN newname = tname + '_cliped'
;
s = SIZE(d.y)
IF s[0] EQ 1 THEN $
  store_data, newname, data={x:d.x, y:d.y[idx1:idx2]}
IF s[0] EQ 2 THEN $
  store_data, newname, data={x:d.x, y:d.y[idx1:idx2, *]}
IF s[0] EQ 3 THEN $
  store_data, newname, data={x:d.x, y:d.y[idx1:idx2, *, *]}   
END
