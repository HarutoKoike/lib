;===========================================================+
; ++ NAME ++
FUNCTION dmsp_load, f, yr, mon, dy, tvar = tvar, reload=reload
;
; ++ PURPOSE ++
;  --> load DMSP SSM and SSJ data for F16, 17, 18
;
; ++ POSITIONAL ARGUMENTS ++
;  --> f(INTEGER): satellite number (16, 17 or 18)
;  --> yr(INTEGER): year
;  --> mon(INTEGER): month
;  --> dy(INTEGER): day
;
; ++ KEYWORDS ++
; -->  tvar(BOOLEAN): set this keyword to make tplot variables
; -->  reload(BOOLEAN): by default, if save file already exists, download is skiped.
;                       set this to download and load data again
;
; ++ CALLING SEQUENCE ++
;  --> dmsp = dmsp_load(16, 2011, 1, 1, /tvar, /reload)
;
; ++ HISTORY ++
;     H.Koike 2020/05/10
;
;===========================================================+
FORWARD_FUNCTION aacgm_v2_setdatetime, cnvcoord_v2, MLTconvert_v2

compile_aacgm
;-------------------------------------------------+
; create DMSP object
;-------------------------------------------------+
dmsp = OBJ_NEW('DMSP')
dmsp->SetProperty, f=f, yr=yr, mon=mon, dy=dy   




;----------------------------------------------------------------+
; cheack whether or not specified file exists
;----------------------------------------------------------------+
IF dmsp->file_test() AND ~KEYWORD_SET(reload) THEN BEGIN 
	RESTORE, dmsp->filename()
	GOTO, nodownload
ENDIF

              

;----------------------------------------------------------------+
; load SSJ and SSM 
;----------------------------------------------------------------+
d_ssj = dmsp->load_ssj()
d_ssm = dmsp->load_ssm ()
;
IF ~ISA(d_ssj, 'STRUCT') THEN BEGIN 
	PRINT, '================================'
	PRINT, 'FAILED TO GET SSJ DATA SET '
	PRINT, 'F' + STRING(f, FORMAT='(I02)')
	PRINT, 'YEAR  : ' + STRING(yr, FORMAT='(I04)')
	PRINT, 'MONTH : ' + STRING(mon, FORMAT='(I02)')
	PRINT, 'DAY   : ' + STRING(dy, FORMAT='(I02)')
	RETURN, 0
ENDIF
IF ~ISA(d_ssm, 'STRUCT') THEN BEGIN 
	PRINT, '================================'
	PRINT, 'FAILED TO GET SSM MFR DATA SET '
	PRINT, 'F' + STRING(f, FORMAT='(I02)')
	PRINT, 'YEAR  : ' + STRING(yr , FORMAT='(I04)')
	PRINT, 'MONTH : ' + STRING(mon, FORMAT='(I02)')
	PRINT, 'DAY   : ' + STRING(dy,  FORMAT='(I02)')
	RETURN, 0
ENDIF



;----------------------------------------------------------------+
; calculate AACGM coordinates
;----------------------------------------------------------------+
compile_aacgm
;
sod = 86400L
;
;*---------- MLAT & MLON  ----------*
;
err        = aacgm_v2_setdatetime(yr, mon, dy)
aacgm      = cnvcoord_v2(d_ssm.glat, d_ssm.glon, d_ssm.alti)
mlat_aacgm = REFORM(aacgm[0, *])
mlon_aacgm = REFORM(aacgm[1, *])
mlt_aacgm  = DBLARR(sod)
;
;*---------- MLT  ----------*
;
FOR i = 0, sod - 1 DO BEGIN 
    hour = i / 3600
    min  = (i / 60) MOD 60
    sec  = i MOD 60
	mlt_aacgm[i] = MLTconvert_v2(yr, mon, dy, hour, min, sec, mlon_aacgm[i])
ENDFOR



;----------------------------------------------------------------+
; make DMSP data set 
;----------------------------------------------------------------+  
d = CREATE_STRUCT($
                  ['F', 'year', 'month', 'day', 'mlt', 'mlat', 'mlon'], $
                  STRING(f)   , $
                  STRING(yr)    , $
				  STRING(mon)   , $
				  STRING(dy)    , $ 
				  mlt_aacgm     , $
				  mlat_aacgm    , $
				  mlon_aacgm    , $
                  d_ssj, d_ssm    $
									)

;

;
;*---------- save variables and compress file  ----------*
;
save_file = dmsp->filename()
SAVE, d, FILENAME = save_file, /COMPRESS


nodownload :
PRINT, STRING(27B) + '[32m'
PRINT, 'SUCCESSED TO GET DATA / F:' + STRING(f) + '  YEAR:' + STRING(yr) + $
			 '  MONTH:' + STRING(mon) + '  DAY:' + STRING(dy)
PRINT, STRING(27B) + '[0m'



;----------------------------------------------------------------+
; make tplot variables 
;----------------------------------------------------------------+
IF KEYWORD_SET(tvar) THEN BEGIN
    dmsp->setdata, d
    dmsp->tplotvar
ENDIF


OBJ_DESTROY, dmsp
RETURN, d
END
