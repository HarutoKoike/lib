PRO efw::load, burst_mode=burst_mode

COMPILE_OPT IDL2
;
;*---------- dataset id  ----------*
;
self->GetProperty, st=st, et=et, sc=sc
;id = 'C' + sc + '_CP_EFW_L1_E'
;id = 'C' + sc + '_CP_EFW_L3_E'
;id = 'C' + sc + '_CP_EFW_L3_E3D_GSE'
;id = 'C' + sc + '_CP_EFW_L2_E3D_GSE'
id = 'C' + sc + '_CP_EFW_L2_E'
;id = 'C' + sc + '_CP_EFW_L2_V3D_GSE'
;id = 'C' + sc + '_CP_EFW_L2_PB'
IF KEYWORD_SET(burst_mode) THEN $
    id = 'C' + sc + '_CP_EFW_L1_E'


;
;*---------- download  ----------*
;
suc=1
IF ~self->filetest(id, st, et) THEN $
  self->download, id, st, et, suc
IF ~suc THEN RETURN


;
;*---------- read cdf  ----------*
;
files = self->file_search(id, st, et)
;
cdf2tplot, files, /all



;
;*----------   ----------*
;
tname = 'E_Vec_xy_ISR2__C' + sc + '_CP_EFW_L2_E'
get_data, tname, data=e
IF ISA(e, 'INT') THEN RETURN
;
;
fgm = fgm(sc=self.sc, st=self.st, et=self.et)
fgm->load, /full
OBJ_DESTROY, fgm
tname_mag = 'B_xyz_gse__C' + sc + '_PP_FGM_'
tname_mag = 'B_vec_xyz_gse__C' + sc + '_CP_FGM_FULL'
get_data, tname_mag, data=b


;
;
;*---------- calc Z component of E  ----------*
;
;  E is in ISR2 coordinate (almost same direction in X-Y of GSE)
;  Ez is calculated under the assumption that E*B = 0 (parallel E field is 0)
;
ex_gse = e.Y[*, 0]
ey_gse = e.Y[*, 1]
bx_gse = interp(b.Y[*, 0], b.X, e.X)
by_gse = interp(b.Y[*, 1], b.X, e.X)
bz_gse = interp(b.Y[*, 2], b.X, e.X)
;
idx_nan = WHERE(ABS(bz_gse) LT 1., /NULL)
bz_gse[idx_nan] = !VALUES.F_NAN
;
ez_gse = -(ex_gse * bx_gse + ey_gse * by_gse) / bz_gse


;
;*---------- GSE to GSM  ----------*
;
aux = aux(sc=self.sc, st=self.st, et=self.et)
aux->load
OBJ_DESTROY, aux
;
get_data, 'gse_gsm__CL_SP_AUX', data=ang
ang = ang.Y * !DTOR
ang = INTERPOL(ang, N_ELEMENTS(e.X)) 
 
 
ex_gsm = ex_gse 
ey_gsm = ey_gse * COS(ang) - ez_gse * SIN(ang)
ez_gsm = ey_gse * SIN(ang) + ez_gse * COS(ang)
;
tname = 'E_xyz_GSM__C' + sc + '_EFW'
store_data, tname, data={x:e.x, y:[ [ex_gsm], [ey_gsm], [ez_gsm] ]} 
options, tname, 'colors', [230, 140, 50]
options, tname, 'ytitle', 'E(GSM, C' + sc + ')'
options, tname, 'ysubtitle', '[mV/m]'
options, tname, 'databar', {yval:0, linestyle:2}


END
