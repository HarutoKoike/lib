
@path::format_char.pro
@path::save_format.pro
@path::filename.pro
@path::format_list.pro

FUNCTION path::init
COMPILE_OPT IDL2
;

RETURN, 1
END


PRO path__define
COMPILE_OPT IDL2
;
DEFSYSV, '!PACKAGE_PATH', exists=exists
;
IF exists THEN BEGIN
    root = !PACKAGE_PATH
ENDIF ELSE BEGIN
    root = GETENV('HOME') + PATH_SEP() + '.idl'
ENDELSE  
;
ptr->store, 'path_root', root
                         



void = {               $
        path,          $
        name:'pathlib' $
       }
       
END
