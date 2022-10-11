



disc=1
while disc do begin
  ctime, t
  ;help, t
  if ~isa(cis) then cis = cl_cis(sc=3)
  ;cis->slice2d_plot, /ion, /hs, /mag, /pef, time_string(t[-1])
  cis->slice2d_plot, /ion, /hs, /mag, /pef, trange=t[-1], xrange=xrange, $
                     yrange=yrange, ycharsize=1.2, xcharsize=1.2, charsize=1.2
  read, disc, prompt='% do:1, end:0 ENTER:'
endwhile
;




end
