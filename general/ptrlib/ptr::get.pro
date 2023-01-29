;===========================================================+
; ++ NAME ++
FUNCTION ptr::get, vname, id=id, description=description 
;
; ++ PURPOSE ++
;  --> ptr::get returns data of specified variable
;      set keyword id or description to receive  or description 
;
; ++ POSITIONAL ARGUMENTS ++
;  --> vname(STRING): name of variable
;
; ++ KEYWORDS ++
; -->  id: set this keyword to recieve heap identifier id
; -->  description: set this keyword to recieve description
;
; ++ CALLING SEQUENCE ++
;  --> data = ptr->get('var1')
;  --> id   = ptr->get('var1', /id)
;  --> des  = ptr->get('var1', /desc)
;
; ++ HISTORY ++
;  09/2022 H.Koike 
;===========================================================+
COMPILE_OPT IDL2
;
IF ~ISA(vname, 'STRING') THEN BEGIN
  PRINT, '% vname must be STRING'
  RETURN, !NULL
ENDIF 

;
idx = self->index(vname)
IF ~ISA(idx) THEN BEGIN
  PRINT, '% Variable "' + vname + '" is not be stored'
  RETURN, !NULL
ENDIF


;
;*---------- id  ----------*
;
IF KEYWORD_SET(id) THEN $
  RETURN, (*(!PTR.ID))[idx]

;
;*---------- description  ----------*
;
IF KEYWORD_SET(description) THEN $
  RETURN, (*(!PTR.DESCRIPTION))[idx]


RETURN, *( (*(!PTR.DATA))[idx] )[0]
END
