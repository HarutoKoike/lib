;===========================================================+
; ++ NAME ++
PRO myspedas::tsavgol, tname, nleft, nright, order, degree, double=double, newname=newname, _EXTRA=e, $
                       subtract=subtract
;
; ++ PURPOSE ++
;  --> This prosedure makes a new tplot variable filtered by the Savitky-Golay filter.
;
; ++ POSITIONAL ARGUMENTS ++
;  --> tname  : tplot variable name to be filtered
;  --> others : same as the IDL native function "SAVGOL",
;               see  https://www.l3harrisgeospatial.com/docs/SAVGOL.html
;
; ++ KEYWORDS ++
; -->  newname  : new tplot name for the filtered data
; -->  subtract : set this keyword to get fluctuation data = (raw data) - (smoothed data)
;
; ++ CALLING SEQUENCE ++
;  --> tsavgol, 'Bx', 10, 10, 0, 4, newname='Bx_sg-filtered'
;
; ++ HISTORY ++
;  H.Koike 2022/06/23
;===========================================================+
COMPILE_OPT IDL2
;
IF ISA(tname, 'INT') THEN tname = (tnames())[tname-1]
;
get_data, tname, data=d, dlim=dlim

;
;*---------- data points  ----------*
;
IF ~ISA(nleft) OR ~ISA(nright) THEN BEGIN
    get_timespan, ts
    idx = nn(tname, ts)
    ;
    n_all = idx[1] - idx[0] + 1
    nleft = FLOOR( (n_all-1)/2 )
    nright= nleft
ENDIF

;
IF ~ISA(order) THEN order=0    ; default:smoothing
IF ~ISA(degree) THEN degree=2

;
;*---------- interpolate  ----------*
;
;
coeff_savgol = SAVGOL(nleft, nright, order, degree, DOUBLE=DOUBLE)
y_savgol     = CONVOL(d.y, coeff_savgol, _EXTRA=e)
;
y_savgol[0:nleft-1]  = !values.f_nan
y_savgol[-nright:-1] = !values.f_nan


;
;*---------- create new tplot name  ----------*
;
IF ~KEYWORD_SET(newname) THEN newname = tname + '_Savitzky-Golay'
store_data, newname, data={x:d.x, y:y_savgol}, dlim=dlim


;
;*---------- subtracted data ----------*
;
IF ~KEYWORD_SET(subtract) THEN RETURN
;
savgol_fit   = SAVGOL(nleft, nright, 0, degree)
y_subtracted = d.y - CONVOL(d.y, savgol_fit, _EXTRA=e)
;
y_subtracted[0:nleft-1]  = !values.f_nan
y_subtracted[-nright:-1] = !values.f_nan

;
store_data, tname + '_subtracted_Savitzky-Golay', data={x:d.x, y:y_subtracted}, $
            dlim=dlim

END
