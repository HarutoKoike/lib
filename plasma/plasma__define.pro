@plasma::palameters.pro

FUNCTION plasma::init
COMPILE_OPT IDL2
RETURN,1
END


PRO plasma__define
COMPILE_OPT IDL2
void = {plasma, $
        name:'plasma'$
        }
END
