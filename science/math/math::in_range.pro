;===========================================================+
; ++ NAME ++
FUNCTION math::in_range, x, range
;
; ++ PURPOSE ++
;  --> determin whether coordinate 'x' is in range
;
; ++ POSITIONAL ARGUMENTS ++
;  -->  x : scalar or 1 dimension array of coordinate
;  -->  range : 2 elmeent array or range (if x is scalar)
;               (2, n_elements(x)) size array (if x is array)
;
; ++ KEYWORDS ++
; -->
;
; ++ CALLING SEQUENCE ++
;  --> in = math->in_range( [0, 2, 4], range=[ [-1, 4], [3, 5], [3, 10] ])
;         -> in : 1 
;
; ++ HISTORY ++
;    H.Koike 
;===========================================================+
;
COMPILE_OPT IDL2
;
nx = N_ELEMENTS(x)
;
IF nx EQ 1 THEN $ 
    RETURN, x GE range[0] AND x LE range[-1]


IF nx GT 1 THEN BEGIN
    ;
    IF SIZE(range, /N_DIM) NE 2 THEN $
        MESSAGE, 'range must be 2-dimension'
    ;
    s    = SIZE(range, /DIMENSION)
    disc = s[0] EQ 2 AND s[1] EQ nx
    IF ~disc THEN $
        MESSAGE, 'if x is not scalar, range must be n_elements(x) * 2 element array' 
    ;
    in = 1
    FOR i = 0, s[1] - 1 DO BEGIN
        in = in AND (x[i] GE range[0, i]) AND (x[i] LE range[1, i])
    ENDFOR
    RETURN, in
ENDIF

END                                   
