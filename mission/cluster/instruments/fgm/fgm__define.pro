@fgm::load.pro
@fgm::fote.pro
@fgm::curlometer.pro

FUNCTION fgm::init, _EXTRA=e
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
PRO fgm__define
void = {                    $
        fgm,                $
        INHERITS cluster    $
       }
END

