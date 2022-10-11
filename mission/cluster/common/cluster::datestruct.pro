
FUNCTION cluster::datestruct, _EXTRA=e, sc=sc 

COMPILE_OPT IDL2, STATIC

;IF ~KEYWORD_SET(set_trange) THEN $
;  mytimespan, year, month, day, hour, minute, second, _EXTRA=e
;
get_timespan, ts

st = time_string2iso( time_string(ts[0]) )
et = time_string2iso( time_string(ts[1]) )

IF ~KEYWORD_SET(sc) THEN sc='1'
RETURN, {st:st, et:et, sc:STRING(sc, FORMAT='(I1)')}

END

