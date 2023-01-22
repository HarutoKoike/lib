@particle::rk4.pro
@particle::plot.pro



FUNCTION particle::init 
COMPILE_OPT IDL2
self.xarr = PTR_NEW(/ALLOCATE)
self.varr = PTR_NEW(/ALLOCATE)
RETURN, 1
END


PRO particle::SetProperty, dt=dt, t=t, r=r, velocity=velocity, xarr=xarr, varr=varr, $
                           func=func
COMPILE_OPT IDL2
IF KEYWORD_SET(dt)       THEN self.dt = dt
IF KEYWORD_SET(t)        THEN self.t = t
IF KEYWORD_SET(r)        THEN self.r = r
IF KEYWORD_SET(velocity) THEN self.velocity = velocity
IF KEYWORD_SET(xarr)     THEN *(self.xarr) = xarr
IF KEYWORD_SET(varr)     THEN *(self.varr) = varr
IF KEYWORD_SET(func)     THEN self.func = func
END

PRO particle::GetProperty, dt=dt, t=t, r=r, velocity=velocity, xarr=xarr, varr=varr, $
                           func=func
COMPILE_OPT IDL2
IF ARG_PRESENT(dt)        THEN  dt = self.dt
IF ARG_PRESENT(t)         THEN  t  = self.t 
IF ARG_PRESENT(r)         THEN  r  = self.r 
IF ARG_PRESENT(velocity)  THEN  velocity  = self.velocity 
IF ARG_PRESENT(xarr)      THEN  xarr  = self.xarr 
IF ARG_PRESENT(xarr)      THEN  varr  = self.varr 
IF ARG_PRESENT(func)      THEN  func  = self.func 
END
 

;===========================================================+
; ++ NAME ++
PRO particle__define
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
void = { particle,      $
         dt:0.   ,      $
         t:0.    ,      $
         r:FLTARR(3),   $
         velocity:FLTARR(3),   $
         xarr:PTR_NEW(), $
         varr:PTR_NEW(), $
         func:'',        $
         INHERITS IDL_OBJECT $
        } 
END
