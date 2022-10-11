;===========================================================+
; ++ NAME ++
PRO cl_cis::inertial_length
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
COMPILE_OPT IDL2, STATIC
;
cis = cl_cis(sc=1)
cis->load
cis->setprop, sc=2
cis->load
cis->setprop, sc=3
cis->load
cis->setprop, sc=4
cis->load
;
;*----------   ----------*
;
tnames = ['N_HIA__C1_PP_CIS', 'N_HIA__C2_PP_CIS', $
          'N_HIA__C3_PP_CIS', 'N_HIA__C4_PP_CIS']

;
cluster->barycentre, tnames

get_data, tnames[0] + '_barycentre', data=v_bc
;
l = !CONST.C * 1.e-3 / SQRT(v_bc*1.e6 * !CONST.E^2 / !CONST.EPS0 / !CONST.MP)    
store_data, 'inertial_length_bc', data={x:v_bc.x, y:l}
END
