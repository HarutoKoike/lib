
flag = 'restore'
@lr_load.pro


i = 5

timespan, events[i].t_event

cluster->load_vars, 3, /all


tnames = [ 'flux__C3_CP_CIS-HIA_HS_1D_PEF', $
           'N_HIA__C3_PP_CIS',  $
           'T_HIA__C3_PP_CIS',  $
           'V_para_perp__C3', $
           'V_HIA_xyz_gsm__C3_PP_CIS', $
           'B_xyz_gsm__C3_PP_FGM', $
           'Parallel_electron__C3', $
           'antiparallel_electron__C3']


window, xs=1000, ys=800
time_stamp, /off
        
tplot, tnames


; timebars
; sheath
timebar, events[i].t_sheath, color=[220, 220]
; sphere
timebar, events[i].t_sphere, color=[50, 50]
; outflow
timebar, events[i].t_outflow, color=[0, 0]


tplot_apply_databar


end

;
;*---------- 2d dist  ----------*
;
cis = cl_cis()
cis->setprop, sc=3
;
; sheath
trange = events[i].t_sheath
trange = ['2003-03-19/15:54:45', '2003-03-19/15:54:46']
;fn = 'lr2d-dist_' + ts_extract(trange[0]) + '_sheath'
;fn = dir + fn
;xrange=[-1500, 1500]
;yrange=[-1500, 1500]
window, 2
cis->slice2d_plot, /ion, /hs, /mag, /pef, trange=trange, xrange=xrange, $
                   yrange=yrange, ycharsize=1.2, xcharsize=1.2, charsize=1.2
XYOUTS, 0, 2600, 'Magnetosheath ion distribution', /data, charsize=2., align=0.5
;
;
;fn = 'lr1d-dist_' + ts_extract(trange[0]) + '_sheath'
;fn = dir + fn
;cis->slice2d_plot, /ion, /hs, /mag, /pef, trange=trange, xrange=xrange, $
;                   ycharsize=1.2, xcharsize=1.2, charsize=1.2, $
;                   thick=1.5, /one_dim
;


end
