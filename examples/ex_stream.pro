
nx   = 10
ny   = 10
flow = fltarr(2, nx+1, ny+1)
;
xgrid = findgen(nx+1) - float(nx) / 2.
ygrid = findgen(ny+1) - float(ny) / 2.


for i = 0, nx  do begin
    for j = 0, ny do begin
        flow[0, i, j] = -ygrid[j]
        flow[1, i, j] = xgrid[i]
    endfor
endfor


u = transpose(flow[0, *, *])
v = transpose(flow[1, *, *])



omodel = obj_new('idlgrmodel')
seeds  = [2, 4]

particle_trace, flow, seeds, vertices, conn, max_iterations=100, $
                max_stepsize=0.1, integ=1


;plot, xgrid, ygrid, /nodata
    
;inc = 10
;n   = nx / inc
;idx = indgen(n, increment=inc)
;idx1= indgen(n, n, increment=inc)
;;
;help, u[[idx], [idx]]
velovect, u, v, xgrid, ygrid
;
;
i = 0
sz = SIZE(vertices, /STRUCTURE)
WHILE (i LT sz.dimensions[1]) DO BEGIN
   nverts = conn[i]
 
; OLD METHOD: Uses 'x' and 'y' as lookup tables, losing the fractional
;                part of the result, ending up only using data grid points.
PLOTS, xgrid[vertices[0, conn[i+1:i+nverts]]], $
   ygrid[vertices[1, conn[i+1:i+nverts]]], $
   COLOR=50, THICK=1
 
; NEW METHOD: Find 'index' locations of desired points, then scale them
;                correctly to exact degrees. Plotting both to show improvement.
;;xIndices = vertices[0, conn[i+1:i+nverts]]
;;yIndices = vertices[1, conn[i+1:i+nverts]]
;;xDeg = (xIndices / 128) * 360 - 180
;;yDeg = (yIndices /  64) * 180 -  90
;; 
;;PLOTS, xDeg, yDeg, COLOR='0000FF'x, THICK=2
i += nverts + 1
ENDWHILE


;ostreamline = obj_new('idlgrpolygon', vertices, polygons=conn)
;omodel->add, ostreamline

;xobjview, omodel, scale=1

end
