;@idlplotlib::psplot.pro
;@idlplotlib::psym.pro
;@idlplotlib::field_line2d.pro
@hkplotlib::fieldline3d.pro
;@idlplotlib::polar_fill.pro
;@idlplotlib::plot_circle.pro
;@idlplotlib::horizontal_error.pro


FUNCTION hkplotlib::init
COMPILE_OPT IDL2
RETURN,1
END


PRO hkplotlib__define
COMPILE_OPT IDL2
void = {hkplotlib, $
        name:'hkplotlib'}
END
