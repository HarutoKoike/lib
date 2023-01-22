;===========================================================+
; ++ NAME ++
FUNCTION particle::plot, sym=sym, _EXTRA=ex
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
xarr = *(self.xarr)
x    = REFORM(xarr[0, *])
y    = REFORM(xarr[1, *])
z    = REFORM(xarr[2, *])
;
IF ~ISA(sym) THEN sym=''
pl = PLOT3D(x, y, z, sym, _EXTRA=ex)

pl.XY_SHADOW=1
pl.XZ_SHADOW=1
pl.YZ_SHADOW=1
pl.SHADOW_COLOR='gray'
pl.XTITLE='X'
pl.YTITLE='Y'
pl.ZTITLE='Z'

RETURN, pl
END
