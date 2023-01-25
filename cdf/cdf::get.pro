;===========================================================+
; ++ NAME ++
PRO cdf::get, var, data=data
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
self->varinfo, varname=var, info
IF ~ISA(info) THEN RETURN


CDF_VARGET, self.id, info.name, data, REC_COUNT = info.maxrec
data = REFORM(data)
END
