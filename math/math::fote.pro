FUNCTION fote_polynominal, r
ptr   = OBJ_NEW('PTR')
coeff = ptr->get('fote_coefficients')
;
vx = coeff[0] + total(coeff[1:3]*r)
vy = coeff[4] + total(coeff[5:7]*r)
vz = coeff[8] + total(coeff[9:11]*r)

RETURN, [vx, vy, vz]
END



;===========================================================+
; ++ NAME ++
FUNCTION math::fote, x1, x2, x3, x4, b1, b2, b3, b4, xref=xref, save=save, $
                     null=null
;
; ++ PURPOSE ++
;  --> calculate First order Taylor expansion (FOTE method)
;
; ++ POSITIONAL ARGUMENTS ++
;  --> x1 ~ x4 (float) : 3-element array of each spacecraft (x, y, z)
;  --> b1 ~ b4 (float) : 3-element array of observed value each spacecraft 
;
; ++ KEYWORDS ++
; -->  xref(float) : 3-element array of origin position for expansion
;                    default is (0, 0, 0)
; -->  save(boolean) : set this keyword to save coefficients 'fote_coeffs'
; -->  null : this keyword receives position of Null 
;
; ++ CALLING SEQUENCE ++
;  --> coeffs=math::fote(x1, x2, x3, x4, b1, b2, b3, b4, xref=(x1+x2+x3+x4)/4, 
;                        /save)
;      vector = fote_polynominal([2, 3, 4])
;
; ++ HISTORY ++
;    2022/10/01 H.Koike
;===========================================================+
;
COMPILE_OPT IDL2, STATIC
;
ptr   = OBJ_NEW('PTR')
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
G[0:3, 0]   = dx1
G[4:7, 1]   = dx1
G[8:11, 2]  = dx1
;
G[0:3, 3]   = dx2
G[4:7, 4]   = dx2
G[8:11, 5]  = dx2
;
G[0:3, 6]   = dx3
G[4:7, 7]   = dx3
G[8:11, 8]  = dx3
;
G[0:3, 9]   = dx4
G[4:7, 10]  = dx4
G[8:11, 11] = dx4
;
;
b = [b1, b2, b3, b4]
;
m = INVERT(TRANSPOSE(G)) # b




IF KEYWORD_SET(save) THEN $
    ptr->store, 'fote_coefficients', [m, xref], /overwrite
;
;
;*---------- calc null point  ----------*
;
IF ARG_PRESENT(null) THEN BEGIN
    mat = [ [m[1:3]], [m[5:7]], [m[9:11]] ] 
    v   = -m[ [0, 4, 8] ]
    ;
    null = INVERT(TRANSPOSE(mat)) # v + xref
ENDIF

;
OBJ_DESTROY, ptr
RETURN, [m, xref]

END
