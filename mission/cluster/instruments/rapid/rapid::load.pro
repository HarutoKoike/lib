pro rapid::load
compile_opt idl2


self->GetProperty, st=st, et=et, sc=sc

id = 'C' + sc + '_PP_RAP'
print, id

;
;*---------- download  ----------*
;
suc=1
IF ~self->filetest(id, st, et) THEN $
  self->download, id, st, et, suc
IF ~suc THEN RETURN


;
;*---------- read cdf  ----------*
;
files = self->file_search(id, st, et)
;
cdf2tplot, files, /all


end
