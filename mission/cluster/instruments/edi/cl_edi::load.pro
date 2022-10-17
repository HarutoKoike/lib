;===========================================================+
; ++ NAME ++
PRO cl_edi::load
;
; ++ PURPOSE ++
;  -->
;
; ++ POSITIONAL ARGUMENTS ++
;  -->
;
; ++ KEYWORDS ++
; -->
;
; ++ CALLING SEQUENCE ++
;  -->
;
; ++ HISTORY ++
;  H.Koike 1/9,2021
;===========================================================+
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
files = self->filesearch(id, st, et)
;
cdf2tplot,files, /all     


END



;mytimespan, 2004, 3, 10, 12, dhr=1
;edi = cl_edi(sc=3)
;edi->load
;end




