
mytimespan, 2004, 3, 10, 12, dhr=1

cluster->fote
get_data, 'FOTE_coefficients', date=coeff
;
ts  = '2004-03-10/12:27:00'
idx = nn('FOTE_coefficients', ts)
;
help, coeff
;ptr   = OBJ_NEW('PTR')
;ptr->store, 'fote_coefficients', coeff.Y[idx]


end
