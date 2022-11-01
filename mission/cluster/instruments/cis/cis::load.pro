;===========================================================+
; ++ NAME ++
PRO cis::load, only_pp=only_pp  
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
;*---------- settings ----------*
;
self->cluster::GetProp, st=st, et=et, sc=sc
;
;
;*---------- dataset id  ----------*
;
; prime parameter
id = 'C' + sc + '_PP_CIS'
;
; omni directional ion flux 
dum = 'C' + sc + '_CP_CIS-HIA_HS_1D_PEF'
id  = [id, dum]
;
; ion pitch angle
dum = 'C' + sc + '_CP_CIS-HIA_PAD_HS_MAG_IONS_PF'
id  = [id, dum]
;
; O+ pitch angle distribution
dum = 'C' + sc + '_CP_CIS-CODIF_PAD_HS_O1_PF'
id  = [id, dum]

IF KEYWORD_SET(only_pp) THEN $
  id = 'C' + sc + '_PP_CIS'

;

;
;*---------- download  ----------*
;
suc = 1
IF ~self->cluster::filetest(id, st, et) THEN $
  self->cluster::download, id, st, et, suc
IF ~suc THEN RETURN


;
;*---------- read cdf  ----------*
;
files = self->cluster::file_search(id, st, et)
;
foreach fn, files do $
    cdf2tplot, fn, /all




;-------------------------------------------------+
; tplot variable setting
;-------------------------------------------------+
;
;*---------- ion density ----------*
;
tname = 'N_HIA__C'+sc+'_PP_CIS'
ylim, tname, 0, 0, /log
options, tname, ytitle='N!Di!N'
options, tname, ysubtitle='[cm!U-3!N]'
;
;*---------- ion velocity ----------*
;
tname = 'V_HIA_xyz_gse__C'+sc+'_PP_CIS'
options, tname, 'labels', ['Vx', 'Vy', 'Vz']
options, tname, 'colors', [0, 50, 230]
options, tname, ytitle='Ion Velocity(GSE)'
options, tname, ysubtitle='[km/s]'
options, tname, 'databar', {yval:0, linestyle:2}
;
;
get_data, tname, data=v
IF SIZE(v, /TYPE) EQ 2 THEN RETURN
;
tname = 'V_HIA_mag__C' + sc + '_PP_CIS'
vx = v.Y[*, 0]
vy = v.Y[*, 1]
vz = v.Y[*, 2]
vmag  = SQRT(vx^2 + vy^2 + vz^2) 
;
dum = WHERE( STRMATCH(tnames(), 'B_xyz_gse__C'+sc+'_PP_FGM'), count)
IF count EQ 0 THEN BEGIN
    fgm = fgm(sc=sc, st=st, et=et)
    fgm->load
ENDIF
;
get_data, 'B_xyz_gse__C'+sc+'_PP_FGM', data=b
IF SIZE(b, /TYPE) EQ 2 THEN RETURN
;
bx = b.Y[*, 0]
by = b.Y[*, 1]
bz = b.Y[*, 2]
bmag  = SQRT(bx^2 + by^2 + bz^2) 
;
v_para = (vx*bx + vy*by + vz*bz) / bmag
v_perp = SQRT(vmag^2 - v_para^2)
;
store_data, 'V_para__C'+sc, data={x:v.x, y:v_para}
store_data, 'V_perp__C'+sc, data={x:v.x, y:v_perp}
store_data, 'V_mag__C' + sc, data={x:v.x, y:SQRT(v_para^2+v_perp^2)}
;
options, 'V_perp__C'+ sc, 'labels', 'perp'
options, 'V_para__C'+ sc, 'labels', 'para'
options, 'V_mag__C'+ sc, 'labels', '|V|'
;
store_data, 'V_para_perp__C'+sc, data=['V_para__C'+sc, 'V_perp__C'+sc, 'V_mag__C'+sc]
options, 'V_para_perp__C'+ sc, 'colors', [50, 220, 0]
options, 'V_para_perp__C'+sc, 'databar', {yval:0, linestyle:2}
options, 'V_para_perp__C'+sc, 'ytitle', 'V!Di!N'



;
;*---------- ion velocity GSE to GSM  ----------*
;
aux = aux(sc=sc, st=st, et=et)
aux->load
OBJ_DESTROY, aux
;
get_data, 'gse_gsm__CL_SP_AUX', data=ang
IF SIZE(ang, /TYPE) EQ 2 THEN RETURN
;
ang = ang.Y * !DTOR
ang = INTERPOL(ang, N_ELEMENTS(b.X))
;
vx_gsm = v.Y[*, 0] 
vy_gsm = v.Y[*, 1] * COS(ang) - v.Y[*, 2] * SIN(ang)
vz_gsm = v.Y[*, 1] * SIN(ang) + v.Y[*, 2] * COS(ang)
;
vx_gsm = INTERPOL(vx_gsm, N_ELEMENTS(v.x))
vy_gsm = INTERPOL(vy_gsm, N_ELEMENTS(v.x))
vz_gsm = INTERPOL(vz_gsm, N_ELEMENTS(v.x))
;                                         
tname = 'V_HIA_xyz_gsm__C' + sc + '_PP_CIS'
store_data, tname, data={X:v.x, Y:[[vx_gsm], [vy_gsm], [vz_gsm]]}
options, tname, 'colors', [0, 50, 220] 
options, tname, 'labels', ['V!DX!N', 'V!DY!N', 'V!DZ!N']
options, tname, 'databar', {yval:0, linestyle:2} 
options, tname, 'ytitle', 'V!Di!Ni(GSM)'
options, tname, 'ysubtitle', '[km/s]'

 

;
;*---------- ion temperature  ----------*
;
options, 'T_HIA_par__C' + sc + '_PP_CIS', 'ytitle', 'Ti_para'
options, 'T_HIA_perp__C' + sc + '_PP_CIS', 'ytitle', 'Ti_perp'
options, 'T_HIA_par__C' + sc + '_PP_CIS', 'ysubtitle', 'MK'
options, 'T_HIA_perp__C' + sc + '_PP_CIS', 'ysubtitle', 'MK'
options, 'T_HIA_par__C' + sc + '_PP_CIS', 'labels', 'para'
options, 'T_HIA_perp__C' + sc + '_PP_CIS', 'labels', 'perp'
;
tname = 'T_HIA__C' + sc + '_PP_CIS'
store_data, tname, data = ['T_HIA_par__C'+sc+'_PP_CIS', $
            'T_HIA_perp__C'+sc+'_PP_CIS']
options, tname, 'colors', [50, 220]
ylim, tname, 1., 100, /log
options, tname, ytitle='T!Di!N'
options, tname, ysubtitle='[10!U6!NK]'




IF KEYWORD_SET(only_pp) THEN GOTO, jump


;
;*---------- ion omni directional ion flux  ----------*
;
tname = 'flux__C'+sc+'_CP_CIS-HIA_HS_1D_PEF'
get_data, tname, dlim=dlim, lim=lim
;
str_element, dlim, 'spec', 1, /add
store_data, tname, dlim=dlim
ylim, tname, 5, 32.e3, /log
zlim, tname, 0, 0, 1
;
options, tname, 'ytitle', 'omni flux'
options, tname, ysubtitle='[eV]'
options, tname, 'eV/eV cm!U2!N s sr]'



;
;*---------- ion pitch angle distribution  ----------*
;
tname = 'Differential_Particle_Flux__C' + sc + '_CP_CIS-HIA_PAD_HS_MAG_IONS_PF'
options, tname, 'spec', 1
zlim, tname, 0, 0, 1
ylim, tname, 0, 180
;
get_data, tname, dlim=dlim, data=d
;
str_element, dlim, 'spec', 1, /add
FOR i = 0, N_ELEMENTS(d.v2) - 1 DO BEGIN
    energy  = STRCOMPRESS( STRING(d.v2[i]*1.e-3, FORMAT='(F8.3)') , /REMOVE_ALL)
    tname_e = tname + '_' + energy + 'keV' 
    store_data, tname_e, dlim=dlim, data={x:d.x, y:REFORM(d.y[*, i, *]), v:d.v1}
    ;
    ylim, tname_e, 0, 180 
    zlim, tname_e, 0, 0, 1
    ;
    options, tname_e, 'ytitle', energy + ' keV'
    options, tname_e, 'ysubtitle', ''

ENDFOR



jump:
;
;*---------- -V x B electric field  ----------*
;
tcrossp, 'B_xyz_gse__C'+sc+'_PP_FGM', 'V_HIA_xyz_gse__C'+sc+'_PP_CIS', $
         /diff_tsize_ok, newname='E_gse_VxB__C' + sc


; mV/m  
calc, '"E_gse_VxB__C' + sc + '" *= 1.e-3'
;
;cotrans, 'E_gse_VxB__C' + sc, 'E_gsm_VxB__C' + sc, /gse2gsm
;
;
options, 'E_gse_VxB__C' + sc, 'ytitle', 'E_field(GSE)'
options, 'E_gse_VxB__C' + sc, 'ysubtitle', 'mV/m'
;options, 'E_gsm_VxB__C' + sc, 'ytitle', 'E_field(GSM)'
;loptions, 'E_gsm_VxB__C' + sc, 'ysubtitle', 'mV/m'


END
