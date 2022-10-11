

@lr_events.pro

for i = 0, 9 do begin
  timespan, events[i].t_event
  cis = cl_cis()
  cis->setprop, sc=3
  cis->slice2d_plot, /hs, /mag, /ion, /pef, events[i].t_event[0]
  ;cluster->load_vars, 3
endfor


end
