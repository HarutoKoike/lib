FUNCTION plasma::alfven, b, n, ion=ion, electron=electron
COMPILE_OPT IDL2, STATIC
;
m = !CONST.MP
IF KEYWORD_SET(electron) THEN m = !CONST.ME 
;
b0 = b * 1.e-9 
n0 = n * 1.e6

RETURN, b0 / SQRT(m * n0 * !CONST.MU0) * 1.e-3
END



PRO plasma::palameters
END
