
@path::format_char.pro
@path::save_format.pro
@path::filename.pro
@path::format_list.pro

FUNCTION path::init
COMPILE_OPT IDL2
RETURN, 1
END


PRO path__define
COMPILE_OPT IDL2
;
void = {               $
        path,          $
        name:'pathlib' $
       }
       
END
