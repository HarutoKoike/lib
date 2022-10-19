PRO efw::load

COMPILE_OPT IDL2
;
;*---------- dataset id  ----------*
;
self->GetProp, st=st, et=et, sc=sc
id = 'C' + sc + '_CP_EFW_L3_E'


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
files = self->filesearch(id, st, et)
;
cdf2tplot, files, /all



;
;*---------- 3D (E*B=0 assumption)  ----------*
;
tname = 'E_Vec_xy_ISR2__C' + sc + '_CP_EFW_L3_E'
get_data, tname, data=e
;
fgm = cl_fgm(sc=sc)
fgm->load
;
tname_mag = 'B_xyz_gse__C' + sc + '_PP_FGM'
suffix = '_interp_efw'
tinterpol, tname_mag, tname, newname=tname_mag+suffix
;
get_data, tname_mag + suffix, data=b
;
ez  = -TOTAL(b.y[*, 0:1] * e.y[*, 0:1], 2) / REFORM(b.y[*,2]) 
e3d = FLTARR(N_ELEMENTS(e.x), 3)
e3d[*, 0:1] = e.y
e3d[*, 2]   = ez
;
tname = 'E_xyz_GSE__C' + sc + '_EFW'
store_data, tname, data={x:e.x, y:e3d} 
;
options, tname, 'colors', [0, 50, 230]

;tname_gsm = 'E_xyz_GSM__C' + sc + '_EFW'
;
;cotrans, tname, tname_gsm, /gse2gsm
;options, tname_gsm, 'colors', [0, 50, 230]

END
