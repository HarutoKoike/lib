

PRO dmsp::tplotvar

COMPILE_OPT IDL2


d = self->GetData()
t = d.t
;----------------------------------------------------------------+
; corrdinates
;----------------------------------------------------------------+
store_data, 'GLAT', data = {x:t, y:d.glat}
store_data, 'GLON', data = {x:t, y:d.glon}
store_data, 'MLT' , data = {x:t, y:d.mlt}
store_data, 'MLAT_AACGM', data = {x:t, y:d.mlat}
store_data, 'MLON_AACGM', data = {x:t, y:d.mlon}
var_label_str = ['MLAT_AACGM', 'MLT']
tplot_options, var_label=var_label_str



;----------------------------------------------------------------+
; SSM magnetic field
;----------------------------------------------------------------+
;
;*---------- magtetic field  ----------*
;
; bx 
store_data, 'Bx', data = {x:t, y:d.bx} 
options, 'Bx', ytitle = 'Bx(nT)' 

; by 
store_data, 'By', data = {x:t, y:d.by} 
options, 'By', ytitle = 'By[nT]' 

; bz 
store_data, 'Bz', data = {x:t, y:d.bz} 
options, 'Bz', ytitle = 'Bz[nT]' 

; delta bz ( bz - IGRF bz)
store_data, 'deltaBz', data = {x:t, y:d.dbz} 
options, 'deltaBz', ytitle = 'Bz - IGRF_Bz [nT]' 

; delta by ( by - IGRF by)
store_data, 'deltaBy', data = {x:t, y:d.dby} 
options, 'deltaBy', ytitle = 'By - IGRF_By [nT]' 

; delta bx ( bx - IGRF bx)
store_data, 'deltaBx', data = {x:t, y:d.dbx} 
options, 'deltaBx', ytitle = 'Bx - IGRF_Bx [nT]' 

;----------------------------------------------------------------+
;	SSJ partiacle data 
;----------------------------------------------------------------+
;
;*---------- total number flux  ----------*
;
; ion total energy flux
store_data, 'JETOTI', data = {x:t, y:d.jetoti}
ylim, 'JETOTI', 1.e9, 1.e13, 1
options, 'JETOTI', ysubtitle = '(eV/cm !U2!Ns sr)'
options, 'JETOTI', 'ytitle', 'TOTAL ION !C ENERGY FLUX'

; ion total number flux
store_data, 'JTOTI', data = {x:t, y:d.jtoti}
ylim, 'JTOTI',0 , 0, 1
options, 'JTOTI', ysubtitle = '(1/cm !U2!Ns sr)'
options, 'JTOTI', 'ytitle', 'TOTAL ION !C NUMBER FLUX'

; ion 948eV energy flux
ion1kev = REFORM( d.jei[9, *] )
store_data, 'ion1kev', data = {x:t, y:ion1kev}
ylim, 'ion1kev', 0, 0, 1
options, 'ion1kev', 'ytitle', '948eV_ION !C ENERGY_FLUX'
options, 'ion1kev', ysubtitle = '(eV/eV cm!U2 !N s sr)'

;electron total energy flux
store_data, 'JETOTE', data = {x:t, y:d.jetote}
ylim, 'JETOTE', 0, 1.e13, 1
options, 'JETOTE', ysubtitle = '(eV/ cm!U2!Ns sr)'
options, 'JETOTE', 'ytitle' , 'ELE TOTAL ENERGY FLUX'

;electron total number flux
store_data, 'JTOTE', data = {x:t, y:d.jtote}
ylim, 'JTOTE',0 , 0, 1
options, 'JTOTE', ysubtitle = '(1/cm!U2!Ns sr)'
options, 'JTOTE', 'ytitle' , 'ELE TOTAL NUMBER FLUX'

;
;*---------- average energy  ----------*
;
; ion average energy
store_data, 'E_ave_ion', data = {x:t, y:d.ei}
ylim, 'E_ave_ion', 1.e1, 1.e5, 1
options, 'E_ave_ion', 'ytitle', $
				 'ION AVERAGE ENERGY'
options, 'E_ave_ion', ysubtitle = '(eV)'

; electron average energy
store_data, 'E_ave_electron', data = {x:t, y:d.ee}
ylim, 'E_ave_electron', 0, 0, 1
options, 'E_ave_electron', 'ytitle', $
				 'ELECTRON AVERAGE ENERGY'
options, 'E_ave_electron', ysubtitle = '(eV)'

; ion & electron average energy
store_data, 'E_ave', data = ['E_ave_ion', 'E_ave_electron']
options, 'E_ave', 'ytitle', $
				 'AVERAGE !C ENERGY'
options, 'E_ave', ysubtitle = '(eV)'
options, 'E_ave', linestyles = [0,0] ; 0 ; solid 
options, 'E_ave_electron', 'colors', 220
options, 'E_ave_ion', 'labels', 'ion'
options, 'E_ave_electron', 'labels', 'electron'
ylim, 'E_ave', 1.e1, 1.e5, 1
  
;
;*---------- differential energy flux ----------*
;
; ion defferential energy flux
ion_lim_low = 3.
ion_lim_up = 8.
jei = alog10(transpose(d.jei))
jei[where(jei LE ion_lim_low)] = 0
str_element,dlim,'spec',1,/add 
store_data, 'ION'  , data = {x:t, y:jei, v:d.ebin}, dlim=dlim
ylim, 'ION', 30., 3.e4, 1
zlim, 'ION', ion_lim_low, ion_lim_up
options, 'ION', ysubtitle = '(eV)'
;options, 'ION', 'ztitle', $
;				 'LOG ENERGY FLUX !C [eV/eV cm!U2 !N s sr]'

; electron defferential energy flux
electron_lim_low = 5.
electron_lim_up = 10.
jee = alog10( transpose(d.jee) )
jee[ where(jee le electron_lim_low) ] = 0
store_data, 'ELECTRON', data = {x:t, y:jee, v:d.ebin}, dlim=dlim
ylim, 'ELECTRON', 30, 3.e4,  1
zlim, 'ELECTRON', electron_lim_low, electron_lim_up
options, 'ELECTRON', ysubtitle = '(eV)'
options, 'ELECTRON', 'ztitle', $
				 'LOG ENERGY FLUX !C (eV/eV cm!U2 !N s sr)'
				 

;----------------------------------------------------------------+
; settings
;----------------------------------------------------------------+
options, ['ION', 'ELECTRON'], no_interp = 1	
tplot_options, 'yticklen', -0.01
tplot_options, 'num_lab_min', 5  
time_stamp, /off



d = 0

END


 
