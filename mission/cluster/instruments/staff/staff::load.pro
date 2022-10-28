PRO staff::load

COMPILE_OPT IDL2
;
;*---------- setting  ----------*
;
self->cluster::GetProp, st=st, et=et, sc=sc

;
;*---------- dataset id  ----------*
;
id = 'C' + sc + '_CP_STA_PSD'



;
;*---------- download  ----------*
;
suc = 1
IF ~self->cluster::filetest(id, st, et) THEN $
  self->cluster::download, id, st, et, suc
IF ~suc THEN RETURN


;
;*---------- read cdf  ----------*
;
files = self->cluster::file_search(id, st, et)
;
foreach fn, files do $
  cdf2tplot, fn, /all
 

;
;*---------- magnetic field ----------*
;
tname = 'BB_xxyyzz_sr2__C' + sc + '_CP_STA_PSD'
get_data, tname, data=d, dlim=dlim
;
IF SIZE(d, /TYPE) EQ 2 THEN BEGIN
    GOTO, SKIP1
ENDIF
;
del_data, tname
;
str_element, dlim, 'SPEC', 1, /add
;
; X 
tname = 'BB_xx_st2__C' + sc + '_CP_STA_PSD'
store_data, tname, data={x:d.x, y:REFORM(d.y[*, 0, *]), v:d.v}, dlim=dlim
zlim, tname, 0, 0, 1
ylim, tname, d.v[0], d.v[-1]
;
options, tname, 'ytitle', 'Bx'
options, tname, 'ysubtitle', '[nT!U2!N/Hz]' 
;
;
; Y
tname = 'BB_yy_st2__C' + sc + '_CP_STA_PSD'
store_data, tname, data={x:d.x, y:REFORM(d.y[*, 1, *]), v:d.v}, dlim=dlim
zlim, tname, 0, 0, 1
ylim, tname, d.v[0], d.v[-1]
options, tname, 'ytitle', 'By'
options, tname, 'ysubtitle', '[nT!U2!N/Hz]' 
;
;
; Z 
tname = 'BB_zz_st2__C' + sc + '_CP_STA_PSD'
store_data, tname, data={x:d.x, y:REFORM(d.y[*, 2, *]), v:d.v}, dlim=dlim
zlim, tname, 0, 0, 1
ylim, tname, d.v[0], d.v[-1]
options, tname, 'ytitle', 'Bz'
options, tname, 'ysubtitle', '[nT!U2!N/Hz]' 
;
;
; total
tname = 'BSUM__C' + sc + '_CP_STA_PPP'
get_data, tname, dlim=dlim
str_element, dlim, 'spec', 1, /add
store_data, tname, dlim=dlim
;
ylim, tname, d.v[0], d.v[-1], 1
zlim, tname, 0, 0, 1
;
options, tname, 'ytitle', 'B_total' 
options, tname, 'ysubtitle', '[nT!U2!N/Hz]' 




;
;*---------- electric field  ----------*
;
SKIP1:
;
tname = 'EE_xxyy_sr2__C' + sc + '_CP_STA_PSD'
get_data, tname, data=d, dlim=dlim
;
IF SIZE(d, /TYPE) EQ 2 THEN RETURN
;
;
del_data, tname
;
str_element, dlim, 'SPEC', 1, /add
;
; X
tname = 'EE_xx_sr2__C' + sc + '_CP_STA_PSD'
store_data, tname, data={x:d.x, y:REFORM(d.y[*, 0, *]), v:d.v}, dlim=dlim
zlim, tname, 0, 0, 1
ylim, tname, d.v[0], d.v[-1]
;
options, tname, 'ytitle', 'Ex'
options, tname, 'ysubtitle', '[(mV/m)!U2!N/Hz]' 
;
;
; Y
tname = 'EE_yy_sr2__C' + sc + '_CP_STA_PSD'
store_data, tname, data={x:d.x, y:REFORM(d.y[*, 1, *]), v:d.v}, dlim=dlim
zlim, tname, 0, 0, 1
ylim, tname, d.v[0], d.v[-1]
options, tname, 'ytitle', 'Ey'
options, tname, 'ysubtitle', '[(mV/m)!U2!N/Hz]' 
;
;
; total
tname = 'ESUM__C' + sc + '_CP_STA_PPP'
get_data, tname, dlim=dlim
str_element, dlim, 'spec', 1, /add
store_data, tname, dlim=dlim
;
ylim, tname, d.v[0], d.v[-1], 1
zlim, tname, 0, 0, 1
;
options, tname, 'ytitle', 'E_total' 
options, tname, 'ysubtitle', '[(mV/m)!U2!N/Hz]' 
 


;
;*---------- polarization angle  ----------*
;
tname = 'POLSVD__C' + sc + '_CP_STA_PPP'
options, tname, 'spec', 1
;
ylim, tname, 8, 4000., 1
options, tname, 'ytitle', 'polarization'
options, tname, 'ysubtitle', ''
;
;
;
;;
;;*---------- ellipcity  ----------*
;;
tname = 'ELLSVD__C' + sc + '_CP_STA_PPP'
options, tname, 'spec', 1
;
ylim, tname, 8, 4000., 1
options, tname, 'ytitle', 'ellipcity'
options, tname, 'ysubtitle', ''
;
;
;
;*---------- plopagetion  ----------*
;
tname = 'THSVD_mfa__C' + sc + '_CP_STA_PPP'
options, tname, 'spec', 1
;
ylim, tname, 8, 4000., 1
options, tname, 'ytitle', 'propagetion'
options, tname, 'ysubtitle', '[deg]'



END
