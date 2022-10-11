;===========================================================+
; ++ NAME ++
;  --> cl_fgm__define.pro
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
;  H.Koike 10/10,2021
;===========================================================+


FUNCTION cl_fgm::init, _EXTRA=e
;
COMPILE_OPT IDL2
;
self->cluster::setprop, _EXTRA=cluster->datestruct(_EXTRA=e)
;
RETURN, 1
END



;-------------------------------------------------+
; 
;-------------------------------------------------+
PRO cl_fgm__define
void = {                    $
        cl_fgm,             $
        INHERITS cluster    $
       }
END

