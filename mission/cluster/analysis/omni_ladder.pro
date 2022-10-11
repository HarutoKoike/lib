
PRO omni_download, yr, mon

yr  = STRING(yr, FORMAT='(I4)')
mon = STRING(mon, FORMAT='(I02)')

path = '/Users/h.koike/home/data/istp/omni/omni_cdaweb' + $
				'/hro_5min/'+ yr + '/' 
file =  'omni_hro_5min_' + yr + mon + '01_v01.cdf'


IF FILE_TEST(path + file) THEN BEGIN
	PRINT, 'already exist : '
	PRINT, path + file
	RETURN
ENDIF

url  = 'https://spdf.gsfc.nasa.gov/pub/data/omni/omni_cdaweb/hro_5min/' + yr + '/'
url  = url + file


spawn, 'wget --timeout=60 --wait=120  --tries=1 -P ' +$
				path + ' ' + url 

	


END



FUNCTION yrange, y, ticks, min = min, max = max,  dy = dy

ticks = FLOAT(ticks)

IF ~KEYWORD_SET(min) THEN BEGIN
	ymin = MIN(y, /NAN)
ENDIF ELSE BEGIN 
	ymin = min
ENDELSE

IF ~KEYWORD_SET(max) THEN BEGIN
	ymax = MAX(y, /NAN)
ENDIF ELSE BEGIN 
	ymax = max
ENDELSE


;
ymin = ymin - ABS(ymin) * 0.5
ymax = ymax + ABS(ymin) * 0.5

IF ~KEYWORD_SET(dy) THEN BEGIN
	yy = (ymax - ymin) / ticks
  IF yy LT 0.1  THEN dy = 0.1
  IF yy GT 0.1  AND yy LE 0.2   THEN dy = 0.2
  IF yy GT 0.2  AND yy LE 0.25  THEN dy = 0.25
  IF yy GT 0.25 AND yy LE 0.5   THEN dy = 0.5
  IF yy GT 0.5 	AND yy LE 1.  	THEN dy = 1.
  IF yy GT 1.  	AND yy LE 2.  	THEN dy = 2.
  IF yy GT 2.  	AND yy LE 5.  	THEN dy = 5.
  IF yy GT 5.  	AND yy LE 10. 	THEN dy = 10.
  IF yy GT 10. 	AND yy LE 20. 	THEN dy = 20.
  IF yy GT 20. 	AND yy LE 25. 	THEN dy = 25.
  IF yy GT 25. 	AND yy LE 50. 	THEN dy = 50.
  IF yy GT 50.  THEN dy = 100.
ENDIF

IF ymin GE 0. THEN ymin = ymin - (ymin MOD dy)
IF ymin LT 0. THEN ymin = ymin - (dy - (ABS(ymin) MOD dy))
IF ymax GE 0. THEN ymax = ymin + dy * ticks

RETURN, [ymin, ymax]

END






PRO omni_ladder, tsn

tsn= '2004-03-10/13:30:00'
!p.font=4
;
;*---------- time setting  ----------*
;
;tsn = '2012-04-23/10:10:00'
yr  = STRMID(tsn, 0, 4)
mon = STRMID(tsn, 5, 2)
title = 'Solar Wind OMNI ' + STRMID(tsn, 0, 10)
omni_download, yr, mon
;
tsn = time_double(tsn)
ten = tsn + 3600D 
ts  = tsn - 7200D - ( tsn MOD 3600D)
te  = ten + 3600D - ( ten MOD 3600D)

;
tsn = time_string(tsn)
ten = time_string(ten)
timespan, [tsn, ten]
;
      


;
;
;*---------- data load  ----------*
;
omni_hro_load, /res5min
get_data, 'OMNI_HRO_5min_BX_GSE', data = bx
get_data, 'OMNI_HRO_5min_BY_GSM', data = by
get_data, 'OMNI_HRO_5min_BZ_GSM', data = bz
get_data, 'OMNI_HRO_5min_flow_speed', data = vs
get_data, 'OMNI_HRO_5min_proton_density', data = ns
get_data, 'OMNI_HRO_5min_Pressure', data = pdyn
get_data, 'OMNI_HRO_5min_mach_num', data = ma
;time
t = bx.x
idx = WHERE( t GE time_double(ts) AND $
						 t LE time_double(te) )


;
;*---------- plot setting  ----------*
;
; symbol
a = FINDGEN(17) * !PI * 2 / 16.
USERSYM, 0.5 * COS(a), 0.5 * SIN(a), /FILL
; charactor size
cs = 1.
cs_title = 1.2
csy = 1.
; thick
data_thick = 2.5
axis_thick = 3.0
title_thick = 1.
; window
mypsplot, fn = 'OMNI_' + STRMID(tsn, 0, 10) + '.eps',xsize=15, ysize=18, /open_ps
;window, xsize = 500, ysize=700
; margin in normal
margin_top    = 0.1
margin_bottom = 0.08
margin_left   = 0.15
margin_right  = 0.10
; height and width
n = 6.    ; number of data
height = (1. - margin_top - margin_bottom) / n
width  = 1. - margin_left - margin_right
;
;*---------- plot  ----------*
;
;
; time label
date = trim_time_string(tsn) 
yr   = date.dy
mon  = date.mon
dy   = date.dy
hr   = date.hr
ut   = INDGEN(5) + hr
ut   = STRING(ut, FORMAT='(I02)') + ':00'
ut1  = REPLICATE(' ', 5)
t    = time_double2julday(t[idx])
dum  = LABEL_DATE(DATE_FORMAT=['%H:%I'])
;date = TIMEGEN(5, UNITS='HOURS', $
;							 START=JULDAY(mon, dy, yr, hr))
; dynamic pressure
position = [                           $
					 margin_left,                $
					 margin_bottom,              $
					 margin_left + width,        $
					 margin_bottom + height      $
					]
pdyn = pdyn.Y[idx]
ytitle = 'P!Ddyn!N(nPa)'
yrange = [0, MAX(pdyn, /NAN)]        
yrange = yrange(pdyn, 4, min=0.)
PLOT, t, pdyn, POSITION=position, /NORMAL, XTICKUNITS='Hours', $
      XTICKS=4, YTICKS=4, YMINOR=1, YRANGE = yrange,           $
			XSTYLE=8, XTITLE='UT', XCHARSIZE=cs, THICK = data_thick, $
      YTHICK=axis_thick, XTHICK=axis_thick, YCHARSIZE=csy,     $
			CHARTHICK=2
OPLOT,t, pdyn, psym=8
PLOTS, [position[0], position[2]], [position[3], position[3]], /NORMAL, $
			 THICK = axis_thick
XYOUTS, margin_left / 2., (position[1] + position[3]) / 2., /NORMAL, $
				ytitle, CHARSIZE=cs, ALIGNMENT=0.5, ORIENTATION=90., $
				CHARTHICK=title_thick
			
;
; density
dp =  [0., height, 0., height]
position += dp 
ns = ns.Y[idx]
ytitle = 'N!DSW!N(cm!U-3!N)'
yrange = yrange(ns, 4, min=0.)
PLOT, t, ns, POSITION=position, /NORMAL, /NOERASE ,XTICKUNITS='Hours', $
			YTICKS=4, YMINOR=1, XSTYLE=4, YRANGE=yrange, THICK = data_thick, $
			XTHICK=axis_thick , YTHICK=axis_thick, YCHARSIZE=csy , $
			CHARTHICK=2
OPLOT,t, ns, psym=8 
PLOTS, [position[0], position[2]], [position[3], position[3]], /NORMAL, $
			 THICK = axis_thick
XYOUTS, margin_left / 2., (position[1] + position[3]) / 2., /NORMAL, $
				ytitle, CHARSIZE=cs, ALIGNMENT=0.5, ORIENTATION=90., $
				CHARTHICK=title_thick
;
; velosity
position += dp 
vs = vs.Y[idx]
ytitle = 'V!DSW!N(km/s)'
y0 = MIN(vs) - (MIN(vs) MOD 100.) 
y1 = MAX(vs) + 100. - (MAX(vs) MOD 100.) 
yrange = yrange(vs, 4., min=y0, max=y1)
yrange=[400, 800]
PLOT, t, vs, POSITION=position, /NORMAL, /NOERASE ,XTICKUNITS='Hours', $
			YTICKS=4, YMINOR=1, XSTYLE=4 ,yrange=yrange , THICK=data_thick, $
			XTHICK=axis_thick , YTHICK=axis_thick , YCHARSIZE=csy, $
			CHARTHICK=2
OPLOT,t, vs, psym=8 
PLOTS, [position[0], position[2]], [position[3], position[3]], /NORMAL, $
			 THICK = axis_thick
XYOUTS, margin_left / 2., (position[1] + position[3]) / 2., /NORMAL, $
				ytitle, CHARSIZE=cs, ALIGNMENT=0.5, ORIENTATION=90., $
				CHARTHICK=title_thick


;
; IMF Bz
position += dp 
bz = bz.Y[idx]
ytitle = 'IMF B!Dz!N(nT)'
yrange = [MIN(bz, /nan) - 1. - (MIN(bz, /NAN) MOD 1.), $
					MAX(bz, /NAN) + 1. - (MAX(bz, /NAN) MOD 1.)]
yrange = yrange(bz, 4) 
;
yrange=[-14, 14]
;
;plot, [-14, 14], /nodata
PLOT, t, bz, POSITION=position, /NORMAL, /NOERASE ,XTICKUNITS='Hours', $
			YTICKS=4, YMINOR=1, XSTYLE=4 , YRANGE=yrange, THICK=data_thick , $
			XTHICK=axis_thick , YTHICK=axis_thick, YCHARSIZE=csy   , $
			CHARTHICK=2
OPLOT,t, bz, psym=8 
PLOTS, [position[0], position[2]], [position[3], position[3]], /NORMAL, $
 		 	 THICK = axis_thick
;IF MIN(bz, /NAN) * MAX(bz, /NAN) LT 0. THEN $ 
 PLOTS, [t[0], t[-1]], [0, 0], /DATA, LINESTYLE=1, THICK=2.0
XYOUTS, margin_left / 2., (position[1] + position[3]) / 2., /NORMAL, $
				ytitle, CHARSIZE=cs, ALIGNMENT=0.5, ORIENTATION=90., $
				CHARTHICK=title_thick
;
; IMF By
position += dp 
by = by.Y[idx]
ytitle = 'IMF B!Dy!N(nT)'
yrange = [MIN(by, /nan) - 1. - (MIN(by, /NAN) MOD 1.), $
					MAX(by, /NAN) + 1. - (MAX(by, /NAN) MOD 1.)]
yrange = yrange(by, 4) 
;
yrange=[-12., 12.]
;
PLOT, t, by, POSITION=position, /NORMAL, /NOERASE ,XTICKUNITS='Hours', $
			YTICKS=4, YMINOR=1, XSTYLE=4 , YRANGE=yrange, THICK=data_thick, $
			XTHICK=axis_thick , YTHICK=axis_thick, YCHARSIZE=csy , $
			charthick=2

OPLOT,t, by, psym=8 
PLOTS, [position[0], position[2]], [position[3], position[3]], /NORMAL,$
 	 		 THICK = axis_thick
IF MIN(by, /NAN) * MAX(bz, /NAN) LT 0. THEN $ 
	PLOTS, [t[0], t[-1]], [0, 0], /DATA, LINESTYLE=1 , THICK=2.0
XYOUTS, margin_left / 2., (position[1] + position[3]) / 2., /NORMAL, $
				ytitle, CHARSIZE=cs, ALIGNMENT=0.5, ORIENTATION=90.  , $
				CHARTHICK=title_thick
;
; IMF Bx
position += dp 
bx = bx.Y[idx]
ytitle = 'IMF B!Dx!N(nT)'
yrange = [MIN(bx, /nan) - 1. - (MIN(bx, /NAN) MOD 1.),$
					MAX(bx, /NAN) + 1. - (MAX(bx, /NAN) MOD 1.)]
yrange=yrange(bx, 4)
;
yrange=[-15, 15]
;
PLOT, t, bx, POSITION=position, /NORMAL, /NOERASE ,XTICKUNITS='Hours', $
			YTICKS=4, YMINOR=1, XSTYLE=4, YRANGE=yrange, THICK = data_thick, $
			XTHICK=axis_thick, YTHICK=axis_thick, YCHARSIZE=csy, $
			charthick=2
OPLOT,t, bx, psym=8 
PLOTS, [position[0], position[2]], [position[3], position[3]], /NORMAL, $
 	 		 THICK = axis_thick
IF MIN(bx, /NAN) * MAX(bx, /NAN) LT 0. THEN $ 
	PLOTS, [t[0], t[-1]], [0, 0], /DATA, LINESTYLE=1, THICK=2.0
XYOUTS, margin_left / 2., (position[1] + position[3]) / 2., /NORMAL, $
				ytitle, CHARSIZE=cs, ALIGNMENT=0.5, ORIENTATION=90., $
				CHARTHICK=title_thick


;
;*---------- options  ----------*
;
; vertical lines
;tsn = time_double2julday( time_double(tsn) )
;ten = time_double2julday( time_double(ten) )
;d = CONVERT_COORD([tsn, ten],[0, 0], /DATA, /TO_NORMAL)
;
;PLOTS, [d[0, 0], d[0, 0]], [margin_bottom, 1 - margin_top], /NORMAL, $
;			 LINESTYLE=1, THICK=2.0
;PLOTS, [d[0, 1], d[0, 1]], [margin_bottom, 1 - margin_top], /NORMAL, $
;			 LINESTYLE=1, THICK=2.0
; title
XYOUTS, 0.5, position[3] + 0.01, title, charsize=cs_title, /NORMAL, $
				ALIGNMENT=0.5, CHARTHICK=title_thick




mypsplot, /close_ps


END





