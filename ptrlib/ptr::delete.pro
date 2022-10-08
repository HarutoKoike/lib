
PRO ptr::array_delete, arr, idx

COMPILE_OPT IDL2, STATIC

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
;  --> test.pro
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



















































PRO ptr::delete, vname

COMPILE_OPT IDL2, STATIC

idx = ptr->index(vname)

IF ~ISA(vname) THEN BEGIN
  PRINT, '% Variable "' + vname + '" does not exists'
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
ptr->array_delete, *(!PTR.VNAME), idx
ptr->array_delete, *(!PTR.DATA), idx
ptr->array_delete, *(!PTR.ID), idx
ptr->array_delete, *(!PTR.DESCRIPTION), idx



END






