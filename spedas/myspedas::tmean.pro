;===========================================================+
; ++ NAME ++
FUNCTION myspedas::tmean, tname, trange=trange, _EXTRA=ex
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
;  H.Koike 
;===========================================================+
COMPILE_OPT IDL2, STATIC
;
IF ~KEYWORD_SET(trange) THEN get_timespan, trange
data = myspedas->tclip_data(tname, trange)
;
RETURN, MEAN(data, _EXTRA=ex)
END
