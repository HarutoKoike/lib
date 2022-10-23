PRO cl_fote, t_cut


END


myspedas->timespan, 2004, 3, 10, 12, dhr=1

cl_load, 1, /fgm
cl_load, 2, /fgm
cl_load, 3, /fgm
cl_load, 4, /fgm

t_cut = '2004-03-10/12:30:00'

get_data, 'B_xyz_gsm__C1_PP_FGM', data=b1 
get_data, 'B_xyz_gsm__C2_PP_FGM', data=b2 
get_data, 'B_xyz_gsm__C3_PP_FGM', data=b3 
get_data, 'B_xyz_gsm__C4_PP_FGM', data=b4 
;
idx1 = nn('B_xyz_gsm__C1_PP_FGM', t_cut)
idx2 = nn('B_xyz_gsm__C2_PP_FGM', t_cut)
idx3 = nn('B_xyz_gsm__C3_PP_FGM', t_cut)
idx4 = nn('B_xyz_gsm__C4_PP_FGM', t_cut)
;
b1 = reform(b1.Y[idx1, *])
b2 = reform(b2.Y[idx1, *])
b3 = reform(b3.Y[idx1, *])
b4 = reform(b4.Y[idx1, *])




get_data, 'pos_gsm_c1', data=x1
get_data, 'pos_gsm_c2', data=x2
get_data, 'pos_gsm_c3', data=x3
get_data, 'pos_gsm_c4', data=x4
;
idx1 = nn('pos_gsm_c1', t_cut)
idx2 = nn('pos_gsm_c2', t_cut)
idx3 = nn('pos_gsm_c3', t_cut)
idx4 = nn('pos_gsm_c4', t_cut)
;
x1 = reform(x1.Y[idx1, *])
x2 = reform(x2.Y[idx2, *])
x3 = reform(x3.Y[idx3, *])
x4 = reform(x4.Y[idx4, *])

center = (x1 + x2 + x3 +x4) / 4.

m = math->fote(x1, x2, x3, x4, b1, b2, b3, b4, xref=xref, /save)
                                                 
!p.position = [0.07, 0.07, 0.92, 0.92]
idlplotlib->field_line2d, xrange=[1.65, 1.85], zrange=[-9.7, -9.5], /xz, $
                          cut=center[1], xtitle='X(Re)', ytitle='Z(Re)', $
                          title='Magnetic Field Line (' + t_cut + ')' 


s = 6.
x = [0, 0.5, 1, 0]
y = [0, 1, 0, 0]
print, x1, x4
usersym, x*s, y*s, /fill 

oplot, [x1[0], x1[0]], [x1[2], x1[2]], color=255, psym=8 
oplot, [x2[0], x2[0]], [x2[2], x2[2]], color=50, psym=8 
oplot, [x3[0], x3[0]], [x3[2], x3[2]], color=150, psym=8 
oplot, [x4[0], x4[0]], [x4[2], x4[2]], color=230, psym=8 

end          
