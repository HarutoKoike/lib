



FUNCTION inertial_length, n, ion=ion, electron=electron, m=m

; n /cc
mass = !CONST.MP
n    *= 1.e6
e    = !CONST.E
;
IF KEYWORD_SET(ion)      THEN mass = !CONST.MP
IF KEYWORD_SET(electron) THEN mass = !CONST.ME
;
omega = SQRT(n*e^2/!CONST.EPS0/mass) 
IF ~KEYWORD_SET(m) THEN omega *= 1.e3

RETURN, !CONST.C/omega

END
