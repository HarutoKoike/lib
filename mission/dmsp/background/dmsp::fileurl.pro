

;===========================================================+
; ++ NAME ++
FUNCTION dmsp::fileurl, ssm=ssm, ssj=ssj 
;
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

f   = self.f
yr  = self.yr
mon = self.mon
dy  = self.dy
;
doy = JULDAY(mon, dy, yr) - JULDAY(1, 1, yr) + 1 
doy = STRING(doy, FORMAT='(I03)')
;
f   = STRING(f,   FORMAT='(I02)')
yr  = STRING(yr,  FORMAT='(I04)')
mon = STRING(mon, FORMAT='(I02)')
dy  = STRING(dy,  FORMAT='(I02)')
;
url = 'http://satdat.ngdc.noaa.gov/dmsp/data/f' + f



;-------------------------------------------------+
; SSJ/5
;-------------------------------------------------+
IF KEYWORD_SET(ssj) THEN BEGIN
;
yr2d = STRMID(yr, 2, 2)
fn   = 'j5f' + f + yr2d + doy + '.gz'  
;
url = url + '/ssj/' + yr + '/' + mon + '/'
RETURN, url + fn
ENDIF





;-------------------------------------------------+
; SSM
;-------------------------------------------------+
;
IF ~KEYWORD_SET(ssm) THEN RETURN, '' 
;
;
;*---------- error handling  ----------*
;
CATCH, error_status
IF error_status NE 0 THEN BEGIN
  CATCH, /CANCEL
  OBJ_DESTROY, ourl
  RETURN, ''
ENDIF


;
;*---------- IDL net url set property ----------*
;
ourl = OBJ_NEW('IDLnetURL')
user = 'IDL' + !VERSION.RELEASE
url_path = 'dmsp/data/f' + f + '/ssm/' + yr + '/' + mon + '/'
;
ourl->SetProperty, HEADERS    = 'User_Agent:' + user
ourl->SetProperty, URL_SCHEME = 'https'
ourl->SetProperty, URL_HOST   = 'satdat.ngdc.noaa.gov'
ourl->SetProperty, URL_PATH   = url_path
;
res = ourl->GET(/STRING_ARRAY)
OBJ_DESTROY, ourl


;
;*---------- file name ----------*
;
regex = '*PS.CKGWC_SC.U_DI.A_GP.SSMXX-F' + f +  $
				'-R99990-B9999090-APSM_AR.GLOBAL_DD.' + $
				yr + mon + dy + '_TP.*_DF.MFR.gz*'
disc  = STRMATCH(res, regex)
idx   = WHERE(disc EQ 1, c) 
IF c NE 1 THEN RETURN, ''
;
res  = res[idx]
pos1 = STRPOS(res, 'PS.CKG')
pos2 = STRPOS(res, '.MFR.gz')
fn   = STRMID(res, pos1, pos2 - pos1 + 7)
url  = url + '/ssm/' + yr + '/' + mon + '/'

RETURN, url + fn  

END








