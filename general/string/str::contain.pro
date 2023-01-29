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
COMPILE_OPT IDL2
;
nl   = N_ELEMENTS(list)
disc = LONARR(N_ELEMENTS(char))
;
FOR j = 0, N_ELEMENTS(disc) - 1 DO BEGIN
    FOR i = 0, nl - 1 DO BEGIN
        disc[j] += STRMATCH(char[j], '*' + list[i] + '*')
    ENDFOR
ENDFOR


IF KEYWORD_SET(partly) THEN $
  RETURN, disc GE 1
;
RETURN, disc EQ nl
END
