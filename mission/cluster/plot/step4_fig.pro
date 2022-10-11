
mytimespan ,2004, 3, 10, 12, 20, dmin=20

sta = cl_staff(sc=3)
sta->load
;;
cl_fgm->curlometer


tnames = [$;'|divB|/|curlB|', $
          '|J|'           , $
          'ACOS(JB)'      , $
          'EdotJ'         , $
          'BB_xx_st2__C3_CP_STA_PSD', $
          'BB_yy_st2__C3_CP_STA_PSD', $
          'BB_zz_st2__C3_CP_STA_PSD', $
          'EE_xx_sr2__C3_CP_STA_PSD', $
          'EE_yy_sr2__C3_CP_STA_PSD'  $
          ]

options, '*', 'ztitle', ' '
options, tnames[0], 'thick', 2.5
options, tnames[1], 'thick', 2.5
options, tnames[2], 'thick', 2.5

;popen, '~/step4', xs=8, ys=8
tplot, tnames
tplot_apply_databar
time_stamp, /off
;pclose




;popen, '~/step4_appendix', xs=8, ys=6
;tnames= [ '|divB|/|curlB|', $
;         'sc_config_QG__CL_SP_AUX', $
;         ;'sc_config_QR__CL_SP_AUX' , $
;         'sc_dr_min__CL_SP_AUX', $
;         'sc_dr_max__CL_SP_AUX']
;for i = 0, n_elements(tnames) -1 do begin
;  options, tnames[i], 'ytitle', '' 
;  options, tnames[i], 'ysubtitle', ''
;endfor
;tplot, tnames
;tplot_apply_databar
;pclose


end
