;===========================================================+ 
; ++ NAME ++
PRO path::save_format, format, format_file=format_file, $
                       class=class, overwrite=overwrite
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
;
;*---------- save path  ----------*
;
IF ~KEYWORD_SET(format_file) THEN $
  save_dir = FILEPATH('naming_format', ROOT=!PACKAGE_PATH)
;
IF KEYWORD_SET(format_file) THEN $
  save_dir = FILE_DIRNAME(format_file)
;
IF ~FILE_TEST(save_dir) THEN FILE_MKDIR, save_dir
;


;
;*---------- check format  ----------*
;
format_char_list = [          $
                    '%c',     $   ; class name
                    '%sc',    $   ; subclass name
                    '%suf',   $   ; suffix
                    '%pre',   $   ; prefix
                    '_',      $   ; separator 1
                    '-',      $   ; separator 2
                    ':',      $   ; separator 3
                    '/'       $   ; separator 4
                    ]
;
; add date format
format_char_list = [format_char_list, date->format_list()]
;

; regular expression of format
format_reg = '(' + STRJOIN(format_char_list, '|') + ')+'
boo        = STREGEX(format, format_reg, LENGTH=len)
;
IF len NE STRLEN(format) THEN BEGIN
  PRINT, '% Format does not match the format of format'
  RETURN
ENDIF



;
;*---------- format file name  ----------*
;
IF ~KEYWORD_SET(format_file) THEN BEGIN
  ;
  IF ~KEYWORD_SET(class) THEN BEGIN
    PRINT, '"Class" must be specified'
    RETURN
  ENDIF
  ;
  format_file = class + '_format.sav'
ENDIF
;
format_file = FILEPATH(format_file, ROOT=save_dir)
;
;
IF FILE_TEST(format_file) AND ~KEYWORD_SET(overwrite) THEN BEGIN
  PRINT, '% format of ' + class + ' already exists'
  RETURN
ENDIF


;
;*---------- save  ----------*
;
SAVE, format, FILENAME=format_file
END
