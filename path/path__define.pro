
@path::format_char.pro
@path::save_format.pro
@path::filename.pro
@path::format_list.pro

FUNCTION path::init
COMPILE_OPT IDL2
;
IF ISA(!PACKAGE_PATH) THEN BEGIN
    root = !PACKAGE_PATH
ENDIF ELSE BEGIN
    root = GETENV('HOME') + PATH_SEP() + '.idl'
ENDIF  
;
ptr->store, 'path_root', root

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
