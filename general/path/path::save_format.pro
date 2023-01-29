;===========================================================+ 
; ++ NAME ++
PRO path::save_format, class, format, format_file=format_file, $
                       overwrite=overwrite, root_dir_format=root_dir_format, $
                       subdir_format=subdir_format, exists=exists
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
; --> root_dir_format(STRING) : format of root directory, default is 
;                               "GETENV('HOME')" 
; --> subdir_format(STRING) : format of sub directory, default is 
;                             class. this can be array  
;
; ++ CALLING SEQUENCE ++
;  --> path::save_format, 'myclass', '%c_%sc_%Y%m'
;
; ++  DEPENDENCY ++
;  --> class "date"
;
; ++ HISTORY ++
;    09/2022,    H.Koike 
;    10/10/2022, added file path, keyword "subdir_format" and "root_dir_format"  
;
;===========================================================+
COMPILE_OPT IDL2, STATIC
;ON_ERROR, 2
;
;
;*---------- path to save format file ----------*
;
IF ~KEYWORD_SET(format_file) THEN $
  save_dir = FILEPATH( 'naming_format', ROOT=ptr->get('path_root') )
;
IF KEYWORD_SET(format_file) THEN $
  save_dir = FILE_DIRNAME(format_file)
;
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
;*---------- check existence  ----------*
;
IF ARG_PRESENT(exists) THEN BEGIN
    exists = FILE_TEST(format_file) 
    RETURN
ENDIF
;

;
;*---------- check existence ----------*
;
IF FILE_TEST(format_file) AND ~KEYWORD_SET(overwrite) THEN $
    MESSAGE, 'format of ' + class + ' already exists', /CONTINUE
   

;
;*---------- create directory  ----------*
;
IF ~FILE_TEST(save_dir) THEN FILE_MKDIR, save_dir



;
;*---------- check format  ----------*
;
path->format_char, all=format_char_list
;

; regular expression of format 
format_reg = '(' + STRJOIN(format_char_list, '|') + ')+'
boo        = STREGEX(format, format_reg, LENGTH=len)
;
IF len NE STRLEN(format) THEN $
  MESSAGE, 'Format does not match the format of format'




;
;*---------- path format setting  ----------*
;
IF ~KEYWORD_SET(root_dir_format) THEN $
    root_dir_format = GETENV('HOME')
IF ~KEYWORD_SET(subdir_format) THEN $
    subdir_format = class
;
path_format = FILEPATH('dummy', subdir=subdir_format, root=root_dir_format)
path_format = FILE_DIRNAME(path_format)

;
;*---------- save  ----------*
;
SAVE, format, path_format, FILENAME=format_file
END
