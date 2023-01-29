;===========================================================+
; ++ NAME ++
PRO io::read_ascii, filename, data
;
; ++ PURPOSE ++
;  --> This procedure reads ascii file made by 
;      io::write_ascii.pro
;
; ++ POSITIONAL ARGUMENTS ++
;  --> filename(STRING); file name to be read
;  --> data: receiver 
;
; ++ KEYWORDS ++
; -->
;
; ++ CALLING SEQUENCE ++
;  --> io->read_ascii, '~/idl/test.txt'
;
; ++ HISTORY ++
;   09/2022, H.Koike 
;===========================================================+
COMPILE_OPT IDL2, STATIC


;
;*---------- check file  ----------*
;
IF ~FILE_TEST(filename) THEN BEGIN
  MESSAGE, '% No file found: ' + filename
ENDIF



;
;*---------- check header ----------*
;
line   = ''
format = ''
;
OPENR, lun, filename, /GET_LUN
READF, lun, line
READF, lun, format
FREE_LUN, lun
;
line = LONG( STRSPLIT(line, '0', /EXTRACT) )
;
IF N_ELEMENTS(line) EQ 1 THEN RETURN
;
header_line = line[0]
nvar        = line[1]
vartypes    = line[2:-1]
;
format = ( STRSPLIT(format, ':', /EXTRACT) )[1]
format = STRCOMPRESS(format, /REMOVE_ALL)



;
;*---------- create receiver ----------*
;
FOR i = 0, nvar - 1 DO BEGIN
  IF i EQ 0 THEN BEGIN
    receiver = {var1: io->type(vartypes[i])}
  ENDIF ELSE BEGIN
    tag = 'var' + STRCOMPRESS(STRING(i+1), /REMOVE_ALL) 
    receiver = CREATE_STRUCT(receiver, tag, $
                             io->type(vartypes[i]) )
  ENDELSE
ENDFOR                
 


;
;*---------- read data ----------*
;
nd   = FILE_LINES(filename) - header_line
data = REPLICATE(receiver, nd)
;
i = 0
l = 1
dum = ''
;
OPENR, lun, filename, /GET_LUN 
WHILE ~EOF(lun) DO BEGIN
  IF l LE header_line THEN BEGIN
    READF, lun, dum
    l ++ 
    CONTINUE 
  ENDIF
  ;
  READF, lun, receiver, FORMAT=format
  data[i] = receiver
  i ++ 
ENDWHILE
FREE_LUN, lun

END
