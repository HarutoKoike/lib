;===========================================================+ 
; ++ NAME ++
PRO path::save_format, class, format, format_file=format_file, $
                       overwrite=overwrite
;
; ++ PURPOSE ++
;  --> define file-path format of a class
;
; ++ POSITIONAL ARGUMENTS ++
;  --> format(STRING): must only consist of charactors in "format_char_list", see line around 40
;
; ++ KEYWORDS ++
; -->  format_file(STRING): by default, format is saved to '!PACKAGE_PATH/naming_format/class_format.sav'
;                           set this keyword to specify another filename to save format
; -->  overwrite(BOOLEAN): by default, format file will not be overwritten.
;                          if you renew format file, set this keyword
;
; ++ CALLING SEQUENCE ++
;  --> path::save_format, 'myclass', '%c_%sc_%Y%m'
;
; ++ HISTORY ++
;    09/2022,  H.Koike 
;===========================================================+
COMPILE_OPT IDL2, STATIC
;ON_ERROR, 2
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
;*---------- format file name  ----------*
;
IF ~KEYWORD_SET(format_file) THEN BEGIN
  format_file = class + '_format.sav'
  format_file = FILEPATH(format_file, ROOT=save_dir)
ENDIF
;
;

;
;*---------- check  ----------*
;
IF FILE_TEST(format_file) AND ~KEYWORD_SET(overwrite) THEN $
  MESSAGE, 'format of ' + class + ' already exists'
   


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
IF len NE STRLEN(format) THEN $
  MESSAGE, 'Format does not match the format of format'



;
;*---------- save  ----------*
;
SAVE, format, FILENAME=format_file
END
