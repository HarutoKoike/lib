@cluster::authentication.pro
@cluster::input.pro
@cluster::file_search.pro
@cluster::download.pro
;@cluster::tplot_names.pro
;@cluster::plot_basic_var.pro
;@cluster::walen_test.pro
;@cluster::curlometer.pro
;@cluster::fote.pro

FUNCTION cluster::init
COMPILE_OPT IDL2
;
PRINT, '% CLUSTER object has been created'
;
RETURN, 1
END



;-------------------------------------------------+
; 
;-------------------------------------------------+
PRO cluster::GetProp, st=st, et=et, sc=sc, username=username, $
                      password=password
COMPILE_OPT IDL2
IF ARG_PRESENT(st) THEN st = self.st
IF ARG_PRESENT(et) THEN et = self.et
IF ARG_PRESENT(sc) THEN sc = self.sc
;
IF ARG_PRESENT(username) THEN username = self.username
IF ARG_PRESENT(password) THEN password = self.password
END
 



;-------------------------------------------------+
; 
;-------------------------------------------------+
PRO cluster::SetProp, st=st, et=et, sc=sc, username=username,$
                      password=password, _EXTRA=e
COMPILE_OPT IDL2
IF KEYWORD_SET(st) THEN self.st = st
IF KEYWORD_SET(et) THEN self.et = et
IF KEYWORD_SET(sc) THEN self.sc = STRING(sc, FORMAT='(I1)')
IF KEYWORD_SET(username) THEN self.username = username
IF KEYWORD_SET(password) THEN self.password = password
;
END




;-------------------------------------------------+
; 
;-------------------------------------------------+
FUNCTION cluster::lib_rootdir
COMPILE_OPT IDL2
;
root = FILE_DIRNAME(ROUTINE_FILEPATH('cluster__define'))
RETURN, root
END


;-------------------------------------------------+
; 
;-------------------------------------------------+
FUNCTION cluster::data_rootdir
COMPILE_OPT IDL2
;
root = GETENV('DATA_PATH')
;
IF STRLEN(root) EQ 0 THEN root = GETENV('SPEDAS_DATA_PATH')
IF STRLEN(root) EQ 0 THEN CD, CURRENT=root  
;
root = FILEPATH('Cluster', root=root)
;
IF ~FILE_TEST(root) THEN FILE_MKDIR, root
;
RETURN, root 
END


;-------------------------------------------------+
; 
;-------------------------------------------------+
PRO cluster__define
COMPILE_OPT IDL2
void = {                                 $
        cluster,                         $
        st       : '',                   $
        et       : '',                   $
        sc       : '',                   $
        username : 'hkoike'             ,$
        password : '@_2CLDBBmjpbrss'    ,$
        INHERITS IDL_OBJECT              $
        }
END
