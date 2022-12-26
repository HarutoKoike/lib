pro cl_psd_plot, sc, t_cut, rotation=rotation, plotbulk=plotbulk, _EXTRA=EX 

if ~keyword_set(plotbulk) then plotbulk=0
if ~keyword_set(rotation) then rotation='BV'
if ~keyword_set(xrange) then xrange=[-1500, 1500]
if ~keyword_set(yrange) then yrange=[-1500, 1500]

cis = obj_new('cis', sc=sc) 
print, t_cut
cis->plot_psd, /ion, /mag,  time=t_cut, $
               xrange=xrange, yrange=yrange, $
               rotation=rotation, plotbulk=plotbulk, _EXTRA=EX
end
