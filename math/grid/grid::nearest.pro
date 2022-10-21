FUNCTION grid::nearest, point
COMPILE_OPT IDL2
;

self->getprop, dim=dim, xgrid=xgrid, ygrid=ygrid, zgrid=zgrid

IF dim EQ 3 THEN GOTO, dim3

idx_x = VALUE_LOCATE(xgrid, point[0])
idx_y = VALUE_LOCATE(ygrid, point[1])

near_grid = [ [idx_x,   idx_y],       $
              [idx_x,   idx_y+1],     $
              [idx_x+1, idx_y],       $
              [idx_x+1, idx_y+1]]
RETURN, near_grid



dim3:
idx_x = VALUE_LOCATE(xgrid, point[0])
idx_y = VALUE_LOCATE(ygrid, point[1])
idx_z = VALUE_LOCATE(zgrid, point[2])

near_grid = [ [idx_x, idx_y,   idx_z],   $
              [idx_x, idx_y,   idx_z+1], $
              [idx_x, idx_y+1, idx_z],   $
              [idx_x, idx_y+1, idx_z+1], $
              [idx_x+1, idx_y, idx_z],   $
              [idx_x+1, idx_y, idx_z+1], $
              [idx_x+1, idx_y+1, idx_z], $
              [idx_x+1, idx_y+1, idx_z+1] ] 
              
RETURN, near_grid
END
