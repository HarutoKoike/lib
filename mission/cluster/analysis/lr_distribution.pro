

flag = 'restore'
@lr_load.pro
loadct, 40


;for i = 0, n_elements(events) - 1 do begin

for i = 0, 0 do begin
;
timespan, events[i].t_event
;
cluster->load_vars, 3
;
fn  = 'lrplot_' + ts_extract(events[i].t_event[0])
dir = '~/idl/cluster/analysis/image/'
fn  = dir + fn
;
popen, fn
title = 'Cluster-3/CIS/FGM/PEACE ' + events[i].t_event[0]
tnames = [ 'Ion_Omni_Flux__C3', $
           'N_HIA__C3_PP_CIS',  $
           'T_HIA__C3_PP_CIS',  $
           'V_para_perp__C3', $
           'V_HIA_xyz_gsm__C3_PP_CIS', $
           'B_xyz_gsm__C3_PP_FGM', $
           'Parallel_electron__C3', $
           'antiparallel_electron__C3']
;
tplot_options, 'title', title
time_stamp, /off
;
;options, tnames[0], 'ytitle', 'Ion energy'
;options, tnames[1], 'ytitle', 'Ion density'
;options, tnames[2], 'ytitle', 'Ion temperature'
;options, tnames[3], 'ytitle', 'Ion velocity!C[km/s]'
;options, tnames[3], 'ytitle', 'V!C[km/s]'
;options, tnames[5], 'ytitle', 'Magnetic field(GSM)!C[km/s]'
;options, tnames[6], 'ytitle', 'Parallel electron'
;options, tnames[7], 'ytitle', 'Antiparallel electron'
;
;
tplot, tnames
tplot_apply_databar
;
; timebars
; sheath
;timebar, events[i].t_sheath, color=[6, 6]
; sphere
;timebar, events[i].t_sphere, color=[2, 2]
; outflow
;timebar, events[i].t_outflow, color=[0, 0]
;
pclose



;
;*---------- 2d dist  ----------*
;
cis = cl_cis()
cis->setprop, sc=3
;
; sheath
trange = events[i].t_sheath
fn = 'lr2d-dist_' + ts_extract(trange[0]) + '_sheath'
fn = dir + fn
popen, fn, xs=7, ys=7
xrange=[-1500, 1500]
yrange=[-1500, 1500]
cis->slice2d_plot, /ion, /hs, /mag, /pef, trange=trange, xrange=xrange, $
                   yrange=yrange, ycharsize=1.2, xcharsize=1.2, charsize=1.2
XYOUTS, 0, 2000, 'Magnetosheath ion distribution', /data, charsize=2., align=0.5
pclose
;
;
fn = 'lr1d-dist_' + ts_extract(trange[0]) + '_sheath'
fn = dir + fn
popen, fn, xs=7, ys=5
cis->slice2d_plot, /ion, /hs, /mag, /pef, trange=trange, xrange=xrange, $
                   ycharsize=1.2, xcharsize=1.2, charsize=1.2, $
                   thick=1.5, /one_dim
pclose


;
; sphere
trange = events[i].t_sphere
fn = 'lr2d-dist_' + ts_extract(trange[0]) + '_sphere'
fn = dir + fn
popen, fn, xs=7, ys=7
xrange=[-1500, 1500]
yrange=[-1500, 1500]
cis->slice2d_plot, /ion, /hs, /mag, /pef, trange=trange, xrange=xrange, $
                   yrange=yrange, ycharsize=1.2, xcharsize=1.2, charsize=1.2
XYOUTS, 0, 2000, 'Magnetosphere ion distribution', /data, charsize=2., align=0.5
pclose  
;
;
fn = 'lr1d-dist_' + ts_extract(trange[0]) + '_sphere'
fn = dir + fn
popen, fn, xs=7, ys=5
cis->slice2d_plot, /ion, /hs, /mag, /pef, trange=trange, xrange=xrange, $
                   ycharsize=1.2, xcharsize=1.2, charsize=1.2, $
                   thick=1.5, /one_dim
pclose
 

;
; outflow
trange = events[i].t_outflow
fn = 'lr2d-dist_' + ts_extract(trange[0]) + '_outflow'
fn = dir + fn
popen, fn, xs=7, ys=7
xrange=[-1500, 1500]
yrange=[-1500, 1500]
cis->slice2d_plot, /ion, /hs, /mag, /pef, trange=trange, xrange=xrange, $
                   yrange=yrange, ycharsize=1.2, xcharsize=1.2, charsize=1.2
XYOUTS, 0, 2000, 'Outflow ion distribution', /data, charsize=2., align=0.5
pclose  
;
;
fn = 'lr1d-dist_' + ts_extract(trange[0]) + '_outflow'
fn = dir + fn
popen, fn, xs=7, ys=5
cis->slice2d_plot, /ion, /hs, /mag, /pef, trange=trange, xrange=xrange, $
                   ycharsize=1.2, xcharsize=1.2, charsize=1.2, $
                   thick=1.5, /one_dim
pclose
 
 
break
endfor



end
