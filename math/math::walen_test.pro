;===========================================================+
; ++ NAME ++
PRO math::walen_test, vx, vy, vz, va_x, va_y, va_z, $
                      ex, ey, ez, bx, by, bz, plot=plot, $
                      correlation
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
COMPILE_OPT IDL2, STATIC
;
idlplotlib->psym, size=1.2
;
v_ht = math->dht_frame(ex, ey, ez, bx, by, bz, quality)

;
v = SQRT(TOTAL(vx^2 + vy^2 + vz^2))
xrange = [-MAX(v, /NAN), MAX(v, /NAN)]
yrange = xrange
;
; fitting
va = [va_x, va_y, va_z]
v  = [vx-v_ht[0], vy-v_ht[1], vz-v_ht[2]]
;
lfit = LINFIT(va, v)
y    = lfit[0] + lfit[1]*xrange
;     

IF KEYWORD_SET(plot) THEN BEGIN
    ; frame
    PLOT, va_x, vx - v_ht[0], psym=8, /NODATA, $
                xstyle=1, ystyle=1, xrange=xrange, yrange=yrange
    ; X component
    OPLOT, va_x, vx - v_ht[0], psym=8, COLOR=230
    ;
    ; Y component
    OPLOT, va_y, vy - v_ht[1], psym=8, COLOR=50
    ;
    ; Z component
    OPLOT, va_z, vz - v_ht[2], psym=8, COLOR=150
    ;
    ; y = x
    OPLOT, xrange, yrange, linestyle=2
    ;
    
    OPLOT, xrange, y
ENDIF



;
; legend
slope = lfit[1]
c     = CORRELATE(va, v)
;
correlation=c
;
legend = 'slope = ' + STRING(slope, FORMAT='(F6.2)') + $
                 '!C' + 'R = ' + STRING(c, FORMAT='(F6.2)') + $
         '!C' + 'quality = ' + STRING(quality, FORMAT='(F6.3)')

IF KEYWORD_SET(plot) THEN $
    XYOUTS, 0.2, 0.6, legend, /NORMAL

END

