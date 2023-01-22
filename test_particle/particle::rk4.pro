;===========================================================+
; ++ NAME ++
PRO particle::rk4
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
dt   = self.dt
t0   = self.t
r0   = self.r
v0   = self.velocity
func = self.func
;
v1 = CALL_FUNCTION(func, t0,          r0, v0          ) * dt
v2 = CALL_FUNCTION(func, t0 + 0.5*dt, r0, v0 + v1*0.5 ) * dt
v3 = CALL_FUNCTION(func, t0 + 0.5*dt, r0, v0 + v2*0.5 ) * dt
v4 = CALL_FUNCTION(func, t0 + dt,     r0, v0 + v3     ) * dt
;
self.t += dt
self.velocity += (v1 + 2.*v2 + 2.*v3 + v4) / 6.
self.r += self.velocity * dt
;

IF ~ISA( *(self.xarr) ) THEN BEGIN
    *(self.xarr) = self.r
ENDIF ELSE BEGIN
    *(self.xarr) = [ [*(self.xarr)],  [self.r] ]
ENDELSE

IF ~ISA( *(self.varr) ) THEN BEGIN
    *(self.varr) = self.velocity
ENDIF ELSE BEGIN
    *(self.varr) = [ [*(self.varr)],  [self.velocity] ]
ENDELSE
;

;
END
