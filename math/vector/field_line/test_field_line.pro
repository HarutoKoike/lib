   
idlplotlib->psym, size=4

n   = 1000
;
; plot frame
plot, indgen(n+1) - n/2., indgen(n+1) - n/2., /nodata
;
charges = [1, -1, -1, 1]
; charge position
charges = [1, -1]
pos_charge_x = [n/4., -n/4]
pos_charge_y = [0, 0]
;pos_charge_x = [n/4., n/4., -n/4., -n/4.]
;pos_charge_y = [n/4., -n/4., n/4., -n/4.]
;pos_charge_x = randomu(1213, n_elements(pos_charge_x)) * n
;pos_charge_y = randomu(124141, n_elements(pos_charge_x)) * n

;
x  = findgen(n) - n/2.
x  = rebin(x, n, n)
y  = findgen(n) - n/2.
y  = rebin(transpose(y), n, n)
vx = fltarr(n, n)
vy = fltarr(n, n)
;

;
;*---------- cal field  ----------*
;
for i = 0, n_elements(charges) - 1 do begin
    q   = charges[i]
    ax  = pos_charge_x[i]
    ay  = pos_charge_y[i]
    vx += -q * (x - ax) / sqrt( (x-ax)^2 + (y-ay)^2 )^3
    vy += -q * (y - ay) / sqrt( (x-ax)^2 + (y-ay)^2 )^3
endfor

;arrow, x, y, x+vx*0.5, y+vy*0.5, /data, color=50, hsize= !D.X_SIZE / 200



;
;
;*---------- create object  ----------*
;
vf = obj_new('vector_field')
vf->setprop, x=x, y=y, vx=vx, vy=vy 


ninit = 20
initx = randomu(1231421, ninit) * n  - n / 2. 
inity = randomu(4314514, ninit) * n  - n / 2. 

;mag0    = sqrt(vx^2 + vy^2)
;contour, alog10(mag0), x, y, /noerase, nlevels=20, c_color=findgen(20) / 20. * 255, /fill

fl      = obj_new('field_line')
;
for i = 0, ninit - 1 do begin
    fl->setprop, x0=initx[i], y0=inity[i]
    fl->calc, vf
    fl->getprop, px=px, py=py, mag=mag 
    ;
    for j = 0, n_elements(px) - 2 do begin
        plots, [px[j], px[j+1]], [py[j], py[j+1]], /data
    endfor
endfor


; plot charge
for i = 0, n_elements(pos_charge_x) - 1 do begin
    x = fltarr(2) + pos_charge_x[i] 
    y = fltarr(2) + pos_charge_y[i] 
    if charges[i] lt 0 then color = 50
    if charges[i] gt 0 then color = 230
    oplot, x, y, psym=8, color=color
endfor



end
