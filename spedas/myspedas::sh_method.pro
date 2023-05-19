;===========================================================+
; ++ NAME ++
FUNCTION sh_method, ex, ey, ez, bx, by, bz, k
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

;
;*---------- deviations  ----------*
;
dex = ex - MEAN(ex, /NAN)   
dey = ey - MEAN(ey, /NAN)   
dez = ez - MEAN(ez, /NAN)   
dbx = bx - MEAN(bx, /NAN)   
dby = by - MEAN(by, /NAN)   
dbz = bz - MEAN(bz, /NAN)   
;
;
;*---------- covariances  ----------*
;
n = 3
m_eb = FLTARR(n, n)
m_be = FLTARR(n, n)
m_ee = FLTARR(n, n)
m_bb = FLTARR(n, n)
;
; M_EB
m_eb[0, 0] = MEAN( dex*dbx, /NAN)
m_eb[1, 0] = MEAN( dey*dbx, /NAN)
m_eb[2, 0] = MEAN( dez*dbx, /NAN)
m_eb[0, 1] = MEAN( dex*dby, /NAN)
m_eb[1, 1] = MEAN( dey*dby, /NAN)
m_eb[2, 1] = MEAN( dez*dby, /NAN)
m_eb[0, 2] = MEAN( dex*dbz, /NAN)
m_eb[1, 2] = MEAN( dey*dbz, /NAN)
m_eb[2, 2] = MEAN( dez*dbz, /NAN)
; M_BE
m_be[0, 0] = MEAN( dbx*dex, /NAN)
m_be[1, 0] = MEAN( dby*dex, /NAN)
m_be[2, 0] = MEAN( dbz*dex, /NAN)
m_be[0, 1] = MEAN( dbx*dey, /NAN)
m_be[1, 1] = MEAN( dby*dey, /NAN)
m_be[2, 1] = MEAN( dbz*dey, /NAN)
m_be[0, 2] = MEAN( dbx*dez, /NAN)
m_be[1, 2] = MEAN( dby*dez, /NAN)
m_be[2, 2] = MEAN( dbz*dez, /NAN) 
; M_BB
m_bb[0, 0] = MEAN( dbx*dbx, /NAN)
m_bb[1, 0] = MEAN( dby*dbx, /NAN)
m_bb[2, 0] = MEAN( dbz*dbx, /NAN)
m_bb[0, 1] = MEAN( dbx*dby, /NAN)
m_bb[1, 1] = MEAN( dby*dby, /NAN)
m_bb[2, 1] = MEAN( dbz*dby, /NAN)
m_bb[0, 2] = MEAN( dbx*dbz, /NAN)
m_bb[1, 2] = MEAN( dby*dbz, /NAN)
m_bb[2, 2] = MEAN( dbz*dbz, /NAN) 
; M_EE
m_ee[0, 0] = MEAN( dex*dex, /NAN)
m_ee[1, 0] = MEAN( dey*dex, /NAN)
m_ee[2, 0] = MEAN( dez*dex, /NAN)
m_ee[0, 1] = MEAN( dex*dey, /NAN)
m_ee[1, 1] = MEAN( dey*dey, /NAN)
m_ee[2, 1] = MEAN( dez*dey, /NAN)
m_ee[0, 2] = MEAN( dex*dez, /NAN)
m_ee[1, 2] = MEAN( dey*dez, /NAN)
m_ee[2, 2] = MEAN( dez*dez, /NAN) 
;
m_eb = TRANSPOSE(m_eb)
m_be = TRANSPOSE(m_be)
m_bb = TRANSPOSE(m_bb)
m_ee = TRANSPOSE(m_ee)
;
;*---------- eigenvectors ----------*
;
m0 = m_eb ## INVERT(m_bb) ## m_be + m_ee
m0 = -m0
;
eval = HQR(ELMHES(m0), /DOUBLE)
k    = EIGENVEC(m0, eval, RESIDUAL=residual)
eval = REAL_PART(eval)
;
PRINT, '************************************'
PRINT, '*** Sonnerup and Hasegawa Method ***'
PRINT, '************************************'
FOR i = 0, 2 DO BEGIN
	PRINT, '*****'
	PRINT, 'eigenvalue : ',  eval[i]
	PRINT, 'residual : ', REAL_PART(residual[i])
ENDFOR
;
eval = MIN(eval, mi)
k    = k[*, mi]; / SQRT(k[0, mi]^2 + k[1, mi]^2 + k[2, mi]^2)
k    = REAL_PART(k)
k    = k / NORM(k)
print, k

u0 = (-INVERT(m_bb) ## m_be) ## k
PRINT, '*** U0*k / |U0| ***'
PRINT, TOTAL(u0 * k) / NORM(u0) 

;
;*----------frame velocity ----------*
;
v0    = -CROSSP(k, u0)
e_ave = [MEAN(ex, /NAN), MEAN(ey, /NAN), MEAN(ez, /NAN)]
b_ave = [MEAN(bx, /NAN), MEAN(by, /NAN), MEAN(bz, /NAN)]

e0 = TOTAL(e_ave * k) + TOTAL(b_ave * CROSSP(k, v0))
PRINT, '*** intrinsic axial electric field (mV/m) ***'
PRINT, e0 * 1.e3 

RETURN, v0 * 1.e-3 ; km/s

END





;-------------------------------------------------+
; 
;-------------------------------------------------+
FUNCTION myspedas::sh_method, ename, bname, trange, k
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
v0 = sh_method(ex, ey, ez, bx, by, bz, k)  

RETURN, v0
END

