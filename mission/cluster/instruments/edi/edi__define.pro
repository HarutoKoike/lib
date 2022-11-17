@edi::load.pro

FUNCTION edi::init, _EXTRA=e
;
COMPILE_OPT IDL2
;
self->cluster::setprop, _EXTRA=self->cluster::input(_EXTRA=e)
;
RETURN, 1
END
 
;-------------------------------------------------+
; 
;-------------------------------------------------+
PRO edi__define
void = {                    $
        edi,                $
        INHERITS cluster    $
       }
END
 
