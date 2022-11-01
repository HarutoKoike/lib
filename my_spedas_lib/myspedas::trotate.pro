;===========================================================+
; ++ NAME ++
PRO myspedas::trotate, ex, ey, ez, tname, tname_new, coord=coord
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
get_data, tname, data=vec, dlim=dlim, lim=lim
;
IF ~KEYWORD_SET(coord) THEN BEGIN
  vec_new_x = vec.y[*, 0]*ex[0] + vec.y[*, 1]*ex[1] + vec.y[*, 2]*ex[2]
  vec_new_y = vec.y[*, 0]*ey[0] + vec.y[*, 1]*ey[1] + vec.y[*, 2]*ey[2]
  vec_new_z = vec.y[*, 0]*ez[0] + vec.y[*, 1]*ez[1] + vec.y[*, 2]*ez[2]
  vec_new = {x:vec.x, y:[[vec_new_x], [vec_new_y], [vec_new_z]]}
ENDIF 

IF KEYWORD_SET(coord) THEN BEGIN
  mat = [[ex], [ey], [ez]]
  vec_new = {x:vec.x, y:INVERT(mat) ## vec.Y}
ENDIF
;
store_data, tname_new, data=vec_new, dlim=dlim, lim=lim
END
