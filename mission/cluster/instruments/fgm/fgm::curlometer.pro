;===========================================================+
; ++ NAME ++
PRO fgm::curlometer 
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
;
COMPILE_OPT IDL2, STATIC
;
self->getprop, sc=sc
FOR i = 1, 4 DO BEGIN
    self->setprop, sc=i
    self->load
ENDFOR
self->setprop, sc=sc 
;

;
;*---------- magnetic field  ----------*
;
tname_mag = STRARR(4)
;
tname_mag[0] = 'B_xyz_gse__C1_PP_FGM'
tname_mag[1] = 'B_xyz_gse__C2_PP_FGM'
tname_mag[2] = 'B_xyz_gse__C3_PP_FGM'
tname_mag[3] = 'B_xyz_gse__C4_PP_FGM'

;
;*---------- positions  ----------*
;
tname_pos = STRARR(4)
;
tname_pos[0] = 'pos_gse_c1' 
tname_pos[1] = 'pos_gse_c2' 
tname_pos[2] = 'pos_gse_c3' 
tname_pos[3] = 'pos_gse_c4' 
;
; Re -> km
re = STRING(!CONST.R_EARTH*1.e-3)
re = STRCOMPRESS(re, /REMOVE)
;
FOR i = 0, 3 DO $
  calc, '"' + tname_pos[i] + '(km)"="' + tname_pos[i] + '"' +$
        '*' + re


;
;*---------- curlometer  ----------*
;
get_timespan, ts
mms_curl, trange=ts, field=tname_mag, position=tname_pos+'(km)', /ignore_dlimit
;
efficiency = '|divB|/|curlB|'
get_data, 'divB' , data=db
get_data, 'curlB', data=cb
eff = ABS(db.Y) / SQRT(cb.Y[*, 0]^2 + cb.Y[*, 1]^2 + cb.Y[*, 2]^2)
;
store_data, efficiency, data={x:db.x, y:eff}
options, efficiency, 'databar', {yval:0.5, linestyle:2}
ylim, efficiency, 0, 0, 1
;
;
calc, '"jtotal"*=1.e9'
options, 'jtotal', 'colors', [220, 150, 50]
options, 'jtotal', 'databar', {yval:0, linestyle:2}

;
;
get_data, 'jtotal', data=j
j_mag = SQRT(TOTAL(j.Y^2, 2))
;
tname = '|J|'
store_data, tname, data={x:j.x, y:j_mag}
options, tname, 'ysubtitle', '[nA/m!D2!N]'

;
; direction
get_data, 'baryb', data=bb
bb_mag = SQRT(TOTAL(bb.Y^2, 2))
prod   = total(j.Y*bb.Y, 2) / j_mag / bb_mag
theta  = ACOS(prod) / !dtor
;
store_data, 'ACOS(JB)', data={x:j.x, y:theta}
options, 'ACOS(JB)', 'ysubtitle', '[degree]'
options, 'ACOS(JB)', 'ytitle', 'alpha'
options, 'ACOS(JB)', 'databar', {yval:90, linestyle:2}
ylim, 'ACOS(JB)', 0, 180





;;
;;*---------- E*J ----------*
;
;cis = cl_cis(sc=sc)
;cis->load
;efw = cl_efw(sc=sc)
;efw->load
;;
;suffix = '_interp_jtotal'
;tinterpol, 'E_xyz_GSE__C' + sc + '_EFW', 'jtotal', suffix=suffix  
;tinterpol, 'E_gse_VxB__C' + sc, 'jtotal', suffix=suffix  
;;
;; E field in ion frame
;newname = 'E_ion_frame_GSM__C'+sc
;dif_data,  'E_xyz_GSE__C' + sc + '_EFW'+suffix, 'E_gse_VxB__C' + sc + suffix, $
;           newname = newname
;;
;;
;tname = 'EdotJ'
;tdotp, newname, 'jtotal', newname=tname
;;tdotp, 'E_xyz_GSM__C'+sc+'_EFW'+suffix, 'jtotal', newname=tname
;;
;options, tname, 'ytitle', "E'J"
;options, tname, 'ysubtitle', '[pW/m!U3!N]'
;options, tname, 'databar', {yval:0, linestyle:2}
;ylim, tname, -600, 600
;
END
