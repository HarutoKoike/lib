PRO ptr::help, vname, _EXTRA=ex

COMPILE_OPT IDL2


vname_list = *(!PTR.VNAME)
idx = WHERE( STRMATCH(vname_list, vname) EQ 1, count )



HELP, *( (*(!PTR.DATA))[idx] )[0]

END  
