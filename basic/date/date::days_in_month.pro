FUNCTION date::days_in_month, month, year
COMPILE_OPT IDL2, STATIC
;
;
IF ~ISA(year)  THEN year = 2001
IF month NE 12 THEN days = JULDAY(month+1, 1, year) - JULDAY(month, 1, year)
IF month EQ 12 THEN days = 31
;
RETURN, LONG(days)
END
