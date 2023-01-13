;===========================================================+
; ++ NAME ++
PRO cluster::combine_multi, sc, tname_pre, tname_suf, all=all, vector=vector, $
                            base=base, new_name
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
COMPILE_OPT IDL2, static
;
ns  = N_ELEMENTS(sc)
sc0    = STRING(sc, FORMAT='(I1)')
tnames = tname_pre + sc0 + tname_suf
;
IF KEYWORD_SET(base) THEN BEGIN
    idx = WHERE(sc EQ base)
    tname_base = tnames[idx]
ENDIF ELSE BEGIN
    tname_base = tnames[0]
ENDELSE
;
IF KEYWORD_SET(vector) THEN GOTO, vector
;


;
;*---------- scalar  ----------*
;
new_name = tname_pre + STRJOIN(sc0) + tname_suf 
;
; interpolate
FOR i = 0, ns - 1 DO tinterpol, tnames[i], tname_base
;
; join
get_data, tname_base, data=d, dlim=dlim
t  = d.x
y  = FLTARR(N_ELEMENTS(t), ns)
FOR i = 0, ns - 1 DO BEGIN
    get_data, tnames[i] + '_interp', data=d
    y[*, i] = d.Y[*, 0]
ENDFOR
;
; delete
del_data, tnames + '_interp'
;
; store
store_data, new_name, data={x:t, y:y}, dlim=dlim

RETURN


;
;*---------- vector ----------*
;
vector:
new_names = tname_pre + STRJOIN(sc0) + tname_suf + '_' + ['X', 'Y', 'Z']
;
; interpolate
FOR i = 0, ns - 1 DO tinterpol, tnames[i], tname_base
;
;
; join
get_data, tname_base, data=d, dlim=dlim 
t  = d.X
dx = FLTARR(N_ELEMENTS(t), ns)
dy = FLTARR(N_ELEMENTS(t), ns)
dz = FLTARR(N_ELEMENTS(t), ns)
FOR i = 0, ns - 1 DO BEGIN
    get_data, tnames[i] + '_interp', data=d
    dx[*, i] = d.Y[*, 0]
    dy[*, i] = d.Y[*, 1]
    dz[*, i] = d.Y[*, 2]
ENDFOR
;
;
; delete
del_data, tnames + '_interp'
 
;
;
store_data, new_names[0], data={x:t, y:dx}, dlim=dlim
store_data, new_names[1], data={x:t, y:dy}, dlim=dlim
store_data, new_names[2], data={x:t, y:dz}, dlim=dlim



END
