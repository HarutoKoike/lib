function mag, t, r, v
d  = 500.e3 * 3.
bx = tanh(r[1]/d)

return, [0, 0, 1]
end


function dipole, t, r, v
;
m = [0, 0, 1] * (-8d22)
b = !const.mu0 / 4 / !pi * (3 * r * total(m*r)/norm(r)^5  - m / norm(r)^3)
return, b
end
  


function dvdt, t, r, v
b = mag(t, r, v)
return, crossp(v, b)  
end




 


p = particle()
;
;b0    = 50.e-9 ; 50 nT
;omega = !const.e * b0 / !const.mp 
;v0    = 400.e3 ; 400 km/s
;r0    = v0 / omega * 2 * !pi


;b0    = 10000.e-9 ; 50 nT
;omega = !const.e * b0 / !const.mp 
;v0    = 400.e3 ; 400 km/s
;r0    = v0 / omega * 2 * !pi
;r0    = 30000.e3
; 
;
;p.dt       = 1./omega * 0.1
;p.r        = [0, 10, 0]
;p.velocity = [v0*0.3, v0*0.1, v0*0.5]
;p.func     = 'dvdt'



p.dt = .1
p.r  = [0, 1, 0]
p.velocity = [1., 0.3, 0.2]
p.func = 'dvdt'

n = ceil(10 / p.dt)
for i = 0, n do p->rk4



t = indgen(n)
t = bytscl(t)

pl = p.plot(sym='', vert_colors=t, rgb_table=33)

pl.axis_style=2
pl.zminor=0
pl.xminor=0
pl.yminor=0
;pl.xrange=[0, 5]
;pl.yrange=[0, -100]
;pl.zrange=[0, 10]
;





end   
