




flag='restore'
@lr_load.pro


x = fltarr(10)
y = fltarr(10)
;
idx = [0, 1, 2, 3, 4, 5, 7, 8, 9]


fp = '~/idl/cluster/analysis/image'
xs = 20
ys = 15
mypsym, size=2.5

!p.thick=2.
!x.thick=1.5
!x.charsize=1.5
!y.thick=1.5
!y.charsize=1.5
;
;*---------- shear flow  ----------*
;
;mypsplot, /open_ps, fn='shear_flow.eps', fp=fp, xs=xs, ys=ys
;
x = total(events[idx].v_sheath[[0, 1]]^2, 1)^0.5
end
;x = total(events[idx].v_sheath[[0, 1]]^2, 1)^0.5 / events[idx].v_asym
;
l0 = sort(events[idx].t_event[0])
;
y = events[idx].v_out[0] / events[idx].v_asym
lfit  = linfit(x, y)
x_lin = [0, 1000]
y_lin = lfit[0] + lfit[1] * x_lin
;
print, correlate(x, y)
plot, x, y,   psym=8, /nodata 
oplot, x, y, psym=8, color=50
oplot, x_lin, y_lin
;
;mypsplot, /close_ps

;
;*---------- ion density ratio  ----------*
;
mypsplot, /open_ps, fn='ion_density_ratio.eps', fp=fp, xs=xs, ys=ys
;
x = events[idx].ni_sheath / events[idx].ni_sphere
plot, x, y,  /xlog, psym=8, /nodata
oplot, x, y, psym=8, color=50
;
mypsplot, /close_ps



;
;*---------- |B| ratio  ----------*
;
mypsplot, /open_ps, fn='mag_ratio.eps', fp=fp, xs=xs, ys=ys
;
x = total(events[idx].b_sheath^2, 1) / total(events[idx].b_sphere^2, 1)
x = sqrt(x)
plot, x, y,  psym=8, /nodata
oplot, x, y, psym=8, color=50
;
mypsplot, /close_ps


;
;*---------- shear angle  ----------*
;
mypsplot, /open_ps, fn='mag_shear.eps', fp=fp, xs=xs, ys=ys
;
prod = total(events[idx].b_sheath * events[idx].b_sphere, 1)
prod = prod / total(events[idx].b_sheath^2, 1)^0.5 / $
              total(events[idx].b_sphere^2, 1)^0.5 
;
theta = acos(prod)/!dtor
;
plot, theta, y,  psym=8, /nodata
oplot, theta, y, psym=8, color=50
;
mypsplot, /close_ps




;
;*---------- asymmetric parameter  ----------*
;
mypsplot, /open_ps, fn='assymmetric_param.eps', fp=fp, xs=xs, ys=ys
;
;
x = total(events[idx].b_sheath^2, 1) * events[idx].ni_sphere
x = x / total(events[idx].b_sphere^2, 1) / events[idx].ni_sheath
;
plot, x, y,  psym=8, /nodata, /xlog
oplot, x, y, psym=8, color=50
;
mypsplot, /close_ps
 

;
;*---------- v_asym (Doss et al., 2015)  ----------*
;


 
end



