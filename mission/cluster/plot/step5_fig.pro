

flag = 'restore'
@lr_load


mytimespan, 2004, 3, 10, 12, 20, dmin=20
;cluster->load_vars, 3, /fgm, /efw


ename = 'E_xyz_GSE__C3_EFW'
bname = 'B_xyz_gse__C3_PP_FGM'
xyz   = 'pos_gse_c3'

tmva, ename, tname_mag=bname, events[0].t_mva
tmva, bname, tname_mag=bname, events[0].t_mva
tmva, xyz,   tname_mag=bname, events[0].t_mva, newname='pos_LMN_c3'

ename = ename + '_LMN'
split_vec, ename

bname = bname + '_LMN'
;
options, ename, 'colors', [0, 50, 220]
options, bname, 'colors', [0, 50, 220]
options, bname, 'databar', {yval:0, linestyle:2}

options, ename+'_z', 'colors', 0
options, ename+'_z', 'databar', {yval:0, linestyle:2}

;tplot, [bname, ename+'_z']


get_data, ename, data=e



trange = ['2004-03-10/12:21:56', '2004-03-10/12:27:24']
tinterpol, 'pos_LMN_c3', ename + '_z', suffix='_interp_E' 
get_data, 'pos_LMN_c3_interp_E', data=r
;
tsmooth_in_time, ename + '_z', 30.
get_data, ename + '_z_smoothed', data=ez


idx = nn('pos_LMN_c3_interp_E', trange)

rn = reform(r.y[idx[0]:idx[1], 2])
ez = -abs(ez.y[idx[0]:idx[1]])

cluster->common_var, re=re
dn = (rn[1:-1] - rn[0:-2]) * re * 1.e3
;
volt = total(dn*ez[0:-2]*1.e-3)
va = sqrt(2*!const.e*abs(volt)/!const.mp)*1.e-3
;

print, (rn[-1] - rn[0])*re
print, inertial_length(7)
print, inertial_length(7, /electron)
print, va
print, velo2ev(va)
print, alfven(10, 50)
 

tnames = [bname,                 $ 
          ename + '_z_smoothed']


options, tnames[1], 'databar', {yval:0, linestyle:2}
options, tnames[0], 'ytitle', 'B(LMN)'
options, tnames[0], 'ysubtitle', '[nT]'
options, tnames[1], 'ytitle', 'E!DN!U'
options, tnames[1], 'ysubtitle', '[mV/m]'
tplot_options, 'title', 'Cluster3'
time_stamp, /off

mypsplot, /open_ps, fp='~', fn='step5.eps', xs=20, ys=12
tplot_options, 'thick', 2.5
tplot, tnames
tplot_apply_databar
timebar, trange
mypsplot, /close_ps
          


end





