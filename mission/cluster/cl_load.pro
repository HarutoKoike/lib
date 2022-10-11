 
sc = 3
mytimespan, 2004, 3, 10, 12, 20, dmin=20
cluster->load_vars, sc, /all 

;tn = cluster->tplot_names(/ion, /mag, /electron,  sc)
;idx = [0, 1, 2, 6, 3, 4, 5]


;popen, '~/test_cl';, xs=30, ys=30
;tplot, tn[idx]                 
;tplot_apply_databar
;
;pclose




end
