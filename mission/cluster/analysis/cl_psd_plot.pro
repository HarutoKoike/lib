pro cl_psd_plot, sc, t_cut
;mytimespan, 2004, 3, 10, 12, dhr=1
cis = obj_new('cis', sc=sc) 
;trange=['2004-03-10/12:20:00', '2004-03-10/12:44:00']
cis->plot_psd, /ion, /mag, /psd, time=t_cut, $
               xrange=[-1500, 1500], yrange=[-1500, 1500], $
               rotation='BV', plotbulk=0
               
end
