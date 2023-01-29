
PRO ptr::array_delete, arr, idx

COMPILE_OPT IDL2

IF N_ELEMENTS(arr) EQ 2 THEN BEGIN
  idx0 = WHERE( INDGEN(2) NE idx, /NULL)
  arr  = arr[idx0] 
  RETURN
ENDIF

idx0 = WHERE( INDGEN( N_ELEMENTS(arr) ) NE idx, /NULL)
arr  = arr[idx0]
END



;===========================================================+
; ++ NAME ++
PRO ptr::delete, vname
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
;  H.Koike 
;===========================================================+
COMPILE_OPT IDL2
;
IF ~ISA(vname, 'STRING') THEN BEGIN
  PRINT, '% vname must be STRING'
  RETURN
ENDIF 


idx = self->index(vname)
;
IF ~ISA(idx) THEN BEGIN
  PRINT, '% Variable "' + vname + '" is not stored'
  RETURN
ENDIF
 

IF N_ELEMENTS( *(!PTR.VNAME) ) EQ 1 THEN BEGIN
  PTR_FREE, *(!PTR.DATA)
  *(!PTR.DATA)        = !NULL
  *(!PTR.VNAME)       = !NULL
  *(!PTR.ID)          = !NULL
  *(!PTR.DESCRIPTION) = !NULL
  RETURN
ENDIF


PTR_FREE, (*(!PTR.DATA))[idx]
self->array_delete, *(!PTR.VNAME), idx
self->array_delete, *(!PTR.DATA), idx
self->array_delete, *(!PTR.ID), idx
self->array_delete, *(!PTR.DESCRIPTION), idx


END
