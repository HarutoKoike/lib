
FUNCTION time_string2iso, ts
;
; ISO 2000-01-01T00:00:00Z
; ts  2000-01-01/00:00:00
iso = STRMID(ts, 0, 10) + 'T' + STRMID(ts, 11, 8) + 'Z'
RETURN, iso
END



FUNCTION cluster::input, sc=sc 
;
COMPILE_OPT IDL2

get_timespan, ts

st = time_string2iso( time_string(ts[0]) )
et = time_string2iso( time_string(ts[1]) )

IF ~KEYWORD_SET(sc) THEN sc='1'
RETURN, {st:st, et:et, sc:STRING(sc, FORMAT='(I1)')}
END



PRO cluster::reload_timerange
;
COMPILE_OPT IDL2
self->getprop, sc=sc
self->setprop, _EXTRA=self->input(sc=sc)
END
