PRO ex_qhull
 
   ; Create a collection of random points.
   n = 20
   seed = 15
   x = RANDOMU(seed, n)
   y = RANDOMU(seed, n)
 
   ; Construct the Delaunay triangulation
   ; and the Voronoi diagram.
   QHULL, x, y, triangle, /DELAUNAY, $
      VDIAGRAM=vdiagram, VVERTICES=vvert, VNORM=vnorm
 
   ; Plot our input points.
   PLOT, [-0.1, 1.1], [-0.1, 1.1], /NODATA, $
      XSTYLE=4, YSTYLE=4
   PLOTS, x, y, PSYM=4
 
   ; Plot the Voronoi diagram.
   FOR i=0,N_ELEMENTS(vdiagram[2,*])-1 DO BEGIN
      vdiag = vdiagram[*, i]
      j = vdiag[2] + 1
      ; Bounded or unbounded?
      IF (j gt 0) THEN BEGIN   ; Bounded.
         PLOTS, vvert[*, vdiag[2:3]], PSYM=-5
         CONTINUE
      ENDIF
 
      ; Unbounded, retrieve starting vertex.
      xystart = vvert[*, vdiag[3]]
      ; Determine the line equation.
      ; Vnorm[0]*x + Vnorm[1]*y + Vnorm[2] = 0
      slope = -vnorm[0,-j]/vnorm[1,-j]
      intercept = -vnorm[2,-j]/vnorm[1,-j]
 
      ; Need to determine the line direction.
      ; Pick a point on one side along the line.
      xunbound = xystart[0] + 5
      yunbound = slope*xunbound + intercept
 
      ; Find the closest original vertex.
      void = MIN( (x-xunbound)^2 + (y-yunbound)^2, idx)
      ; By definition of Voronoi diagram, the line should
      ; be closest to one of the bisected points. If not,
      ; our line went in the wrong direction.
      IF (idx ne vdiag[0] && idx ne vdiag[1]) THEN BEGIN
         xunbound = xystart[0] - 5
         yunbound = slope*xunbound + intercept
      ENDIF
 
      PLOTS, [[xystart], [xunbound, yunbound]]
 
   ENDFOR
 
END
