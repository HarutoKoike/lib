;===========================================================+
; ++ NAME ++
PRO aux::plot_configuration, time=time, trange=trange
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
;*---------- settings  ----------*
;
self->load


;
;*---------- get data  ----------*
;
pos0 = {sc:'', x:0, y:0, z:0} 
pos  = REPLICATE(pos0, 4)
;
FOR i = 1, 4 DO BEGIN
  sc = STRING(i, FORMAT='(I1)')
  get_data, 'pos_x_gsm_c'+sc, data=pos_x
  get_data, 'pos_y_gsm_c'+sc, data=pos_y
  get_data, 'pos_z_gsm_c'+sc, data=pos_z
  ;
  IF KEYWORD_SET(time) THEN idx = nn(pos_x, time)

  pos[i-1].sc = sc
  pos[i-1].x  = pos_x.Y[idx]
  pos[i-1].y  = pos_y.Y[idx]
  pos[i-1].z  = pos_z.Y[idx]
ENDFOR

;
;*----------   ----------*
;
colors = [0, 50, 230, 150]
mypsym, size=2
PLOT_3DBOX, pos.x, pos.y, pos.z, psym=8;, /NODATA
;FOR i = 0, 3 DO BEGIN
;  PLOT_3DBOX, pos[i].x, pos[i].y, pos[i].z,  PSYM=8, /NOERASE
;ENDFOR


END
;
;
;
;
;
;loadct, 39
;mytimespan, 2004, 3, 10, 12, 20, dmin=20
;aux = cl_aux(sc=3)
;aux->plot_config, time='2004-03-10/12:30:00'
;
;
;end
