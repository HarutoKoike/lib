PRO cis::load_onboard_moment
COMPILE_OPT IDL2
;
;*---------- settings ----------*
;
self->cluster::GetProperty, st=st, et=et, sc=sc
;
;
;*---------- dataset id  ----------*
;                              
id = 'C' + sc + '_CP_CIS-HIA_ONBOARD_MOMENTS'

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

 
END


;===========================================================+
; ++ NAME ++
PRO cis::load, only_pp=only_pp, full_moment=full_moment, success=success, advanced=advanced
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
success=0
;
;*---------- settings ----------*
;
self->cluster::GetProperty, st=st, et=et, sc=sc
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
;
;
IF KEYWORD_SET(only_pp) THEN $
  id = 'C' + sc + '_PP_CIS'



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
;
; load FGM data
fgm = fgm(sc=sc, st=st, et=et)
fgm->load
;
get_data, 'B_xyz_gse__C'+sc+'_PP_FGM', data=b
IF SIZE(b, /TYPE) EQ 2 THEN GOTO, no_mag
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
options, 'V_para_perp__C'+sc, 'ytitle', 'V!Dpara!N/V!Dperp!N'
options, 'V_para_perp__C'+sc, 'ysubtitle', '[km/s]'


no_mag:

;
;*---------- ion velocity GSE to GSM  ----------*
;
aux = aux(sc=sc, st=st, et=et)
aux->load
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
options, 'T_HIA_par__C' + sc + '_PP_CIS', 'ytitle', 'Ti!Dpara!N'
options, 'T_HIA_perp__C' + sc + '_PP_CIS', 'ytitle', 'Ti!Dperp!N'
options, 'T_HIA_par__C' + sc + '_PP_CIS', 'ysubtitle', '[MK]'
options, 'T_HIA_perp__C' + sc + '_PP_CIS', 'ysubtitle', '[MK]'
;
tname = 'T_HIA__C' + sc + '_PP_CIS'
store_data, tname, data = ['T_HIA_par__C'+sc+'_PP_CIS', $
            'T_HIA_perp__C'+sc+'_PP_CIS']
options, tname, 'colors', [50, 220]
ylim, tname, 1., 100, /log
options, tname, ytitle='T!Di!N'
options, tname, ysubtitle='[10!U6!NK]'
options, tname, labels=['para', 'perp']




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
options, tname, 'ytitle', 'Ion(C' + sc + ')' 
options, tname, ysubtitle='[eV]'
options, tname, '[eV/eV cm!U2!N s sr]'




IF KEYWORD_SET(only_pp) THEN GOTO, jump

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



;
;*---------- ion pitch angle distribution (energy integrated)  ----------*
;
tname = 'Differential_Particle_Flux__C' + sc + '_CP_CIS-HIA_PAD_HS_MAG_IONS_PF'
get_data, tname, data=d
;
de       = FLTARR(N_ELEMENTS(d.v2)) 
de[0]    = d.v2[0] - d.v2[1]
de[-1]   = d.v2[-2] - d.v2[-1]
de[1:-2] = 0.5 * (d.v2[0:-3] - d.v2[2:-1])
;
flux = FLTARR(N_ELEMENTS(d.x), N_ELEMENTS(d.v1))
FOR i = 0, N_ELEMENTS(de) - 1 DO BEGIN
    flux += d.Y[*, i, *] * de[i] * 1.e-3 ; eV -> keV
ENDFOR
;
tname = 'Total_Number_Flux_PAD__C' + sc + '_CP_CIS-HIA_HS_MAG_IONS_PF'
store_data, tname, data={x:d.x, y:flux, v:d.v1}
;
ylim, tname, 0, 180
zlim, tname, 0, 0, 1
get_data, tname, dlim=dlim
str_element, dlim, 'spec', 1, /add
store_data, tname, dlim=dlim
;
options, tname, 'ytitle', 'Ion PAD (C' + sc + ')'
options, tname, 'ysubtitle', '[deg]'
options, tname, 'ztitle', 'cm!U-2!N s!U-1!N st!U-1!N'
;



jump:
;
;*---------- plasma frequency & inertial length  ----------*
;
get_data, 'N_HIA__C'+sc+'_PP_CIS', data=n
np = n.Y * 1.e6
;
;
tname   = 'Proton_plasma_frequancy__C' + sc  
omega_p = SQRT( !CONST.E^2 * np / (!CONST.EPS0 * !CONST.MP) ) 
store_data, tname, data={x:n.X, y:omega_p/!PI/2.}
options, tname, 'ytitle', 'f!Dpi!N'
options, tname, 'ysubtitle', '[Hz]'
;
;
tname = 'Proton_inertial_length__C' + sc
intl  = !CONST.C / omega_p * 1.e-3
store_data, tname, data={x:n.X, y:intl}
options, tname, 'ytitle', 'Inertial Length(C' + sc + ')'
options, tname, 'ysubtitle', '[km]'




;
;*---------- ion beta  ----------*
;
;
bmag   = SQRT(b.Y[*, 0]^2 + b.Y[*, 1]^2 + b.Y[*, 2]^2) * 1.e-9
tmag   = b.X
b_pres = bmag^2  / 2. / !CONST.MU0  ; magnetic pressure
;
get_data, 'T_HIA_par__C' + sc + '_PP_CIS', data=t_para 
get_data, 'T_HIA_perp__C' + sc + '_PP_CIS', data=t_perp 
get_data, 'N_HIA__C'+sc+'_PP_CIS', data=n
;
np     = interp(n.Y, n.X, tmag) * 1.e6
t_para = interp(t_para.Y, t_para.X, tmag) * 1.e6 
t_perp = interp(t_perp.Y, t_perp.X, tmag) * 1.e6 
;
beta_para = np * !CONST.K * t_para / b_pres 
beta_perp = np * !CONST.K * t_perp / b_pres 
tname_para = 'Beta_para__C' + sc
tname_perp = 'Beta_perp__C' + sc
store_data, tname_para, data={X:tmag, Y:beta_para} 
store_data, tname_perp, data={X:tmag, Y:beta_perp} 
;
ylim, tname_para, 0, 0, 1
ylim, tname_perp, 0, 0, 1
;
tname_beta = 'Ion_Beta__C' + sc
store_data, tname_beta, data=[tname_para, tname_perp]
options, tname_beta, 'colors', [50, 230]
options, tname_beta, 'labels', ['para', 'perp']
options, tname_beta, 'databar', {yval:1., linestyle:2}
ylim, tname_beta, 0.0001, 100, 1



;
;*---------- Frequency ratio (F_pi / F_ci)  ----------*
;
tname = 'Frequency_ratio_ion__C' + sc
ratio = SQRT( !CONST.MP * np / !CONST.EPS0 / bmag^2)
store_data, tname, data={x:tmag, y:ratio}
options, tname, 'databar', {yval:1, linestyle:2}
options, tname, 'ytitle', 'f!Dpi!N/f!Dci!N (C' + sc + ')'
ylim, tname, 0, 0, /log
;
;
tname = 'Frequency_ratio_electron__C' + sc
ratio = ratio * SQRT(!CONST.ME / !CONST.MP)
store_data, tname, data={x:tmag, y:ratio}
options, tname, 'databar', {yval:1, linestyle:2}
options, tname, 'ytitle', 'f!Dpe!N/f!Dce!N (C' + sc + ')'
ylim, tname, 0, 0, /log     


;
;*---------- anisotropy  ----------*
;
get_data, 'T_HIA_par__C' + sc + '_PP_CIS', data=t
;
tname_aniso = 'Ion_Anisotropy__C' + sc 
store_data, tname_aniso, data={X:t.X, Y:t_para/t_perp}
options, tname_aniso, 'ytitle', 'T!Dpara!N/T!Dperp!N (C' + sc + ')'
options, tname_aniso, 'databar', {yval:1., linestyle:2}
ylim, tname_aniso, 0, 0, 1



;
;*---------- -V x B electric field  ----------*
;
tcrossp, 'B_xyz_gsm__C'+sc+'_PP_FGM', 'V_HIA_xyz_gsm__C'+sc+'_PP_CIS', $
         /diff_tsize_ok, newname='E_gsm_VxB__C' + sc

; mV/m  
calc, '"E_gsm_VxB__C' + sc + '" *= 1.e-3'
options, 'E_gsm_VxB__C' + sc, 'ytitle', 'E_field(GSM, C' + sc + ')'
options, 'E_gsm_VxB__C' + sc, 'ysubtitle', 'mV/m'




;
;*---------- Alfven Velocity (proton) ----------*
;
get_data, 'B_xyz_gsm__C'+sc+'_PP_FGM', data=b
get_data, 'N_HIA__C'+sc+'_PP_CIS', data=n
;
np = interp(n.Y, n.X, b.X) * 1.e6
t  = b.X
b  = b.Y * 1.e-9
;
va = FLTARR(N_ELEMENTS(t), 3)
va[*, 0] = b[*, 0] / SQRT( !CONST.MU0 * np * !CONST.MP ) * 1.e-3
va[*, 1] = b[*, 1] / SQRT( !CONST.MU0 * np * !CONST.MP ) * 1.e-3
va[*, 2] = b[*, 2] / SQRT( !CONST.MU0 * np * !CONST.MP ) * 1.e-3
;
tname = 'Alfven_Velocity__C' + sc
store_data, tname, data = {X:t, Y:va}
;
options, tname, 'ytitle', 'V!DA!N (C' + sc + ')'
options, tname, 'ysubtitle', '[km/s]'
options, tname, 'colors', [230, 150, 50]
options, tname, 'labels', ['x', 'y', 'z']


IF ~KEYWORD_SET(advanced) THEN RETURN


;-------------------------------------------------+
; advanced parameters
;-------------------------------------------------+
get_data, 'flux__C' + sc + '_CP_CIS-HIA_HS_1D_PEF', data=f
;
e       = f.v
e_max   = FLTARR( N_ELEMENTS(f.x) )  ; energy at maximum flux
e_lower = FLTARR( N_ELEMENTS(f.x) )  ; lower energy at maximum flux /10. 
e_upper = FLTARR( N_ELEMENTS(f.x) )  ; 
kurt    = FLTARR( N_ELEMENTS(f.x) )  ; kurtosis
skew    = FLTARR( N_ELEMENTS(f.x) )  ; skewness
;
;
r = exp(-1) ; 
;
FOR i = 0, N_ELEMENTS(f.x) - 1 DO BEGIN
    fmax = MAX( f.y[i, *], mi, /NAN )
    e_max[i] = e[mi]  
    ;
    idx     = WHERE( f.y[i, *] ge fmax * r)
    ;
    e_lower[i] = e[ idx[-1] ]
    e_upper[i] = e[ idx[0]  ]
    ;
    rv = dist2randomvar(reform(f.y[i, *]))
    IF N_ELEMENTS(rv) EQ 1 THEN BEGIN
        kurt[i] = !VALUES.F_NAN
        skew[i] = !VALUES.F_NAN
    ENDIF
    kurt[i] = KURTOSIS(rv, /nan)
    skew[i] = SKEWNESS(rv, /nan)
ENDFOR




;
;*----------   ----------*
;
tn = 'erange__C' + sc
store_data, tn, data={x:f.x, y:[ [e_max], [e_lower], [e_upper] ]}
ylim, tn, e[-1], e[0], 1
options, tn, 'ysubtitle', '[eV]'
;
tn_new = tn+'_smoothed'
tsmooth_in_time, tn, 20., newname=tn_new
options, tn_new, 'colors', [0, 50, 230]
ylim, tn_new, e[-1], e[0], 1

deriv_data, tn
deriv_data, tn_new


tn = 'delta_e__C' + sc
de  = 1 - ALOG10(e_lower)/ALOG10(e_upper)
store_data, tn, data={x:f.x, y:de}
ylim, tn, 0, 0, 1
options, tn, 'databar', {yval:1, linestyle:2}
;
de_ave = MEAN(de, /NAN)
de_std = STDDEV(de, /NAN)
options, tn, 'databar', {yval:[de_ave, de_ave-de_std], linestyle:2}


;
;
tn_new = tn + '_sm'
tsmooth_in_time, tn, 20., newname=tn_new


;
; kurtosis
tn = 'kurtosis__C' + sc
store_data, tn, data={x:f.x, y:kurt}
options, tn, 'databar', {yval:0, linestyle:2}


;
; skewness
tn = 'skewness__C' + sc
store_data, tn, data={x:f.x, y:skew}
options, tn, 'databar', {yval:0, linestyle:2}



END
