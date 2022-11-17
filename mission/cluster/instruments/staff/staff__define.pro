
@staff::load.pro

FUNCTION staff::init, _EXTRA=e
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
PRO staff__define
void = {                    $
        staff,              $
        INHERITS cluster    $
       }

END
 

 
