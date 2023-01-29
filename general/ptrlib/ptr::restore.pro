;===========================================================+
; ++ NAME ++
PRO ptr::restore, filename
;
; ++ PURPOSE ++
;  --> ptr::restore restores save file created by ptr::save 
;
; ++ POSITIONAL ARGUMENTS ++
;  --> filename(STRING): filename of save file
;
; ++ KEYWORDS ++
; -->
;
; ++ CALLING SEQUENCE ++
;  --> ptr->restore, '~/ptrlib/ptrsave.sav'
;
; ++ HISTORY ++
;   09/2022 H.Koike 
;===========================================================+
COMPILE_OPT IDL2
;
RESTORE, filename
DEFSYSV, '!PTR', ptr_save
END
