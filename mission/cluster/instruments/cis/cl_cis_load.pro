PRO cl_cis_load, sc, yr, mon, dy, hr, min, sec,  _EXTRA=e
;
myspedas->timespan, yr, mon, dy, hr, min, sec, _EXTRA=e 
;
cis = cis(sc=sc)
cis->load
OBJ_DESTROY, cis
END
