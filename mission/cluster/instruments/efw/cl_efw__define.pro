;===========================================================+
; ++ NAME ++
;  --> cl_efw__define.pro
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


FUNCTION cl_efw::init, _EXTRA=e
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
PRO cl_efw__define
void = {                    $
        cl_efw,             $
        INHERITS cluster    $
       }
END
 
