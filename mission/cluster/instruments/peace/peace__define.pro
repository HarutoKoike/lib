@peace::load.pro

FUNCTION peace::init, _EXTRA=e
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
PRO peace__define
;
void = {                 $
        peace,           $
        INHERITS cluster $
       }

END
