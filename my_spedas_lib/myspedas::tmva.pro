FUNCTION mvab, bx, by, bz, bl, bm, bn
;
m_bb = FLTARR(3, 3)
;
bxx  = MEAN(bx*bx, /NAN)
bxy  = MEAN(bx*by, /NAN)
bxz  = MEAN(bx*bz, /NAN)
byx  = MEAN(by*bx, /NAN)
byy  = MEAN(by*by, /NAN)
byz  = MEAN(by*bz, /NAN)
bzx  = MEAN(bz*bx, /NAN)
bzy  = MEAN(bz*by, /NAN)
bzz  = MEAN(bz*bz, /NAN)
;
m_bb[0,0] = bxx - MEAN(bx, /NAN) * MEAN(bx, /NAN) 
m_bb[1,0] = byx - MEAN(by, /NAN) * MEAN(bx, /NAN) 
m_bb[2,0] = bzx - MEAN(bz, /NAN) * MEAN(bx, /NAN) 
m_bb[0,1] = bxy - MEAN(bx, /NAN) * MEAN(by, /NAN) 
m_bb[1,1] = byy - MEAN(by, /NAN) * MEAN(by, /NAN) 
m_bb[2,1] = bzy - MEAN(bz, /NAN) * MEAN(by, /NAN) 
m_bb[0,2] = bxz - MEAN(bx, /NAN) * MEAN(bz, /NAN) 
m_bb[1,2] = byz - MEAN(by, /NAN) * MEAN(bz, /NAN) 
m_bb[2,2] = bzz - MEAN(bz, /NAN) * MEAN(bz, /NAN) 
;
m_bb = TRANSPOSE(m_bb)
;
eval = HQR(ELMHES(m_bb), /DOUBLE)
;
k  = EIGENVEC(m_bb, eval, RESIDUAL=residual)
eval = REAL_PART(eval)

 
PRINT, '***************************************************'
PRINT, '*** Minimum Variance Analysis of Magnetic Field ***'
PRINT, '***************************************************'
FOR i = 0, 2 DO BEGIN
	PRINT, 'eigenvalue : ',  REAL_PART(eval[i])
	PRINT, 'residual : ', REAL_PART(residual[i])
ENDFOR
;
dum  = MIN(eval, maxi)
kmin = k[*, maxi] / SQRT(k[0, maxi]^2 + k[1, maxi]^2 + $
       k[2, maxi]^2)
kmin = REAL_PART(kmin)     
;
dum  = MAX(eval, mini)
kmax =  k[*, mini] / SQRT(k[0, mini]^2 + k[1, mini]^2 + $
        k[2, mini]^2)
kmax = REAL_PART(kmax) 
;
idx  = [0, 1, 2]
idx  = WHERE(idx NE maxi and idx NE mini)
idx  = idx[0]
kmid = k[*, idx] / SQRT(k[0, idx]^2 + k[1, idx]^2 + $
       k[2, idx]^2)
kmid = REAL_PART(kmid)

;
;*----------   ----------*
;
bl = kmax[0]*bx + kmax[1]*by + kmax[2]*bz
bm = kmid[0]*by + kmid[1]*by + kmid[2]*bz
bn = kmin[0]*bz + kmin[1]*by + kmin[2]*bz


RETURN, {kmin:kmin, kmax:kmax, kmid:kmid,  $
         eigen_min:MIN(eval), eigen_max:MAX(eval), $
       	 eigen_mid:eval[idx]}
END




;-------------------------------------------------+
; 
;-------------------------------------------------+
PRO tmvab_eigenvec, tname_mag, trange, kl, km, kn 
;
ts = time_string(trange)
PRINT, '% MVAB START:' + ts[0]
PRINT, '% MVAB END  :' + ts[1]
;
get_data, tname_mag, data=b
idx = nn(tname_mag, trange)
;
idx = INDGEN(idx[-1] - idx[0] + 1) + idx[0]
bx = b.Y[idx, 0]
by = b.Y[idx, 1]
bz = b.Y[idx, 2]
;
k = mvab(bx, by, bz) 
kl = k.kmax
km = k.kmid
kn = k.kmin
;
;*----------   ----------*
;
get_timespan, ts
disc = FLTARR(2) + ABS(k.eigen_min / k.eigen_max)
store_data, 'MVA_test', data={x:ts, y:disc}
store_data, 'MVA_L', data={x:ts, y:kl}
store_data, 'MVA_M', data={x:ts, y:km}
store_data, 'MVA_N', data={x:ts, y:kn}

END





;===========================================================+
; ++ NAME ++
PRO myspedas::tmva, tname, tname_mag, trange, newname=newname, coord=coord
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
tn  = tnames()
idx = WHERE(STRMATCH(tn, tname_mag), count)
;
IF count EQ 0 THEN $
    PRINT, '% tplot name for magnetic field data should be set to "tname_mag"'
;
tmvab_eigenvec, tname_mag, trange, kl, km, kn

;
;*----------   ----------*
;
IF ~KEYWORD_SET(newname) THEN newname = tname + '_LMN'
;
FOR i = 0, N_ELEMENTS(tname) - 1 DO $
  myspedas->trotate, kl, km, kn, tname[i], newname[i], coord=coord


END
