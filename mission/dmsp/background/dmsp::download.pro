 
FUNCTION url_callback, status, progress, data

PRINT, statuc
RETURN, 1

END



;===========================================================+
; ++ NAME ++
PRO dmsp::download, ssj=ssj, ssm=ssm, success, fn
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
;  H.Koike 1/9,2021
;===========================================================+
COMPILE_OPT IDL2
;
;CATCH, error_status
;IF error_status NE 0 THEN BEGIN
;  CATCH, /CANCEL
;	PRINT, !ERROR_STATE.MSG
;	;
;  ourl->GetProperty, RESPONSE_CODE=rc, RESPONSE_HEADER=rh, $
;                     RESPONSE_FILENAME=rf
;  PRINT, '% Response Code = ' + rc
;  PRINT, '% Response Header = ' + rh
;  PRINT, '% Response Filename = ' + rf
;  PRINT, ' '
;  PRINT, '% Request stoped'
;	;
;  OBJ_DESTROY, ourl
;	success=0
;	fn     = ''
;  RETURN
;ENDIF
 

;-------------------------------------------------+
; IDL net url
;-------------------------------------------------+
;
ourl = OBJ_NEW('IDLnetURL')
user = 'IDL' + !VERSION.RELEASE
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


ourl->SetProperty, HEADERS  = 'User_Agent:' + user
dum = ourl->Get(FILENAME=local_file, URL=remote_file)
;
fn = local_file

success = 1

END





