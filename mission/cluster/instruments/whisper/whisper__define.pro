
FUNCTION whisper::init,  _EXTRA=e
;
COMPILE_OPT IDL2
;
self->cluster::SetProperty, _EXTRA=self->cluster::datestruct(_EXTRA=e)
;
RETURN, 1
END



;-------------------------------------------------+
; 
;-------------------------------------------------+
PRO whisper__define
void = {                    $
        whisper,            $
        INHERITS cluster    $
       }
END
