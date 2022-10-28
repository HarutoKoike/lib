@myspedas::timespan.pro
@mytimespan.pro
@myspedas::trotate.pro
@myspedas::tmva.pro
@myspedas::twalen_test.pro

FUNCTION myspedas::init
COMPILE_OPT IDL2, STATIC
RETURN, 1
END


PRO myspedas__define
COMPILE_OPT IDL2, STATIC
void = { myspedas,       $
         name:'myspedas' $
       }
END
