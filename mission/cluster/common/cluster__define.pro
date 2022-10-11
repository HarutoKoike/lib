;===========================================================+
; ++ NAME ++
;  --> cluster__define.pro
;
; ++ PURPOSE ++
;  -->
;
; ++ POSITIONAL ARGUMENTS ++
;  -->
;
; ++ KEYWORDS ++
; -->
;
; ++ CALLING SEQUENCE ++
;  -->
;
; ++ HISTORY ++
;  H.Koike 5/10,2022
;===========================================================+
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
PRO cluster::GetProp, st=st, et=et, sc=sc
COMPILE_OPT IDL2
IF ARG_PRESENT(st) THEN st = self.st
IF ARG_PRESENT(et) THEN et = self.et
IF ARG_PRESENT(sc) THEN sc = self.sc
END
 



;-------------------------------------------------+
; 
;-------------------------------------------------+
PRO cluster::SetProp, st=st, et=et, sc=sc, _EXTRA=e
COMPILE_OPT IDL2
IF KEYWORD_SET(st) THEN self.st = st
IF KEYWORD_SET(et) THEN self.et = et
IF KEYWORD_SET(sc) THEN self.sc = STRING(sc, FORMAT='(I1)')
;

END




;-------------------------------------------------+
; 
;-------------------------------------------------+
FUNCTION cluster::data_rootdir
COMPILE_OPT IDL2, STATIC
;
root = GETENV('CLUSTER_DATA_PATH')
IF STRLEN(root) EQ 0 THEN CD, CURRENT=root  
;
RETURN, root 
END



;-------------------------------------------------+
; 
;-------------------------------------------------+
PRO cluster__define
void = {                                 $
        cluster,                         $
        username : ''                   ,$
        password : ''                   ,$
        st:''                           ,$ 
        et:''                           ,$ 
        sc:'3'                          ,$ 
        INHERITS IDL_OBJECT              $
        }
END
