;function vec_field, x, y
;c  = [1, -1, 1, -1]
;xc = [80, 30, 20, 50]
;yc = [50, 50, 10, 30]
;;
;ex = 0
;ey = 0
;for i = 0, n_elements(c) - 1 do begin
;    dino = sqrt( (x-xc[i])^2 + (y-yc[i])^2 )^3
;    ;
;    ex += -(x - xc[i]) / dino * c[i]
;    ey += -(y - yc[i]) / dino * c[i]
;endfor
;
;return, 1.e4*[ex, ey]
;end
;
;
;function nvec_field_x, x, y
;return, (vec_field(x, y) / norm(vec_field(x, y)))[0]
;end
;
;function nvec_field_y, x, y
;return, (vec_field(x, y) / norm(vec_field(x, y)))[1]
;end



FUNCTION vec_field, x, y, z
coeff = ptr->get('fote_coeffs')
;
xref = coeff[12:14]

dx   = [x, y, z] - xref
;
vx = total(coeff[1:3]*dx)  + coeff[0] 
vy = total(coeff[5:7]*dx)  + coeff[4] 
vz = total(coeff[9:11]*dx) + coeff[8] 

RETURN, [vx, vy, vz]
END


FUNCTION nvec_field, x, y, z
vec = vec_field(x, y, z)
RETURN, vec / NORM(vec)
END

;

;===========================================================+
; ++ NAME ++
PRO idlplotlib::field_line2d, xrange=xrange, yrange=yrange, zrange=zrange, seed=seed, _EXTRA=ex, $
                              xy=xy, yz=yz, zx=zx, yx=yx, zy=zy, xz=xz, cut=cut, max_loop=max_loop, $
                              del=del
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
;  H.Koike 
;===========================================================+
COMPILE_OPT IDL2, STATIC
;
;
;*---------- setting  ----------*
;
idlplotlib->psym, size=1
;
nx = 101
ny = 101
nz = 101
;
coeffs = ptr->get('fote_coeffs')
x0 = coeffs[12]
y0 = coeffs[13]
z0 = coeffs[14]
;
; integration
IF ~KEYWORD_SET(max_loop) THEN max_loop = 10000L
;
IF ~KEYWORD_SET(xrange) THEN $
    xrange = [x0 - x0/10., x0 + x0/10.]
IF ~KEYWORD_SET(yrange) THEN $
    yrange = [y0 - y0/10., y0 + y0/10.]
IF ~KEYWORD_SET(zrange) THEN $
    zrange = [z0 - z0/10., z0 + z0/10.]
;
xgrid  = (FINDGEN(nx) - (nx-1)/2.)/(nx-1)*2.*(xrange[1] - xrange[0]) + xrange[0]
ygrid  = (FINDGEN(ny) - (ny-1)/2.)/(ny-1)*2.*(yrange[1] - yrange[0]) + yrange[0]
zgrid  = (FINDGEN(nz) - (nz-1)/2.)/(nz-1)*2.*(zrange[1] - zrange[0]) + zrange[0]
;
IF ~KEYWORD_SET(del) THEN $
    del = SQRT( (xrange[1] - xrange[0])^2 + (yrange[1] - yrange[0])^2 +$
                (zrange[1] - zrange[0])^2 ) / FLOAT(max_loop)



;
;*---------- determine cut direction  ----------*
;
IF KEYWORD_SET(xy) THEN BEGIN
    n1=nx & n2=ny
    grid1 = xgrid
    grid2 = ygrid
    ;
    range1 = xrange 
    range2 = yrange 
    ;
    idx = [0, 1]
ENDIF
IF KEYWORD_SET(yz) THEN BEGIN
    n1=ny & n2=nz
    grid1 = ygrid
    grid2 = zgrid
    ;
    range1 = yrange 
    range2 = zrange 
    ;
    idx = [1, 2]
ENDIF
IF KEYWORD_SET(zx) THEN BEGIN
    n1=nz & n2=nx
    grid1 = zgrid
    grid2 = xgrid
    ;
    range1 = zrange 
    range2 = xrange 
    ;
    idx = [2, 0]
ENDIF
IF KEYWORD_SET(yx) THEN BEGIN
    n1=ny & n2=nx
    grid1 = ygrid
    grid2 = xgrid
    ;
    range1 = yrange 
    range2 = xrange 
    ;
    idx = [1, 0]
ENDIF
IF KEYWORD_SET(zy) THEN BEGIN 
    n1=nz & n2=ny
    grid1 = zgrid
    grid2 = ygrid
    ;
    range1 = zrange 
    range2 = yrange 
    ;
    idx = [2, 1]
ENDIF
IF KEYWORD_SET(xz) THEN BEGIN 
    n1=nx & n2=nz
    grid1 = xgrid
    grid2 = zgrid
    ;
    range1 = xrange 
    range2 = zrange 
    ;
    idx = [0, 2]
ENDIF
;


;
;*---------- cal vector  ----------*
;
n1 = N_ELEMENTS(grid1)
n2 = N_ELEMENTS(grid2)
;
v1 = FLTARR(n1, n2)
v2 = FLTARR(n1, n2)

FOR i = 0, n1 - 1 DO BEGIN
    FOR j = 0, n2 - 1 DO BEGIN
        pos1 = grid1[i]
        pos2 = grid2[j]
        ;
        IF KEYWORD_SET(xy) THEN $
            x = pos1 & y = pos2 & z = cut
        IF KEYWORD_SET(yz) THEN $
            y = pos1 & z = pos2 & x = cut
        IF KEYWORD_SET(zx) THEN $
            z = pos1 & x = pos2 & y = cut
        IF KEYWORD_SET(yx) THEN $
            y = pos1 & x = pos2 & z = cut
        IF KEYWORD_SET(zy) THEN $
            z = pos1 & x = pos2 & x = cut
        IF KEYWORD_SET(xz) THEN $
            x = pos1 & z = pos2 & y = cut
        ;
        vec = vec_field(x, y, z)
        ;
        v1[i, j] = vec[idx[0]]
        v2[i, j] = vec[idx[1]]
    ENDFOR
ENDFOR


vmag     = SQRT(v1^2 + v2^2)
vmag_max = MAX(vmag, /NAN)
;



zrange = [min(alog10(vmag)), max(alog10(vmag))]  
zrange = [min(vmag), max(vmag)]  
CONTOUR, alog10(vmag), grid1, grid2, /fill, xrange=range1, $
         yrange=range2, xsty=1, ysty=1, _EXTRA=ex
;plot, range1, range2, xsty=1, ysty=1, /nodata, _EXTRA=ex
;velovect, v1, v2, grid1, grid2, xsty=4, ysty=4, /noerase

;mycolorbar, zrange[0], zrange[1], /log





;
;*---------- Runge-Kutta tracing  ----------*
;
h = del
;
IF ~KEYWORD_SET(seed) THEN BEGIN
    ns1  = 5L
    ns2  = 5L
    ns   = ns1 * ns2 
    ;
    seed = FINDGEN(2, ns)
    s1   = ( FINDGEN(ns1) / (FLOAT(ns1) - 1.) - 0.5 ) * (range1[1] - range1[0]) + MEAN(range1)
    s2   = ( FINDGEN(ns2) / (FLOAT(ns2) - 1.) - 0.5 ) * (range2[1] - range2[0]) + MEAN(range2)
    ;
    FOR i = 0, ns2 - 1 DO BEGIN
        seed[0, i*ns1:(i+1)*ns1-1] = s1
    ENDFOR
    FOR i = 0, ns2 - 1 DO BEGIN
        seed[1, i*ns1:(i+1)*ns1-1] = s2[i]
    ENDFOR
ENDIF
;
ndim_seed = SIZE(seed, /N_DIMENSION)
seed_size = SIZE(seed, /DIMENSION)
nseed     = seed_size[1]



FOR i = 0, nseed - 1 DO BEGIN
    ;
    ; start point
    p0 = seed[0, i]
    p1 = seed[1, i]
    ;OPLOT, [p0, p0], [p1, p1], psym=8, color=220
    ;
    ;
    ;*---------- forward  ----------*
    ;
    count = 0
    WHILE count LE max_loop DO BEGIN
        count ++
        ;
        ;
        IF KEYWORD_SET(xy) THEN BEGIN
            k1 = h * (nvec_field(p0, p1, cut))[0]
            m1 = h * (nvec_field(p0, p1, cut))[1]
            k2 = h * (nvec_field(p0+0.5*k1, p1+0.5*m1, cut))[0]
            m2 = h * (nvec_field(p0+0.5*k1, p1+0.5*m1, cut))[1]
            k3 = h * (nvec_field(p0+0.5*k2, p1+0.5*m2, cut))[0]
            m3 = h * (nvec_field(p0+0.5*k2, p1+0.5*m2, cut))[1]
            k4 = h * (nvec_field(xp+k3, yp+m3, cut))[0]
            m4 = h * (nvec_field(xp+k3, yp+m3, cut))[1] 
        ENDIF
        IF KEYWORD_SET(xz) THEN BEGIN
            k1 = h * (nvec_field(p0, cut, p1))[0]
            m1 = h * (nvec_field(p0, cut, p1))[1]
            k2 = h * (nvec_field(p0+0.5*k1, cut, p1+0.5*m1))[0]
            m2 = h * (nvec_field(p0+0.5*k1, cut, p1+0.5*m1))[1]
            k3 = h * (nvec_field(p0+0.5*k2, cut, p1+0.5*m2))[0]
            m3 = h * (nvec_field(p0+0.5*k2, cut, p1+0.5*m2))[1]
            k4 = h * (nvec_field(p0+k3, cut, p1+m3))[0]
            m4 = h * (nvec_field(p0+k3, cut, p1+m3))[1] 
            ;
            color = NORM(vec_field(p0, cut, p1)) / vmag_max * 255.
        ENDIF            
        ;
        dp0 = (k1 + 2*k2 + 2*k3 + k4) / 6.
        dp1 = (m1 + 2*m2 + 2*m3 + m4) / 6.
        ;
        ;print, range1, range2
        IF ~math->in_range(p0+dp0, range1) OR ~math->in_range(p1+dp1, range2) THEN BREAK
        ;
        color=0
        PLOTS, [p0, p0+dp0], [p1, p1+dp1], /DATA, THICK=2., color=color
        ;
        p0 += dp0
        p1 += dp1
        ;
    ENDWHILE

    ;
    ;*---------- backward  ----------*
    ;
    count = 0
    h = -h
    WHILE count LE max_loop DO BEGIN
        count ++
        ;
        IF KEYWORD_SET(xy) THEN BEGIN
            k1 = h * (nvec_field(p0, p1, cut))[0]
            m1 = h * (nvec_field(p0, p1, cut))[1]
            k2 = h * (nvec_field(p0+0.5*k1, p1+0.5*m1, cut))[0]
            m2 = h * (nvec_field(p0+0.5*k1, p1+0.5*m1, cut))[1]
            k3 = h * (nvec_field(p0+0.5*k2, p1+0.5*m2, cut))[0]
            m3 = h * (nvec_field(p0+0.5*k2, p1+0.5*m2, cut))[1]
            k4 = h * (nvec_field(xp+k3, yp+m3, cut))[0]
            m4 = h * (nvec_field(xp+k3, yp+m3, cut))[1] 
        ENDIF
        IF KEYWORD_SET(xz) THEN BEGIN
            k1 = h * (nvec_field(p0, cut, p1))[0]
            m1 = h * (nvec_field(p0, cut, p1))[1]
            k2 = h * (nvec_field(p0+0.5*k1, cut, p1+0.5*m1))[0]
            m2 = h * (nvec_field(p0+0.5*k1, cut, p1+0.5*m1))[1]
            k3 = h * (nvec_field(p0+0.5*k2, cut, p1+0.5*m2))[0]
            m3 = h * (nvec_field(p0+0.5*k2, cut, p1+0.5*m2))[1]
            k4 = h * (nvec_field(p0+k3, cut, p1+m3))[0]
            m4 = h * (nvec_field(p0+k3, cut, p1+m3))[1] 
            color = NORM(vec_field(p0, cut, p1)) / vmag_max * 255.
        ENDIF            
        ;
        dp0 = (k1 + 2*k2 + 2*k3 + k4) / 6.
        dp1 = (m1 + 2*m2 + 2*m3 + m4) / 6.
        ;
        ;print, range1, range2
        IF ~math->in_range(p0+dp0, range1) OR ~math->in_range(p1+dp1, range2) THEN BREAK
        ;
        color=0
        PLOTS, [p0, p0+dp0], [p1, p1+dp1], /DATA, THICK=2., color=color
        ;
        p0 += dp0
        p1 += dp1
        ;
    ENDWHILE
    h = -h
ENDFOR


!p.position=0
END

