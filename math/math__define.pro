@math::in_range.pro

FUNCTION math::init
COMPILE_OPT IDL2
RETURN, 1
END



PRO math__define
COMPILE_OPT IDL2
void = {math,             $
        class_name:'math'}
END
