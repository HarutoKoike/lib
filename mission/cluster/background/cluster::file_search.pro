FUNCTION iso2julday, iso

yr  = FIX( STRMID(iso, 0, 4) )
mon = FIX( STRMID(iso, 5, 2) )
dy  = FIX( STRMID(iso, 8, 2) )
hr  = FIX( STRMID(iso, 11, 2) )
min = FIX( STRMID(iso, 14, 2) )
sec = FIX( STRMID(iso, 17, 2) )

jd  = JULDAY(mon, dy, yr, hr, min, sec)

RETURN, jd

END

;-------------------------------------------------+
; 
;-------------------------------------------------+
FUNCTION julday_devide, st, et, hourly=hourly, daily=daily
;
sec = 1D / 86400D ; 1 second
interval   = 1D   ; daily
IF KEYWORD_SET(hourly) THEN $
  interval = 3600D / 86400D

;
st_val = st
et_val = et
;
IF ABS(et - st) LE 1D AND ~KEYWORD_SET(daily) THEN BEGIN
  t0 = st
  t1 = et
  GOTO, jump1
ENDIF
;
st += 0.5D
et += 0.5D
;
st = st - (st MOD interval) - 0.5D 
;
IF et MOD interval LE sec THEN BEGIN
  et = et - (et MOD interval) - 0.5D  
ENDIF ELSE BEGIN
  et = et - (et MOD interval) + interval - 0.5D  
ENDELSE
;
n   = FIX((et - st) / interval ) 
t0  = DINDGEN(n) * interval + st[0]
t1  = t0 + interval 


jump1:

CALDAT, t0, mon0, day0, yr0, hour0, min0, sec0
CALDAT, t1, mon1, day1, yr1, hour1, min1, sec1
;
f = STRING(yr0, FORMAT='(I4)')    + $
    STRING(mon0, FORMAT='(I02)')  + $
    STRING(day0, FORMAT='(I02)')  + $
    '_'                           + $
    STRING(hour0, FORMAT='(I02)') + $
    STRING(min0, FORMAT='(I02)')  + $
    STRING(sec0, FORMAT='(I02)')  + $
    '_'                           + $
    STRING(yr1, FORMAT='(I4)')    + $
    STRING(mon1, FORMAT='(I02)')  + $
    STRING(day1, FORMAT='(I02)')  + $
    '_'                           + $
    STRING(hour1, FORMAT='(I02)') + $
    STRING(min1, FORMAT='(I02)')  + $
    STRING(sec1, FORMAT='(I02)') 

st = st_val
et = et_val
RETURN, f
END


;-------------------------------------------------+
; 
;-------------------------------------------------+
FUNCTION cluster::filename, id, start_date, end_date, $
                            hourly=hourly, full=full, daily=daily

COMPILE_OPT IDL2
;
IF N_ELEMENTS(start_date) NE 1 OR $
   N_ELEMENTS(end_date) NE 1 THEN BEGIN $
   MESSAGE, '% start_date, end date must be 1-element'
ENDIF
;
st  = iso2julday(start_date)
et  = iso2julday(end_date)
;
dev = julday_devide(st, et, daily=daily)

;
fn = []
root = self->data_rootdir()
;
FOR i = 0, N_ELEMENTS(id) - 1 DO BEGIN
   IF KEYWORD_SET(full) THEN BEGIN
     fn = [fn, root + PATH_SEP() + id[i] + PATH_SEP() + id[i] + '__' + dev]
   ENDIF ELSE BEGIN
     fn = [fn, id[i] + '__' + dev]
   ENDELSE
ENDFOR

RETURN, fn + '*cdf' 

END

 


;-------------------------------------------------+
; 
;-------------------------------------------------+
FUNCTION cluster::filetest, id, start_date, end_date, daily=daily
COMPILE_OPT IDL2
files = self->cluster::filename(id, start_date, end_date, /full, daily=daily)
RETURN, N_ELEMENTS(files) EQ TOTAL(FILE_TEST(files))
END







;===========================================================+
; ++ NAME ++
;
FUNCTION cluster::file_search, id, start_date, end_date, daily=daily
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
;  H.Koike 8/9,2021
;===========================================================+
COMPILE_OPT IDL2
;
;*---------- file name format ----------*
;
RETURN, FILE_SEARCH(self->cluster::filename(id, start_date, end_date, /full, daily=daily))
END
