@idlplotlib::psplot.pro
@idlplotlib::psym.pro
@idlplotlib::field_line2d.pro
@idlplotlib::field_line3d.pro


FUNCTION idlplotlib::init
COMPILE_OPT IDL2
RETURN,1
END


PRO idlplotlib__define
COMPILE_OPT IDL2
void = {idlplotlib, $
        name:'idlplotlib'}
END