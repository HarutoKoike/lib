@aux::load.pro

FUNCTION aux::init, _EXTRA=e
;
COMPILE_OPT IDL2
;
self->cluster::setprop, _EXTRA=cluster->input(_EXTRA=e)
;
RETURN, 1
END


;-------------------------------------------------+
; 
;-------------------------------------------------+
PRO aux__define
void = {                    $
        aux,                $
        INHERITS cluster    $
       }
END
 