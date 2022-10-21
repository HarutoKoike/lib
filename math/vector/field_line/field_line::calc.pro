;-------------------------------------------------+
; 
;-------------------------------------------------+
FUNCTION conv_pos2idx, npoints, pos_range, pos
RETURN, FLOAT(npoints) / (pos_range[1] - pos_range[0]) * (pos - pos_range[0])
END





PRO field_line::calc, field, dl=dl, max_roop=max_roop
COMPILE_OPT IDL2
;
;
;*---------- settings  ----------*
;
tranc = 0.1   ; trancate if v < max(|v|) * tranc


IF ~ISA(field, 'vector_field') THEN MESSAGE, 'argument must be "vector_field" object'
;
;

;
;*---------- dimension  ----------*
;
field->getprop, x=x, y=y, z=z, vx=vx, vy=vy, vz=vz
dim = ISA(x) + ISA(y) + ISA(z)


;
;*---------- start point  ----------*
;
self->getprop, x0=x0, y0=y0, z0=z0



IF dim EQ 3 THEN GOTO, dim3




;-------------------------------------------------+
; 2 dimension
;-------------------------------------------------+
ngrid_x = (SIZE(x, /DIMENSIONS))[0]
ngrid_y = (SIZE(y, /DIMENSIONS))[1]


;
;*---------- range of vector field ----------*
;
x_range = [MIN(x, /NAN), MAX(x, /NAN) ]
y_range = [MIN(y, /NAN), MAX(y, /NAN) ]
range   = 2.*[[x_range], [y_range]]

;
;*---------- unit ----------*
;
l_max = SQRT( (x_range[1] - x_range[0])^2 + (y_range[1] - y_range[0])^2 )
IF ~KEYWORD_SET(dl) THEN dl = l_max / 1000.


;
;*---------- max loop  ----------*
;
;IF ~KEYWORD_SET(max_loop) THEN max_loop = FLOOR(5 * l_max / dl) 

;
;*---------- forward calculation x > min(x_range) ----------*
;
pos_x = x0
pos_y = y0
pos   = [x0, y0]
;
; vector at start point
idx_x0 = conv_pos2idx(ngrid_x, x_range, x0)
idx_y0 = conv_pos2idx(ngrid_y, y_range, y0)

vx_fit = INTERPOLATE(vx, idx_x0, idx_y0)
vy_fit = INTERPOLATE(vy, idx_x0, idx_y0)

vec     = [vx_fit, vy_fit]
mag_max = MAX(SQRT(vx^2 + vy^2), /NAN)


mag = []



;                  
;*---------- forward  ----------*
;
count = 0
;
WHILE math->in_range(pos, range) DO BEGIN
    ;IF count GE max_loop THEN BREAK
    ;
    vec      = [vx_fit, vy_fit]    
    ;
    print, norm(vec), mag_max
    IF NORM(vec) LT mag_max * 0.05 THEN BREAK
    mag      = [mag, NORM(vec)]
    ;
    unit_vec = vec / NORM(vec) * dl
    pos += unit_vec
    ;
    pos_x = [pos_x, pos[0]] 
    pos_y = [pos_y, pos[1]] 
    ;
    idx_x = conv_pos2idx(ngrid_x, x_range, pos[0])
    idx_y = conv_pos2idx(ngrid_y, y_range, pos[1])
    ;
    vx_fit = INTERPOLATE(vx, idx_x, idx_y)
    vy_fit = INTERPOLATE(vy, idx_x, idx_y)
ENDWHILE   
 
;
;*---------- backward  ----------*
;
pos   = [x0, y0]
vx_fit = INTERPOLATE(vx, idx_x0, idx_y0)
vy_fit = INTERPOLATE(vy, idx_x0, idx_y0)
;
WHILE math->in_range(pos, range) DO BEGIN
    vec      = -[vx_fit, vy_fit]    
    ;
    IF NORM(vec) LT mag_max * 0.05 THEN BREAK
    mag      = [mag, NORM(vec)]
    ;
    unit_vec = vec / NORM(vec) * dl
    pos += unit_vec
    ;
    pos_x = [pos[0], pos_x] 
    pos_y = [pos[1], pos_y] 
    ;
    idx_x = conv_pos2idx(ngrid_x, x_range, pos[0])
    idx_y = conv_pos2idx(ngrid_y, y_range, pos[1])
    ;
    vx_fit = INTERPOLATE(vx, idx_x, idx_y)
    vy_fit = INTERPOLATE(vy, idx_x, idx_y)
ENDWHILE   
;
self->setprop, px=pos_x, py=pos_y, mag=mag
self->getprop, x0=x0, px=px

RETURN



;-------------------------------------------------+
; 3 dimension
;-------------------------------------------------
dim3:
;-------------------------------------------------+
;
;*---------- range of vector field ----------*
;
x_range = [ MIN(x, /NAN), MAX(x, /NAN) ]
y_range = [ MIN(y, /NAN), MAX(y, /NAN) ]
;
z_range = [ MIN(z, /NAN), MAX(z, /NAN) ]




l_max = SQRT( (x_range[1] - x_range[0])^2 + (y_range[1] - y_range[0])^2 + $
              (z_range[1] - z_range[0])^2 )

END
