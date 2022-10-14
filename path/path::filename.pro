;===========================================================+
; ++ NAME ++
FUNCTION path::filename, class=class, subclass=subclass, $
                         suffix=suffix, prefix=prefix,   $
                         misc=misc, $
                         julday=julday, extension=extension, $
                         format_file=format_file, mkdir=mkdir
;
; ++ PURPOSE ++
;  --> This function returns file-name, following the format file 
;      that already defined
;
; ++ POSITIONAL ARGUMENTS ++
;  -->
;
; ++ KEYWORDS ++
; --> class(STRING): class name
;                    if this keyword is set, format_file will automatically
;                    searched by class name
; --> subclass(STRING): subclass name
; --> suffix(STRING): suffix 
; --> prefix(STRING): prefix 
; --> extension(STRING): extension (etc., '.txt') 
; --> julday(DOUBLE): date in julian date format
;                     julday is needed if format includes time date
; --> format_file(STRING): path to format file
; --> mkdir(BOOLEAN): set this to make direcotry 'file_dirname(path)'  
; 
;
; ++ CALLING SEQUENCE ++
;  --> filename = path->file_name(class='myclass', subclass='sub', $
;                                 suffix='new', julday=julday(10, 1, 2020), $
;                                 extension='.txt')
;
; ++ DEPENDENCY ++
;  --> class "date"
;
; ++ HISTORY ++
;    09/2022, H.Koike 
;    10/10/2022 added keyword "mkdir"
;===========================================================+
COMPILE_OPT IDL2, STATIC
;
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

;
; restore vars "format" and "path_format"
RESTORE, format_file
;
; separator
path->format_char, separator=sep 
sep = '[(*|' + STRJOIN(sep, '|') + ')+]'
;
filename = STRSPLIT(format, '%', /EXTRACT)
filepath = STRSPLIT(path_format, '%', /EXTRACT)






;
;*---------- class  ----------*
;
in_class = str->contain(format, 'c') OR $
           str->contain(path_format, 'c') 
;
IF ~KEYWORD_SET(class) AND in_class THEN BEGIN 
    MESSAGE, '"Class" not specified'
ENDIF
;
IF KEYWORD_SET(class) THEN BEGIN
    filename = str->replace(filename, 'c', class, regex=sep+'c'+sep)
    filepath = str->replace(filepath, 'c', class, regex=sep+'c'+sep)
ENDIF



;
;*---------- subclass  ----------*
;
;
in_subclass =  str->contain(format, 'sc') OR $
               str->contain(path_format, 'sc') 
;
IF ~KEYWORD_SET(subclass) AND in_subclass THEN BEGIN 
    MESSAGE, '"Subclass" not specified'
ENDIF
;
IF KEYWORD_SET(subclass) THEN BEGIN
    filename = str->replace(filename, 'sc', subclass, regex=sep+'sc'+sep)
    filepath = str->replace(filepath, 'sc', subclass, regex=sep+'sc'+sep)
ENDIF



;
;*---------- suffix  ----------*
;
in_suffix = str->contain(format, 'suf') OR $
            str->contain(path_format, 'suf')
;
IF ~KEYWORD_SET(suffix) AND in_suffix THEN BEGIN 
    MESSAGE, '"suffix" not specified'
ENDIF
;
IF KEYWORD_SET(suffix) THEN BEGIN
    filename = str->replace(filename, 'suf', suffix, regex=sep+'suf'+sep)
    filepath = str->replace(filepath, 'suf', suffix, regex=sep+'suf'+sep)
ENDIF
 


;
;*---------- prefix  ----------*
;
;
in_prefix = str->contain(filename, 'pre') OR $
            str->contain(path_format, 'pre')
;
IF ~KEYWORD_SET(prefix) AND in_prefix THEN BEGIN 
    MESSAGE, '"prefix" not specified'
ENDIF
;
IF KEYWORD_SET(prefix) THEN BEGIN
    filename = str->replace(filename, 'pre', prefix, regex=sep+'pre'+sep)   
    filepath = str->replace(filepath, 'pre', prefix, regex=sep+'pre'+sep)
ENDIF



;
;*---------- misc (not neccesary) ----------*
;
;
IF KEYWORD_SET(misc) THEN BEGIN
    filename = str->replace(filename, 'misc', misc, regex=sep+'misc'+sep)   
    filepath = str->replace(filepath, 'misc', misc, regex=sep+'misc'+sep)
ENDIF 




;
;*---------- date time ----------*
;
IF KEYWORD_SET(julday) THEN date = date(julday=julday)
;
; check format contains date
format_list  = date->format_list()
;
in_date = str->contain(filename, format_list, /partly) OR $
          str->contain(path_format, format_list, /partly) 
;
; if julday not set
IF ~KEYWORD_SET(julday) AND in_date THEN BEGIN
  MESSAGE, 'Keyword "julday" must be set if file name ' + $
           'contains date'
ENDIF                   

 
; replace date format by value
IF KEYWORD_SET(julday) THEN BEGIN
    FOREACH f, format_list DO BEGIN
        dc       = date->string(format=f)
        filename = str->replace(filename, f, dc, regex=sep+f+sep)
        filepath = str->replace(filepath, f, dc, regex=sep+f+sep)
    ENDFOREACH
ENDIF





;
;*---------- join filename  ----------*
;
filename = STRJOIN(filename)
filepath = STRJOIN(filepath)
print, filename

;
;*---------- add extension  ----------*
;
IF KEYWORD_SET(extension) THEN $
  filename += extension


;
;*---------- make directory  ----------*
;
IF ~FILE_TEST(filepath) AND KEYWORD_SET(mkdir) THEN FILE_MKDIR, filepath

RETURN, FILEPATH(filename, ROOT=filepath)
END






