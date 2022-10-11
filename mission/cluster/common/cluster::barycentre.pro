;===========================================================+
; ++ NAME ++
PRO cluster::barycentre, tnames 
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


;aux = cl_aux(sc=1)
;aux->load
;;
;aux->setprop, sc=2
;aux->load
;;
;aux->setprop, sc=3
;aux->load
;;
;aux->setprop, sc=4
;aux->load

;
;*---------- barycenter  ----------*
;
suffix = '_i'
tinterpol, 'pos_gsm_c2', 'pos_gsm_c1', new_name='pos_gsm_c2' + suffix
tinterpol, 'pos_gsm_c3', 'pos_gsm_c1', new_name='pos_gsm_c3' + suffix
tinterpol, 'pos_gsm_c4', 'pos_gsm_c1', new_name='pos_gsm_c4' + suffix
;
calc, '"pos_gsm_barycentre" = ("pos_gsm_c1" + "pos_gsm_c2" + "pos_gsm_c3" +' + $
      '"pos_gsm_c4") / 4.'


;
;*---------- weight ----------*
;
get_data, 'pos_gsm_c1', data=r1
get_data, 'pos_gsm_c2', data=r2
get_data, 'pos_gsm_c3', data=r3
get_data, 'pos_gsm_c4', data=r4
get_data, 'pos_gsm_barycentre', data=rb
;
dr1 = rb.y - r1.y
dr2 = rb.y - r2.y
dr3 = rb.y - r3.y
dr4 = rb.y - r4.y
;
dr1 = SQRT(TOTAL(dr1^2, 2)) 
dr2 = SQRT(TOTAL(dr2^2, 2)) 
dr3 = SQRT(TOTAL(dr3^2, 2)) 
dr4 = SQRT(TOTAL(dr4^2, 2)) 
;
weight1 = dr1 / (dr1+dr2+dr3+dr4)
weight2 = dr2 / (dr1+dr2+dr3+dr4)
weight3 = dr3 / (dr1+dr2+dr3+dr4)
weight4 = dr4 / (dr1+dr2+dr3+dr4)


;
;*---------- calc barycentre value  ----------*
;
IF N_ELEMENTS(tnames) NE 4 THEN BEGIN
  PRINT, '% tname must be 4-element array'
  RETURN
ENDIF
;
suffix = '_i'
tinterpol, tname[1], tname[0], new_name=tname[1] + suffix
tinterpol, tname[2], tname[0], new_name=tname[2] + suffix
tinterpol, tname[3], tname[0], new_name=tname[3] + suffix
;
get_data, tname[0], data=v1
get_data, tname[1], data=v2
get_data, tname[2], data=v3
get_data, tname[3], data=v4
;
v = v1.Y * weight1 + v2.Y*weight2 + v3.Y*weight3 + v4.Y*weight4
store_data, tname[0] + '_barycentre', data={x:v1.x, y:v}

END




