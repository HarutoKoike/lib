device, retain=2

t_filament=strarr(3)
t_filament[0] = '2004-03-10/12:29:31'
t_filament[1] = '2004-03-10/12:32:36'
t_filament[2] = '2004-03-10/12:30:10'
;t_filament[3] = '2004-03-10/12:26:25'  ; void 
;t_filament[4] = '2004-03-10/12:38:00'  ; void 
void = '2004-03-10/12:30:37'




tname =  'EE_yy_sr2__C3_CP_STA_PSD'
tname =  'BB_xx_st2__C3_CP_STA_PSD'
get_data, tname, data=b
get_data, 'Electron_cyclotoron_frequency__C3', data=fce
get_data, 'Ion_cyclotoron_frequency__C3', data=fci

f = b.v
flh = sqrt(fce.y*fci.y)
;
;*----------   ----------*
;
mypsym, size=1.5
window, 2, xs=500, ys=400
xtitle = 'frequency[Hz]'
ytitle = 'PSD[nT!U2!N/Hz]'
title  = 'Bx power'
;ytitle = 'PSD[nT!U2!N/Hz]'
;

yrange=[1.e-10, 1.e-2]
plot, f, yrange, /nodata, /xlog, /ylog, $
      xrange=[5, 4000], xsty=1, xtitle=xtitle, $
      ytitle=ytitle, yrange=yrange, thick=2.5, $
      xchars=1.2, ychars=1.2, title=title, $
      chars=1.2, charthick=1.5


colors = [50, 150, 220, 0, 0]
xfit=[]
yfit=[]

ypos = [2.5e-4, 1.e-4, 0.4e-4]
for i = 0, n_elements(t_filament) - 1 do begin
  idx = nn(tname, t_filament[i])
  ;
  oplot, f, b.y[idx, *], color=colors[i], thick=1.5
  oplot, f, b.y[idx, *], psym=8, color=colors[i], thick=1.5
  ;
  idx_fce = nn('Electron_cyclotoron_frequency__C3', t_filament[i]) 
  oplot, [fce.y[idx_fce], fce.y[idx_fce]], yrange, $
         color=colors[i], thick=2.5, linesty=1
  ;
  oplot, [flh[idx_fce], flh[idx_fce]], yrange, $
         color=colors[i], thick=2.5, linesty=1
  xfit = [xfit, f]
  yfit = [yfit, reform(b.y[idx, *])]
  ;;
  xyouts, 50, ypos[i], t_filament[i], /data, $
          color=colors[i], charsize=1.5
endfor

idx = nn(tname, void)
oplot, f, b.y[idx, *]
oplot, f, b.y[idx, *], psym=8

; -5/3
idx = where(xfit lt 1200.)
xfit=alog10(xfit[idx])
yfit=alog10(yfit[idx])
lfit=linfit(xfit, yfit)
;
x = [1, 2000]
y = 10.^(lfit[1]*alog10(x) + lfit[0])
print, lfit

oplot, x, y, linestyle=2
xyouts, 50, 0.15e-4, void, /data, $
        charsize=1.5

tvlct,rtv,gtv,btv,/get
write_png,'~/bx_psd.png',tvrd(/true),rtv,gtv,btv

end
