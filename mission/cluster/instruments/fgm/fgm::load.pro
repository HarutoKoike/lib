;===========================================================+
; ++ NAME ++
PRO fgm::load, full=full
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
;  H.Koike 
;===========================================================+
;
COMPILE_OPT IDL2
;
;*---------- dataset id ----------*
;
self->GetProperty, st=st, et=et, sc=sc 
id = 'C' + sc + '_PP_FGM' 
IF KEYWORD_SET(full) THEN $
    id = 'C' + sc + '_CP_FGM_FULL'


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
files = self->cluster::file_search(id, st, et)
;
cdf2tplot,files, /all
;


;-------------------------------------------------+
; 
;-------------------------------------------------+
;
;*---------- tplot ----------*
;
tname = 'B_xyz_gse__C'+sc+'_PP_FGM'
IF KEYWORD_SET(full) THEN $
    tname = 'B_vec_xyz_gse__C' + sc + '_CP_FGM_FULL'

;
get_data, tname, data=b
;
IF SIZE(b, /TYPE) EQ 2 THEN RETURN
;
options, tname, 'colors', [220, 140, 50]
options, tname, 'labels', ['Bx', 'By', 'Bz']


;
;*---------- GSE to GSM ----------*
;
aux = aux(sc=sc, st=st, et=et)
aux->load
OBJ_DESTROY, aux
;
get_data, 'gse_gsm__CL_SP_AUX', data=ang
;
ang = ang.Y * !DTOR
ang = INTERPOL(ang, N_ELEMENTS(b.X))
;
bx_gsm = b.Y[*, 0] 
by_gsm = b.Y[*, 1] * COS(ang) - b.Y[*, 2] * SIN(ang)
bz_gsm = b.Y[*, 1] * SIN(ang) + b.Y[*, 2] * COS(ang)
;                                         
; tname for GSM
tname = 'B_xyz_gsm__C'+sc+'_PP_FGM'
IF KEYWORD_SET(full) THEN $
    tname = 'B_vec_xyz_gsm__C' + sc + '_CP_FGM_FULL'
;
store_data, tname, data={X:b.x, Y:[[bx_gsm], [by_gsm], [bz_gsm]]}
options, tname, 'colors', [220, 140, 50] 
options, tname, 'labels', ['B!DX!N', 'B!DY!N', 'B!DZ!N']
options, tname, 'databar', {yval:0, linestyle:2} 
options, tname, 'ytitle', 'B(GSM)'
options, tname, 'ysubtitle', '[nT]'



;
;*---------- B total  ----------*
;
IF ~KEYWORD_SET(full) THEN BEGIN
    tname = 'B_total__C' + sc + '_PP_FGM'
    ;
    mag = SQRT( bx_gsm^2 + by_gsm^2 + bz_gsm^2 )
    store_data, tname, data={x:b.x, y:mag}
    ;
    options, tname, 'ytitle', 'B!Dtot!N'
    options, tname, 'ysubtitle', '[nT]'
ENDIF ELSE BEGIN
    tname = 'B_mag__C' + sc + '_CP_FGM_FULL'
    ;
    options, tname, 'ytitle', 'B!Dmag!N'
    options, tname, 'ysubtitle', '[nT]'
ENDELSE


;
;*----------   ----------*
;
tname = 'B_gsm__C' + sc + '_PP_FGM_all'
IF KEYWORD_SET(full) THEN BEGIN
    tname = 'B_vec_xyz_gsm__C' + sc + '_CP_FGM_FULL_all'
    get_data,'B_mag__C' + sc + '_CP_FGM_FULL', data=b
    mag = b.Y
ENDIF
;
store_data, tname, data={x:b.x, Y:[[bx_gsm], [by_gsm], [bz_gsm], [mag]]} 
options, tname, 'colors', [220, 140, 50, 0]
options, tname, 'labels', ['B!DX!N', 'B!DY!N', 'B!DZ!N', '|B|']
options, tname, 'databar', {yval:0, linestyle:2} 
options, tname, 'ytitle', 'B(GSM)'
options, tname, 'ysubtitle', '[nT]'
 



;
;*---------- Electron cyclotron frequency (Hz)----------*
;
suffix = ''
IF KEYWORD_SET(full) THEN $
    suffix = '_FULL'
;
tname = 'Electron_cyclotoron_frequency__C' + sc + suffix
b_mag = SQRT(bx_gsm^2 + by_gsm^2 + bz_gsm^2) * 1.e-9 ; nT
f_ce  = !CONST.E * b_mag / !CONST.ME / 2. / !PI
;
store_data, tname, data={x:b.X, y:f_ce}
ylim, tname, 0, 0, /log



;
;*---------- Ion cyclotron frequency (Hz)----------*
;
tname = 'Ion_cyclotoron_frequency__C' + sc + suffix
f_ce  = !CONST.E * b_mag / !CONST.MP / 2. / !PI
;
store_data, tname, data={x:b.X, y:f_ce}
ylim, tname, 0, 0, /log


END
