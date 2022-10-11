;-------------------------------------------------+
; 
;-------------------------------------------------+
FUNCTION isosplit, iso

n = N_ELEMENTS(iso)
iso_spt = STRSPLIT(iso, '[-T:Z]', /EXTRACT, /REGEX)
;
;*---------- n = 1  ----------*
;
IF n EQ 1 THEN BEGIN
  date    = {                     $
             year   : iso_spt[0], $
             month  : iso_spt[1], $
             day    : iso_spt[2], $
             hour   : iso_spt[3], $
             minute : iso_spt[4], $
             second : iso_spt[5]  $
            }
RETURN, date
ENDIF
;
;*---------- n > 1  ----------*
;
date = list()
FOR i = 0, n - 1 DO BEGIN
  iso_spt_dum  = iso_spt[i]
  date_dum     = {                         $
                  year   : iso_spt_dum[0], $
                  month  : iso_spt_dum[1], $
                  day    : iso_spt_dum[2], $
                  hour   : iso_spt_dum[3], $
                  minute : iso_spt_dum[4], $
                  second : iso_spt_dum[5]  $
                 }
  date.add, date_dum
ENDFOR
RETURN, date
END



;-------------------------------------------------+
; 
;-------------------------------------------------+
FUNCTION date2iso, year, month, day, hour
;
IF ~ISA(hour)   THEN hour = 0
IF ~ISA(minute) THEN minute = 0
IF ~ISA(second) THEN second = 0
year    = STRING(year , FORMAT = '(I04)')
month   = STRING(month, FORMAT = '(I02)')
day     = STRING(day,   FORMAT = '(I02)')
hour    = STRING(hour,  FORMAT = '(I02)')
minute  = STRING(minute,FORMAT = '(I02)')
second  = STRING(second,FORMAT = '(I02)')
;
iso = year + '-' + month + '-' + day + 'T' + $
                                hour + ':' + minute + ':' + second + 'Z'
RETURN, iso
END


;-------------------------------------------------+
; 
;-------------------------------------------------+
; iso:2020-08-09T20:20:20Z
FUNCTION iso2dateexp, iso
;
date = isosplit(iso)
n    = N_ELEMENTS(iso)
date_exp = STRARR(n)
;
FOR i = 0, n - 1 DO $
  date_exp[i] = (date[i]).year + (date[i]).month + $
                (date[i]).day + '_' + (date[i]).hour + $
                (date[i]).minute + (date[i]).second
RETURN, date_exp
;
END




;-------------------------------------------------+
; 
;-------------------------------------------------+
FUNCTION julday_devide, st, et, hourly=hourly, daily=daily
;st = iso2julday('1999-12-30T20:40:43Z')
;et = iso2julday('2000-01-02T05:30:00Z')
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


FUNCTION iso_split_1day, st, et

t0 = iso2julday(st) + 0.5D
t1 = iso2julday(et) + 0.5D
;
td = 1D
t0 = t0 - (t0 MOD td) - 0.5D
t1 = t1 - (t1 MOD td) + td - 0.5D

n  = FIX( (t1 - t0) / td )

iso_arr = DINDGEN(n) * td + t0

RETURN, julday2iso(iso_arr)

END




;-------------------------------------------------+
; 
;-------------------------------------------------+
FUNCTION cluster::filename, id, start_date, end_date, $
                            hourly=hourly, dir = dir, daily=daily

;start_date = '2000-01-01T20:40:43Z'
;end_date = '2000-01-01T22:30:00Z'
COMPILE_OPT IDL2, STATIC
;
IF N_ELEMENTS(start_date) NE 1 OR $
   N_ELEMENTS(end_date) NE 1 THEN BEGIN $
   PRINT, '% start_date, end date must be 1-element'
   RETURN, 0
ENDIF
;
dev = julday_devide(iso2julday(start_date), iso2julday(end_date), daily=daily)

;
fn = []
root = cluster->data_rootdir()
;
FOR i = 0, N_ELEMENTS(id) - 1 DO BEGIN
   IF KEYWORD_SET(dir) THEN BEGIN
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
COMPILE_OPT IDL2, STATIC
files = cluster->filename(id, start_date, end_date, /dir, daily=daily)
RETURN, N_ELEMENTS(files) EQ TOTAL(FILE_TEST(files))
END




;===========================================================+
; ++ NAME ++
;
FUNCTION cluster::filesearch, id, start_date, end_date, daily=daily
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
COMPILE_OPT IDL2, STATIC
;
;*---------- file name format ----------*
;
RETURN, FILE_SEARCH(cluster->filename(id, start_date, end_date, /dir, daily=daily))
END








