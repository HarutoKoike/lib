PRO cdf::print_gatts
COMPILE_OPT IDL2
;
gatts = (*(self.info)).gatts

keys = gatts.Keys()
n    = gatts.Count()


FOR i = 0, n-1 DO BEGIN
    PRINT, '' 
    PRINT, '========================================='
    PRINT, ' ', keys[i]
    PRINT, '' 
    PRINT, '      ', gatts[ keys[i] ]
    PRINT, '' 
    PRINT, '' 
ENDFOR

END
