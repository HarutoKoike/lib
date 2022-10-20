;_===========================================================+
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
print, name
list = FILE_SEARCH(name)
print, list

FOREACH l, list DO BEGIN
  RESTORE, l
  PRINT, '% --------------------------------------------'
  PRINT, '% ' + l
  PRINT, '% format     : ' + FILEPATH(format, root=path_format)
ENDFOREACH

END
