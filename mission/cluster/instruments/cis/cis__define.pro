@cis::load.pro
@cis::instrument.pro
@cis::slice2d_plot.pro
;
FUNCTION cis::init, _EXTRA=e
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
PRO cis__define
void = {                    $
        cis,                $
        INHERITS cluster    $
       }
END
