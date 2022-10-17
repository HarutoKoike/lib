
;===========================================================+
; ++ NAME ++
FUNCTION cl_aux::distance, trange
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


get_data, 'pos_x_gsm_barycentre', data=x
get_data, 'pos_y_gsm_barycentre', data=y
get_data, 'pos_z_gsm_barycentre', data=z

dx = x.y[nn('pos_x_gsm_barycentre',trange[1])] - x.y[nn('pos_x_gsm_barycentre', trange[0])]
dy = y.y[nn('pos_y_gsm_barycentre',trange[1])] - y.y[nn('pos_y_gsm_barycentre', trange[0])]
dz = z.y[nn('pos_z_gsm_barycentre',trange[1])] - z.y[nn('pos_z_gsm_barycentre', trange[0])]


cluster->common_var, re=re
RETURN, SQRT(dx^2 + dy^2 + dz^2)*re
END

