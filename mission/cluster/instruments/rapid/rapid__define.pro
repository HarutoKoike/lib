@rapid::load.pro

FUNCTION rapid::init, _EXTRA=e
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
PRO rapid__define
void = {                    $
        rapid,              $
        INHERITS cluster    $
       }
END
      
