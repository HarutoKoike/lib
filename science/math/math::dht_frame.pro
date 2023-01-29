;===========================================================+
; ++ NAME ++
FUNCTION math::dht_frame, ex, ey, ez, bx, by, bz, quality
;
; ++ PURPOSE ++
;  --> calculate deHoffmann-Teller frame
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

m0      = FLTARR(3, 3)
m0[0,0] = MEAN(by^2 + bz^2, /NAN)
m0[0,1] = MEAN(-bx*by, /NAN)
m0[0,2] = MEAN(-bx*bz, /NAN)
m0[1,0] = MEAN(-bx*by, /NAN)
m0[1,1] = MEAN(bx^2 + bz^2, /NAN)
m0[1,2] = MEAN(-by*bz, /NAN)
m0[2,0] = MEAN(-bx*bz, /NAN)
m0[2,1] = MEAN(-by*bz, /NAN)
m0[2,2] = MEAN(bx^2 + by^2, /NAN)
;
m1 = [                           $
            MEAN(ey*bz - ez*by, /NAN), $
            MEAN(ez*bx - ex*bz, /NAN), $
            MEAN(ex*by - ey*bx, /NAN)  $
         ]
;
v_ht = INVERT(TRANSPOSE(m0)) ## m1

;
;*---------- quality check  ----------*
;
D0 = SQRT( TOTAL(ex^2 + ey^2 + ez^2) )
;
ex_dht = v_ht[1] * bz - v_ht[2] * by
ey_dht = v_ht[2] * bx - v_ht[0] * bz
ez_dht = v_ht[0] * by - v_ht[1] * bx
;
D1 = TOTAL( (ex - ex_dht)^2 + (ey - ey_dht)^2 + $
                        (ez - ez_dht)^2 )
D1 = SQRT(D1)
;
quality = D1 / D0

RETURN, REFORM(v_ht)
END
