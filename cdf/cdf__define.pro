@cdf::info.pro



;
;*----------   ----------*
;
FUNCTION cdf::init
COMPILE_OPT IDL2
;
RETURN, 1
END



;
;*----------   ----------*
;
PRO cdf::SetProperty, filename=filename, info=info
;
COMPILE_OPT IDL2
;
IF KEYWORD_SET(filename) THEN BEGIN
    self.filename = filename
    ;
    ; initial process
    IF FILE_TEST(filename) THEN BEGIN
        self.id = CDF_OPEN(filename) 
        self->info
        self.is_connected = 1
    ENDIF
ENDIF
;
IF KEYWORD_SET(info) THEN self.info = info
;
END



;
;*----------   ----------*
;
PRO cdf::GetProperty, filename=filename, id=id, is_connected=is_connected, info=info
COMPILE_OPT IDL2
;
IF ARG_PRESENT(filename)  THEN filename = self.filename
IF ARG_PRESENT(id)        THEN id = self.id
IF ARG_PRESENT(connected) THEN is_connected = self.is_connected
IF ARG_PRESENT(info)      THEN info = self.info
;
END



;
;*----------   ----------*
;
PRO cdf::delete
COMPILE_OPT IDL2
IF self.id NE 0 THEN CDF_CLOSE, id
OBJ_DESTROY, self
END



;===========================================================+
; ++ NAME ++
PRO cdf__define
;
; ++ PURPOSE ++
;  -->
;
; ++ POSITIONAL ARGUMENTS ++
;  -->
;
; ++ KEYWORDS ++
; -->
;
; ++ CALLING SEQUENCE ++
;  -->
;
; ++ HISTORY ++
;===========================================================+
COMPILE_OPT IDL2
void = {cdf,                      $
        filename     : ''  ,      $
        is_connected : 0   ,      $
        id           : 0L  ,      $
        info         : PTR_NEW(), $
        INHERITS IDL_OBJECT       $
       }

END
