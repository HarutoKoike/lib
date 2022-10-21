@grid::nearest.pro


FUNCTION grid::init
COMPILE_OPT IDL2
;
tags = N_TAGS(self)
FOR i = 0, tags - 1 DO BEGIN
    IF SIZE(self.(i), /TYPE) EQ 10 THEN $
        self.(i) = PTR_NEW(/ALLOCATE)
ENDFOR 
;

RETURN, 1  
;
END



;-------------------------------------------------+
; 
;-------------------------------------------------+
PRO grid::setprop, dim=dim, xgrid=xgrid, ygrid=ygrid, zgrid=zgrid
COMPILE_OPT IDL2
;
IF KEYWORD_SET(dim) THEN BEGIN 
    IF ~(dim EQ 3) AND ~(dim EQ 2) THEN $
        MESSAGE, 'dim must be 2 or 3'
    self.dim = dim
ENDIF
IF KEYWORD_SET(xgrid)  THEN *(self.xgrid) = xgrid
IF KEYWORD_SET(ygrid)  THEN *(self.ygrid) = ygrid
IF KEYWORD_SET(zgrid)  THEN *(self.zgrid) = zgrid
;
END



;-------------------------------------------------+
; 
;-------------------------------------------------+
PRO grid::getprop, dim=dim, xgrid=xgrid, ygrid=ygrid, zgrid=zgrid
COMPILE_OPT IDL2
;
IF KEYWORD_SET(dim) THEN BEGIN 
    IF ~(dim EQ 3) AND ~(dim EQ 2) THEN $
        MESSAGE, 'dim must be 2 or 3'
    self.dim = dim
ENDIF
;
IF ARG_PRESENT(xgrid) THEN xgrid = *(self.xgrid)
IF ARG_PRESENT(ygrid) THEN ygrid = *(self.ygrid)
IF ARG_PRESENT(zgrid) THEN zgrid = *(self.zgrid)
;
END

 




;-------------------------------------------------+
; 
;-------------------------------------------------+
PRO grid__define
COMPILE_OPT IDL2
void = {grid,             $
        dim:3,            $
        xgrid:PTR_NEW(),  $
        ygrid:PTR_NEW(),  $
        zgrid:PTR_NEW()   $
        }
END
