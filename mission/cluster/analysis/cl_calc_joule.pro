;pro cl_calc_joule
;
;cl_load, [1, 3, 4], /fote, /full, /cis, /efw, /only


get_data, 'FOTE_curl_current', data=j
;
get_data, 'E_xyz_GSM__C1_EFW', data=e1
;get_data, 'E_xyz_GSM__C2_EFW', data=e2
get_data, 'E_xyz_GSM__C3_EFW', data=e3
get_data, 'E_xyz_GSM__C4_EFW', data=e4
;
get_data, 'V_HIA_xyz_gsm__C1_PP_CIS', data=v1
;get_data, 'V_HIA_xyz_gsm__C2_PP_CIS', data=v2
get_data, 'V_HIA_xyz_gsm__C3_PP_CIS', data=v3
get_data, 'V_HIA_xyz_gsm__C4_PP_CIS', data=v4
;
get_data, 'B_vec_xyz_gsm__C1_CP_FGM_FULL', data=b1
get_data, 'B_vec_xyz_gsm__C3_CP_FGM_FULL', data=b3
get_data, 'B_vec_xyz_gsm__C4_CP_FGM_FULL', data=b4

e1 = interp(e1.y, e1.x, j.x)
e3 = interp(e3.y, e3.x, j.x)
e4 = interp(e4.y, e4.x, j.x)
v1 = interp(v1.y, v1.x, j.x)
v3 = interp(v3.y, v3.x, j.x)
v4 = interp(v4.y, v4.x, j.x)
b1 = interp(b1.y, b1.x, j.x)
b3 = interp(b3.y, b3.x, j.x)
b4 = interp(b4.y, b4.x, j.x)
;
;e = (e1 + e3+ e4) / 3.
;v = (v1 + v3+ v4) / 3.
;b = (b1 + b3+ b4) / 3.
;
e = mean( [ [[e1]], [[e3]], [[e4]] ], dim=3, /nan )
v = mean( [ [[v1]], [[v3]], [[v4]] ], dim=3, /nan )
b = mean( [ [[b1]], [[b3]], [[b4]] ], dim=3, /nan )
t = j.x
j = j.y * 1.e-6
;
e *= 1.e-3
b *= 1.e-9
v *= 1.e3
;
joule  =fltarr(n_elements(t))
e_conv =fltarr(n_elements(t), 3)
for i = 0, n_elements(t) - 1 do begin
    e_conv[i, *] = crossp(v[i, *], b[i, *]) * 1.e-3
    ;
    ef = e[i, *] + e_conv[i, *]
    joule[i] = total( ef * j[i, *] )
endfor

store_data, "EJ", data={x:t, y:joule*1.e12} 
options, "EJ", ysubtitle='[pW/m!U3!N]'
store_data, 'vxB', data={x:t, y:e_conv} 
store_data, 'E+vxB', data = {x:t, y:e+e_conv}

end
