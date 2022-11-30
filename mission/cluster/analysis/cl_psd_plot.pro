pro cl_psd_plot, sc, t_cut
cis = obj_new('cis', sc=sc) 
cis->plot_psd, /ion, /mag, /psd, time=t_cut, $
               xrange=[-1500, 1500], yrange=[-1500, 1500], $
               rotation='BV', plotbulk=0
end
