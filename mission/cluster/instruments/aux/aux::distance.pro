;===========================================================+
; ++ NAME ++
PRO aux::distance, skip_load=skip_load
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
;
;*---------- download ----------*
;
IF ~KEYWORD_SET(skip_load) THEN BEGIN
    FOR i = 1, 4 DO BEGIN
        self->SetProperty, sc=i
        self->load
    ENDFOR
ENDIF

;
;*---------- calculation ----------*
;
tname_arr = []
FOR i = 1, 3 DO BEGIN
    FOR j = i+1, 4 DO BEGIN
        c1 = 'C' + STRING(i, FORMAT='(I1)')
        c2 = 'C' + STRING(j, FORMAT='(I1)')
        ;
        tname = 'AUX_distance_' + c1 + '_' + c2
        tname_arr = [tname_arr, tname]
        ;
        get_data, 'pos_gse_c' + STRING(i, FORMAT='(I1)'), data=p1
        get_data, 'pos_gse_c' + STRING(j, FORMAT='(I1)'), data=p2
        ;
        t  = p1.X
        p1 = p1.Y
        p2 = interp(p2.Y, p2.X, t)
        d  = SQRT( TOTAL( (p2 - p1)^2, 2 ) ) * !CONST.R_EARTH * 1.e-3
        ;
        store_data, tname, data={x:t, y:d}
        options, tname, 'ytitle', 'distance(' + c1 + '-' + c2 + ')'
        options, tname, 'ysubtitle', '[km]'
    ENDFOR
ENDFOR
;
;
join_vec, tname_arr, 'AUX_distance'
options, 'AUX_distance', 'colors', [0, 50, 80, 120, 190, 220]
options, 'AUX_distance', 'labels', ['12', '13', '14', '23', '24', '34']

END
