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
r1 = v1 * dt
v2 = CALL_FUNCTION(func, t0 + 0.5*dt, r0 + r1 * 0.5, v0 + v1*0.5 ) * dt
r2 = v2 * dt
v3 = CALL_FUNCTION(func, t0 + 0.5*dt, r0 + r2 * 0.5, v0 + v2*0.5 ) * dt
r3 = v3 * dt
v4 = CALL_FUNCTION(func, t0 + dt,     r0 + r3, v0 + v3     ) * dt
r4 = v4 * dt
;
self.t = t0 + dt
self.velocity = v0 + (v1 + 2.*v2 + 2.*v3 + v4) / 6.
self.r = r0 + (r1 + 2*r2 + 2*r3 + r4) / 6.
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
