

flag = 'restore'
@lr_load.pro



for i = 0, 0 do begin
  timespan, events[i].t_event
  cluster->load_vars, 3, /cis, /fgm
  ;
  ;*---------- mva  ----------*
  ;
  bname  =  'B_xyz_gse__C3_PP_FGM'
  vname  = 'V_HIA_xyz_gse__C3_PP_CIS'
  tmva, [bname, vname], tname_mag=bname, events[i].t_mva
  ;
  bname  = bname + '_LMN'
  vname  = vname + '_LMN'
  split_vec, bname
  split_vec, vname


  tnames=[bname+'_x', bname+'_y', bname+'_z', $
          'B_total__C3_PP_FGM',               $
          vname+'_x', vname+'_y', vname+'_z']

  ;
  ;*----------   ----------*
  ;
  ytitles = ['B!DL!N', 'B!DM!N', 'B!DN!N', '|B|', $
             'V!DL!N', 'V!DM!N', 'V!DN!N']
  ;
  ysubtitles = ['[nT]', '[nT]', '[nT]', '[nT]', $
                '[km/s]', '[km/s]', '[km/s]']
  options, tnames, 'databar', {yval:0, linestyle:2}
  for j = 0, 6 do begin
    options, tnames[j], 'ytitle', ytitles[j]
    options, tnames[j], 'ysubtitle', ysubtitles[j]
  endfor
  ;
  ;
  fn = '~/lr_LMN_'+ts_extract(events[i].t_event[0])
  popen, fn, xs=15, ys=6
  ;
  tplot_options, 'thick', 2.5
  tplot_options, 'region', [0.25, 0, 0.80, 1]
  tplot_options, 'title', 'Cluster3/FGM/CIS'
  tplot_options, 'charsize', 1.
  tplot, tnames
  ;
  timebar, events[i].t_sheath, color=[230, 230], thick=3.
  timebar, events[i].t_sphere, color=[50, 50], thick=3.
  timebar, events[i].t_outflow, color=[205, 205], thick=3.
  ;
  tplot_apply_databar
  time_stamp, /off
  ;
  pclose


  break

  cis = cl_cis(sc=3)
  ;
  ;*---------- sheath distribution ----------*
  ;
  trange = events[i].t_sheath
  ;
  xrange=[-1500, 1500]
  yrange=[-1500, 1500]
  ;
  fn = '~/lr2d-dist_' + ts_extract(trange[0]) + '_sheath'
  popen, fn, xs=7, ys=7
  ;
  cis->slice2d_plot, /ion, /hs, /mag, /pef, $
                     trange=trange, ycharsize=1.2, $
                     xcharsize=1.2, charsize=1.2, xrange=xrange, $
                     yrange=yrange 
  pclose
  ;
  ;
  fn = ' ~/lr1d-dist_' + ts_extract(trange[0]) + '_sheath'
  popen, fn, xs=7, ys=5
  cis->slice2d_plot, /ion, /hs, /mag, /pef, trange=trange, $
                     xrange=xrange, ycharsize=1.2, $
                     xcharsize=1.2, charsize=1.2, $
                     thick=1.5, /one_dim
  pclose


  ;
  ;*---------- sphere distribution ----------*
  ;
  trange = events[i].t_sphere
  ;
  xrange=[-1500, 1500]
  yrange=[-1500, 1500]
  ;
  fn = '~/lr2d-dist_' + ts_extract(trange[0]) + '_sphere'
  popen, fn, xs=7, ys=7
  ;
  cis->slice2d_plot, /ion, /hs, /mag, /pef, $
                     trange=trange, ycharsize=1.2, $
                     xcharsize=1.2, charsize=1.2, xrange=xrange, $
                     yrange=yrange 
  pclose
  ;
  ;
  fn = ' ~/lr1d-dist_' + ts_extract(trange[0]) + '_sphere'
  popen, fn, xs=7, ys=5
  cis->slice2d_plot, /ion, /hs, /mag, /pef, trange=trange, $
                     xrange=xrange, ycharsize=1.2, $
                     xcharsize=1.2, charsize=1.2, $
                     thick=1.5, /one_dim
  pclose 


  ;
  ;*---------- outflow distribution ----------*
  ;
  trange = events[i].t_outflow
  time = '2004-03-10/12:30:40'
  ;
  xrange=[-1500, 1500]
  yrange=[-1500, 1500]
  ;
  fn = '~/lr2d-dist_' + ts_extract(trange[0]) + '_outflow'
  popen, fn, xs=7, ys=7
  ;
  cis->slice2d_plot, /ion, /hs, /mag, /pef, $
                     time=time, ycharsize=1.2, $
                     xcharsize=1.2, charsize=1.2, xrange=xrange, $
                     yrange=yrange 
  pclose
  ;
  ;
  fn = ' ~/lr1d-dist_' + ts_extract(trange[0]) + '_outflow'
  popen, fn, xs=7, ys=5
  cis->slice2d_plot, /ion, /hs, /mag, /pef, time=time, $
                     xrange=xrange, ycharsize=1.2, $
                     xcharsize=1.2, charsize=1.2, $
                     thick=1.5, /one_dim
  pclose 
endfor




end
