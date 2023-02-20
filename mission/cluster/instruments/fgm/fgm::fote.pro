;===========================================================+
; ++ NAME ++
PRO fgm::fote, full=full, skip_load=skip_load
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
; ++ HISTORY ++ ;    2022/06/01 H.Koike 
;===========================================================+
COMPILE_OPT IDL2
; 
IF KEYWORD_SET(skip_load) THEN GOTO, jump1
;
self->GetProperty, sc=sc
FOR i = 1, 4 DO BEGIN
    self->SetProperty, sc=i
    self->load, full=full
ENDFOR
self->SetProperty, sc=sc
;



jump1:
;
;*----------tname ----------*
;
IF ~KEYWORD_SET(full) THEN BEGIN
    tname_suffix = 'B_xyz_gse__C'
    tname_prefix = '_PP_FGM'
ENDIF ELSE BEGIN
    tname_suffix = 'B_vec_xyz_gse__C'
    tname_prefix = '_CP_FGM_FULL'
ENDELSE
;





;
;*---------- magnetic field  ----------*
;
get_data, tname_suffix + '1' + tname_prefix, data=b1
get_data, tname_suffix + '2' + tname_prefix, data=b2
get_data, tname_suffix + '3' + tname_prefix, data=b3
get_data, tname_suffix + '4' + tname_prefix, data=b4

;
disc = ~ISA(b1, 'STRUCT')  OR ~ISA(b2, 'STRUCT')  OR ~ISA(b3, 'STRUCT') OR $
       ~ISA(b4, 'STRUCT')  
;
IF disc THEN RETURN

;
; interpolate
t   = b3.x
b1x = interp(b1.y[*, 0], b1.x, t) * 1.e-9
b1y = interp(b1.y[*, 1], b1.x, t) * 1.e-9
b1z = interp(b1.y[*, 2], b1.x, t) * 1.e-9
;
b2x = interp(b2.y[*, 0], b2.x, t) * 1.e-9
b2y = interp(b2.y[*, 1], b2.x, t) * 1.e-9
b2z = interp(b2.y[*, 2], b2.x, t) * 1.e-9
;
b3x = REFORM(b3.y[*, 0]) * 1.e-9
b3y = REFORM(b3.y[*, 1]) * 1.e-9
b3z = REFORM(b3.y[*, 2]) * 1.e-9
;
b4x = interp(b4.y[*, 0], b4.x, t) * 1.e-9
b4y = interp(b4.y[*, 1], b4.x, t) * 1.e-9
b4z = interp(b4.y[*, 2], b4.x, t) * 1.e-9   






;
;*---------- position  ----------*
;
IF KEYWORD_SET(full) THEN BEGIN
    tp1 = 'sc_pos_xyz_gse__C1_CP_FGM_FULL'
    tp2 = 'sc_pos_xyz_gse__C2_CP_FGM_FULL'
    tp3 = 'sc_pos_xyz_gse__C3_CP_FGM_FULL'
    tp4 = 'sc_pos_xyz_gse__C4_CP_FGM_FULL'
ENDIF ELSE BEGIN
    tp1 = 'pos_gse_c1'
    tp2 = 'pos_gse_c2'
    tp3 = 'pos_gse_c3'
    tp4 = 'pos_gse_c4'
ENDELSE
;
;
get_data, tp1, data=p1
get_data, tp2, data=p2
get_data, tp3, data=p3
get_data, tp4, data=p4
;
disc = ~ISA(p1, 'STRUCT') OR ~ISA(p2, 'STRUCT') OR $
       ~ISA(p3, 'STRUCT') OR ~ISA(p4, 'STRUCT') 
;
IF disc THEN RETURN             


;
; interpolate
;
IF KEYWORD_SET(full) THEN BEGIN
    p1 = interp(p1.y, p1.x, t) * 1.e3
    p2 = interp(p2.y, p2.x, t) * 1.e3
    p3 = interp(p3.y, p3.x, t) * 1.e3
    p4 = interp(p4.y, p4.x, t) * 1.e3
ENDIF ELSE BEGIN
    p1 = interp(p1.y, p1.x, t) * !CONST.R_EARTH 
    p2 = interp(p2.y, p2.x, t) * !CONST.R_EARTH  
    p3 = interp(p3.y, p3.x, t) * !CONST.R_EARTH  
    p4 = interp(p4.y, p4.x, t) * !CONST.R_EARTH  
ENDELSE
;
p1x = p1[*, 0]
p1y = p1[*, 1]
p1z = p1[*, 2]
;
p2x = p2[*, 0]
p2y = p2[*, 1]
p2z = p2[*, 2]
;
p3x = p3[*, 0]
p3y = p3[*, 1]
p3z = p3[*, 2]
;
p4x = p4[*, 0]
p4y = p4[*, 1]
p4z = p4[*, 2]




;-------------------------------------------------+
; 
;-------------------------------------------------+
n     = N_ELEMENTS(t)
null  = FLTARR(n, 3)
coeff = FLTARR(n, 12)
;
dp1 = FLTARR(n)
dp2 = FLTARR(n)
dp3 = FLTARR(n)
dp4 = FLTARR(n)
;
dp_bary = FLTARR(n, 3)
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
    p_bary = (p1 + p2 + p3 + p4) / 4.
    ;
    m = math->fote(p1, p2, p3, p4, b1, b2, b3, b4, null=np)
    ;
    dp1[i] = SQRT(TOTAL( (p1 - np)^2 )) 
    dp2[i] = SQRT(TOTAL( (p2 - np)^2 )) 
    dp3[i] = SQRT(TOTAL( (p3 - np)^2 )) 
    dp4[i] = SQRT(TOTAL( (p4 - np)^2 )) 
    ;
    dp_bary[i, *] = np - p_bary
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
    current[i, 0]  = (m[10] - m[7]) / !CONST.MU0
    current[i, 1]  = (m[3] - m[9] ) / !CONST.MU0
    current[i, 2]  = (m[5] - m[2] ) / !CONST.MU0
    current_mag[i] = NORM(current[i, *])
    ;
    ;
    b_ave = (b1 + b2 + b3 + b4) / 4.
    current_para[i] = TOTAL(REFORM(current[i, *] * b_ave) / NORM(b_ave) )
    current_perp[i] = SQRT(current_mag[i]^2 - current_para[i]^2)
ENDFOR


divb          = ABS(divb / current_mag * !CONST.MU0)     ; divB/|curlB|
current      *= 1.e9  ; A/m^2 -> nA/m^2
current_mag  *= 1.e9
current_para *= 1.e9
current_perp *= 1.e9


store_data, 'FOTE_coefficients', data={x:t, y:coeff}
;
store_data, 'FOTE_null_point', data={x:t, y:null}
;
dp1 *=  1.e-3  ; m -> km
dp2 *=  1.e-3  ; m -> km 
dp3 *=  1.e-3  ; m -> km 
dp4 *=  1.e-3  ; m -> km 
dp_bary *=  1.e-3
;
store_data, 'FOTE_null_distance_C1', data={x:t, y:dp1}
store_data, 'FOTE_null_distance_C2', data={x:t, y:dp2}
store_data, 'FOTE_null_distance_C3', data={x:t, y:dp3}
store_data, 'FOTE_null_distance_C4', data={x:t, y:dp4}
store_data, 'FOTE_null_distance_bary', data={x:t, y:dp_bary}
store_data, 'FOTE_null_distance', data={x:t, y:[[dp1], [dp2], [dp3], [dp4]]}
;
store_data, 'FOTE_null_in_tetra', data={x:t, y:in_null}
;
store_data, 'FOTE_null_coeff_norm', data={x:t, y:coeff_norm}
store_data, 'FOTE_curl_current', data={x:t, y:current}
store_data, 'FOTE_curl_current_mag', data={x:t, y:current_mag}
store_data, 'FOTE_curl_current_para', data={x:t, y:current_para}
store_data, 'FOTE_curl_current_perp', data={x:t, y:current_perp}
store_data, 'FOTE_curl_current_para_perp', data={x:t, y:[ [current_para], [current_perp] ]}
store_data, 'FOTE_curl_current_ratio', data={x:t, y:ABS(current_para/current_perp)}
store_data, 'FOTE_divB', data={x:t, y:divb}
;


;ylim, 'FOTE_null_point'
ylim, 'FOTE_null_distance_C1', 0, 1000 
ylim, 'FOTE_null_distance_C2', 0, 1000 
ylim, 'FOTE_null_distance_C3', 0, 1000 
ylim, 'FOTE_null_distance_C4', 0, 1000 
ylim, 'FOTE_null_distance', -100, 1000 
ylim, 'FOTE_null_distance_bary', -1000, 1000, 0
ylim, 'FOTE_null_in_tetra', -1, 2
ylim, 'FOTE_null_coeff_norm', 0, 1
ylim, 'FOTE_divB', 0.01, 10, 1
;
;
options, 'FOTE_null_point', 'ytitle', 'Null point (GSE)'
options, 'FOTE_null_point', 'ysubtitle', '[R!DE!N]'
options, 'FOTE_null_point', 'labels', ['X', 'Y', 'Z']
options, 'FOTE_null_point', 'colors', [230, 150, 50]
;
options, 'FOTE_null_distance_bary', 'colors', [230, 150, 50]
options, 'FOTE_null_distance_bary', 'labels', ['X', 'Y', 'Z']
;
options, 'FOTE_curl_current', 'colors', [230, 150, 50]
options, 'FOTE_curl_current', 'ytitle', 'FOTE_current(GSE)'
options, 'FOTE_curl_current', 'ysubtitle', '[nA/m!U2!N]'
options, 'FOTE_curl_current', 'labels', ['jx', 'jy', 'jz']
options, 'FOTE_curl_current', 'databar', {yval:0, linestyle:2} 
;
options, 'FOTE_divB', 'ytitle', '|divB/curlB|'
options, 'FOTE_divB', 'databar', {yval:0.5, linestyle:2}
;
options, 'FOTE_curl_current_ratio', 'ytitle', '|J_para/J_parp|'
;
options, 'FOTE_curl_current_mag', 'ytitle', '|J|'
options, 'FOTE_curl_current_mag', 'ysubtitle', '[nA/m!U2!N]'
;
options, 'FOTE_curl_current_para_perp', 'colors', [50, 220]
options, 'FOTE_curl_current_para_perp', 'labels', ['para', 'perp']
options, 'FOTE_curl_current_para_perp', 'databar', {yval:0, linestyle:2}
options, 'FOTE_curl_current_para_perp', 'ysubtitle', '[nA/m!U2!N]'
options, 'FOTE_curl_current_para_perp', 'ytitle', 'J'
;
options, 'FOTE_null_distance', 'colors', [0, 50, 230, 150] 
options, 'FOTE_null_distance', 'labels', ['C1', 'C2', 'C3', 'C4']
options, 'FOTE_null_distance', 'ytitle', 'Null distance'
options, 'FOTE_null_distance', 'ysubtitle', '[km]'
options, 'FOTE_null_distance', 'databar', {yval:0, linestyle:0}

END
