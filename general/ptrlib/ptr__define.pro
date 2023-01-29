;
;*---------- include all files  ----------*
;
@ptr::store.pro
@ptr::list.pro
@ptr::get.pro
@ptr::help.pro
@ptr::delete.pro
@ptr::save.pro
@ptr::restore.pro
@ptr::exists.pro



FUNCTION ptr::init
COMPILE_OPT IDL2
RETURN, 1
END


;
;*---------- return index of variable  ----------*
;
FUNCTION ptr::index, vname
COMPILE_OPT IDL2
;
IF N_ELEMENTS(vname) NE 1 OR ~ISA(vname, 'STRING') THEN BEGIN
  PRINT, '% vname must be scalar and STRING'
  RETURN, !NULL 
ENDIF
;
IF ~ISA( *(!PTR.VNAME) ) THEN RETURN, !NULL
;
RETURN, WHERE( STRMATCH( *(!PTR.VNAME), vname ) EQ 1, /NULL) 
END

;===========================================================+
; ++ NAME ++
PRO ptr__define
;
; ++ PURPOSE ++
;  --> define system variable !PTR. !PTR consists of four pointers
;      
;      !PTR.VNAME: 
;           pointer to string array of variable name
;      !PTR.DATA : 
;           pointer to pointer array of data
;      !PTR.DESCRIPTION : 
;           pointer to string array of description for data
;      !PTR.id : 
;           pointer to integer array of heap identifier 
;           see function PTR_VALID() and keyword GET_HEAP_IDENTIFIER
;
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
;    09/2022  H.Koike 
;===========================================================+
COMPILE_OPT IDL2
;
; check existence of system variable '!PTR'
DEFSYSV, '!PTR', EXISTS=exists

ptr = {                                  $
       vname:PTR_NEW(/ALLOCATE)        , $
       data:PTR_NEW(/ALLOCATE)         , $
       description:PTR_NEW(/ALLOCATE)  , $
       id:PTR_NEW(/ALLOCATE)             $
      }

IF ~exists THEN DEFSYSV, '!PTR', ptr

void = {           $
         ptr,      $
         vname:'', $
         data :'', $
         id   :''  $
       }

END
