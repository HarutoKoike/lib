

;===========================================================+
; ++ NAME ++
PRO cluster::load_vars, sc, peace=peace, cis=cis, fgm=fgm, aux=aux, $
                        efw=efw, whisper=whisper, staff=staff, all=all, _extra=e
;
; ++ PURPOSE ++
;  -->
;
; ++ POSITIONAL ARGUMENTS ++
;  -->
;
; ++ KEYWORDS ++
; -->
;
; ++ CALLING SEQUENCE ++
;  -->
;
; ++ HISTORY ++
;  H.Koike 1/9,2021
;===========================================================+
COMPILE_OPT IDL2, static
;
;
;*---------- PEACE (electron) ----------*
;
IF KEYWORD_SET(peace) OR KEYWORD_SET(all) THEN BEGIN
  pea = cl_peace(sc=sc)
  pea->load
ENDIF


;
;*---------- CIS (ion) ----------*
;
IF KEYWORD_SET(cis) OR KEYWORD_SET(all) THEN BEGIN
  cis = cl_cis(sc=sc)
  cis->load, _extra=e
ENDIF


;
;*---------- FGM ----------*
;
IF KEYWORD_SET(fgm) OR KEYWORD_SET(all) THEN BEGIN
  fgm = cl_fgm(sc=sc)
  fgm->load
ENDIF

;
;*---------- AUX ----------*
;
IF KEYWORD_SET(aux) OR KEYWORD_SET(all) THEN BEGIN
  aux = cl_aux(sc=sc)
  aux->load
ENDIF

;
;*---------- EFW  ----------*
;
IF KEYWORD_SET(efw) OR KEYWORD_SET(all) THEN BEGIN
  efw = cl_efw(sc=sc)
  efw->load
ENDIF
 

;
;*---------- WHISPER  ----------*
;
IF KEYWORD_SET(whisper) OR KEYWORD_SET(all) THEN BEGIN
  whi = cl_whisper(sc=sc)
  whi->load
ENDIF


;
;*---------- STAFF  ----------*
;
IF KEYWORD_SET(staff) OR KEYWORD_SET(all) THEN BEGIN
  sta = cl_staff(sc=sc)
  sta->load
ENDIF
 



OBJ_DESTROY, OBJ_VALID()
END


