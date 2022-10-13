FUNCTION url_callback, status, progress, data
PRINT, status
RETURN, 1
END




PRO dmsp::download, ssj=ssj, ssm=ssm, success, local_file
;
COMPILE_OPT IDL2
;
success = 0
CATCH, error_status
IF error_status NE 0 THEN BEGIN
    CATCH, /CANCEL
	PRINT, !ERROR_STATE.MSG
	;
    ourl->GetProperty, RESPONSE_CODE=rc, RESPONSE_HEADER=rh, $
                       RESPONSE_FILENAME=rf
    PRINT, '% Response Code = ' + rc
    PRINT, '% Response Header = ' + rh
    PRINT, '% Response Filename = ' + rf
    PRINT, ' '
    PRINT, '% Request stoped'
	;
    OBJ_DESTROY, ourl
    success=0
    fn     = ''
    RETURN
ENDIF
 

;
;*----------   ----------*
;
IF KEYWORD_SET(ssj) THEN $
    PRINT, '% Download DMSP SSJ DATA' 
IF KEYWORD_SET(ssm) THEN $
    PRINT, '% Download DMSP SSM DATA' 
;
date = '% Year: ' + STRING(self.yr, FORMAT='(I04)') + ' Month: ' + $
       STRING(self.mon, FORMAT='(I02)') + ' Day: ' + STRING(self.dy, FORMAT='(I02)')
PRINT, date

;-------------------------------------------------+
; IDL net url
;-------------------------------------------------+
ourl = OBJ_NEW('IDLnetURL')
;user = 'IDL' + !VERSION.RELEASE
;
IF KEYWORD_SET(ssj) THEN BEGIN
	remote_file = self->fileurl(/ssj)
	local_file  = self->filename(/ssj)
ENDIF
IF KEYWORD_SET(ssm) THEN BEGIN
	remote_file = self->fileurl(/ssm)
	local_file  = self->filename(/ssm)
ENDIF
;

dum = ourl->Get(URL=remote_file, FILENAME=local_file)
;
success = 1
END
