


;
;*----------   ----------*
;
FUNCTION joule2ev, joule

ev = joule / 1.60217e-19 

RETURN, ev

END

;
;*----------   ----------*
;
;
FUNCTION ev2joule, ev

joule = ev * 1.60217e-19

RETURN, joule

END    


;
;*----------   ----------*
;
FUNCTION velo2ev, velo

mp = 1.6726e-27
jl = 0.5 * mp * (velo * 1.e3)^2

RETURN, joule2ev(jl)

END


FUNCTION ev2velo, ev, ion=ion, electron=electron

IF KEYWORD_SET(ion)      THEN m = 1.6726e-27
IF KEYWORD_SET(electron) THEN m = 9.10938e-31

k  = ev2joule(ev)
;
velo = SQRT(2.*k/m) * 1.e-3

RETURN, velo

END




function temp2ev, temp

ev = 8.617*temp*1.e-5
return, ev
end



function alfven, n, b

va = b * 1.e-9 / sqrt(!const.mu0 * !const.mp *  n*1.e6)
return, va*1.e-3

end



FUNCTION pbeta, n, t, b, ev = ev 

;IF ~KEYWORD_SET(ev) THEN


p_therm = n*1.e6 * !CONST.K * t  
p_mag   = (b*1.e-9)^2 / 2. / !CONST.MU0
RETURN, p_therm / p_mag

END

