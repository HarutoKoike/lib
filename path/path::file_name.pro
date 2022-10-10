;===========================================================+
; ++ NAME ++
FUNCTION path::file_name, class=class, subclass=subclass, $
                          suffix=suffix, prefix=prefix,   $
                          julday=julday, extension=extension, $
                          format_file=format_file
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
; ++ DEPENDENCY ++
;  --> class "date"
;
; ++ HISTORY ++
;  H.Koike 
;===========================================================+
COMPILE_OPT IDL2, STATIC
;
;
;*---------- restore format ----------*
;
IF ~KEYWORD_SET(format_file) THEN BEGIN
  ;
  IF ~KEYWORD_SET(class) THEN BEGIN
    MESSAGE, '"Class" must be set'
  ENDIF
  ;
  save_dir    = FILEPATH('naming_format', ROOT=!PACKAGE_PATH)
  format_file = class + '_format.sav'
  format_file = FILEPATH(format_file, ROOT=save_dir)
ENDIF 

;
IF ~FILE_TEST(format_file) THEN BEGIN
  MESSAGE, 'No format file for class "' + class + '"'
ENDIF

RESTORE, format_file


;list = STRSPLIT(format, '(%|-|_|/)', /REGEX, /EXTRACT)
filename = format


;
;*---------- date time ----------*
;
IF KEYWORD_SET(julday) THEN date = date(julday=julday)
;
; check format contains date
format_list  = date->format_list()
date_contain = 0
IF str->contain(format, format_list, /partly) THEN date_contain = 1
;
; if julday not set
IF date_contain AND ~KEYWORD_SET(julday) THEN BEGIN
  MESSAGE, 'Keyword "julday" must be set if file name ' + $
         'contains date'
ENDIF                   




;
;*---------- class  ----------*
;
IF ~str->contain(format, '%c') THEN GOTO, SKIP1
;
IF ~KEYWORD_SET(class) THEN BEGIN 
  MESSAGE, '"Class" not specified'
ENDIF
;
filename = str->replace(format, '%c', class)



;
;*---------- subclass  ----------*
;
SKIP1:
;
IF ~str->contain(format, '%sc') THEN GOTO, SKIP2
;
IF ~KEYWORD_SET(subclass) THEN BEGIN 
  MESSAGE, '"Subclass" not specified'
ENDIF
;
filename = str->replace(filename, '%sc', subclass)



;
;*---------- suffix  ----------*
;
SKIP2:
;
IF ~str->contain(format, '%suf') THEN GOTO, SKIP3
;
IF ~KEYWORD_SET(suffix) THEN BEGIN 
  MESSAGE, '"suffix" not specified'
ENDIF
;
filename = str->replace(filename, '%suf', suffix)
 


;
;*---------- prefix  ----------*
;
SKIP3:
;
IF ~str->contain(format, '%pre') THEN GOTO, SKIP4
;
IF ~KEYWORD_SET(prefix) THEN BEGIN 
  MESSAGE, '"prefix" not specified'
ENDIF
;
filename = str->replace(filename, '%pre', prefix)   



;
;*---------- date ----------*
;
SKIP4:
;
IF ~date_contain THEN GOTO, SKIP5
;
; replace date format by value
FOREACH f, format_list DO BEGIN
  IF ~str->contain(format, f) THEN CONTINUE
  ;
  dc       = date->string(format=f)
  filename = str->replace(filename, f, dc)
ENDFOREACH



SKIP5:
IF KEYWORD_SET(extension) THEN $
  filename += extension

RETURN, filename
END

