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
options, tname, 'ytitle', 'f!Dce!N'
options, tname, 'ysubtitle', '[Hz]'
ylim, tname, 0, 0, /log



;
;*---------- Ion cyclotron frequency (Hz)----------*
;
tname = 'Ion_cyclotoron_frequency__C' + sc + suffix
f_ci  = !CONST.E * b_mag / !CONST.MP / 2. / !PI
;
store_data, tname, data={x:b.X, y:f_ci}
options, tname, 'ytitle', 'f!Dci!N'
options, tname, 'ysubtitle', '[Hz]'
ylim, tname, 0, 0, /log



;
;*---------- Lower Hybrid frequency (Hz) ----------*
;
tname = 'Lower_hybrid_frequency__C' + sc + suffix
f_lh = SQRT(f_ce * f_ci)
;
store_data, tname, data={x:b.x, y:f_lh}
options, tname, 'ytitle', 'f!Dlh!N'
options, tname, 'ysubtitle', '[Hz]'
ylim, tname, 0, 0, /log




;
;*---------- Lower Hybrid frequency (Using Freq. ratio)  ----------*
;
tname     = 'Lower_hybrid_frequency__C' + sc + suffix + '_accurate'
tname_fpi = 'Proton_plasma_frequancy__C' + sc
;
dum = WHERE(STRMATCH(tnames(), tname_fpi), count)  
IF count NE 1 THEN GOTO, skip_lh
;
get_data, tname_fpi, data=fpi 
t_fpi = fpi.x
f_pe   = fpi.y * SQRT(!CONST.MP/!CONST.ME)
;
f_pe   = interp(f_pe, t_fpi, b.x)
ratio  = f_pe / f_ce
f_lh   = !CONST.ME/!CONST.MP * f_ce^2 / (1. + ratio^(-2))
f_lh   = SQRT(f_lh)
;
store_data, tname, data={x:b.x, y:f_lh}
options, tnems, 'ytitle', 'f!Dlh!N'
options, tname, 'ysubtitle', '[Hz]'
ylim, tname, 0, 0, /log


skip_lh:
END

