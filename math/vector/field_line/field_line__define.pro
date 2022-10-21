@field_line::calc.pro


FUNCTION field_line::init
COMPILE_OPT IDL2
;
tags = N_TAGS(self)
FOR i = 0, tags - 1 DO BEGIN
    IF SIZE(self.(i), /TYPE) EQ 10 THEN $
        self.(i) = PTR_NEW(/ALLOCATE)
ENDFOR
;
RETURN, 1
END


PRO field_line::setprop, x0=x0, y0=y0, z0=z0, px=px, py=py, pz=pz, mag=mag
COMPILE_OPT IDL2
;
IF KEYWORD_SET(x0) THEN *(self.x0) = x0
IF KEYWORD_SET(y0) THEN *(self.y0) = y0
IF KEYWORD_SET(z0) THEN *(self.z0) = z0
IF KEYWORD_SET(px) THEN *(self.px) = px
IF KEYWORD_SET(py) THEN *(self.py) = py
IF KEYWORD_SET(pz) THEN *(self.pz) = pz
IF KEYWORD_SET(mag) THEN *(self.mag) = mag

END


PRO field_line::getprop, x0=x0, y0=y0, z0=z0, px=px, py=py, pz=pz, mag=mag
COMPILE_OPT IDL2
;
IF ARG_PRESENT(x0) THEN x0 = *(self.x0) 
IF ARG_PRESENT(y0) THEN y0 = *(self.y0) 
IF ARG_PRESENT(z0) THEN z0 = *(self.z0) 
IF ARG_PRESENT(px) THEN px = *(self.px) 
IF ARG_PRESENT(py) THEN py = *(self.py) 
IF ARG_PRESENT(pz) THEN pz = *(self.pz) 
IF ARG_PRESENT(mag) THEN mag = *(self.mag)

END



PRO field_line__define
COMPILE_OPT IDL2
;
void = { field_line,               $
         x0:PTR_NEW() ,            $
         y0:PTR_NEW() ,            $
         z0:PTR_NEW() ,            $
         px:PTR_NEW() ,            $
         py:PTR_NEW() ,            $
         pz:PTR_NEW() ,            $
         mag:PTR_NEW(),            $
         INHERITS vector_field     $
         }

END 
