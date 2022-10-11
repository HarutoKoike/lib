

; time string 2000-01-01/00:00:00
FUNCTION ts_extract, ts

ts = STRSPLIT(ts, '/', /EXTRACT)
ts = STRJOIN(ts)
ts = STRSPLIT(ts, '-', /EXTRACT)
ts = STRJOIN(ts)
;
RETURN, STRMID(ts, 0, 10)

END
