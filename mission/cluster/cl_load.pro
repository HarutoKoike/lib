PRO cl_load, sc, yr, mon, dy, hr, min, sec, _EXTRA=e, $
             cis=cis, fgm=fgm, aux=aux, peace=peace, $
             edi=edi, efw=efw, staff=staff, walen_test=walen_test

IF ISA(yr) AND ISA(mon) AND ISA(dy) THEN BEGIN
    myspedas->timespan, yr, mon, dy, hr, min, sec, _EXTRA=e
ENDIF
;
IF KEYWORD_SET(cis) THEN BEGIN
    cis = OBJ_NEW('cis')
    cis->setprop, sc=sc
    cis->load
ENDIF
;
IF KEYWORD_SET(fgm) THEN BEGIN
    fgm = OBJ_NEW('fgm')
    fgm->setprop, sc=sc
    fgm->load
ENDIF
;
IF KEYWORD_SET(aux) THEN BEGIN
    aux = OBJ_NEW('aux')
    aux->setprop, sc=sc
    aux->load
ENDIF
;
IF KEYWORD_SET(peace) THEN BEGIN
    peace = OBJ_NEW('peace')
    peace->setprop, sc=sc
    peace->load
ENDIF  
;
IF KEYWORD_SET(edi) THEN BEGIN
    edi = OBJ_NEW('edi')
    edi->setprop, sc=sc
    edi->load
ENDIF  
;
IF KEYWORD_SET(efw) THEN BEGIN
    efw = OBJ_NEW('efw')
    efw->setprop, sc=sc
    efw->load
ENDIF  
;
IF KEYWORD_SET(staff) THEN BEGIN
    staff = OBJ_NEW('staff')
    staff->setprop, sc=sc
    staff->load
ENDIF  

IF KEYWORD_SET(walen_test) THEN BEGIN
    cluster->walen_test, sc
ENDIF

END
