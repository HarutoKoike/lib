;function func1, r
;
;idx = [2, 0, 1]
;x = r[1]
;y = - r[0]
;z = 10
;return, [x, y, z]
;end
;
;
;
function coulomb, r
c  = [1, -1]
xc = [20, -20]
yc = [0, 0]
zc = [0, 0]
;
ex = 0
ey = 0
ez = 0
for i = 0, n_elements(c) - 1 do begin
    dino = sqrt( (r[0]-xc[i])^2 + (r[1]-yc[i])^2 + $
                 (r[2]-zc[i])^2 )^3
    ;
    ex += -(r[0] - xc[i]) / dino * c[i]
    ey += -(r[1] - yc[i]) / dino * c[i]
    ez += -(r[2] - zc[i]) / dino * c[i]
endfor
return, 1.e4*[ex, ey, ez]
;
end




;===========================================================+
; ++ NAME ++
PRO idlplotlib::field_line3d, funcname, xrange, yrange, $
                              zrange, seed=seed
;
; ++ PURPOSE ++
;  --> plot field line in 3-D using 4th Runge-Kutta 
;
; ++ POSITIONAL ARGUMENTS ++
;  --> funcname(STRING): name of function that returns 3 component
;                        vector data
;  --> xrange
;                
;
; ++ KEYWORDS ++
; -->  seed:
;
; ++ CALLING SEQUENCE ++
;  --> idlplotlib->field_line3d, 'Coulomb', [-100, 100], [100, 150], [100, 120]
;
; ++ HISTORY ++
;  H.Koike 
;===========================================================+
;
COMPILE_OPT IDL2, STATIC
;


;xrange = [-50, 50]
;yrange = xrange
;zrange = xrange


;
;*---------- make frame  ----------*
;
;PLOT_3DBOX, xrange, yrange, zrange, /NODATA
; Create some data.
 
;p = PLOT3D(xrange, yrange, zrange, 'o', /SYM_FILLED, $
;           XRANGE=[-6, 6], YRANGE=[-6, 6], $
;           ZRANGE=[-1.4, 1.4],$
;           AXIS_STYLE=2, MARGIN=[0.2, 0.3, 0.1, 0], $
;           DEPTH_CUE=[0, 2], /PERSPECTIVE, $
;           XTITLE='x', YTITLE='y', /nodata)





;
;*---------- setting for tracing  ----------*
;
max_loop = 10000L
h        = 1.5*SQRT( (xrange[1] - xrange[0])^2 +$
                     (yrange[1] - yrange[0])^2 +$
                     (zrange[1] - zrange[0])^2 ) / $
            FLOAT(max_loop)
;h = 0.1

;

IF ~KEYWORD_SET(seed) THEN BEGIN
    ns   = 10
    seed = FINDGEN(3, ns)
    ;
    ;seed[0, *] = (FINDGEN(ns) / (ns - 1) - 0.5) * (xrange[1] - xrange[0]) + MEAN(xrange)
    ;seed[1, *] = (FINDGEN(ns) / (ns - 1) - 0.5) * (yrange[1] - yrange[0]) + MEAN(yrange)
    ;seed[2, *] = (FINDGEN(ns) / (ns - 1) - 0.5) * (zrange[1] - zrange[0]) + MEAN(zrange)
    seed[0, *] = (RANDOMU(2411452, ns) - 0.5) * (xrange[1] - xrange[0]) + MEAN(xrange)
    seed[1, *] = (RANDOMU(31120, ns) - 0.5) * (yrange[1] - yrange[0]) + MEAN(yrange)
    seed[2, *] = (RANDOMU(3144421888, ns) - 0.5) * (zrange[1] - zrange[0]) + MEAN(zrange)
ENDIF

;
ndim_seed = SIZE(seed, /N_DIMENSION)
seed_size = SIZE(seed, /DIMENSION)
nseed     = seed_size[1]




;
;*---------- Runge-Kutta ----------*
;
;
; forward
;
FOR i = 0, nseed - 1 DO BEGIN
    ;
    ; color
    vert_colors = []
    ;
    ; start point
    p = REFORM(seed[*, i])
    ;
    ; posicion
    posx = p[0]
    posy = p[1]
    posz = p[2]
    mag  = NORM(CALL_FUNCTION(funcname, p))
    ;
    ; calc
    count = 0
    WHILE count LE max_loop DO BEGIN
        ;
        v1 = CALL_FUNCTION(funcname, p)
        k1 = h * v1 / NORM(v1) 
        v2 = CALL_FUNCTION(funcname, p + 0.5*k1)
        k2 = h * v2 / NORM(v2) 
        v3 = CALL_FUNCTION(funcname, p + 0.5*k2)
        k3 = h * v3 / NORM(v3) 
        v4 = CALL_FUNCTION(funcname, p + k3)
        k4 = h * v4 / NORM(v4) 
        ;
        dp = (k1 + 2.*k2 + 2.*k3 + k4) / 6.
        ;
        IF ~math->in_range(p[0]+dp[0], xrange) OR $
           ~math->in_range(p[1]+dp[1], yrange) OR $
           ~math->in_range(p[2]+dp[2], zrange) THEN BREAK
        ;
        p    = p + dp
        mag  = [mag, CALL_FUNCTION(funcname, p)] 
        ;
        ;
        posx = [posx, p[0]]
        posy = [posy, p[1]]
        posz = [posz, p[2]]
        ;
        count ++
    ENDWHILE
    ;
    IF count LE 1 THEN CONTINUE
    ;
    p = PLOT3D(posx, posy, posz, vert_color=bytscl(mag), rgb_table=33, /OVERPLOT, 'o', /sym_filled)
ENDFOR
;
; backward
;
h = -h
FOR i = 0, nseed - 1 DO BEGIN
    ;
    ; color
    vert_colors = []
    ;
    ; start point
    p = REFORM(seed[*, i])
    ;
    ; posicion
    posx = p[0]
    posy = p[1]
    posz = p[2]
    mag  = NORM(CALL_FUNCTION(funcname, p))
    ;
    ; calc
    count = 0
    WHILE count LE max_loop DO BEGIN
        ;
        v1 = CALL_FUNCTION(funcname, p)
        k1 = h * v1 / NORM(v1) 
        v2 = CALL_FUNCTION(funcname, p + 0.5*k1)
        k2 = h * v2 / NORM(v2) 
        v3 = CALL_FUNCTION(funcname, p + 0.5*k2)
        k3 = h * v3 / NORM(v3) 
        v4 = CALL_FUNCTION(funcname, p + k3)
        k4 = h * v4 / NORM(v4) 
        ;
        dp = (k1 + 2.*k2 + 2.*k3 + k4) / 6.
        ;
        IF ~math->in_range(p[0]+dp[0], xrange) OR $
           ~math->in_range(p[1]+dp[1], yrange) OR $
           ~math->in_range(p[2]+dp[2], zrange) THEN BREAK
        ;
        p    = p + dp
        mag  = [mag, CALL_FUNCTION(funcname, p)] 
        ;
        ;
        posx = [posx, p[0]]
        posy = [posy, p[1]]
        posz = [posz, p[2]]
        ;
        count ++
    ENDWHILE
    ;
    IF count LE 1 THEN CONTINUE
    ;
    p = PLOT3D(posx, posy, posz, vert_color=bytscl(mag), rgb_table=33, /OVERPLOT, 'o', /sym_filled)
ENDFOR   



END


;seed = fltarr(3, 2)
;seed[0, 0] = 0
;seed[1, 0] = 30
;seed[2, 0] = -50
;seed[0, 0] = 0
;seed[1, 0] = 10
;seed[2, 0] = -50

;idlplotlib->field_line3d, 'coulomb', [-10, 10], [-20, 20], [40, 80]

;end
