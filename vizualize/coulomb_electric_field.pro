function e_field, x, y
c  = [1, -1]
xc = [-20, 20]
yc = [0, 0]
;
ex = 0
ey = 0
for i = 0, n_elements(c) - 1 do begin
    dino = sqrt( (x-xc[i])^2 + (y-yc[i])^2 )^3 
    ;
    ex += -(x - xc[i]) / dino * c[i]
    ey += -(y - yc[i]) / dino * c[i]
endfor

return, 1.e4*[ex, ey]
end 


function en_x, x, y
return, (e_field(x, y) / norm(e_field(x, y)))[0]
end

function en_y, x, y
return, (e_field(x, y) / norm(e_field(x, y)))[1]
end

nx = 101
ny = 101
x  = indgen(nx) - 50
y  = indgen(ny) - 50

ex  = fltarr(nx, ny)
ey  = fltarr(nx, ny)
;
for i = 0, nx - 1 do begin
    for j = 0, ny - 1 do begin
        e = e_field(x[i], y[j])
        ;
        ex[i, j] = e[0]
        ey[i, j] = e[1]
    endfor
endfor

velovect, ex, ey, x, y


;
;*----------   ----------*
;
h = 0.1
;
sx = -45
sy = -20
idlplotlib->psym, size=3
oplot, [sx, sx], [sy, sy], psym=8, color=200
;
lx = [sx]
ly = [sy]
;
xp = sx
yp = sy
count = 0
while 1 do begin 
    count ++
    if count ge 10000 then break
    ;
    kx1 = h * en_x(xp, yp)
    ky1 = h * en_y(xp, yp)
    kx2 = h * en_x(xp+0.5*kx1, yp+0.5*ky1)
    ky2 = h * en_y(xp+0.5*kx1, yp+0.5*ky1)
    kx3 = h * en_x(xp+0.5*kx2, yp+0.5*ky2)
    ky3 = h * en_y(xp+0.5*kx2, yp+0.5*ky2)
    kx4 = h * en_x(xp+kx3, yp+ky3)
    ky4 = h * en_y(xp+kx3, yp+ky3)
    ;
    dx = (kx1 + 2*kx2 + 2*kx3 + kx4) / 6.
    dy = (ky1 + 2*ky2 + 2*ky3 + ky4) / 6.
    ;
    plots, [xp, xp+dx], [yp, yp+dy], /data , color=50, thick=2
    ;
    xp += dx
    yp += dy
endwhile


;
; backward
xp = sx
yp = sy
count = 0
h = -h
while 1 do begin 
    count ++
    if count ge 1000 then break
    ;
    kx1 = h * en_x(xp, yp)
    ky1 = h * en_y(xp, yp)
    kx2 = h * en_x(xp+0.5*kx1, yp+0.5*ky1)
    ky2 = h * en_y(xp+0.5*kx1, yp+0.5*ky1)
    kx3 = h * en_x(xp+0.5*kx2, yp+0.5*ky2)
    ky3 = h * en_y(xp+0.5*kx2, yp+0.5*ky2)
    kx4 = h * en_x(xp+kx3, yp+ky3)
    ky4 = h * en_y(xp+kx3, yp+ky3)
    ;
    dx = (kx1 + 2*kx2 + 2*kx3 + kx4) / 6.
    dy = (ky1 + 2*ky2 + 2*ky3 + ky4) / 6.
    ;
    plots, [xp, xp+dx], [yp, yp+dy], /data, color=50, thick=2 
    ;
    xp += dx
    yp += dy
endwhile
 



end





