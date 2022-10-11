



PRO dmsp::plot, f, ts, te

COMPILE_OPT IDL2, STATIC

!z.type = 1

;-------------------------------------------------+
; graphic keywords
;-------------------------------------------------+
!P.FONT = 4
!Y.THICK = 1.5
!X.THICK = 2.
!P.CHARTHICK=0.3
!Y.CHARSIZE = 1. 
!X.CHARSIZE = 1.2
!P.NOERASE=1
!X.STYLE = 1
!Y.STYLE = 1
!X.MINOR = 0
!X.TICKS = 1
!X.TICKNAME = [' ', ' ']
!Y.TICKLEN = -0.015
!X.TICKLEN = -0.007
!y.type = 1
;
xmargin0 = 0.15
xmargin1 = 0.15
width = 1 - xmargin0 - xmargin1
;
n_panel  = 5.
ymargin0 = 0.1
ymargin1 = 0.15
hinterval= 0.01
height   = (1. - ymargin0 - ymargin1 $
						- (n_panel-1.) * hinterval ) / n_panel
;
!P.POSITION = [xmargin0, 1 - ymargin0 - height, $
							 xmargin0 + width, 1 - ymargin0]
dpos = [0, hinterval + height, 0, hinterval + height]


resolve_routine, 'spect_plot'
f = 17
;f = 16
ts = '2012-04-23/11:18:05'
te = '2012-04-23/11:23:46'
;ts = '2016-01-08/15:35:00'
;te = '2016-01-08/15:39:00'

td  = trim_time_string(ts)
yr  = td.yr
mon = td.mon
dy  = td.dy


d = dmsp_load(f, yr, mon, dy)

t1 = time_double(ts)
t2 = time_double(te)
idx = where(d.t ge t1 and d.t le t2)
 
t = d.t[idx]
t_dum = t - t[0]

mlat = d.mlat[idx]
mlt  = d.mlt[idx]



;-------------------------------------------------+
; title
;-------------------------------------------------+
title = 'DMSP F' + string(f, format='(I02)')
title += ' ' + STRMID(ts, 0, 10) + ' ' + $
				 STRMID(ts, 11, 2) + 'UT'
;
XYOUTS, (!P.POSITION[0] + !P.POSITION[2]) / 2. , $
				!P.POSITION[3] + !D.Y_CH_SIZE / FLOAT(!D.Y_VSIZE), $
				title, alignment=0.5, charsize = 1.7 , /NORMAL


;-------------------------------------------------+
; electron
;-------------------------------------------------+

myspect_struc, t_dum, .5, .5, d.ebin, d.e_plus, $
							 d.e_minus, TRANSPOSE(d.jee[*, idx]) 
spect_plot, n_level = 30
;
;*---------- title  ----------*
;
ch = !D.Y_CH_SIZE / FLOAT(!D.X_VSIZE)
pos_x_ytitle = !P.POSITION[0] - 6.5*ch
pos_y_ytitle = (!P.POSITION[1] + !P.POSITION[3])/2.
ytitle = 'Electron!C(eV)'
XYOUTS, pos_x_ytitle, pos_y_ytitle, ytitle, $
				alignment=0.5, orientation=90, /normal, $
				charsize=1.2
;
;*---------- colorbar caption  ----------*
;
caption = 'Differential Energy Flux!C( eV/(eV cm!U2!N s sr) )'
XYOUTS, !P.POSITION[2] + 5*ch, !P.POSITION[1], $
				caption, alignment=0.5, charsize = .9 , $
				orientation=90, /NORMAL



;-------------------------------------------------+
; ion
;-------------------------------------------------+
!P.POSITION -= dpos
;
myspect_struc, t_dum, 0.5, 0.5, d.ebin, d.e_plus, $
							 d.e_minus, TRANSPOSE(d.jei[*, idx]) 
spect_plot, n_level = 30

;
;*---------- title  ----------*
;
pos_x_ytitle = !P.POSITION[0] - 6.5*ch
pos_y_ytitle = (!P.POSITION[1] + !P.POSITION[3])/2.
ytitle = 'Ion!C(eV)'
XYOUTS, pos_x_ytitle, pos_y_ytitle, ytitle, $
				alignment=0.5, orientation=90, /normal, $
				charsize=1.2



;-------------------------------------------------+
; total number flux
;-------------------------------------------------+
!P.POSITION -= dpos
;!Y.TICKLEN = 1.4*!Y.TICKLEN
;    
jtoti = d.jtoti[idx]
jtote = d.jtote[idx]
;
PLOT, t, jtote, xrange=[t[0], t[-1]], xstyle=1, /ylog, $
			/nodata, ystyle=5
PLOT, t, jtoti, color=230, /NOERASE, xstyle=5, ystyle=4, $
			/ylog, thick=2.5
AXIS, yaxis=1, /ylog, color=230;, ytitle=
PLOT, t, jtote, color=50 , /NOERASE, xstyle=5, ystyle=4, $
			/ylog, thick=2.5
AXIS, yaxis=0, /ylog, color=50
 
pos_x_ytitle = !P.POSITION[0] - 6.5*ch
pos_y_ytitle = (!P.POSITION[1] + !P.POSITION[3])/2.
ytitle = 'Jtot!C(1/(cm!U2!N s sr))'
XYOUTS, pos_x_ytitle, pos_y_ytitle, ytitle, $
				alignment=0.5, orientation=90, /normal, $
				charsize=1.2
 


;-------------------------------------------------+
; total energy flux
;-------------------------------------------------+
!P.POSITION -= dpos
;!Y.TICKLEN = 1.4*!Y.TICKLEN
;    
jetoti = d.jetoti[idx]
jetote = d.jetote[idx]
;
PLOT, t, jetote, xrange=[t[0], t[-1]], xstyle=1, /ylog, $
			/nodata, ystyle=5 
PLOT, t, jetoti, color=230, /NOERASE, xstyle=5, ystyle=4, $
			/ylog, thick=2.5
AXIS, yaxis=1, /ylog, color=230 
PLOT, t, jetote, color=50 , /NOERASE, xstyle=5, ystyle=4, $
			/ylog, thick=2.5
AXIS, yaxis=0, /ylog, color=50 


pos_x_ytitle = !P.POSITION[0] - 6.5*ch
pos_y_ytitle = (!P.POSITION[1] + !P.POSITION[3])/2.
ytitle = 'Jetot!C(eV/(cm!U2!N s sr))'
XYOUTS, pos_x_ytitle, pos_y_ytitle, ytitle, $
				alignment=0.5, orientation=90, /normal, $
				charsize=1.2




;-------------------------------------------------+
; average energy
;-------------------------------------------------+

;!y.type = 0
!P.POSITION -= dpos
!Y.TICKLEN = 1.4*!Y.TICKLEN
;
iave = d.ei[idx]
eave = d.ee[idx]
;

PLOT,  t, iave, /nodata, /ylog, xrange=[t[0], t[-1]], $
			 yrange=[10, 3.e4]
OPLOT, t, iave, color = 230, thick = 2.5
OPLOT, t, eave, color = 50, thick=2.5

PLOTS, [t[0], t[-1]], [3000., 3000.], color=230, $
			 linestyle=2
PLOTS, [t[0], t[-1]], [220., 220.], color=50, $
			 linestyle=2
cord=CONVERT_COORD([t[-1],t[-1]], [3000, 200], /data, /to_normal) 
pos_x_caption = cord[0, 0] + ABS(!Y.TICKLEN) * 1.5
pos_y_caption_ion = cord[1, 0]
pos_y_caption_ele = cord[1, 1]
XYOUTS, pos_x_caption, pos_y_caption_ion, 'Ion', $
				color=230, /normal, charsize=.9, $
				alignment=0.3
XYOUTS, pos_x_caption, pos_y_caption_ele, 'Electron', $
				color=50, /normal, charsize=.9, $
				alignment=0.3

!Y.TICKLEN = !Y.TICKLEN/1.4
;
;*---------- title  ----------*
;
pos_x_ytitle = !P.POSITION[0] - 6.5*ch
pos_y_ytitle = (!P.POSITION[1] + !P.POSITION[3])/2.
ytitle = 'E!DAVE!N!C(eV)'
XYOUTS, pos_x_ytitle, pos_y_ytitle, ytitle, $
				alignment=0.5, orientation=90, /normal, $
				charsize=1.2 








;-------------------------------------------------+
; axis
;-------------------------------------------------+
!P.POSITION -= dpos
!P.POSITION += [0, hinterval, 0, hinterval]
!x.charsize=!y.charsize
tj = t / 86400D + julday(1, 1, 1970, 0, 0, 0)
caldat, tj, mon, dy, yr, hr, min, sec
idx = where(sec lt 1.) 
;
tags = ['MLT', 'MLAT']
mlt = STRING(mlt[idx], format='(F4.1)')
mlat = STRING(mlat[idx], format='(F5.1)')
time_axis, [tj[0], tj[-1]], tj[idx], tags, $
					 mlt, mlat
					 





;-------------------------------------------------+
; add time of cusp 
;-------------------------------------------------+
COMMON plt_common
t1 = time_double('2012-04-23/11:21:01')
t1 = time_double2julday(t1)
t2 = time_double('2012-04-23/11:21:49')
t2 = time_double2julday(t2)
;
pos_x_t1 = taxis_conv[0] + taxis_conv[1] * t1
pos_x_t2 = taxis_conv[0] + taxis_conv[1] * t2

PLOTS, [pos_x_t1, pos_x_t1], [!P.POSITION[3], 1 - ymargin0], $
			 /NORMAL, thick=2.5, color = 0
PLOTS, [pos_x_t2, pos_x_t2], [!P.POSITION[3], 1 - ymargin0], $
			 /NORMAL, thick=2.5, color=0




t1 = time_double('2012-04-23/11:21:01')
t2 = time_double('2012-04-23/11:21:49')
idx = where(d.t ge t1 and d.t le t2)
jei = d.jei[*, idx]
mlt = d.mlt[idx]
mlat = d.mlat[idx]
mj =max(jei[*, 0], mi)
;print, d.ebin[mi]
mj =max(jei[*, -1], mi)
;print, d.ebin[mi]
;print, mean(d.ei[idx], /nan)

;print, mlt[0], mlt[-1]
;print, mlat[0], mlat[-1]



END







pro testdmsp

;st = strarr(10)
;et = strarr(10)
;;
;st[0] = '2011-12-19/09:23:19' 
;et[0] = '2011-12-19/09:24:57' 
;st[1] = '2011-12-27/09:21:26'
;et[1] = '2011-12-27/09:23:12' 
;st[2] = '2011-12-28/09:07:50' 
;et[2] = '2011-12-28/09:10:47'
;st[3] = '2012-12-14/08:20:44'
;et[3] = '2012-12-14/08:23:09'
;st[4] = '2014-12-23/09:21:15' 
;et[4] = '2014-12-23/09:23:29'
;st[5] = '2015-01-17/07:16:22'
;et[5] = '2015-01-17/07:19:16'
;st[6] = '2015-12-09/10:17:33'
;et[6] = '2015-12-09/10:20:05'
;st[7] = '2015-12-17/06:50:48'
;et[7] = '2015-12-17/06:53:54'
;st[8] = '2015-12-17/08:31:38'
;et[8] = '2015-12-17/08:33:21'
;st[9] = '2016-01-05/07:44:20'
;et[9] = '2016-01-05/07:47:49'
;
;for i = 0, 9 do begin
;	fn = 'dmsp_check_' + string(i+1, format='(i02)') + '.eps'
;	print, fn
;	mypsplot, fn=fn, /open_ps, xsize=20, ysize=15
;	dmsp_plot, 16, st[i], et[i]
;	mypsplot, /close_ps
;endfor



fn = manager->filename(year=2012, month=4, day=23, hour=11, $
											prefix='DMSP_F17', extension='.eps')
mypsplot, /open_ps, fn=fn, xs=20, ys=24            
loadct, 39
dmsp->plot
mypsplot, /close_ps 





end  



