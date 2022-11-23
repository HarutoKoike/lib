;===========================================================+
; ++ NAME ++
PRO cluster::walen_test, sc, trange, span=span, window=window
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
;  H.Koike 1/9,2021
;===========================================================+
COMPILE_OPT IDL2
;
IF ~KEYWORD_SET(span)   THEN span = 10   ; seconds
IF ~KEYWORD_SET(window) THEN window = 31   ; seconds
IF ~ISA(trange) THEN get_timespan, trange

;

trange0 = time_double(trange)
sc0     = STRING(sc, format='(I1)')


e_name = 'E_gse_VxB__C'+sc0
v_name = 'V_HIA_xyz_gse__C'+sc0+'_PP_CIS'
b_name = 'B_xyz_gse__C'+sc0+'_PP_FGM'
;
get_data, 'N_HIA__C'+sc0+'_PP_CIS', data=n
get_data, b_name, data=b
va_name = 'Alfven_velocity_gse__C'+sc0



;
IF ~ISA(n, 'STRUCT') OR ~ISA(b, 'STRUCT') THEN RETURN
;
rho   = interp(n.y, n.x, b.x) * !const.mp * 1.e6


va_x  = b.Y[*, 0] * 1.e-9 / sqrt(!const.mu0 * rho) * 1.e-3
va_y  = b.Y[*, 1] * 1.e-9 / sqrt(!const.mu0 * rho) * 1.e-3
va_z  = b.Y[*, 2] * 1.e-9 / sqrt(!const.mu0 * rho) * 1.e-3
;
store_data, va_name, data={x:b.x, y:[[va_x], [va_y], [va_z]]}



t  = time_double(trange0)
nt = FLOOR(trange0[1]) - FLOOR(trange0[0]) + 1
t  = DINDGEN(nt) + trange0[1]
;
nwindow = (trange0[1] - trange0[0]) / DOUBLE(span)
;
t   = []
cor = []
tcenter  = trange0[0] + (window - 1) / 2.
FOR i = 0, nwindow - 1 DO BEGIN
    t0 = tcenter - (window - 1) / 2.
    t1 = tcenter + (window - 1) / 2.
    ;
    tcenter += DOUBLE(span) 
    ;
    c = myspedas->twalen_test([t0, t1], v_name, b_name, va_name, e_name)
    c = ABS(c)
    ;
    t   = [t, tcenter]
    cor = [cor, c]
ENDFOR

store_data, 'Walen_test__C'+sc0, data={x:t, y:cor}

END
