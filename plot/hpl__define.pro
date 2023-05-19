@hpl::fieldline3d.pro
@hpl::psplot.pro



;
;*---------- HKplotlib(hpl) ----------*
;
FUNCTION hpl::init
COMPILE_OPT IDL2
RETURN,1
END


PRO hpl__define
COMPILE_OPT IDL2
void = {hpl, $
        name:'hpl'}
END
