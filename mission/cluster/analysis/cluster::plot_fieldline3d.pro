;===========================================================+
; ++ NAME ++
FUNCTION cluster::plot_fieldline3d, t_cut, xodds, yodds, zodds, range=range, _EXTRA=ex
;
; ++ PURPOSE ++
;  -->
;
; ++ POSITIONAL ARGUMENTS ++
;  --> t_cut(STRING): time string of the moment to be plotedfield line
;
; ++ KEYWORDS ++
; -->
;
; ++ CALLING SEQUENCE ++
;  -->
;
; ++ HISTORY ++
;  H.Koike 
;===========================================================+
COMPILE_OPT IDL2
;
;
;*---------- load FGM data  ----------*
;
cl_load, [1, 2, 3, 4], /fgm
 
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
;*---------- load AUX data ----------*
;
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



;
;*---------- FOTE  ----------*
;
math = OBJ_NEW('math')
hpl  = OBJ_NEW('hkplotlib')
;
m = math->fote(x1, x2, x3, x4, b1, b2, b3, b4, /save)



IF ~ISA(xodds) THEN xodds = 3.
IF ~ISA(yodds) THEN yodds = 3.
IF ~ISA(zodds) THEN zodds = 3.
;
!p.position = [0.07, 0.07, 0.92, 0.95]
xrange = [-0.1, 0.1]*xodds + center[0]
yrange = [-0.1, 0.1]*yodds + center[1]
zrange = [-0.1, 0.1]*zodds + center[2]


p = hpl->field_line3d('fote_polynominal', xrange, yrange, zrange, nseed=10, range=range, $
                       xtitle='X!DGSE!N(R!DE!N)', ytitle='Y!DGSE!N(R!DE!N)', $
                       ztitle='Z!DGSE!N(R!DE!N)', title=title, _EXTRA=ex)
RETURN, p
END
