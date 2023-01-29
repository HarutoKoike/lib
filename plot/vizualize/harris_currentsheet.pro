
; setting
vel_ratio = 1. / 20.              ; ratio of Alfven velociy to the speed of light
v_a = !const.c * vel_ratio
;
b0 = 10                           ; magnetic field (nT)
n0 = b0^2 / !const.mu0 / v_a^2
;
;di = !const.c / sqrt(n0 * !const.e^2 / !const.mp / !const.eps0)  ; ion inertial length
;L  = 0.5 * di


z   = (findgen(101) - 50.) / 100. * 10
b_x = b0 * tanh(z)  

nb  = n0 * 0.2
n   = n0 * cosh(z)^(-2) + nb

!p.multi=[0, 1, 2]
plot, b_x, z, ytitle='Z', xtitle='Bx', title='Magnetic Field'
oplot,[-b0, b0], [0, 0], linesty=1 
oplot,[0, 0], [z[0], z[-1]]*10, linesty=1 

!p.multi=[1, 1, 2]
plot, n, z, ytitle='Z', xtitle='n', title='Density'
oplot, [0, max(n)*10], [0, 0], linesty=1 






end
