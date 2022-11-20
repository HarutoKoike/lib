PRO cl_fote, t_cut


END


mytimespan, 2004, 3, 10, 11, dhr=2

cl_load, 1, /fgm
cl_load, 2, /fgm
cl_load, 3, /fgm
cl_load, 4, /fgm

;trange = ['2004-03-10/12:28:00', '2004-03-10/12:31:00']
;trange = ['2003-10-09/02:24:20', '2003-10-09/02:25:00']

;myspedas->tmva,'B_xyz_gsm__C1_PP_FGM', 'B_xyz_gsm__C3_PP_FGM', trange
;myspedas->tmva,'B_xyz_gsm__C2_PP_FGM', 'B_xyz_gsm__C3_PP_FGM', trange
;myspedas->tmva,'B_xyz_gsm__C3_PP_FGM', 'B_xyz_gsm__C3_PP_FGM', trange
;myspedas->tmva,'B_xyz_gsm__C4_PP_FGM', 'B_xyz_gsm__C3_PP_FGM', trange
;

t_cut = '2004-03-10/12:29:59'
;t_cut = '2003-10-09/02:25:04'

;get_data, 'B_xyz_gsm__C1_PP_FGM_LMN', data=b1 
;get_data, 'B_xyz_gsm__C2_PP_FGM_LMN', data=b2 
;get_data, 'B_xyz_gsm__C3_PP_FGM_LMN', data=b3 
;get_data, 'B_xyz_gsm__C4_PP_FGM_LMN', data=b4 
;;
;idx1 = nn('B_xyz_gsm__C1_PP_FGM_LMN', t_cut)
;idx2 = nn('B_xyz_gsm__C2_PP_FGM_LMN', t_cut)
;idx3 = nn('B_xyz_gsm__C3_PP_FGM_LMN', t_cut)
;idx4 = nn('B_xyz_gsm__C4_PP_FGM_LMN', t_cut)
;

get_data, 'B_xyz_gsm__C1_PP_FGM', data=b1 
get_data, 'B_xyz_gsm__C2_PP_FGM', data=b2 
get_data, 'B_xyz_gsm__C3_PP_FGM', data=b3 
get_data, 'B_xyz_gsm__C4_PP_FGM', data=b4 
;
idx1 = nn('B_xyz_gsm__C1_PP_FGM', t_cut)
idx2 = nn('B_xyz_gsm__C2_PP_FGM', t_cut)
idx3 = nn('B_xyz_gsm__C3_PP_FGM', t_cut)
idx4 = nn('B_xyz_gsm__C4_PP_FGM', t_cut)


b1 = reform(b1.Y[idx1, *])
b2 = reform(b2.Y[idx1, *])
b3 = reform(b3.Y[idx1, *])
b4 = reform(b4.Y[idx1, *])




;
;*----------   ----------*
;
;myspedas->tmva, 'pos_gsm_c1', 'B_xyz_gsm__C3_PP_FGM_LMN', trange, /coord
;myspedas->tmva, 'pos_gsm_c2', 'B_xyz_gsm__C3_PP_FGM_LMN', trange, /coord
;myspedas->tmva, 'pos_gsm_c3', 'B_xyz_gsm__C3_PP_FGM_LMN', trange, /coord
;myspedas->tmva, 'pos_gsm_c4', 'B_xyz_gsm__C3_PP_FGM_LMN', trange, /coord

;get_data, 'pos_gsm_c1_LMN', data=x1
;get_data, 'pos_gsm_c2_LMN', data=x2
;get_data, 'pos_gsm_c3_LMN', data=x3
;get_data, 'pos_gsm_c4_LMN', data=x4
;;
;idx1 = nn('pos_gsm_c1_LMN', t_cut)
;idx2 = nn('pos_gsm_c2_LMN', t_cut)
;idx3 = nn('pos_gsm_c3_LMN', t_cut)
;idx4 = nn('pos_gsm_c4_LMN', t_cut)

get_data, 'pos_gsm_c1', data=x1 
get_data, 'pos_gsm_c2', data=x2 
get_data, 'pos_gsm_c3', data=x3 
get_data, 'pos_gsm_c4', data=x4 
;                               
idx1 = nn('pos_gsm_c1', t_cut)  
idx2 = nn('pos_gsm_c2', t_cut)  
idx3 = nn('pos_gsm_c3', t_cut)  
idx4 = nn('pos_gsm_c4', t_cut)  

x1 = reform(x1.Y[idx1, *])
x2 = reform(x2.Y[idx2, *])
x3 = reform(x3.Y[idx3, *])
x4 = reform(x4.Y[idx4, *])

center = (x1 + x2 + x3 +x4) / 4.
;x1 -= center 
;x2 -= center
;x3 -= center
;x4 -= center
 





;
;*----------   ----------*
;

;
math = obj_new('math')
idlplotlib=obj_new('idlplotlib')

m = math->fote(x1, x2, x3, x4, b1, b2, b3, b4, /save)
                                                 
!p.position = [0.07, 0.07, 0.92, 0.95]
xrange = [-0.1, 0.1]*3 + center[0]
yrange = [-0.1, 0.1]*3 + center[1]
zrange = [-0.1, 0.1]*3 + center[2]
;idlplotlib->field_line2d, xrange=xrange, zrange=zrange, /xz, $
;                          cut=center[1], xtitle='L(Re)', ytitle='M(Re)', $
;                          title='Magnetic Field Line (' + t_cut + ')',   $
;                          nlevels=100

title = 'Magnetic Field Line Topology (' + t_cut + ')'
idlplotlib->field_line3d, 'fote_polynominal', xrange, yrange, zrange, nseed=50, $
                          xtitle='X!DGSE!N(R!DE!N)', ytitle='Y!DGSE!N(R!DE!N)', $
                          ztitle='Z!DGSE!N(R!DE!N)', title=title

;p1 = scatterplot3d([x1[0], x1[0]], [x1[1], x1[1]], [x1[2], x1[2]], /over, /sym_filled, $
;                   sym_object=orb(), sym_color='black', name='C1')
;p2 = scatterplot3d([x2[0], x2[0]], [x2[1], x2[1]], [x2[2], x2[2]], /over, /sym_filled, $
;                   sym_object=orb(), sym_color='blue', name='C2')
;p3 = scatterplot3d([x3[0], x3[0]], [x3[1], x3[1]], [x3[2], x3[2]], /over, /sym_filled, $
;                   sym_object=orb(), sym_color='red', name='C3')
;p4 = scatterplot3d([x4[0], x4[0]], [x4[1], x4[1]], [x4[2], x4[2]], /over, /sym_filled, $
;                   sym_object=orb(), sym_color='green', name='C4')
;
pl1 = plot3d([x1[0], x2[0]], [x1[1], x2[1]], [x1[2], x2[2]], /over)
pl2 = plot3d([x2[0], x3[0]], [x2[1], x3[1]], [x2[2], x3[2]], /over)
pl3 = plot3d([x3[0], x4[0]], [x3[1], x4[1]], [x3[2], x4[2]], /over)
pl4 = plot3d([x4[0], x1[0]], [x4[1], x1[1]], [x4[2], x1[2]], /over)
pl5 = plot3d([x2[0], x4[0]], [x2[1], x4[1]], [x2[2], x4[2]], /over)
pl6 = plot3d([x3[0], x1[0]], [x3[1], x1[1]], [x3[2], x1[2]], /over)

leg = legend(target=[p1, p2, p3, p4]) 
;s = 6.
;x = [0, 0.5, 1, 0]
;y = [0, 1, 0, 0]
;
;usersym, x*s, y*s, /fill 
;
;oplot, [x1[0], x1[0]], [x1[2], x1[2]], color=255, psym=8 
;oplot, [x2[0], x2[0]], [x2[2], x2[2]], color=50, psym=8 
;oplot, [x3[0], x3[0]], [x3[2], x3[2]], color=150, psym=8 
;oplot, [x4[0], x4[0]], [x4[2], x4[2]], color=230, psym=8 

end          
