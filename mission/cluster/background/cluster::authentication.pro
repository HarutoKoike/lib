FUNCTION url_callback, status, progress, data
PRINT, status
RETURN, 1
END

;===========================================================+
; ++ NAME ++
PRO cluster::authentication, renew =renew
;
; ++ PURPOSE ++
;  --> authenticate CSA-web
;
; ++ POSITIONAL ARGUMENTS ++
;  -->
;
; ++ KEYWORDS ++
; -->  renew(BOOLEAN): By default, if an authentication has been performed 
;                      within an hour, no new authentication is performed.
;                      Set this keyword to perform new authentication regardless of
;                      whether or not an authentication has been performed within an hour.
;
; ++ CALLING SEQUENCE ++
;  -->
;
; ++ HISTORY ++
;  H.Koike 1/9,2021
; 
; ++ NOTE ++
; username and password of CSA-web must be specified in 'cluster__define.pro'
; as static properties of Cluster object.
;
;===========================================================+
;
COMPILE_OPT IDL2
;
self->getprop, username=username, password=password
;
root = self->lib_rootdir()
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
FREE_LUN, lun
;
now = SYSTIME(/JULIAN)
CALDAT, last_login, mon, dy, yr, hr, min, sec
last = STRING(yr, format='(I04)') + '-' + STRING(mon, format='(I02)') + '-' + $
             STRING(dy, format='(I02)') + '/' + STRING(hr, format='(I02)') + ':' + $
             STRING(min, format='(I02)') + ':' + STRING(sec, format='(I02)') 
PRINT, '% Last login : ' + last
;
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
datadir  = FILEPATH('buff.dat', root=self->data_rootdir())
filename = ourl->GET(filename=datadir)
OBJ_DESTROY, ourl
last_login = SYSTIME(/JUL)
;
FILE_DELETE, filename;, /VERBOSE

;
;*---------- renew login history  ----------*
;                        
OPENW, lun, log, /GET_LUN
PRINTF, lun, last_login, FORMAT=format
FREE_LUN, lun
 

PRINT, '% login completed'
END
