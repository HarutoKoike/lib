;===========================================================+
; ++ NAME ++
PRO cdf::info, test 
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
;===========================================================+
COMPILE_OPT IDL2
;
id = self.id
;
;
;*----------   ----------*
;
inq = CDF_INQUIRE(id)
CDF_CONTROL, id, GET_NUMATTRS=natts


;
;*---------- get variable name ----------*
;
varnames = STRARR(inq.nzvars)
FOR i = 0, inq.nzvars -1 DO BEGIN 
    vinq = CDF_VARINQ(id, i, /ZVAR)
    varnames[i] = vinq.name
ENDFOR



;
;*---------- create struct for variable info  ----------*
;
variables = PTRARR(inq.nzvars, /ALLOCATE)
;
FOR i = 0, inq.nzvars - 1 DO $
    *(variables[i]) = {name : varnames[i]}
    


;
;*---------- get variable attributes ----------*
;
i0   = natts[0] 
i1   = i0 + natts[1] - 1
;
FOR i = i0, i1 DO BEGIN  
    CDF_ATTINQ, id, i, attname, scope, maxentry, maxzentry
    ; 
    FOR j = 0, inq.nzvars - 1 DO BEGIN
        CDF_ATTGET, id, i, varnames[j], att, CDF_TYPE=ct
        ;
        dum = *(variables[j])
        *(variables[j]) = CREATE_STRUCT(dum, attname, att) 
    ENDFOR
ENDFOR




;
;*---------- get global attribute  ----------*
;
gatts = HASH()
FOR i = 0, natts[0] - 1 DO BEGIN
    CDF_ATTINQ, id, i, attname, scope, maxentry, maxzentry
    CDF_CONTROL, id, ATTRIBUTE=attname, GET_ATTR_INFO=x
    CDF_ATTGET, id, attname, x.maxgentry, gatt
    gatts[attname] = gatt 
ENDFOR



;
;*---------- set info property  ----------*
;
info = { $
         nzvars    : inq.nzvars,   $
         ngatts    : natts[0]  ,   $   ; number of global attributes
         nvatts    : natts[1]  ,   $   ; number of variable attributes
         gatts     : gatts     ,   $
         varnames  : varnames,     $
         variables : variables     $
        }

self.info = PTR_NEW(info)
END



fn = '~/idl/project/swarm/SW_OPER_MAGA_LR_1B_20131208T000000_20131208T235959_0503_MDR_MAG_LR.cdf'
c = obj_new('cdf')
c.filename=fn
c->info, v

end
