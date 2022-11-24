function coulomb, r
c  = [1, -1]
xc = [20, -5, 10]
yc = [0, 5, 10]
zc = [0, 20, 15]
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
FUNCTION hkplotlib::fieldline3d, funcname, xrange, yrange,$
                             zrange, seed=seed, nseed=nseed,$
                             _EXTRA=ex, range=range, $
                             log_color=log_color
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
;  --> hkplotlib->field_line3d, 'Coulomb', [-100, 100], [100, 150], [100, 120]
;
; ++ HISTORY ++
;  H.Koike 
;===========================================================+
;
COMPILE_OPT IDL2
;
;
;*---------- make frame  ----------*
;
 
rgb_table = 33
;
p = PLOT3D(xrange, yrange, zrange, /NODATA, $
           AXIS_STYLE=1, $
           _EXTRA=ex, RGB_TABLE=rgb_table)



;
;*---------- setting for tracing  ----------*
;
max_loop = 1000L
h        = 1.5*SQRT( (xrange[1] - xrange[0])^2 +$
                     (yrange[1] - yrange[0])^2 +$
                     (zrange[1] - zrange[0])^2 ) / $
            FLOAT(max_loop)

;

IF ~KEYWORD_SET(seed) THEN BEGIN
    IF ~KEYWORD_SET(nseed) THEN ns = 10
    IF  KEYWORD_SET(nseed) THEN ns = nseed
    ;
    seed = FINDGEN(3, ns)
    ;
    seed[0, *] = (RANDOMU(2411452321, ns) - 0.5) * (xrange[1] - xrange[0]) + MEAN(xrange)
    seed[1, *] = (RANDOMU(3112000000, ns) - 0.5) * (yrange[1] - yrange[0]) + MEAN(yrange)
    seed[2, *] = (RANDOMU(3144421888, ns) - 0.5) * (zrange[1] - zrange[0]) + MEAN(zrange)
ENDIF

;
ndim_seed = SIZE(seed, /N_DIMENSION)
seed_size = SIZE(seed, /DIMENSION)
nseed     = seed_size[1]


;max_mag = 30.

;
;*---------- Runge-Kutta ----------*
;
math = OBJ_NEW('math')
posx_all = []
posy_all = []
posz_all = []
mag_all  = []
sepidx   = []
;
; forward
;
;
FOR i = 0, nseed - 1 DO BEGIN
    ;
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
        mag  = [mag, NORM(CALL_FUNCTION(funcname, p))] 
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
    posx_all = [posx_all, posx]
    posy_all = [posy_all, posy]
    posz_all = [posz_all, posz]
    mag_all  = [mag_all, mag]
    sepidx   = [sepidx, count + 1]
ENDFOR
;
; backward
;
h = -h
FOR i = 0, nseed - 1 DO BEGIN
    ;
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
        mag  = [mag, NORM(CALL_FUNCTION(funcname, p))] 
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
    posx_all = [posx_all, posx]
    posy_all = [posy_all, posy]
    posz_all = [posz_all, posz]
    mag_all  = [mag_all, mag]
    sepidx   = [sepidx, count+1]
ENDFOR   



;
;*----------   ----------*
;
min = MIN(mag_all, /NAN)
max = MAX(mag_all, /NAN)
IF ARG_PRESENT(range) THEN range = [min, max]
;
IF KEYWORD_SET(log_color) THEN BEGIN
    vert_color = BYTSCL(ALOG10(mag_all))
ENDIF ELSE BEGIN
    vert_color = BYTSCL(mag_all)
ENDELSE


istart = 0
FOR i = 0, N_ELEMENTS(sepidx) - 1 DO BEGIN
    iend = istart + sepidx[i] - 1
    p = PLOT3D(posx_all[istart:iend], posy_all[istart:iend], posz_all[istart:iend], VERT_COLOR=vert_color[istart:iend], $
                RGB_TABLE=rgb_table, /OVERPLOT, $
                _EXTRA=ex)
    istart = iend + 1
ENDFOR

RETURN, p

END
