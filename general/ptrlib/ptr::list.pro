;===========================================================+
; ++ NAME ++
PRO ptr::list, count=count, names=names
;
; ++ PURPOSE ++
;  --> 'ptr::list' shows infomation of all stored variables 
;
; ++ POSITIONAL ARGUMENTS ++
;  -->
;
; ++ KEYWORDS ++
; -->
;
; ++ CALLING SEQUENCE ++
;  --> ptr->list
;
; ++ HISTORY ++
;   09/2022 H.Koike 
;===========================================================+
COMPILE_OPT IDL2
;
IF ARG_PRESENT(count) THEN BEGIN
  count = N_ELEMENTS( *(!PTR.VNAME) )
  RETURN
ENDIF
;
IF ARG_PRESENT(names) THEN BEGIN
  names = *(!PTR.VNAME) 
  RETURN
ENDIF
;
PRINT, ' '
PRINT, ' '
PRINT, '% -------+---------- Stored Variables (ptrlib) ----------------------+'
PRINT, '%        |           |                        |                      |'
PRINT, '%   Num  |  Heap ID  |      Variable Name     |      Description     |'
PRINT, '%        |           |                        |                      |'
PRINT, '% -------+-----------+------------------------+----------------------+' 
IF ~ISA(!PTR.VNAME) THEN GOTO, SKIP
;
vname_list  = *(!PTR.VNAME)
description = *(!PTR.DESCRIPTION)
id          = *(!PTR.ID)

maxlen_Varname = 20


FOR i = 0, N_ELEMENTS(vname_list) - 1 DO BEGIN
  voutlen = maxlen_Varname - STRLEN(vname_list[i]) 
  ;
  vout  = '%    ' + STRING(i, FORMAT='(I3)') + ' |'
  vout += '  ' + STRING(id[i], FORMAT='(I6)') + '   |'
  vout += '  "' + vname_list[i] + '"' + STRJOIN( REPLICATE(' ', voutlen) ) + $
          '| '
  vout += description[i]
  ;
  PRINT, vout
ENDFOR

SKIP:
PRINT, '% -------+-----------+------------------------+----------------------+'
PRINT, ' '

END
