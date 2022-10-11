

;----------------------------------------------------------------+
; get month array
;----------------------------------------------------------------+
FUNCTION monarr 
	
	m = INDGEN(12) + 1
	RETURN, m

END



;----------------------------------------------------------------+
; month to string month
;----------------------------------------------------------------+
FUNCTION month_to_str, month

  months = list('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul' ,$
               'Aug', 'Sep', 'Oct', 'Nov', 'Dec')
  RETURN, months[month - 1]
END



;----------------------------------------------------------------+
; 
;----------------------------------------------------------------+
FUNCTION dayarr, year, month 
  month1 = indgen(31) + 1 
  month2 = indgen(30) + 1
  feb_heinen = indgen(28) + 1
  feb_uruu = indgen(29) + 1
  
  CASE month OF
     1 : RETURN, month1
     3 : RETURN, month1
     4 : RETURN, month2
     5 : RETURN, month1
     6 : RETURN, month2
     7 : RETURN, month1
     8 : RETURN, month1
     9 : RETURN, month2
     10 : RETURN, month1
     11 : RETURN, month2
     12 : RETURN, month1
     2 : BEGIN
        IF  (year MOD 4 EQ 0 ) AND $
           ( (year MOD 100 NE 0) OR (year MOD 400 EQ 0) )  THEN BEGIN 
           RETURN, feb_uruu
        ENDIF ELSE BEGIN
           RETURN, feb_heinen
        ENDELSE
     END
     ELSE : PRINT, 'ERROR'
  ENDCASE
END



;----------------------------------------------------------------+
; 
;----------------------------------------------------------------+
FUNCTION date_expr, year, month, day, hour=hour, min=mim, sec=sec
	
	yr = STRING(year, FORMAT = '(I04)') 
	mon = STRING(month, FORMAT = '(I02)') 
	dy = STRING(day, FORMAT = '(I02)') 
	hh = '00'
	mm = '00'
	ss = '00'
	IF KEYWORD_SET(hour) THEN hh = STRING(hour, FORMAT='(I02)')
	IF KEYWORD_SET(min) THEN mm = STRING(min, FORMAT='(I02)')
	IF KEYWORD_SET(sec) THEN ss = STRING(sec, FORMAT='(I02)')
	t = STRCOMPRESS(yr + '-' + mon + '-' + dy + '/' + hh + ':' + mm + ':' + ss)

	RETURN, t
END 



;----------------------------------------------------------------+
; 
;----------------------------------------------------------------+
FUNCTION time_strmid, t, type   ;  t : ut[s]
  timestring = SYSTIME(ELAPSED = t, /UTC)
  ; Mon Jan 10 14:28:16 2011
  IF type EQ 'day' THEN $
     st = STRMID(timestring, 8, 2)
  IF type EQ 'time' THEN $
     st = STRMID(timestring, 11, 8)
  RETURN, st
END



;----------------------------------------------------------------+
; 
;----------------------------------------------------------------+
FUNCTION trim_time_string, ts
; 2000-01-01/00:00:00
d = {                                $		
			yr  : FIX(STRMID(ts, 0, 4))   ,$
			mon : FIX(STRMID(ts, 5, 2))   ,$
			dy  : FIX(STRMID(ts, 8, 2))   ,$
			hr  : FIX(STRMID(ts, 11, 2))  ,$
			min : FIX(STRMID(ts, 14, 2))  ,$
			sec : FIX(STRMID(ts, 17, 2))   $
    }

RETURN, d

END



;----------------------------------------------------------------+
; calculate time double by IDL original procedures
;----------------------------------------------------------------+
FUNCTION mytime_double, ts

date = trim_time_string(ts) 

t0 = JULDAY(1, 1, 1970, 0, 0, 0) * 86400D 
t1 = JULDAY(date.mon, date.dy, date.yr, date.hr, date.min, date.sec) * 86400D 

RETURN, t1 - t0

END



;----------------------------------------------------------------+
; calculate time string by IDL original procedures
;----------------------------------------------------------------+
FUNCTION mytime_string, td

td = td / 86400D
jul = JULDAY(1, 1, 1970, 0, 0, 0) + td
CALDAT, jul, mon, dy, yr, hr, min, sec

ts = STRCOMPRESS(/REMOVE_ALL,        $
		 STRING(yr, FORMAT = '(I04)')  + $	
     '-'                           + $
		 STRING(mon, FORMAT = '(I02)') + $
     '-'                           + $
		 STRING(dy, FORMAT = '(I02)')  + $
		 '/'                           + $
		 STRING(hr, FORMAT = '(I02)')  + $
		 ':'                           + $
		 STRING(min, FORMAT = '(I02)') + $
		 ':'                           + $
		 STRING(sec, FORMAT = '(I02)')   $
		 )
		 
RETURN, ts

END
 

;----------------------------------------------------------------+
; day of year
;----------------------------------------------------------------+
FUNCTION  doy, year, month, day

doy = JULDAY(month, day, year) - JULDAY(1, 1, year) + 1L
RETURN, doy

END



;----------------------------------------------------------------+
; calculate date from doy
;----------------------------------------------------------------+
FUNCTION inv_doy, yr, doy

jul = JULDAY(1, 1, yr) + doy - 1
CALDAT, jul, mon, dy, yr

date = { $
				yr  : yr ,$
				mon : mon  ,$
				dy  : dy    $
		   }

RETURN, date

END



;----------------------------------------------------------------+
; 
;----------------------------------------------------------------+
FUNCTION date_arr_1day
	 sod = 86400
   harr = ( lindgen(sod) + 1 ) / 3600
	 marr = ( ( lindgen(sod) + 1 ) / 60 ) mod 60 
	 sarr = ( lindgen(sod) + 1 ) mod 60 

   d = create_struct( ['hourarr', 'minarr', 'secarr'], harr, marr, sarr )
	 return, d
END   













;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FUNCTION day_of_year, year, month, day

	n1 = N_ELEMENTS(year)
	n2 = N_ELEMENTS(month)
	n3 = N_ELEMENTS(day)
	IF n1 NE n2 THEN RETURN, 0
	IF n2 NE n3 THEN RETURN, 0
	IF n3 NE n1 THEN RETURN, 0

	ind_uruu = WHERE( ((year MOD 4 EQ 0) AND (year MOD 100 NE 0)) OR (year MOD 400 EQ 0), /NULL, $
										COMPLEMENT = ind_heinen)
	doy_buff_heinen = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334]
	doy_buff_uruu   = [0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335]
	doy = UINTARR(n1) 
	
	IF ISA(ind_heinen) THEN BEGIN 
		doy_heinen = doy_buff_heinen[ month[ind_heinen] - 1 ] + day[ind_heinen]
		doy[ind_heinen] = doy_heinen
	ENDIF
	IF ISA(ind_uruu) THEN BEGIN 
		doy_uruu = doy_buff_uruu[ month[ind_uruu] - 1 ] + day[ind_uruu]
		doy[ind_uruu] = doy_uruu
	ENDIF

	RETURN, doy
END








;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FUNCTION time_double2julday, td 


t_unix = JULDAY(1, 1, 1970, 0, 0, 0)
t_jul  = td / 86400D + t_unix

;CALDAT,t_jul, m, d, y, hr, min, sec

RETURN, t_jul

END




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


FUNCTION julday2iso, jd

CALDAT, jd, mon, dy, yr, hr, min, sec

yr  = STRING(yr, FORMAT='(I04)')
mon = STRING(mon, FORMAT='(I02)')
dy  = STRING(dy, FORMAT='(I02)')
hr  = STRING(hr, FORMAT='(I02)')
min = STRING(min, FORMAT='(I02)')
sec = STRING(sec, FORMAT='(I02)')

iso = yr + '-' + mon + '-' + dy + 'T' + $
			hr + ':' + min + ':' + sec + 'Z'

RETURN, iso

END 



FUNCTION time_string2iso, ts
jd = time_double2julday( time_double(ts) )
RETURN, julday2iso(jd) 
END





PRO mytimespan, yr, mon, dy, hr, min, sec, dhr = dhr, dmin = dmin, dsec = dsec


yr_st  = STRING(yr, format = '(I04)')
mon_st = STRING(mon, format = '(I02)')
dy_st  = '01'
hr_st  = '00'
min_st = '00'
sec_st = '00'

IF KEYWORD_SET(dy) THEN dy_st = STRING(dy, format = '(I02)')
IF KEYWORD_SET(hr) THEN hr_st = STRING(hr, format = '(I02)')
IF KEYWORD_SET(min) THEN min_st = STRING(min, format = '(I02)')
IF KEYWORD_SET(sec) THEN sec_st = STRING(sec, format = '(I02)')


ts1 = yr_st + '-' + mon_st + '-' + dy_st + '/' + $
                hr_st + ':' + min_st + ':' + sec_st



IF ~KEYWORD_SET(dhr) AND ~KEYWORD_SET(dmin) AND ~KEYWORD_SET(dsec) THEN BEGIN 
  timespan, ts1
  RETURN
ENDIF

ts1 = time_double(ts1)
ts2 = ts1
IF KEYWORD_SET(dhr)  THEN ts2 += DOUBLE(dhr) * 3600D
IF KEYWORD_SET(dmin) THEN ts2 += DOUBLE(dmin) * 60D
IF KEYWORD_SET(dsec) THEN ts2 += DOUBLE(dsec)

IF ts1 LE ts2 THEN timespan, [ts1, ts2]
IF ts2 LE ts1 THEN timespan, [ts2, ts1]

END





