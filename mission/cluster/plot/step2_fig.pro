
mytimespan, 2004, 3, 10, 12, 20, dmin=20

;cl_all_cis
;cl_all_fgm
;pea=cl_peace(sc=3)
;pea->load
 
trange = ['2004-03-10/12:25:16', $
          '2004-03-10/12:26:55']

tname_mag = 'B_xyz_gse__C3_PP_FGM'
tnames = ['V_HIA_xyz_gse__C1_PP_CIS', $
          ;'V_HIA_xyz_gse__C2_PP_CIS', $
          'V_HIA_xyz_gse__C3_PP_CIS', $
          ;'V_HIA_xyz_gse__C4_PP_CIS', $
          'B_xyz_gse__C1_PP_FGM',     $
          'B_xyz_gse__C2_PP_FGM',     $
          'B_xyz_gse__C3_PP_FGM',     $
          'B_xyz_gse__C4_PP_FGM'      $
          ]

tmva, tnames, tname_mag=tname_mag, trange

tnames = ['V_HIA_xyz_gse__C1_PP_CIS_LMN', $
          'V_HIA_xyz_gse__C3_PP_CIS_LMN',  $
          'B_xyz_gse__C1_PP_FGM_LMN'     , $
          'B_xyz_gse__C2_PP_FGM_LMN'     , $
          'B_xyz_gse__C3_PP_FGM_LMN'     , $
          'B_xyz_gse__C4_PP_FGM_LMN'     ] 


tplot, tnames
suffix = '_interp_c3'
tinterpol, tnames[0], tnames[1], suffix=suffix
tinterpol, tnames[2], tnames[4], suffix=suffix
tinterpol, tnames[3], tnames[4], suffix=suffix
tinterpol, tnames[5], tnames[4], suffix=suffix


get_data, tnames[0]+suffix, data=v1
get_data, tnames[1], data=v3
get_data, tnames[2]+suffix, data=b1
get_data, tnames[3]+suffix, data=b2
get_data, tnames[4], data=b3
get_data, tnames[5]+suffix, data=b4

vl = [ [v1.y[*, 0]], [v3.y[*, 0]] ]
vm = [ [v1.y[*, 1]], [v3.y[*, 1]] ]
vn = [ [v1.y[*, 2]], [v3.y[*, 2]] ]
                         
bl = [ [b1.y[*, 0]], [b2.y[*, 0]] , [b3.y[*, 0]], [b4.y[*, 0]] ]
bm = [ [b1.y[*, 1]], [b2.y[*, 1]] , [b3.y[*, 1]], [b4.y[*, 1]] ]
bn = [ [b1.y[*, 2]], [b2.y[*, 2]] , [b3.y[*, 2]], [b4.y[*, 2]] ]

store_data, 'V_HIA_L_all', data={x:v3.x, y:vl}
store_data, 'V_HIA_M_all', data={x:v3.x, y:vm}
store_data, 'V_HIA_N_all', data={x:v3.x, y:vn}

store_data, 'B_L_all', data={x:b3.x, y:bl}
store_data, 'B_M_all', data={x:b3.x, y:bm}
store_data, 'B_N_all', data={x:b3.x, y:bn}


options, 'V_HIA_L_all', 'colors', [0, 150]
options, 'V_HIA_M_all', 'colors', [0, 150]
options, 'V_HIA_N_all', 'colors', [0, 150]

options, 'B_L_all', 'colors', [0, 50, 150, 220]
options, 'B_M_all', 'colors', [0, 50, 150, 220]
options, 'B_N_all', 'colors', [0, 50, 150, 220]

;
;*----------   ----------*
;
options, 'V_HIA_L_all', 'databar', {yval:0, linestyle:2}
options, 'V_HIA_M_all', 'databar', {yval:0, linestyle:2}
options, 'V_HIA_N_all', 'databar', {yval:0, linestyle:2}
 
options, 'B_L_all', 'databar', {yval:0, linestyle:2}
options, 'B_M_all', 'databar', {yval:0, linestyle:2}
options, 'B_N_all', 'databar', {yval:0, linestyle:2}


;
;*----------   ----------*
;
options, 'V_HIA_L_all', 'ytitle', 'V!DL!N'
options, 'V_HIA_M_all', 'ytitle', 'V!DM!N'
options, 'V_HIA_N_all', 'ytitle', 'V!DN!N'
options, 'V_HIA_L_all', 'ysubtitle', '[km/s]'
options, 'V_HIA_M_all', 'ysubtitle', '[km/s]'
options, 'V_HIA_N_all', 'ysubtitle', '[km/s]'
;
options, 'B_L_all', 'ytitle', 'B!DL!N'
options, 'B_M_all', 'ytitle', 'B!DM!N'
options, 'B_N_all', 'ytitle', 'B!DN!N'
options, 'B_L_all', 'ysubtitle', '[nT]'
options, 'B_M_all', 'ysubtitle', '[nT]'
options, 'B_N_all', 'ysubtitle', '[nT]'


;
;*----------   ----------*
;
store_data, 'B_total', data=['B_total__C1_PP_FGM', 'B_total__C2_PP_FGM', $
                             'B_total__C3_PP_FGM', 'B_total__C4_PP_FGM']
options, 'B_total', 'colors', [0, 50, 150, 220]


tnames = [$;'V_HIA_L_all'   $
          ;'V_HIA_M_all' , $
          ;'V_HIA_N_all' , $
          'B_L_all'     , $
          'B_M_all'     , $
          'B_N_all'     , $
          'B_total'     , $
          'Parallel_electron__C3', $
          'antiparallel_electron__C3']


popen, '~/step2'

tplot, tnames
tplot_apply_databar
timebar, trange
time_stamp, /off
tplot_options, 'title', 'Cluster/FGM/CIS 2004-03-10'
tplot_options, 'thick', 3.
                          
pclose
end






