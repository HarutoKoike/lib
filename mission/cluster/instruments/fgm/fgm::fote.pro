;===========================================================+
; ++ NAME ++
PRO fgm::fote, full=full
;
; ++ PURPOSE ++
;  --> calculate magnetic field by FOTE (Fu et al., 2015)
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
;    2022/06/01 H.Koike 
;===========================================================+
COMPILE_OPT IDL2
; 
self->GetProperty, sc=sc
FOR i = 1, 4 DO BEGIN
    self->SetProperty, sc=i
    self->load, full=full
ENDFOR
self->SetProperty, sc=sc
;
IF ~KEYWORD_SET(full) THEN BEGIN
    tname_suffix = 'B_xyz_gsm__C'
    tname_prefix = '_PP_FGM'
ENDIF ELSE BEGIN
    tname_suffix = 'B_vec_xyz_gsm__C'
    tname_prefix = '_CP_FGM_FULL'
ENDELSE
;
get_data, tname_suffix + '1' + tname_prefix, data=b1
get_data, tname_suffix + '2' + tname_prefix, data=b2
get_data, tname_suffix + '3' + tname_prefix, data=b3
get_data, tname_suffix + '4' + tname_prefix, data=b4
;
get_data, 'pos_x_gsm_c1', data=p1x
get_data, 'pos_x_gsm_c2', data=p2x
get_data, 'pos_x_gsm_c3', data=p3x
get_data, 'pos_x_gsm_c4', data=p4x
get_data, 'pos_y_gsm_c1', data=p1y
get_data, 'pos_y_gsm_c2', data=p2y
get_data, 'pos_y_gsm_c3', data=p3y
get_data, 'pos_y_gsm_c4', data=p4y
get_data, 'pos_z_gsm_c1', data=p1z
get_data, 'pos_z_gsm_c2', data=p2z
get_data, 'pos_z_gsm_c3', data=p3z
get_data, 'pos_z_gsm_c4', data=p4z


disc = ~ISA(b1, 'STRUCT')  OR ~ISA(b2, 'STRUCT')  OR ~ISA(b3, 'STRUCT') OR $
       ~ISA(b4, 'STRUCT')  OR ~ISA(p1x, 'STRUCT') OR ~ISA(p2x, 'STRUCT') OR $
       ~ISA(p3x, 'STRUCT') OR ~ISA(p4x, 'STRUCT') OR ~ISA(p1y, 'STRUCT') OR $  
       ~ISA(p2y, 'STRUCT') OR ~ISA(p3y, 'STRUCT') OR ~ISA(p4y, 'STRUCT') OR $  
       ~ISA(p1z, 'STRUCT') OR ~ISA(p2z, 'STRUCT') OR ~ISA(p3z, 'STRUCT') OR $  
       ~ISA(p4z, 'STRUCT') 

IF disc THEN RETURN

;
;*---------- interpolate  ----------*
;
;
; magnetic field
;
t   = b3.x
;
b1x = interp(b1.y[*, 0], b1.x, t)
b1y = interp(b1.y[*, 1], b1.x, t)
b1z = interp(b1.y[*, 2], b1.x, t)
;
b2x = interp(b2.y[*, 0], b2.x, t)
b2y = interp(b2.y[*, 1], b2.x, t)
b2z = interp(b2.y[*, 2], b2.x, t)
;
b3x = REFORM(b3.y[*, 0])
b3y = REFORM(b3.y[*, 1])
b3z = REFORM(b3.y[*, 2])
;
b4x = interp(b4.y[*, 0], b4.x, t)
b4y = interp(b4.y[*, 1], b4.x, t)
b4z = interp(b4.y[*, 2], b4.x, t)
;
; position
p1x = interp(p1x.y, p1x.x, t)
p1y = interp(p1y.y, p1y.x, t)
p1z = interp(p1z.y, p1z.x, t)
;
p2x = interp(p2x.y, p2x.x, t)
p2y = interp(p2y.y, p2y.x, t)
p2z = interp(p2z.y, p2z.x, t)
;
p3x = interp(p3x.y, p3x.x, t)
p3y = interp(p3y.y, p3y.x, t)
p3z = interp(p3z.y, p3z.x, t)
;
p4x = interp(p4x.y, p4x.x, t)
p4y = interp(p4y.y, p4y.x, t)
p4z = interp(p4z.y, p4z.x, t)



n     = N_ELEMENTS(t)
null  = FLTARR(n, 3)
coeff = FLTARR(n, 12)
;
dp1 = FLTARR(n)
dp2 = FLTARR(n)
dp3 = FLTARR(n)
dp4 = FLTARR(n)
;
in_null = BYTARR(n)
;
coeff_norm = FLTARR(n)
;
divb         = FLTARR(n)
current      = FLTARR(n, 3)
current_mag  = FLTARR(n)
current_para = FLTARR(n)
current_perp = FLTARR(n)

math = OBJ_NEW('math')
FOR i = 0, N_ELEMENTS(t) - 1 DO BEGIN
    ;
    b1 = [b1x[i], b1y[i], b1z[i]]
    b2 = [b2x[i], b2y[i], b2z[i]]
    b3 = [b3x[i], b3y[i], b3z[i]]
    b4 = [b4x[i], b4y[i], b4z[i]]
    ;
    p1 = [p1x[i], p1y[i], p1z[i]]
    p2 = [p2x[i], p2y[i], p2z[i]]
    p3 = [p3x[i], p3y[i], p3z[i]]
    p4 = [p4x[i], p4y[i], p4z[i]]
    ;
    m = math->fote(p1, p2, p3, p4, b1, b2, b3, b4, null=np)
    ;
    dp1[i] = SQRT(TOTAL( (p1 - np)^2 )) 
    dp2[i] = SQRT(TOTAL( (p2 - np)^2 )) 
    dp3[i] = SQRT(TOTAL( (p3 - np)^2 )) 
    dp4[i] = SQRT(TOTAL( (p4 - np)^2 )) 
    ;
    null[i, *]  = np
    coeff[i, *] = m[0:11]  
    ;
    op2 = p2 - p1
    op3 = p3 - p1
    op4 = p4 - p1
    opn = np - p1
    ;
    mat   = [[op2], [op3], [op4]]
    alpha = INVERT(mat) # opn
    ;
    coeff_norm = NORM(alpha)
    ;
    in_null[i] = (alpha[0] GE 0) AND (alpha[0] LE 1) AND (alpha[1] GE 0) AND $
                 (alpha[1] LE 1) AND (alpha[2] GE 0) AND (alpha[2] LE 1)
    ;
    ; current
    divb[i] = m[1] + m[6] + m[11]
    current[i, 0] = m[10] - m[7]
    current[i, 1] = m[3] - m[9]
    current[i, 2] = m[5] - m[2]
    ;
    current_mag[i] = NORM(current[i, *])
    ;
    b_ave = (b1 + b2 + b3 + b4) / 4.
    current_para[i] = TOTAL(REFORM(current[i, *] * b_ave) / NORM(b_ave) )
    current_perp[i] = SQRT(current_mag[i]^2 - current_para[i]^2)
ENDFOR

;
;*----------   ----------*
;
current = current / !CONST.MU0 / !CONST.R_EARTH * 1.e6 * 1.e-9
divb    = ABS(divb / current_mag) * 100.  ; divB/|curlB|
;
current_para = current_para / !CONST.MU0 / !CONST.R_EARTH * 1.e6 * 1.e-9
current_perp = current_perp / !CONST.MU0 / !CONST.R_EARTH * 1.e6 * 1.e-9


store_data, 'FOTE_coefficients', data={x:t, y:coeff}
;
store_data, 'FOTE_null_point', data={x:t, y:null}
;
dp1 *= !CONST.R_EARTH * 1.e-3
dp2 *= !CONST.R_EARTH * 1.e-3
dp3 *= !CONST.R_EARTH * 1.e-3
dp4 *= !CONST.R_EARTH * 1.e-3
store_data, 'FOTE_null_distance_C1', data={x:t, y:dp1}
store_data, 'FOTE_null_distance_C2', data={x:t, y:dp2}
store_data, 'FOTE_null_distance_C3', data={x:t, y:dp3}
store_data, 'FOTE_null_distance_C4', data={x:t, y:dp4}
store_data, 'FOTE_null_distance', data={x:t, y:[[dp1], [dp2], [dp3], [dp4]]}
;
store_data, 'FOTE_null_in_tetra', data={x:t, y:in_null}
;
store_data, 'FOTE_null_coeff_norm', data={x:t, y:coeff_norm}
store_data, 'FOTE_curl_current', data={x:t, y:current}
store_data, 'FOTE_curl_current_para', data={x:t, y:current_para}
store_data, 'FOTE_curl_current_perp', data={x:t, y:current_perp}
store_data, 'FOTE_curl_current_ratio', data={x:t, y:ABS(current_para/current_perp)}
store_data, 'FOTE_curl_current_mag', data={x:t, y:[ [current_para], [current_perp] ]}
store_data, 'FOTE_divB', data={x:t, y:divb}
;


;ylim, 'FOTE_null_point'
ylim, 'FOTE_null_distance_C1', 0, 1000 
ylim, 'FOTE_null_distance_C2', 0, 1000 
ylim, 'FOTE_null_distance_C3', 0, 1000 
ylim, 'FOTE_null_distance_C4', 0, 1000 
ylim, 'FOTE_null_distance', -100, 1000 
ylim, 'FOTE_null_in_tetra', -1, 2
ylim, 'FOTE_null_coeff_norm', 0, 1
ylim, 'FOTE_divB', 0, 100
;
;
options, 'FOTE_null_point', 'ytitle', 'Null point (GSM)'
options, 'FOTE_null_point', 'ysubtitle', '[R!DE!N]'
options, 'FOTE_null_point', 'labels', ['X', 'Y', 'Z']
options, 'FOTE_null_point', 'colors', [230, 150, 50]
;
options, 'FOTE_curl_current', 'colors', [230, 150, 50]
options, 'FOTE_curl_current', 'ytitle', 'FOTE_current(GSM)'
options, 'FOTE_curl_current', 'ysubtitle', '[10!U-6!NA]'
options, 'FOTE_curl_current', 'labels', ['jx', 'jy', 'jz']
options, 'FOTE_curl_current', 'databar', {yval:0, linestyle:2} 
;
options, 'FOTE_divB', 'ytitle', 'FOTE_divB(%)'
;
options, 'FOTE_curl_current_ratio', 'ytitle', '|J_para/J_parp|'
;
options, 'FOTE_curl_current_mag', 'colors', [50, 220]
options, 'FOTE_curl_current_mag', 'labels', ['para', 'perp']
options, 'FOTE_curl_current_mag', 'databar', {yval:0, linestyle:2}
options, 'FOTE_curl_current_mag', 'ysubtitle', '[10!U-6!NA]'
;
options, 'FOTE_null_distance', 'colors', [0, 230, 150, 50] 
options, 'FOTE_null_distance', 'labels', ['C1', 'C2', 'C3', 'C4']
options, 'FOTE_null_distance', 'ytitle', 'Null distance'
options, 'FOTE_null_distance', 'ysubtitle', '[km]'
options, 'FOTE_null_distance', 'databar', {yval:0, linestyle:0}

END
