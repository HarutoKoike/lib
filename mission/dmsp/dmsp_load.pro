


;===========================================================+
; ++ NAME ++
FUNCTION dmsp_load, f, yr, mon, dy, tvar = tvar, reload=reload
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
;
; progress bar
;waiting, /wait_start
sod = 86400L
levels = 50
interval = sod / levels
;
;*---------- MLAT & MLON  ----------*
;
da = date_arr_1day()
err = aacgm_v2_setdatetime(yr, mon, dy)
aacgm = cnvcoord_v2(d_ssm.glat, d_ssm.glon, d_ssm.alti)
mlat_aacgm = REFORM(aacgm[0, *])
mlon_aacgm = REFORM(aacgm[1, *])
mlt_aacgm  = DBLARR(sod)
;
;*---------- MLT  ----------*
;
FOR i = 0, sod - 1 DO BEGIN 
	mlt_aacgm[i] = MLTconvert_v2(yr, mon, dy, da.hourarr[i], da.minarr[i], da.secarr[i], mlon_aacgm[i])
	IF (i + 1) MOD interval EQ 0 THEN BEGIN
		level = (i + 1) / interval
		;progress_bar, levels, level 
	ENDIF
ENDFOR
;waiting, /wait_end



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



;
;*---------- set data  ----------*
;
dmsp->SetData, d
dum = dmsp->getdata()

;----------------------------------------------------------------+
; make tplot variables 
;----------------------------------------------------------------+
IF KEYWORD_SET(tvar) THEN dmsp->tplotvar


OBJ_DESTROY, dmsp

RETURN, d
END



 
