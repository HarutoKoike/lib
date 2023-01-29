;===========================================================+
; ++ NAME ++
FUNCTION dht_frame, ex, ey, ez, bx, by, bz, quality 
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
D0 = SQRT( TOTAL(ex^2 + ey^2 + ez^2, /NAN) )    
;
ex_dht = v_ht[1] * bz - v_ht[2] * by 
ey_dht = v_ht[2] * bx - v_ht[0] * bz 
ez_dht = v_ht[0] * by - v_ht[1] * bx 
;
D1 = TOTAL( (ex - ex_dht)^2 + (ey - ey_dht)^2 + $
						(ez - ez_dht)^2 , /NAN)
D1 = SQRT(D1)
;
quality = D1 / D0 

RETURN, REFORM(v_ht)
END


;-------------------------------------------------+
; 
;-------------------------------------------------+
FUNCTION myspedas::dht_velocity, ename, bname, trange, $
                                 quality  
COMPILE_OPT IDL2, STATIC
;
get_data, ename, data=e
get_data, bname, data=b
;
idx_e = nn(ename, trange)
idx_b = nn(bname, trange)
;
te = e.X[idx_e[0]:idx_e[1]] 
tb = b.X[idx_b[0]:idx_b[1]] 
e  = e.Y[idx_e[0]:idx_e[1], *] * 1.e-3  ; mV/m -> V/m
b  = b.Y[idx_b[0]:idx_b[1], *] * 1.e-9 ; nT -> T
;
e = interp(e, te, tb)
;
ex = e[*, 0]
ey = e[*, 1]
ez = e[*, 2]
bx = b[*, 0]
by = b[*, 1]
bz = b[*, 2]
;
v0 = dht_frame(ex, ey, ez, bx, by, bz, quality) * 1.e-3  

RETURN, v0  
END


