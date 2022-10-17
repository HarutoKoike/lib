PRO cl_load, sc, yr, mon, dy, hr, min, sec, _EXTRA=e, $
             cis=cis, fgm=fgm, aux=aux
myspedas->timespan, yr, mon, dy, hr, min, sec, _EXTRA=e
;
IF KEYWORD_SET(cis) THEN BEGIN
    cis = cis(sc=sc)
    cis->load
ENDIF
;
IF KEYWORD_SET(fgm) THEN BEGIN
    fgm = fgm(sc=sc)
    fgm->load
ENDIF
;
IF KEYWORD_SET(aux) THEN BEGIN
    aux = aux(sc=sc)
    aux->load
ENDIF
;
END
