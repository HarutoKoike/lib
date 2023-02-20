PRO omni_setting, res5min=res5min, tnames

res = '1min'
IF KEYWORD_SET(res5min) THEN res = '5min'



;
;*---------- IMF ----------*
;
; bx
bx = 'OMNI_HRO_' + res + '_BX_GSE'
options, bx, 'ytitle', 'B!DX!N (GSM)'
options, bx, 'ysubtitle', '[nT]'
options, bx, 'databar', {yval:0, linestyle:2}
; by
by = 'OMNI_HRO_' + res + '_BY_GSM'
options, by, 'ytitle', 'B!DY!N (GSM)'
options, by, 'ysubtitle', '[nT]'
options, by, 'databar', {yval:0, linestyle:2}
; bz
bz = 'OMNI_HRO_' + res + '_BZ_GSM'
options, bz, 'ytitle', 'B!DZ!N (GSM)'
options, bz, 'ysubtitle', '[nT]'
options, bz, 'databar', {yval:0, linestyle:2}


;
;*---------- velocity  ----------*
;
; vx
vx = 'OMNI_HRO_' + res + '_Vx'
options, vx, 'ytitle', 'V!DX!N (GSE)'
options, vx, 'ysubtitle', '[km/s]'
options, vx, 'databar', {yval:0, linestyle:2}
options, vx, 'label', 'V!DX!N'

; vy
vy = 'OMNI_HRO_' + res + '_Vy'
options, vy, 'ytitle', 'V!DY!N (GSM)'
options, vy, 'ysubtitle', '[km/s]'
options, vy, 'databar', {yval:0, linestyle:2}
options, vy, 'label', 'V!DY!N'
; vz
vz = 'OMNI_HRO_' + res + '_Vz'
options, vz, 'ytitle', 'V!DZ!N (GSM)'
options, vz, 'ysubtitle', '[km/s]'
options, vz, 'databar', {yval:0, linestyle:2}
options, vz, 'label', 'V!DZ!N'
; v
v = 'OMNI_HRO_' + res + '_Velocity'
get_data, vx, data=vxd
get_data, vy, data=vyd
get_data, vz, data=vzd
store_data, v, data={x:vxd.x, y:[[vxd.y], [vyd.y], [vzd.y]]}
options, v, 'colors', [230, 140, 50]
options, v, 'labels', ['V!DX!N', 'V!DY!N', 'V!DZ!N']
options, v, 'ytitle', 'V!DSW!N'
options, v, 'ysubtitle', '[km/s]'
options, v, 'databar', {yval:0, linestyle:2}
;
; |v|
vmag = 'OMNI_HRO_'+res+'_flow_speed'
options, vmag, 'ytitle', 'Flow Speed'
options, vmag, 'ysubtitle', '[km/s]'


;
;*---------- density  ----------*
;
n = 'OMNI_HRO_' + res + '_proton_density'
options, n, 'ytitle', 'Density'
options, n, 'ysubtitle', '[cm!U-3!N]'
ylim, n, 0, 0, 0


;
;*---------- dynamic pressure  ----------*
;
pdyn = 'OMNI_HRO_' + res + '_Pressure'
options, pdyn, 'ytitle', 'P!Ddyn!N'
options, pdyn, 'ysubtitle', '[nPa]'


;
;*---------- beta  ----------*
;
beta = 'OMNI_HRO_' + res + '_Beta'
options, beta, 'ytitle', 'Beta'
ylim, 0, 0, /log



;
;*---------- Mach num  ----------*
;                    
get_data, 'OMNI_HRO_'+res+'_Mach_num', data=ma
get_data, 'OMNI_HRO_'+res+'_Mgs_mach_num', data=ms
;
m = 'OMNI_HRO_1min_Mach_number'
store_data, m, data={x:ma.x, y:[ [ma.y], [ms.y] ]}
options, m, 'ytitle', 'Alfven/Magnetosonic!CMach Number'
options, m, 'labels', ['M!DA!N', 'M!DS!N']
options, m, 'colors', [230, 50]


tnames = [bx, by, bz, v, vmag, n, pdyn, beta, m]

END
