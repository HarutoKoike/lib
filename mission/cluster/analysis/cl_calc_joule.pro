pro cl_calc_joule, load=load


if keyword_set(load) then begin
    sc = [1, 3, 4]
    cl_load, sc, /fote, /full, /cis, /efw, /only
    cl_load, 2, /efw, /fgm
endif




get_data, 'FOTE_curl_current', data=j
;
get_data, 'E_xyz_GSM__C1_EFW', data=e1
get_data, 'E_xyz_GSM__C2_EFW', data=e2
get_data, 'E_xyz_GSM__C3_EFW', data=e3
get_data, 'E_xyz_GSM__C4_EFW', data=e4
;
get_data, 'V_HIA_xyz_gsm__C1_PP_CIS', data=v1
;get_data, 'V_HIA_xyz_gsm__C2_PP_CIS', data=v2
get_data, 'V_HIA_xyz_gsm__C3_PP_CIS', data=v3
get_data, 'V_HIA_xyz_gsm__C4_PP_CIS', data=v4
;
get_data, 'B_vec_xyz_gsm__C1_CP_FGM_FULL', data=b1
get_data, 'B_vec_xyz_gsm__C2_CP_FGM_FULL', data=b2
get_data, 'B_vec_xyz_gsm__C3_CP_FGM_FULL', data=b3
get_data, 'B_vec_xyz_gsm__C4_CP_FGM_FULL', data=b4



if isa(j, 'int') or isa(e1, 'int') or isa(e2, 'int') or $
   isa(e3, 'int') or isa(e4, 'int') or isa(v1, 'int') or $
   isa(v3, 'int') or isa(v4, 'int') or isa(b1, 'int') or $
   isa(b2, 'int') or isa(b3, 'int') or isa(b4, 'int') then $
   return

e1 = interp(e1.y, e1.x, j.x)
e2 = interp(e2.y, e2.x, j.x)
e3 = interp(e3.y, e3.x, j.x)
e4 = interp(e4.y, e4.x, j.x)
v1 = interp(v1.y, v1.x, j.x)
;v2 = interp(v2.y, v2.x, j.x)
v3 = interp(v3.y, v3.x, j.x)
v4 = interp(v4.y, v4.x, j.x)
b1 = interp(b1.y, b1.x, j.x)
b2 = interp(b2.y, b2.x, j.x)
b3 = interp(b3.y, b3.x, j.x)
b4 = interp(b4.y, b4.x, j.x)
;
;
e = mean( [ [[e1]], [[e2]], [[e3]], [[e4]] ], dim=3, /nan )
v = mean( [ [[v1]], [[v3]], [[v4]] ], dim=3, /nan )
b = mean( [ [[b1]], [[b2]], [[b3]], [[b4]] ], dim=3, /nan )
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
options, "EJ", databar={yval:0, linestyle:2}
options, "EJ", ysubtitle='[pW/m!U3!N]'
store_data, 'vxB', data={x:t, y:e_conv} 
store_data, 'E+vxB', data = {x:t, y:e+e_conv}

end
