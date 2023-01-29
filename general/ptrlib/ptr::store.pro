;===========================================================+
; ++ NAME ++
PRO ptr::store, vname, data, description=description, $
                overwrite=overwrite, read_only=read_only
;
; ++ PURPOSE ++
;  --> "ptr::store" stores variable and memorize variable name and pointer in !PTR. 
;
; ++ POSITIONAL ARGUMENTS ++
;  --> vname(STRING)         : name of variable to be stored
;  --> data(any type)        : data to be stored, pointer to this variable is stored.
;  --> description(STRING)   : description of the data
;
; ++ KEYWORDS ++
; -->  overrite(LOGICAL) : Set this keyword to overwrite existing data. 
;                          If not set, overwrite is refused.
;
; ++ CALLING SEQUENCE ++
;  --> ptr->store, 'var1', indgen(100), description='difference sequence up to 100'
;
; ++ HISTORY ++
;   09/2022, H.Koike(koike@kugi.kyoto-u.ac.jp)
;===========================================================+
COMPILE_OPT IDL2
;
IF ~ISA(vname, 'STRING') THEN BEGIN
  PRINT, '% vname must be STRING'
  RETURN
ENDIF

IF ~KEYWORD_SET(description) THEN $
  description = ' '

;
; case: variable does not exist
IF ~ISA( *(!PTR.VNAME) ) THEN GOTO, SKIP


;
;*---------- overwrite data ----------*
;
IF KEYWORD_SET(overwrite) THEN BEGIN
  idx = self->index(vname)
  ;
  IF ~ISA(idx) THEN BEGIN
    ;PRINT, '% Variable "' + vname + '" is not stored' 
    GOTO, SKIP
  ENDIF
  ;
  IF KEYWORD_SET(description) THEN $
    (*(!PTR.DESCRIPTION))[idx] = description
  IF ISA(data) THEN $
    *((*(!PTR.DATA))[idx])[0] = data
  ;
  RETURN
ENDIF


;
;*---------- check existence of variable ----------*
;
IF ISA(self->index(vname)) THEN BEGIN
  PRINT, '% variable "' + vname + '" is already stored'
  RETURN
ENDIF



SKIP:
;
;*---------- store data  ----------*
;
*(!PTR.VNAME)        = [*(!PTR.VNAME), vname]
*(!PTR.DATA)         = [*(!PTR.DATA), PTR_NEW(data, /ALLOCATE)]
*(!PTR.DESCRIPTION)  = [*(!PTR.DESCRIPTION), description]
;
id = ( PTR_VALID( PTR_VALID(), /GET_HEAP_IDENTIFIER ) )[-1]
*(!PTR.ID) = [*(!PTR.ID), id]


END
