;===========================================================+
; ++ NAME ++
FUNCTION str::contain, char, list, partly=partly
;
; ++ PURPOSE ++
;  --> check whether a word contains specified words. 
;      if the words contains list of words, return true
;
; ++ POSITIONAL ARGUMENTS ++
;  --> char(STRING): word
;  --> list(STRING): list of words to be contained
;
; ++ KEYWORDS ++
; -->  partly(BOOLEAN): if this keyword is set, return 1 even if 
;                       at least 1 element in the list is contained
;
; ++ CALLING SEQUENCE ++
;  -->  str::contain('abcdef', ['bc', 'ac'], /partly
;
; ++ HISTORY ++
;  H.Koike 
;===========================================================+
COMPILE_OPT IDL2, STATIC
;
nl   = N_ELEMENTS(list)
disc = 0
;
FOR i = 0, nl - 1 DO BEGIN
  disc += STRMATCH(char, '*' + list[i] + '*')
ENDFOR


IF KEYWORD_SET(partly) THEN $
  RETURN, disc GE 1
;
RETURN, nl EQ disc
END
