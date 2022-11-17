FUNCTION date::days_in_month, month, year
COMPILE_OPT IDL2
;
;
IF ~ISA(year)  THEN year = 2001
IF month NE 12 THEN days = JULDAY(month+1, 1, year) - JULDAY(month, 1, year)
IF month EQ 12 THEN days = 31
;
RETURN, LONG(days)
END   


;-------------------------------------------------+
; 
;-------------------------------------------------+
FUNCTION date::day_of_year, year, month, day
COMPILE_OPT IDL2
;
doy = JULDAY(month, day, year) - JULDAY(1, 1, year) + 1L
RETURN, doy
END

;-------------------------------------------------+
; 
;-------------------------------------------------+
FUNCTION  date::inv_doy, year, doy
COMPILE_OPT IDL2

jul = JULDAY(1, 1, yr) + doy - 1
CALDAT, jul, mon, dy, yr

date = {            $
        yr  : yr   ,$
        mon : mon  ,$
        dy  : dy    $
        }

RETURN, date
END

;-------------------------------------------------+
; 
;-------------------------------------------------+
FUNCTION date::iso2julday, iso
COMPILE_OPT IDL2

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
FUNCTION date::julday2iso, jd
COMPILE_OPT IDL2

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



;-------------------------------------------------+
; 
;-------------------------------------------------+
FUNCTION date::iso2time_string, iso
COMPILE_OPT IDL2
;
; ISO 2000-01-01T00:00:00Z
; ts  2000-01-01/00:00:00
;
ts = STRMID(iso, 0, 10) + '/' + STRMID(iso, 11, 8)
RETURN, ts
END



;-------------------------------------------------+
; 
;-------------------------------------------------+
FUNCTION date::time_string2iso, ts
COMPILE_OPT IDL2
;
; ISO 2000-01-01T00:00:00Z
; ts  2000-01-01/00:00:00
iso = STRMID(ts, 0, 10) + 'T' + STRMID(ts, 11, 8) + 'Z' 
RETURN, iso
END
 

 


;-------------------------------------------------+
; 
;-------------------------------------------------+
FUNCTION date::julday2time_string, julday
COMPILE_OPT IDL2
;
RETURN, self->iso2time_string( date->julday2iso(julday) )
END



;-------------------------------------------------+
; 
;-------------------------------------------------+
FUNCTION date::time_string2julday, ts
COMPILE_OPT IDL2
;
ts = self->time_string2iso(ts)
ts = self->iso2julday(ts)
RETURN, ts
END
 


;-------------------------------------------------+
; 
;-------------------------------------------------+
FUNCTION date::julday2time_double, jul
COMPILE_OPT IDL2
RETURN, ( jul - JULDAY(1, 1, 1970, 0, 0, 0) ) * 86400D
END


;-------------------------------------------------+
; 
;-------------------------------------------------+
FUNCTION date::time_double2iso, td
COMPILE_OPT IDL2
RETURN, self->time_string2iso(time_string(td))
END
 








PRO date::convert 
COMPILE_OPT IDL2
END
