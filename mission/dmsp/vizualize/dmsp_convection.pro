;map_set, /sate, sat_p=[1.02, 0, 0], 0, 0, /continents, /iso, /horizon
;map_grid, londel=1, latdel=1

height = 1. + 840. / !CONST.R_EARTH * 1.e3
p      = [height, 55, 150]
;p=[1.0251, 55, 150]

MAP_SET, /SATELLITE, SAT_P=p,  41.5, -74., $
   /ISOTROPIC, /HORIZON, $
   LIMIT=1.*[39, -74, 33, -80, 40, -77, 41,-74], $
   /CONTINENTS, TITLE='Satellite / Tilted Perspective'
; Set up the satellite projection:
MAP_GRID, /LABEL, LATLAB=-75, LONLAB=39, LATDEL=1, LONDEL=1
; Get North vector:
p = convert_coord(-74.5, [40.2, 40.5], /TO_NORM)
; Draw North arrow:
ARROW, p(0,0), p(1,0), p(0,1), p(1,1), /NORMAL
XYOUTS, -74.5, 40.1, 'North', ALIGNMENT=0.5
