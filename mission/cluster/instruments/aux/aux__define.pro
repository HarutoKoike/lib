@aux::load.pro
@aux::plot_configuration.pro

FUNCTION aux::init, _EXTRA=e
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
PRO aux__define
void = {                    $
        aux,                $
        INHERITS cluster    $
       }
END
