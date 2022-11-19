;
FUNCTION ev2joule, ev
RETURN, !CONST.E * ev
END

FUNCTION joule2ev, joule
RETURN, joule / !CONST.E
END


;
;*---------- from eV  ----------*
;
FUNCTION ev2temp, ev
RETURN, ev2joule(ev) / !CONST.K
END

FUNCTION ev2vel, ev, electron=electron
m = !CONST.MP
IF KEYWORD_SET(electron) THEN m = !CONST.ME
;
RETURN, SQRT(2. * ev2joule(ev) / m) * 1.e-3  ; km/s
END


;
;*---------- from temperature  ----------*
;
FUNCTION temp2ev, temp, electron=electron
RETURN, joule2ev(temp*!CONST.K) 
END
; 
FUNCTION temp2vel, temp, electron=electron
m = !CONST.MP
IF KEYWORD_SET(electron) THEN m = !CONST.ME
;
RETURN, SQRT(2 * temp * !CONST.K / m) * 1.e-3 
END


;
;*---------- from velocity  ----------*
;
FUNCTION vel2ev, vel, electron=electron
m = !CONST.MP
IF KEYWORD_SET(electron) THEN m = !CONST.ME
;
RETURN, joule2ev( (vel*1.e3)^2 * 0.5 * m )
END


;===========================================================+
; ++ NAME ++
FUNCTION convert_unit, v, from_vel=from_vel, from_temp=from_temp, from_ev=from_ev, $
                          to_vel=to_vel, to_temp=to_temp, to_ev=to_ev, _EXTRA=e
;
; ++ PURPOSE ++
;  --> comvert velocity, temperature, electron volt
;
; ++ POSITIONAL ARGUMENTS ++
;  --> v: velocity(km/s) or temperature(K) or electron volt(eV)
;
; ++ KEYWORDS ++
; -->
;
; ++ CALLING SEQUENCE ++
;  -->
;
; ++ HISTORY ++
;===========================================================+

;
;*---------- from eV  ----------*
;
IF KEYWORD_SET(from_ev) AND KEYWORD_SET(to_temp) THEN $
    RETURN, ev2temp(v)

IF KEYWORD_SET(from_ev) AND KEYWORD_SET(to_vel) THEN $
    RETURN, ev2vel(v, _EXTRA=e)

;
;*---------- from temperature  ----------*
;
IF KEYWORD_SET(from_temp) AND KEYWORD_SET(to_ev) THEN $
    RETURN, temp2ev(v)

IF KEYWORD_SET(from_ev) AND KEYWORD_SET(to_vel) THEN $
    RETURN, temp2vel(v, _EXTRA=e)

;
;*---------- from velocity  ----------*
;
IF KEYWORD_SET(from_vel) AND KEYWORD_SET(to_ev) THEN $
    RETURN, vel2ev(v, _EXTRA=e)



END
