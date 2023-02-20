PRO mypsym, size=size
;
IF ~KEYWORD_SET(SIZE) THEN SIZE = 0.75
a = findgen(17) * !PI * 2 / 16.
USERSYM, size*COS(a), size*SIN(A), /FILL
;
END
