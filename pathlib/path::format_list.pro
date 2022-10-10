;===========================================================+
; ++ NAME ++
PRO path::format_list
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
COMPILE_OPT IDL2, STATIC
;
name  = FILEPATH('*', SUBDIR='naming_format', ROOT=!PACKAGE_PATH)
list = FILE_SEARCH(name)

FOREACH l, list DO BEGIN
  RESTORE, l
  PRINT, '% --------------------------------------------'
  PRINT, '% ' + l
  PRINT, '% format: ' + format
ENDFOREACH

END
