@efw::load.pro

FUNCTION efw::init, _EXTRA=e
;
COMPILE_OPT IDL2
;
self->cluster::SetProperty, _EXTRA=self->cluster::input(_EXTRA=e)
;
RETURN, 1
END



;-------------------------------------------------+
; 
;-------------------------------------------------+
PRO efw__define
void = {                    $
        efw,                $
        INHERITS cluster    $
       }
END
 
