

mytimespan, 2004, 3, 10, 12, 10, dmin=30
cl_all_cis
cl_all_fgm

tnames = ['flux__C1_CP_CIS-HIA_HS_1D_PEF', $
          'flux__C3_CP_CIS-HIA_HS_1D_PEF', $
          'N_HIA_all'                    , $
          'T_HIA_par_all'                , $
          'T_HIA_perp_all'               , $
          'Bx_gsm_all'                   , $
          'By_gsm_all'                   , $
          'Bz_gsm_all'                   , $
          'B_all'                          $
          ]


options, tnames[0], 'ytitle', 'C1'
options, tnames[1], 'ytitle', 'C3'
;
options, tnames[0], 'ztitle', ''
options, tnames[1], 'ztitle', ''
;
options, tnames[0], 'ysubtitle', '[eV]'
options, tnames[1], 'ysubtitle', '[eV]'
;
options, tnames[2], 'ysubtitle', '[cm!U-3!N]'
;
options, tnames[3], 'ysubtitle', '[MK]'
options, tnames[4], 'ysubtitle', '[MK]'
;
options, tnames[5], 'ytitle', 'Bx(GSM)'
options, tnames[6], 'ytitle', 'By(GSM)'
options, tnames[7], 'ytitle', 'Bz(GSM)'
options, tnames[8], 'ytitle', '|B|'
;
options, tnames[5], 'ysubtitle', '[nT]'
options, tnames[6], 'ysubtitle', '[nT]'
options, tnames[7], 'ysubtitle', '[nT]'
options, tnames[8], 'ysubtitle', '[nT]'

tplot_options, 'title', 'Cluster/FGM/CIS 2004-03-10'
tplot_options, 'thick', 3.

ylim, tnames[3], 0, 0, 1
ylim, tnames[4], 0, 0, 1

popen, '~/step1' 

;mypsplot, /open_ps, fn='step1.eps', fp='~', xs=15, ys=20
tplot, tnames
tplot_apply_databar
time_stamp, /off
;mypsplot, /close_ps

pclose
end
