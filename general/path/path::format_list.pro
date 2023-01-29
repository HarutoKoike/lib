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
name  = FILEPATH('*', SUBDIR='naming_format', ROOT=ptr->get('path_root') )
list = FILE_SEARCH(name)

FOREACH l, list DO BEGIN
  RESTORE, l
  PRINT, '% --------------------------------------------'
  PRINT, '% ' + l
  PRINT, '% format     : ' + FILEPATH(format, root=path_format)
ENDFOREACH

END
