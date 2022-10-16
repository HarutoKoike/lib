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
;

;
;*---------- separator list  ----------*
;
print, format
print, path_format
dummy0 = 'dummy0dummy0dummy0dummy0' 
format = dummy0 + format + dummy0
path_format = dummy0 + format + dummy0
;
path->format_char, separator=sep 
sep = [sep, '%']
sep = '[(*|' + STRJOIN(sep, '|') + ')+]'
file_sep_idx = (STRSPLIT(format, sep, /REGEX) - 1)[1:-1] 
path_sep_idx = (STRSPLIT(path_format, sep, /REGEX) - 1)[1:-1]
;
IF TOTAL(file_sep_idx) GE 0 THEN BEGIN
    file_sep_list  = STRARR(N_ELEMENTS(file_sep_idx))
    FOR i = 0, N_ELEMENTS(file_sep_list) -1 DO $
        file_sep_list[i] = STRMID(format, file_sep_idx[i],$
                                  1)
ENDIF
;
IF TOTAL(path_sep_idx) GE 0 THEN BEGIN
    path_sep_list  = STRARR(N_ELEMENTS(path_sep_idx))
    FOR i = 0, N_ELEMENTS(path_sep_list) -1 DO $
        path_sep_list[i] = STRMID(path_format, $
                                  path_sep_idx[i], 1)
ENDIF   


print, path_sep_list
print, file_sep_list


; separator
dummy = 'dummydummydummydummy'
filename = str->replace(format, '%', '%' + dummy) 
filepath = str->replace(path_format, '%', '%' + dummy) 
;
filename = STRSPLIT(filename, sep, /EXTRACT, /REGEX)
filepath = STRSPLIT(filepath, sep, /EXTRACT, /REGEX)


;
;*---------- class  ----------*
;
in0 = TOTAL(str->contain(filename, dummy+'c')) GE 0
in1 = TOTAL(str->contain(filepath, dummy+'c')) GE 0
in_class = in0 OR in1
;
IF ~KEYWORD_SET(class) AND in_class THEN BEGIN 
    MESSAGE, '"Class" not specified'
ENDIF
;
IF KEYWORD_SET(class) THEN BEGIN
    filename = str->replace(filename, dummy+'c', class, $
                            /complete)
    filepath = str->replace(filepath, dummy+'c', class, $
                            /complete)
ENDIF


;
;*---------- subclass  ----------*
;
;
in_subclass =  str->contain(format, dummy+'sc') OR $
               str->contain(path_format, dummy+'sc') 
;
IF ~KEYWORD_SET(subclass) AND in_subclass THEN BEGIN 
    MESSAGE, '"Subclass" not specified'
ENDIF
;
IF KEYWORD_SET(subclass) THEN BEGIN
    filename = str->replace(filename, dummy+'sc', subclass,$
                            /complete)
    filepath = str->replace(filepath, dummy+'sc', subclass,$
                            /complete)
ENDIF



;
;*---------- suffix  ----------*
;
in_suffix = str->contain(format, dummy+'suf') OR $
            str->contain(path_format, dummy+'suf')
;
IF ~KEYWORD_SET(suffix) AND in_suffix THEN BEGIN 
    MESSAGE, '"suffix" not specified'
ENDIF
;
IF KEYWORD_SET(suffix) THEN BEGIN
    filename = str->replace(filename, dummy+'suf', suffix,$
                            /complete)
    filepath = str->replace(filepath, dummy+'suf', suffix,$
                            /complete)
ENDIF
 


;
;*---------- prefix  ----------*
;
;
in_prefix = str->contain(filename, dummy+'pre') OR $
            str->contain(path_format, dummy+'pre')
;
IF ~KEYWORD_SET(prefix) AND in_prefix THEN BEGIN 
    MESSAGE, '"prefix" not specified'
ENDIF
;
IF KEYWORD_SET(prefix) THEN BEGIN
    filename = str->replace(filename, dummy+'pre', prefix, $
                            /complete)   
    filepath = str->replace(filepath, 'pre', dummy+prefix, $
                            /complete)
ENDIF



;
;*---------- misc (not neccesary) ----------*
;
;
IF KEYWORD_SET(misc) THEN BEGIN
    filename = str->replace(filename, dummy+'misc', misc, $
                            /complete)   
    filepath = str->replace(filepath, dummy+'misc', misc, $
                            /complete)
ENDIF 




;
;*---------- date time ----------*
;
IF KEYWORD_SET(julday) THEN date = date(julday=julday)
;
; check format contains date
format_list  = date->format_list()
format_list  = str->replace(format_list, '%', '')
;
in0 = str->contain(filename, dummy+format_list, /partly) 
in1 = str->contain(filepath, dummy+format_list, /partly) 
in_date = (TOTAL(in0) GE 1) OR (TOTAL(in1) GE 1)
;
; if julday not set
IF ~KEYWORD_SET(julday) AND in_date THEN BEGIN
  MESSAGE, 'Keyword "julday" must be set if file name ' + $
           'contains date'
ENDIF                   

 
; replace date format by value
IF KEYWORD_SET(julday) THEN BEGIN
    FOREACH f, format_list DO BEGIN
        dc       = date->string(format='%' + f)
        filename = str->replace(filename, dummy+f, dc, $
                                /complete)
        filepath = str->replace(filepath, dummy+f, dc, $
                                /complete)
    ENDFOREACH
ENDIF





;
;*---------- join filename  ----------*
;


filename_join = filename[0]
FOR i = 0, N_ELEMENTS(file_sep_list) - 1 DO BEGIN
    sep = file_sep_list[i]
    filename_join = STRJOIN([filename_join, filename[i+1]],$
                            sep) 
ENDFOR
;
filepath_join = filepath[0]
FOR i = 0, N_ELEMENTS(path_sep_list) - 1 DO BEGIN
    sep = path_sep_list[i]
    filepath_join = STRJOIN([filepath_join, filepath[i+1]],$
                            sep) 
ENDFOR

filename = filename_join
filepath = filepath_join

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




filename = path->filename(class='Cusp', sub='nbz', exten='.txt', julday=julday(1, 1, 2000), prefix='pre', misc='aaa')
print, filename

end
