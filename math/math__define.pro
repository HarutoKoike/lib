@math::in_range.pro
@math::fote.pro
;@math::dht_frame.pro
;@math::walen_test.pro

FUNCTION math::init
COMPILE_OPT IDL2
RETURN, 1
END



PRO math__define
COMPILE_OPT IDL2
void = {math,             $
        class_name:'math'}
END
