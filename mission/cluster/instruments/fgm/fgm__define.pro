@fgm::load.pro

FUNCTION fgm::init, _EXTRA=e
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
PRO fgm__define
void = {                    $
        fgm,                $
        INHERITS cluster    $
       }
END

