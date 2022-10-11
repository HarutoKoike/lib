;===========================================================+
; ++ NAME ++
PRO cl_fgm::load
;
; ++ PURPOSE ++
;  -->
;
; ++ POSITIONAL ARGUMENTS ++
;  -->
;
; ++ KEYWORDS ++
; -->
;
; ++ CALLING SEQUENCE ++
;  -->
;
; ++ HISTORY ++
;  H.Koike 1/9,2021
;===========================================================+
COMPILE_OPT IDL2
;
;*---------- dataset id ----------*
;
self->GetProp, st=st, et=et, sc=sc 
id = 'C' + sc + '_PP_FGM' 



;
;*---------- download  ----------*
;
;
suc = 1
IF ~self->filetest(id, st, et) THEN $
  self->download, id, st, et, suc
IF ~suc THEN RETURN



;
;*---------- read cdf  ----------*
;
files = self->filesearch(id, st, et)
;
cdf2tplot,files, /all
get_data, 'B_xyz_gse__C' + sc + '_PP_FGM', data=b
;



;
;*---------- tplot ----------*
;
tname = 'B_xyz_gse__C'+sc+'_PP_FGM'
get_data, tname, data=mag
options, tname, 'colors', [0, 50, 220]
options, tname, 'labels', ['Bx', 'By', 'Bz']


;
;*---------- GSE to GSM ----------*
;
aux = cl_aux(sc=sc, st=st, et=et)
aux->load
OBJ_DESTROY, aux
;
get_data, 'gse_gsm__CL_SP_AUX', data=ang
ang = ang.Y * !DTOR
ang = INTERPOL(ang, N_ELEMENTS(b.X))
;
bx_gsm = b.Y[*, 0] 
by_gsm = b.Y[*, 1] * COS(ang) - b.Y[*, 2] * SIN(ang)
bz_gsm = b.Y[*, 1] * SIN(ang) + b.Y[*, 2] * COS(ang)
;                                         
tname = 'B_xyz_gsm__C' + sc + '_PP_FGM'
store_data, tname, data={X:b.x, Y:[[bx_gsm], [by_gsm], [bz_gsm]]}
options, tname, 'colors', [0, 50, 220] 
options, tname, 'labels', ['B!DX!N', 'B!DY!N', 'B!DZ!N']
options, tname, 'databar', {yval:0, linestyle:2} 
options, tname, 'ytitle', 'B(GSM)'
options, tname, 'ysubtitle', '[nT]'




;
;*---------- B total  ----------*
;
tname = 'B_total__C' + sc + '_PP_FGM'
mag = SQRT( bx_gsm^2 + by_gsm^2 + bz_gsm^2 )
store_data, tname, data={x:b.x, y:mag}
;
options, tname, 'ytitle', 'B!Dtot!N'
options, tname, 'ysubtitle', '[nT]'

;
;*---------- Electron cyclotron frequency (Hz)----------*
;
tname = 'Electron_cyclotoron_frequency__C' + sc
b_mag = SQRT(bx_gsm^2 + by_gsm^2 + bz_gsm^2) * 1.e-9 ; nT
f_ce  = !CONST.E * b_mag / !CONST.ME / 2. / !PI
;
store_data, tname, data={x:b.X, y:f_ce}

;
;*---------- Ion cyclotron frequency (Hz)----------*
;
tname = 'Ion_cyclotoron_frequency__C' + sc
f_ce  = !CONST.E * b_mag / !CONST.MP / 2. / !PI
;
store_data, tname, data={x:b.X, y:f_ce}





END

