;===========================================================+
; ++ NAME ++
PRO import, path, recursive=recursive, class=class
;
; ++ PURPOSE ++
;  --> add new library path to !PATH system variable
;
; ++ POSITIONAL ARGUMENTS ++
;  --> path(STRING): absolute path to library
;
; ++ KEYWORDS ++
; -->  recursive(BOOLEAN): set this keyword to include sub-directy recursively
; -->  class(STRING): 
;
; ++ CALLING SEQUENCE ++
;  --> import, '~/mylib', /recursive 
;
; ++ HISTORY ++
;   09/2022, H.Koike 
;===========================================================+
;
COMPILE_OPT IDL2
ON_ERROR, 0

;
path_full = path

IF ~FILE_TEST(path) THEN $
  MESSAGE, 'Directory "' + path + '" not fount.'

; recursive include
IF KEYWORD_SET(recursive) THEN BEGIN
  path_full = '+' + path_full
  path_full = EXPAND_PATH(path_full)
ENDIF


;
;*---------- add new path  ----------*
;
!PATH = !PATH + ':' + path_full
RETURN



;
;*---------- resolve object method ----------*
;
;import_class:
;;
;dummy = 'class_import_list'
;;
;def_file = class + '__define.pro'
;def_file = FILE_WHICH(def_file)
;;
;IF STRLEN(def_file) EQ 0 THEN $
;  MESSAGE, 'No deffinition file "' + class + '__define.pro" found.'
;;
;class_dir   = FILE_DIRNAME(def_file)
;file_list   = FILE_SEARCH( FILEPATH('*.pro', ROOT=class_dir) ) 
;idx         = WHERE( STRMATCH(file_list, '*' + class + '*', /FOLD_CASE) EQ 1) 
;;
;;OPENW, lun, dummy, /GET_LUN
;FOREACH method, file_list[idx] DO BEGIN
;  print, method
;  RESOLVE_ROUTINE, method, /either
;  ;PRINTF, lun, '@' + method
;ENDFOREACH
;;FREE_LUN, lun
END
