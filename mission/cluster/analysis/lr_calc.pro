


flag = 'restore'
@lr_load.pro


for i = 0, 9 do begin
  timespan, events[i].t_event
  cluster->load_vars, 3
  ;
  ;*---------- mva ----------*
  ;
  b_name     = 'B_xyz_gse__C3_PP_FGM'
  b_name_new = 'B_MVA_LMN__C3_PP_FGM'
  tmva, b_name, b_name_new, e=e
  options, b_name_new, 'colors', [0, 50, 220]
  options, b_name_new, 'labels', ['B!DL!N', 'B!DM!N', 'B!DN!N']
  ;

  ;
  ;*---------- rotate  ----------*
  ;
  v_name     = 'V_HIA_xyz_gse__C3_PP_CIS'
  v_name_new = 'V_HIA_LMN__C3_PP_CIS'
  trotate, e.el, e.em, e.en, v_name, v_name_new   
  options, v_name_new, 'colors', [0, 50, 220]
  options, v_name_new, 'labels', ['V!DL!N', 'V!DM!N', 'V!DN!N']
  ;
  ;
  
  ;
  ;*---------- magnetospehre  ----------*
  ;
  trange = events[i].t_sphere
  events[i].b_sphere  = tmean(b_name_new, trange=trange, dim=1, /nan)

  v_mean = tmean(v_name_new, trange=trange, dim=1, /nan) 
  events[i].v_sphere  = v_mean 
  events[i].ni_sphere = tmean('N_HIA__C3_PP_CIS', trange=trange, /nan) 

  ;
  ;*---------- magnetosheath   ----------*
  ;
  trange = events[i].t_sheath
  events[i].b_sheath  = tmean(b_name_new, trange=trange, dim=1, /nan)
  v_mean = tmean(v_name_new, trange=trange, dim=1, /nan) 
  events[i].v_sheath  = v_mean
  events[i].ni_sheath = tmean('N_HIA__C3_PP_CIS', trange=trange, /nan) 
  ;

  ;
  ;*---------- asymmetric  ----------*
  ;
  b1   = NORM(events[i].b_sphere) * 1.e-9
  b2   = NORM(events[i].b_sheath) * 1.e-9
  rho1 = events[i].ni_sphere * !const.mp * 1.e6
  rho2 = events[i].ni_sheath * !const.mp * 1.e6
  ;
  v_asym = SQRT( b1*b2/!const.mu0 * (b1+b2) / (rho1*b2+rho2*b1) ) * 1.e-3
  events[i].v_asym = v_asym  


  ;
  ;*---------- outflow  ----------*
  ;
  trange = events[i].t_outflow
  events[i].v_out  = tmax(v_name_new, trange=trange, /nan)
endfor



flag = 'save'
@lr_load.pro

end



