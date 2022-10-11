
!p.font=4
!p.thick=1.5
!x.charsize=1.2
!y.charsize=1.2
!x.thick=1.5
!y.thick=1.5

;mypsplot, fn='~/idl/cluster/analysis/image/lr_loc.eps', /open_ps, xsize=20, ysize=20

lr_data, dlr

n = 50
theta = findgen(n) / float(n-1) * 2 * !pi
r     = fltarr(n)
xrange = [0, 13]
yrange = [-13, 13]
ntick = 4
tickv = replicate('', ntick+1)

xtitle = 'X!DGSM!N(R!DE!N)'
ytitle = 'Z!DGSM!N(R!DE!N)'
plot, r+11., theta, /polar, /isotropic, xrange=-xrange, yrange=yrange, $
                        xstyle=1, ystyle=1, /nodata, xtitle=xtitle, ytitle=ytitle
                        ;xticks=ntick, yticks=ntick, xtickv=tickv,   $
                        ;ytickv=tickv

oplot, r+1., theta, /polar
;oplot, r+2., theta, /polar , linestyle=1, thick=2.
;oplot, r+4., theta, /polar , linestyle=1, thick=2.
oplot, r+6., theta, /polar , linestyle=1, thick=2.
oplot, r+8.,theta, /polar  , linestyle=1, thick=2.
oplot, r+10., theta, /polar, linestyle=1, thick=2.
oplot, r+12., theta, /polar, linestyle=1, thick=2.


oplot, [0, 0], [-1, 1]
;oplot, [0, 0], [-11, 11]

;polar_fill, [0, 1], [90, 270]


idx = where(dlr.x_gsm ne 0)
mypsym, size=1.5
oplot, dlr.x_gsm[idx], dlr.z_gsm[idx], color=50, psym=8

;mypsplot, /close_ps
end

