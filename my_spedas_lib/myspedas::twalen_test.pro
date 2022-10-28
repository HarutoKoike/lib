;===========================================================+
; ++ NAME ++
FUNCTION myspedas::twalen_test, trange, v_name, b_name, va_name, e_name
;
; ++ PURPOSE ++
;  -->
;
; ++ POSITIONAL ARGUMENTS ++
;  --> v_name(string): tplot name of velocity vector (3xN)
;  --> b_name(string): tplot name of magnetic field vector (3xN)
;  --> va_name(string): tplot name of Alfven velocity vector (3xN)
;  --> e_name(string): tplot name of electric field vector (3xN) (V x B)
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
;
COMPILE_OPT IDL2, STATIC
;
idx1 = nn(v_name, trange)
idx2 = nn(b_name, trange)
idx3 = nn(va_name, trange)
idx4 = nn(e_name, trange)

;
get_data, v_name, data=v
get_data, b_name, data=b
get_data, va_name, data=va
get_data, e_name, data=e
;

t  = b.x[idx2[0]:idx2[1]]
bx = b.y[idx2[0]:idx2[1], 0]
by = b.y[idx2[0]:idx2[1], 1]
bz = b.y[idx2[0]:idx2[1], 2]
;
vt = v.x[idx1[0]:idx1[1]]
vx = interp(v.y[idx1[0]:idx1[1], 0], vt, t)
vy = interp(v.y[idx1[0]:idx1[1], 1], vt, t)
vz = interp(v.y[idx1[0]:idx1[1], 2], vt, t)
;
et = e.x[idx4[0]:idx4[1]]
ex = interp(e.y[idx4[0]:idx4[1], 0], et, t)
ey = interp(e.y[idx4[0]:idx4[1], 1], et, t)
ez = interp(e.y[idx4[0]:idx4[1], 2], et, t)
;
vat = va.x[idx3[0]:idx3[1]]
vax = interp(va.y[idx3[0]:idx3[1], 0], vat, t)
vay = interp(va.y[idx3[0]:idx3[1], 1], vat, t)
vaz = interp(va.y[idx3[0]:idx3[1], 2], vat, t)

math->walen_test, vx, vy, vz, vax, vay, vaz, ex, ey, ez, bx, by, bz, correlation
;
RETURN, correlation
END
