;===========================================================+
; ++ NAME ++
PRO kill, process, fold_case=fold_case
;
; ++ PURPOSE ++
;  --> kill process 
;
; ++ POSITIONAL ARGUMENTS ++
;  --> process (STRING): name of process to be killed
;
; ++ KEYWORDS ++
; -->  fold_case (BOOLEAN): set this keyword for case insensitive
;
; ++ CALLING SEQUENCE ++
;  --> kill, 'Preview'
;
; ++ HISTORY ++
;   2023/01/23
;===========================================================+

IF STRMATCH(process, 'idl', /FOLD_CASE) THEN $
    MESSAGE, '"idl" process cannot be killed.'

IF ~ISA(process, 'STRING') THEN $
    MESSAGE, 'Argument must be string.'

option = ''
IF KEYWORD_SET(fold_case) THEN $
    option = ' -i '

str = 'ps -x | grep ' + option + process + ' | head -n 1' 
fn  = 'kill_process_buffer.txt'
SPAWN, str + ' >> ' + fn

;
ps = ''
OPENR, lun, fn, /GET_LUN
READF, lun, ps
FREE_LUN, lun

;
FILE_DELETE, fn
;

ps = STRSPLIT(ps, ' ', /EXTRACT)
ps = ps[0]
;
SPAWN, 'kill ' + ps
END
