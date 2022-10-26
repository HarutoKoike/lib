FUNCTION fote_polynominal, r
coeff = ptr->get('fote_coeffs')
;
vx = coeff[0] + total(coeff[1:3]*r)
vy = coeff[4] + total(coeff[5:7]*r)
vz = coeff[8] + total(coeff[9:11]*r)
;
RETURN, [vx, vy, vz]
END

;===========================================================+
; ++ NAME ++
FUNCTION math::fote, x1, x2, x3, x4, b1, b2, b3, b4, xref=xref, save=save
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
COMPILE_OPT IDL2, STATIC
;
IF ~KEYWORD_SET(xref) THEN $
    xref = [0, 0, 0]
;
dx1 = [1, x1 - xref]
dx2 = [1, x2 - xref]
dx3 = [1, x3 - xref]
dx4 = [1, x4 - xref]
;
G = FLTARR(12, 12)
;
G[0:3, 0]   = TRANSPOSE(dx1)
G[4:7, 1]   = TRANSPOSE(dx1)
G[8:11, 2]  = TRANSPOSE(dx1)
;
G[0:3, 3]   = TRANSPOSE(dx2)
G[4:7, 4]   = TRANSPOSE(dx2)
G[8:11, 5]  = TRANSPOSE(dx2)
;
G[0:3, 6]   = TRANSPOSE(dx3)
G[4:7, 7]   = TRANSPOSE(dx3)
G[8:11, 8]  = TRANSPOSE(dx3)
;
G[0:3, 9]   = TRANSPOSE(dx4)
G[4:7, 10]  = TRANSPOSE(dx4)
G[8:11, 11] = TRANSPOSE(dx4)
;
;
b = [b1, b2, b3, b4]
m = INVERT(TRANSPOSE(G)) # b 

IF KEYWORD_SET(save) THEN ptr->store, 'fote_coeffs', [m, xref], /over

RETURN, [m, xref]
END



