 
sc = '3'
st = '2004-03-10T00:00:00Z'
et = '2004-03-11T00:00:00Z'

trange = ['2004-03-10/12:20:00', $
          '2004-03-10/12:35:00']
timespan, trange

pea = cl_peace(sc=sc, st=st, et=et)
pea->load

aux = cl_aux(sc=sc, st=st, et=et)
aux->load

fgm = cl_fgm(sc=sc, st=st, et=et)
fgm->load
;
cis = cl_cis(sc=sc, st=st, et=et)
cis->load




;
mypsplot, /open_ps, fp='~/tex', fn='figure4.eps', xs=20, ys=10
time_stamp, /off
loadct, 0
;tplot_options, 'title', 'Cluster-3/CIS-HIA'
tplot_options, 'title', ''
tplot_options, 'ygap', 0.3
gap=''
options, '*', 'labels', gap
;options, '*', 'ytitle', gap
options, '*', 'ysubtitle', gap

tnames = ['Ion_Omni_Flux__C3', 'V_para_perp__C3']


options, tnames[1], 'colors', [0, 150]
zlim, tnames[0], 1.e4, 5e8, 1

options, tnames, 'ytitle', ''
options, tnames[1], 'databar', {yval:0}

!p.thick=3.5
tplot_options, 'var_label', ''
tplot, tnames
;tplot_apply_databar


mypsplot, /close_ps

END   
