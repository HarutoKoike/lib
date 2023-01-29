FUNCTION tools::is_samesize, var1, var2, var3, var4, var5, $
                             var6, var7, var8, var9, var10
COMPILE_OPT IDL2, STATIC

nvars = N_PARAMS()
IF nvars LT 2 THEN RETURN, 0
;
n1   = N_ELEMENTS(var1)
disc = n1 EQ N_ELEMENTS(var2)

IF ISA(var3)  THEN disc = disc AND (n1 EQ N_ELEMENTS(var3)) 
IF ISA(var4)  THEN disc = disc AND (n1 EQ N_ELEMENTS(var4)) 
IF ISA(var5)  THEN disc = disc AND (n1 EQ N_ELEMENTS(var5)) 
IF ISA(var6)  THEN disc = disc AND (n1 EQ N_ELEMENTS(var6)) 
IF ISA(var7)  THEN disc = disc AND (n1 EQ N_ELEMENTS(var7)) 
IF ISA(var8)  THEN disc = disc AND (n1 EQ N_ELEMENTS(var8)) 
IF ISA(var9)  THEN disc = disc AND (n1 EQ N_ELEMENTS(var9)) 
IF ISA(var10) THEN disc = disc AND (n1 EQ N_ELEMENTS(var10)) 

RETURN, disc
END
