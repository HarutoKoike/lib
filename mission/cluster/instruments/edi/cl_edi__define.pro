;===========================================================+
; ++ NAME ++
;  --> cl_edi__define.pro
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
FUNCTION cl_edi::init, _EXTRA=e
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
PRO cl_edi__define
void = {                    $
        cl_edi,             $
        INHERITS cluster    $
       }
END
 
