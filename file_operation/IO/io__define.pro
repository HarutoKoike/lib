@io::write_ascii.pro
@io::read_ascii.pro


FUNCTION io::init
COMPILE_OPT IDL2
RETURN, 1
END


PRO io__define
COMPILE_OPT IDL2
;
void = {io, name:'io'}
;
END
