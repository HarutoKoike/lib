@str::replace.pro
@str::contain.pro

FUNCTION str::init
COMPILE_OPT IDL2
RETURN, 1
END


PRO str__define
COMPILE_OPT IDL2
void = {str, name:'str'}
END
