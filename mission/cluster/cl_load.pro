PRO cl_load, sc0, $
             cis=cis, fgm=fgm, aux=aux, peace=peace, $
             edi=edi, efw=efw, staff=staff, walen_test=walen_test



FOR i = 0, N_ELEMENTS(sc0) - 1 DO BEGIN
    sc = sc0[i]
    ;
    IF KEYWORD_SET(cis) THEN BEGIN
        cis = OBJ_NEW('cis')
        cis->setprop, sc=sc
        cis->load
        OBJ_DESTROY, cis
    ENDIF
    ;
    IF KEYWORD_SET(fgm) THEN BEGIN
        fgm = OBJ_NEW('fgm')
        fgm->setprop, sc=sc
        fgm->load
        OBJ_DESTROY, fgm
    ENDIF
    ;
    IF KEYWORD_SET(aux) THEN BEGIN
        aux = OBJ_NEW('aux')
        aux->setprop, sc=sc
        aux->load
        OBJ_DESTROY, aux
    ENDIF
    ;
    IF KEYWORD_SET(peace) THEN BEGIN
        peace = OBJ_NEW('peace')
        peace->setprop, sc=sc
        peace->load
        OBJ_DESTROY, peace
    ENDIF  
    ;
    IF KEYWORD_SET(edi) THEN BEGIN
        edi = OBJ_NEW('edi')
        edi->setprop, sc=sc
        edi->load
        OBJ_DESTROY, edi
    ENDIF  
    ;
    IF KEYWORD_SET(efw) THEN BEGIN
        efw = OBJ_NEW('efw')
        efw->setprop, sc=sc
        efw->load
        OBJ_DESTROY, efw
    ENDIF  
    ;
    IF KEYWORD_SET(staff) THEN BEGIN
        staff = OBJ_NEW('staff')
        staff->setprop, sc=sc
        staff->load
        OBJ_DESTROY, staff
    ENDIF  
    ;
    IF KEYWORD_SET(walen_test) THEN BEGIN
        cluster->walen_test, sc
    ENDIF
    ;

ENDFOR



END
