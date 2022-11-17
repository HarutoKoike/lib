@cis::load.pro
@cis::instrument.pro
@cis::plot_psd.pro
;
FUNCTION cis::init, _EXTRA=e
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
PRO cis__define
void = {                    $
        cis,                $
        INHERITS cluster    $
       }
END
