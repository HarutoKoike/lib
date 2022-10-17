FUNCTION url_callback, status, progress, data
PRINT, status
RETURN, 1
END
 
;===========================================================+
; ++ NAME ++
PRO cluster::authentication, renew =renew
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
COMPILE_OPT IDL2, STATIC
;
;
cl       = OBJ_NEW('cluster')
cl->getprop, username=username, password=password
OBJ_DESTROY, cl 
;
root = GETENV('HOME')
log  = FILEPATH('.csa_log', ROOT=root)

;
last_login = 0d
elasped    = 3600D / 86400D
format     = '(F20.11)'
;
IF ~FILE_TEST(log) THEN BEGIN
    OPENW, lun, log, /GET_LUN
    PRINTF, lun, JULDAY(1, 1, 2000), format=format    
    CLOSE, lun
ENDIF  

;
OPENR, lun, log, /GET_LUN
READF, lun, last_login, FORMAT=format 
CLOSE, lun
;
now = SYSTIME(/JUL)
PRINT, '% Last login : ' + date->julday2iso(last_login)
IF (now - last_login LT elasped) AND ~KEYWORD_SET(renew) THEN $
  RETURN


;
;
;*---------- Error handle  ----------*
;
CATCH, error_status
IF error_status NE 0 THEN BEGIN
	CATCH, /CANCEL
    MESSAGE, !ERROR_STATE.MSG
    ;
	ourl->GetProperty, RESPONSE_CODE=rc, RESPONSE_HEADER=rh, $
										 RESPONSE_FILENAME=rf
    ;
	PRINT, '% Response Code = ' + rc
	PRINT, '% Response Header = ' + rh
	PRINT, '% Response Filename = ' + rf
	PRINT, '% Request stoped'
	OBJ_DESTROY, ourl
	RETURN
ENDIF



;
;*---------- HTTP request  ----------*
;
url_host = 'csa.esac.esa.int'
url_path = 'csa-sl-tap/login'
user_agent = 'IDL' + !VERSION.RELEASE
;
ourl = OBJ_NEW('IDLnetUrl')
ourl->SetProperty, /VERBOSE
ourl->SetProperty, AUTHENTICATION=3
ourl->SetProperty, URL_SCHEME = 'https'
ourl->SetProperty, URL_HOST  = url_host
ourl->SetProperty, URL_PATH  = url_path
ourl->SetProperty, URL_USERNAME=username
ourl->SetProperty, URL_PASSWORD=password
ourl->SetProperty, HEADERS   = 'User-Agent:<' + user_agent + '>'
;
filename = ourl->GET()
OBJ_DESTROY, ourl
last_login = SYSTIME(/JUL)


;
;*---------- renew login history  ----------*
;                        nceIs#1
OPENW, lun, log, /GET_LUN
PRINTF, lun, last_login, FORMAT=format
CLOSE, lun
 

PRINT, '% login completed'
END
