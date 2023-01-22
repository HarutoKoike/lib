;===========================================================+
; ++ NAME ++
PRO cl_walen_test, sc, trange, window=window
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
;  H.Koike 
;===========================================================+
;
IF ~ISA(sc) THEN sc = 3
sc = STRING(sc, FORMAT='(I1)')  
;
IF ~KEYWORD_SET(window) THEN window = 11.   ; number of data points
IF ~ISA(trange) THEN get_timespan, trange
;
;cl_load, sc, /fgm, /cis, /efw
;
;
ename  = 'E_xyz_GSM__C' + sc + '_EFW'
vname  = 'V_HIA_xyz_gsm__C' + sc + '_PP_CIS'
bname  = 'B_xyz_gsm__C' + sc + '_PP_FGM'
vaname = 'Alfven_Velocity__C' + sc
;
;
get_data, bname, data=d
t  = d.X
cc = FINDGEN( N_ELEMENTS(d.X) )
cc[*] = !VALUES.F_NAN
;
whalf = (window - 1) / 2.
;
FOR i = 0, N_ELEMENTS(d.x) - 1 DO BEGIN
    IF i LT whalf THEN CONTINUE
    IF N_ELEMENTS(d.x) - i - 1 LT whalf THEN BREAK
    ;
    i0      = ROUND(i-whalf)
    i1      = ROUND(i+whalf)
    trange  = [t[i0], t[i1]]
    cc[i] = ABS(myspedas->twalen_test(trange, vname, bname, vaname, ename))
ENDFOR

;
tname =  'Walen_Test__C' + sc
store_data, tname, data={X:t, Y:cc}

            

END

