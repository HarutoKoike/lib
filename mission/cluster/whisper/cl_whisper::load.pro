;===========================================================+
; ++ NAME ++
PRO cl_whisper::load
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
;*---------- dataset id ----------*
;
self->GetProp, st=st, et=et, sc=sc 
id = 'C' + sc + '_CP_WHI_ACTIVE' 



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



;
;*---------- options  ----------*
;
tname = 'Electric_Spectral_Power_Density__' + id
;
get_data, tname, dlim=dlim , data=d
str_element, dlim, 'SPEC', 1, /add
store_data, tname, dlim=dlim
;
ylim, tname, 2, 80
zlim, tname, 0, 0, 1
;
options, tname, 'ytitle', 'E_pow'

END
 
