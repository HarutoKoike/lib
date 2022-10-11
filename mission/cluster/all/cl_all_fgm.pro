
pro cl_all_fgm

cluster->load_vars, 1, /fgm
cluster->load_vars, 2, /fgm
cluster->load_vars, 3, /fgm
cluster->load_vars, 4, /fgm



suffix = '_interp_c3'
tinterpol, 'B_xyz_gsm__C1_PP_FGM', 'B_xyz_gsm__C3_PP_FGM', suffix=suffix
tinterpol, 'B_xyz_gsm__C2_PP_FGM', 'B_xyz_gsm__C3_PP_FGM', suffix=suffix
;tinterpol, 'B_xyz_gsm__C3_PP_FGM', 'B_xyz_gsm__C3_PP_FGM', suffix=suffix
tinterpol, 'B_xyz_gsm__C4_PP_FGM', 'B_xyz_gsm__C3_PP_FGM', suffix=suffix


get_data, 'B_xyz_gsm__C1_PP_FGM'+suffix, data=b1
get_data, 'B_xyz_gsm__C2_PP_FGM'+suffix, data=b2
get_data, 'B_xyz_gsm__C3_PP_FGM', data=b3
get_data, 'B_xyz_gsm__C4_PP_FGM'+suffix, data=b4

bx_all = [[b1.Y[*, 0]], [b2.Y[*, 0]], $
          [b3.Y[*, 0]], [b4.Y[*, 0]] ]
by_all = [[b1.Y[*, 1]], [b2.Y[*, 1]], $
          [b3.Y[*, 1]], [b4.Y[*, 1]] ]
bz_all = [[b1.Y[*, 2]], [b2.Y[*, 2]], $
          [b3.Y[*, 2]], [b4.Y[*, 2]] ]
b_all  = [[sqrt(total(b1.y^2, 2))], [sqrt(total(b2.y^2, 2))], $
          [sqrt(total(b3.y^2, 2))], [sqrt(total(b4.y^2, 2))]]



store_data, 'Bx_gsm_all', data={x:b1.x, y:bx_all}
store_data, 'By_gsm_all', data={x:b1.x, y:by_all}
store_data, 'Bz_gsm_all', data={x:b1.x, y:bz_all}
store_data, 'B_all', data={x:b1.x, y:b_all}

options, 'Bx_gsm_all', 'colors', [0, 50, 150, 220]
options, 'By_gsm_all', 'colors', [0, 50, 150, 220]
options, 'Bz_gsm_all', 'colors', [0, 50, 150, 220]
options, 'B_all', 'colors', [0, 50, 150, 220]


options, 'Bx_gsm_all', 'databar', {yval:0, linestyle:2, thick:2.5}
options, 'By_gsm_all', 'databar', {yval:0, linestyle:2, thick:2.5}
options, 'Bz_gsm_all', 'databar', {yval:0, linestyle:2, thick:2.5}

;options, 'Bx_gsm_all', 'labels', ['C1', 'C2', 'C3', 'C4']
;options, 'By_gsm_all', 'labels', ['C1', 'C2', 'C3', 'C4']
;options, 'Bz_gsm_all', 'labels', ['C1', 'C2', 'C3', 'C4']

end
