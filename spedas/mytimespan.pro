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
IF KEYWORD_SET(dhr) THEN $
	ts2 += DOUBLE(dhr) * 3600D
IF KEYWORD_SET(dmin) THEN $
	ts2 += DOUBLE(dmin) * 60D
IF KEYWORD_SET(dsec) THEN $
	ts2 += DOUBLE(dsec)

IF ts1 LE ts2 THEN timespan, [ts1, ts2]
IF ts2 LE ts1 THEN timespan, [ts2, ts1]
;

END
