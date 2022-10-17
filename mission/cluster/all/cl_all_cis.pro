


pro cl_all_cis

cluster->load_vars, 1, /cis
cluster->load_vars, 2, /cis, /only_pp
cluster->load_vars, 3, /cis 
cluster->load_vars, 4, /cis, /only_pp
 

suffix = '_interp_c3'
tinterpol, 'T_HIA_par__C1_PP_CIS', 'T_HIA_par__C3_PP_CIS', suffix=suffix
tinterpol, 'T_HIA_par__C2_PP_CIS', 'T_HIA_par__C3_PP_CIS', suffix=suffix
tinterpol, 'T_HIA_par__C4_PP_CIS', 'T_HIA_par__C3_PP_CIS', suffix=suffix
;
tinterpol, 'T_HIA_perp__C1_PP_CIS', 'T_HIA_perp__C3_PP_CIS', suffix=suffix
tinterpol, 'T_HIA_perp__C2_PP_CIS', 'T_HIA_perp__C3_PP_CIS', suffix=suffix
tinterpol, 'T_HIA_perp__C4_PP_CIS', 'T_HIA_perp__C3_PP_CIS', suffix=suffix
;
tinterpol, 'N_HIA__C1_PP_CIS', 'N_HIA__C3_PP_CIS', suffix=suffix
tinterpol, 'N_HIA__C2_PP_CIS', 'N_HIA__C3_PP_CIS', suffix=suffix
tinterpol, 'N_HIA__C4_PP_CIS', 'N_HIA__C3_PP_CIS', suffix=suffix

;
get_data, 'N_HIA__C1_PP_CIS'+suffix, data=n1
get_data, 'N_HIA__C2_PP_CIS'+suffix, data=n2
get_data, 'N_HIA__C3_PP_CIS', data=n3
get_data, 'N_HIA__C4_PP_CIS'+suffix, data=n4
;
get_data, 'T_HIA_par__C1_PP_CIS'+suffix, data=t_para1
get_data, 'T_HIA_par__C2_PP_CIS'+suffix, data=t_para2
get_data, 'T_HIA_par__C3_PP_CIS', data=t_para3
get_data, 'T_HIA_par__C4_PP_CIS'+suffix, data=t_para4
;
get_data, 'T_HIA_perp__C1_PP_CIS'+suffix, data=t_perp1
get_data, 'T_HIA_perp__C2_PP_CIS'+suffix, data=t_perp2
get_data, 'T_HIA_perp__C3_PP_CIS', data=t_perp3
get_data, 'T_HIA_perp__C4_PP_CIS'+suffix, data=t_perp4


if isa(n2, 'int') then begin
  n2      = {x:n3.x, y:replicate(!values.f_nan, n_elements(n3.x)) }
  t_para2 = {x:n3.x, y:replicate(!values.f_nan, n_elements(n3.x)) }
  t_perp2 = {x:n3.x, y:replicate(!values.f_nan, n_elements(n3.x)) }
endif

n_all = [[n1.Y[*, 0]], [n2.Y[*, 0]], $
         [n3.Y[*, 0]], [n4.Y[*, 0]] ]
;
t_para_all = [[t_para1.Y[*, 0]], [t_para2.Y[*, 0]], $
              [t_para3.Y[*, 0]], [t_para4.Y[*, 0]] ]
;
t_perp_all = [[t_perp1.Y[*, 0]], [t_perp2.Y[*, 0]], $
              [t_perp3.Y[*, 0]], [t_perp4.Y[*, 0]] ]


;
store_data, 'N_HIA_all',      data={x:n3.x, y:n_all}
store_data, 'T_HIA_par_all',  data={x:t_para3.x, y:t_para_all}
store_data, 'T_HIA_perp_all', data={x:t_perp3.x, y:t_perp_all}

options, 'N_HIA_all', 'colors', [0, 50, 150, 220]
options, 'T_HIA_par_all', 'colors', [0, 50, 150, 220]
options, 'T_HIA_perp_all', 'colors', [0, 50, 150, 220]


options, 'N_HIA_all', 'ytitle', 'N!Di!N'
options, 'T_HIA_par_all', 'ytitle', 'T!Di_para!N'
options, 'T_HIA_perp_all', 'ytitle', 'T!Di_perp!N'

ylim, 'N_HIA_all', 0.01, 100, 1 
ylim, 'T_HIA_par_all', 1, 30, 1
ylim, 'T_HIA_perp_all', 1, 30, 1


end
