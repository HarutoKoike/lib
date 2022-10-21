FUNCTION vector_field::init
COMPILE_OPT IDL2
;
tags = N_TAGS(self)
FOR i = 0, tags - 1 DO BEGIN
    IF SIZE(self.(i), /TYPE) EQ 10 THEN $
        self.(i) = PTR_NEW(/ALLOCATE)
ENDFOR 
RETURN, 1
END


PRO vector_field::setprop, x=x, y=y, z=z, vx=vx, vy=vy, vz=vz, dim=dim
COMPILE_OPT IDL2
;
IF KEYWORD_SET(x)  THEN *(self.x) = x
IF KEYWORD_SET(y)  THEN *(self.y) = y
IF KEYWORD_SET(z)  THEN *(self.z) = z
IF KEYWORD_SET(vx) THEN *(self.vx) = vx
IF KEYWORD_SET(vy) THEN *(self.vy) = vy
IF KEYWORD_SET(vz) THEN *(self.vz) = vz
IF KEYWORD_SET(dim) THEN self.dim = dim

RETURN
END

PRO vector_field::getprop, x=x, y=y, z=z, vx=vx, vy=vy, vz=vz
COMPILE_OPT IDL2
;
IF ARG_PRESENT(x)  THEN x  = *(self.x) 
IF ARG_PRESENT(y)  THEN y  = *(self.y) 
IF ARG_PRESENT(z)  THEN z  = *(self.z) 
IF ARG_PRESENT(vx) THEN vx = *(self.vx) 
IF ARG_PRESENT(vy) THEN vy = *(self.vy) 
IF ARG_PRESENT(vz) THEN vz = *(self.vz) 

RETURN
END



PRO vector_field__define
COMPILE_OPT IDL2
void = { vector_field,    $
         dim:3       ,    $
         x:PTR_NEW() ,    $
         y:PTR_NEW() ,    $
         z:PTR_NEW() ,    $
         vx:PTR_NEW() ,   $
         vy:PTR_NEW() ,   $
         vz:PTR_NEW()}
END
