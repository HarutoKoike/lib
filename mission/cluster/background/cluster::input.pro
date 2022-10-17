FUNCTION cluster::input, sc=sc 
;
COMPILE_OPT IDL2, STATIC

get_timespan, ts

st = date->time_string2iso( time_string(ts[0]) )
et = date->time_string2iso( time_string(ts[1]) )

IF ~KEYWORD_SET(sc) THEN sc='1'
RETURN, {st:st, et:et, sc:STRING(sc, FORMAT='(I1)')}
END
