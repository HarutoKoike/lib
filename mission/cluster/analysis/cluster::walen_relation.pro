;===========================================================+
; ++ NAME ++
PRO cluster::walen_relation, sc, t_ref, sign, $
                             trange_autosign=trange_autosign
;
; ++ PURPOSE ++
;  --> calculate velocity change across the rotational discondinuity
;
; ++ POSITIONAL ARGUMENTS ++
;  --> sc: spacecraft number
;  --> t_ref: reference time of upstream region
;
; ++ KEYWORDS ++
; -->
;
; ++ CALLING SEQUENCE ++
;  -->
;
; ++ HISTORY ++
;  H.Koike 2023/05/08
;===========================================================+
COMPILE_OPT IDL2, STATIC
;
IF N_ELEMENTS(t_ref) GE 3 THEN RETURN
;
sc = STRING(sc, FORMAT='(I1)')
;
v_name = 'V_HIA_xyz_gsm__C'+sc+'_PP_CIS'
b_name = 'B_xyz_gsm__C'+sc+'_PP_FGM'
a_name = 'Pressure_anisotropy__C' + sc
n_name = 'N_HIA__C'+sc+'_PP_CIS'
;
get_data, n_name, data=n
get_data, b_name, data=b
get_data, v_name, data=v
get_data, a_name, data=alpha

;
;*---------- interpolate  ----------*
;
t     = b.x
b     = b.y * 1.e-9           ; nT -> T
n     = interp(n.y, n.x, t)
v     = interp(v.y, v.x, t)
alpha = interp(alpha.y, alpha.x, t)


;
;*---------- reference point ----------*
;
idx = nn(b_name, t_ref)
IF N_ELEMENTS(idx) eq 2 THEN BEGIN
    idx = INDGEN(idx[1] - idx[0] + 1) + idx[0]
    ;
    b1     = MEAN(b[idx, *], DIM=1, /NAN)      ; [T]
    v1     = MEAN(v[idx, *], DIM=1, /NAN)      ; [km/s]
    n1     = MEAN(n[idx], /NAN)                ; [cm^-3]
    alpha1 = MEAN(alpha[idx], /NAN)
    rho1   = n1 * !CONST.MP * 1.e6             ; [kg/m^3]
ENDIF ELSE BEGIN
    b1     = REFORM(b[idx, *])                 ; [T]
    v1     = REFORM(v[idx, *])                 ; [km/s]
    n1     = n[idx]                            ; [cm^-3]
    alpha1 = alpha[idx]
    rho1   = n1 * !CONST.MP * 1.e6             ; [kg/m^3]
ENDELSE



;
;*---------- predicted velocity  ----------*
;
; predicted velocity change
dv_pred = FLTARR(N_ELEMENTS(t), 3)
v_pred  = FLTARR(N_ELEMENTS(t), 3)
dv_obs  = FLTARR(N_ELEMENTS(t), 3)
IF KEYWORD_SET(trange_autosign) THEN $
    v_pred2 = FLTARR(N_ELEMENTS(t), 3)
;
;
IF ~ISA(sign) THEN sign = 1.

FOR i = 0, 2 DO BEGIN
    dv_pred[*, i] = sign * SQRT( (1. - alpha1) /  (!CONST.MU0 * rho1) ) * $
                    (b[*, i] * (1. - alpha) / (1. - alpha1) - b1[i]) * 1.e-3
    ;
    v_pred[*, i] = v1[i] + dv_pred[*, i]
    IF KEYWORD_SET(trange_autosign) THEN $
        v_pred2[*, i] = v1[i] - dv_pred[*, i]
    ;
    dv_obs[*, i] = v[*, i] - v1[i]
ENDFOR

IF KEYWORD_SET(trange_autosign) THEN BEGIN
    idx = WHERE(t GE trange_autosign[0] and t LE trange_autosign[1])
    dv1 = TOTAL( (v[idx, *] - v_pred[idx, *])^2, /NAN)
    dv2 = TOTAL( (v[idx, *] - v_pred2[idx, *])^2, /NAN)    
    ;
    IF dv2 LT dv1 THEN BEGIN
        dv_pred = dv_pred
        v_pred  = v_pred2
        sign    = sign*(-1)
    ENDIF
ENDIF




theta  = ACOS(TOTAL(dv_pred * dv_obs, 2) / $
              SQRT(TOTAL(dv_obs^2, 2)*TOTAL(dv_pred^2, 2))) / !DTOR

r  = TOTAL(dv_obs * dv_pred, 2) / TOTAL(dv_pred^2, 2)  
r  = total(dv_obs^2, 2) / total(dv_pred^2, 2)
r  = sqrt(r)


;
; angle between the predicted and observed velocity change 
tn = 'Walen_theta__C' + sc
store_data, tn, data={x:t, y:theta}
options, tn, 'ytitle', 'Walen_angle'
options, tn, 'ysubtitle', '[deg.]'
options, tn, 'databar', {yval:0, linestyle:1}
ylim, tn, 0, 180, 0

;
; predicted velocity
tn = 'Walen_V_gsm__C'+ sc
store_data, tn, data={x:t, y:v_pred}


tn = 'Walen_Vx'
y  = [[v[*, 0]], [v_pred[*, 0]]]
store_data, tn, data={x:t, y:y}

tn = 'Walen_Vy'
y  = [[v[*, 1]], [v_pred[*, 1]]]
store_data, tn, data={x:t, y:y}

tn = 'Walen_Vz'
y  = [[v[*, 2]], [v_pred[*, 2]]]
store_data, tn, data={x:t, y:y}


;
; check
tn = 'Walen_check'
store_data, tn, data={x:t, y:r}
options, tn, 'ytitle', 'R!DW!N'
options, tn, 'databar', {yval:0.5, linestyle:1}
ylim, tn, 0, 1.5


tn   = 'Walen_valid'
disc = (r gt 0.4 and r lt 3.) and $
       ( (theta ge 0 and theta lt 30.)  or $
       (theta gt 150 and theta le 180.) )
store_data, tn, data={x:t, y:disc}
ylim, tn, 0, 2


tn = 'Walen_deltaV_obs'
y  = SQRT(TOTAL(dv_obs^2, 2))
store_data, tn, data={x:t, y:y}
options, 'ysubtitle', '[km/s]'


END 

