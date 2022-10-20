;===========================================================+
; ++ NAME ++
FUNCTION path::filename, class=class, subclass=subclass, $
                         suffix=suffix, prefix=prefix,   $
                         misc=misc, $
                         julday=julday, extension=extension, $
                         format_file=format_file, mkdir=mkdir, $
                         filename_only=filename_only
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
  save_dir    = FILEPATH('naming_format', ROOT=ptr->get('path_root') )
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
;*---------- separator list and position ----------*
;
;
path->format_char, sep=sep
sep = [sep, '%']
sep = '(' + STRJOIN(sep, '|') + ')+'
;
l0       = str->split2(format, sep, /REGEX)
filename = l0[0]
sep_list_filename = l0[1]
sep_idx_filename  = l0[2]
;
l1  = str->split2(path_format, sep, /REGEX)
filepath = l1[0]
sep_list_filepath = l1[1]
sep_idx_filepath  = l1[2]



;
;*---------- dummy charactor  ----------*
;
dummy = 'dummydummydummydummy122241'
filename = dummy + filename
filepath = dummy + filepath



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
ENDIF ELSE BEGIN
    filename = str->replace(filename, dummy+'misc', '', $
                            /complete)
    filepath = str->replace(filepath, dummy+'misc', '', $
                            /complete)
ENDELSE





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
;*---------- join ----------*
;
filename = str->join2(filename, sep_list_filename, $
                      sep_idx_filename)
filepath = str->join2(filepath, sep_list_filepath, $
                      sep_idx_filepath)
filename = str->replace(filename, '%', '')
filepath = str->replace(filepath, '%', '')


;
;*---------- delete dummy charactor ----------*
;
filename = str->replace(filename, dummy, '')
filepath = str->replace(filepath, dummy, '')



;
;*---------- add extension  ----------*
;
IF KEYWORD_SET(extension) THEN $
  filename += extension


;
;*---------- make directory  ----------*
;
IF ~FILE_TEST(filepath) AND KEYWORD_SET(mkdir) THEN $
    FILE_MKDIR, filepath


IF KEYWORD_SET(filename_only) THEN RETURN, filename 
RETURN, FILEPATH(filename, ROOT=filepath)
END
