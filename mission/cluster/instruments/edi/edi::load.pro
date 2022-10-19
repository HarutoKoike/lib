PRO edi::load
;
COMPILE_OPT IDL2
;
;*---------- dattaset id  ----------*
;
self->getprop, st=st, et=et, sc=sc
id = 'C' + sc + '_PP_EDI'


;
;*---------- download  ----------*
;
;
suc = 1
IF ~self->filetest(id, st, et) THEN $
  self->download, id, st, et, suc
IF ~suc THEN RETURN

 
;
;*---------- read cdf  ----------*
;
files = self->file_search(id, st, et)
;
cdf2tplot,files, /all     

END
