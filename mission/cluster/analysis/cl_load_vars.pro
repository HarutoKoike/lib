
;sc = '3'
;st = '2004-03-10T00:00:00Z'
;et = '2004-03-11T00:00:00Z'
;
;trange = ['2004-03-10/12:00:00', $
;          '2004-03-10/13:00:00']
;timespan, trange
;
;pea = cl_peace(sc=sc, st=st, et=et)
;pea->load
;
;aux = cl_aux(sc=sc, st=st, et=et)
;aux->load
;;
;fgm = cl_fgm(sc=sc, st=st, et=et)
;fgm->load
;;
;cis = cl_cis(sc=sc, st=st, et=et)
;cis->load
;
;
;
;
;;
;time_stamp, /off
;tplot_options, 'title', st
;tplot_options, 'ygap', 0.3
;gap=''
;options, '*', 'labels', gap
;options, '*', 'ytitle', gap
;options, '*', 'ysubtitle', gap

;tnames = [ 'Ion_Omni_Flux__C3', $
;           'N_HIA__C3_PP_CIS',  $
;           'T_HIA__C3_PP_CIS',  $
;           'V_HIA_xyz_gse__C3_PP_CIS', $
;           'B_xyz_gsm__C3_PP_FGM', $
;           'Parallel_electron__C3', $
;           'antiparallel_electron__C3', $
;           'C' + sc + '_CP_CIS-CODIF_PAD_HS_O1_PF']
;;gap = replicate('', n_elements(tnames))
;tplot, tnames
sc = '3'
st = '2004-03-10T00:00:00Z'
et = '2004-03-11T00:00:00Z'

trange = ['2004-03-10/12:00:00', $
          '2004-03-10/13:00:00']
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
time_stamp, /off
tplot_options, 'title', st
tplot_options, 'title', 'Cluster-3/CIS-HIA'
tplot_options, 'ygap', 0.3
gap=''
options, '*', 'labels', gap
;options, '*', 'ytitle', gap
options, '*', 'ysubtitle', gap

tnames = [ 'Ion_Omni_Flux__C3', $
           'N_HIA__C3_PP_CIS',  $
           'T_HIA__C3_PP_CIS',  $
           'V_HIA_xyz_gse__C3_PP_CIS', $
           'B_xyz_gsm__C3_PP_FGM', $
           'Parallel_electron__C3', $
           'antiparallel_electron__C3', $
           'C' + sc + '_CP_CIS-CODIF_PAD_HS_O1_PF']
;gap = replicate('', n_elements(tnames))
;tnames = [ 'Ion_Omni_Flux__C3', $
;tplot, ['Ion_Omni_Flux__C3', 'V_para_perp__C3']
tplot, ['Ion_Omni_Flux__C3', 'V_para_perp__C3']


END
