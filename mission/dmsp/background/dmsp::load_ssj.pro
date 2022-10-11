 
;================================================+
; ++ NAME ++
;  --> dmsp_load_ssj.pro
FUNCTION dmsp::load_ssj
;
; ++ PURPOSE ++
;  --> This procedure reads SSJ/5 sensor binary file and process data to scientifically usable quantities 
;
; ++ POSITIONAL ARGUMENTS ++
;  --> sat(byte)   : space craft flught number  ;  --> yr(integer) : year
;  --> mon(byte)   : month
;  --> dy(byte)    : day
;
; ++ KEYWORDS ++
; -->
;
;
; ++ HISTORY ++
;  H.Koike 5/9,2020
;
; !!! NOTE !!!
; -> ssj4/5 binary file is written in 2 byte unsigned integer (0 ~ 65535) by big endian encoding 
; -> missing data are zero filled
;
;===============================================+

;------------------------------------------------------+
; download ssj file from noaa
;------------------------------------------------------+
self->download, /ssj, success, fn
IF ~success THEN RETURN, 0  
;
;*---------- gunzip file  ----------*
;
FILE_GUNZIP, fn, /DELETE
fn = STRMID(fn, 0, STRPOS(fn, '.gz') ) ; j5f1611001.gz
; ssj sensor number
ssj = STRMID(fn, 8, 1, /REVERSE_OFFSET)


;------------------------------------------------------+
; read ssj
;------------------------------------------------------+
sod  = 86400L      ; seconds of day    00:00:00 ~ 23:59:59
nmin = 2640L      ; 2640 words per min,
ndy  = 1440L       ; 1440 minutes per day
nf   = nmin * ndy    
;  
ON_IOERROR, errlab
OPENR, lun, fn, /GET_LUN, /SWAP_ENDIAN  ; big endian
; set data array
fst = FSTAT(lun)
words = fst.size / 2      ; total byte / 2  (2byte per word)
; 
IF words MOD nmin NE 0 THEN RETURN, 0

ind_dum = LINDGEN(words)  ; index
dumarr = UINTARR(words)

READU, lun, dumarr
FREE_LUN, lun

; delete file
FILE_DELETE, fn



;----------------------------------------------------------------+
; binary --> unsigned integer
;----------------------------------------------------------------+
; time unit for word 18  ->  1:millisecond 
t_unit_dum = dumarr[ WHERE( ind_dum MOD nmin EQ 2595L ) ]
ind_milli = WHERE(t_unit_dum EQ 1U)
t_unit_dum = MAKE_ARRAY(N_ELEMENTS(t_unit_dum), /DOUBLE, VALUE = 1D)
t_unit_dum[ind_milli] = 0.001D
t_unit = DBLARR(sod) 
;
FOR i = 0, N_ELEMENTS(t_unit_dum) - 1 DO BEGIN 
	ns = LONG(i) * 60L
	t_unit[ns : ns+59L] = t_unit_dum[i]
ENDFOR
t_unit_dum = 0
ind_milli = 0
;
;*---------- particle count raw data ----------*
;
dumarr = dumarr[ WHERE( (ind_dum MOD nmin GE 15) AND $
												(ind_dum MOD nmin LE 2594) ) ]  			  ; ignore word 1 ~ 15, 2596~ (per 1min)


ebin = 20                                                       ; energy bins 
t    = DINDGEN(sod)                                             ; time
t0 	 = JULDAY(1, 1, 1970, 0, 0, 0) * 86400D                       
t1   = JULDAY(self.mon, self.dy, self.yr, 0, 0, 0) * 86400D
sdt  = t1 - t0                                                  ; UNIX time
t += sdt                                                        
;
;*---------- make array for particle flux  ----------*
;
ji  = MAKE_ARRAY(ebin, sod, /FLOAT, VALUE = !VALUES.F_NAN)      ; ion count
je  = MAKE_ARRAY(ebin, sod, /FLOAT, VALUE = !VALUES.F_NAN)      ; electron count
jei = MAKE_ARRAY(ebin, sod, /FLOAT, VALUE = !VALUES.F_NAN)      ; ion differential energy flux
jee = MAKE_ARRAY(ebin, sod, /FLOAT, VALUE = !VALUES.F_NAN)      ; electron differential energu flux
nsec = 43L                                                      ; data per 1 sec ion&electron&time
ind_dum = LINDGEN( N_ELEMENTS(dumarr) )                         ; remake ind_dum
;
;*---------- time array  ----------*
;
hr 		= dumarr[ WHERE( ind_dum MOD nsec EQ 0 ) ]   				 		  ; hour of day
min 	= dumarr[ WHERE( ind_dum MOD nsec EQ 1 ) ]    			 		  ; minutes of hour
sec 	= dumarr[ WHERE( ind_dum MOD nsec EQ 2 ) ]   				 		  ; seconds of minute
t_dum = hr * 3600L + min * 60L + LONG(FLOOR(sec * t_unit)) 		  ; seconds of day time for valid data
hr = 0
min = 0
sec = 0
t_unit = 0
;
;*---------- electron data ----------*
;
je[0, t_dum] = dumarr[ WHERE( ind_dum MOD nsec EQ 6L ) ]    ; electron channel 1   30000eV
je[1, t_dum] = dumarr[ WHERE( ind_dum MOD nsec EQ 5L ) ]    ; electron channel 2   20400eV
je[2, t_dum] = dumarr[ WHERE( ind_dum MOD nsec EQ 4L ) ]    ; electron channel 3   13900eV
je[3, t_dum] = dumarr[ WHERE( ind_dum MOD nsec EQ 3L ) ]    ; electron channel 4   9450eV
je[4, t_dum] = dumarr[ WHERE( ind_dum MOD nsec EQ 10L ) ]   ; electron channel 5   6460eV
je[5, t_dum] = dumarr[ WHERE( ind_dum MOD nsec EQ 9L ) ]    ; electron channel 6   4400eV
je[6, t_dum] = dumarr[ WHERE( ind_dum MOD nsec EQ 8L ) ]    ; electron channel 7   3000eV
je[7, t_dum] = dumarr[ WHERE( ind_dum MOD nsec EQ 7L ) ]    ; electron channel 8   2040eV
je[8, t_dum] = dumarr[ WHERE( ind_dum MOD nsec EQ 14L )]    ; electron channel 9   1392eV
je[9, t_dum] = dumarr[ WHERE( ind_dum MOD nsec EQ 13L )]    ; electron channel 10  949eV
je[10, t_dum] = dumarr[ WHERE( ind_dum MOD nsec EQ 12L )]   ; electron channel 11  949eV
je[11, t_dum] = dumarr[ WHERE( ind_dum MOD nsec EQ 11L )]   ; electron channel 12  646eV
je[12, t_dum] = dumarr[ WHERE( ind_dum MOD nsec EQ 18L )]   ; electron channel 13  440eV
je[13, t_dum] = dumarr[ WHERE( ind_dum MOD nsec EQ 17L )]   ; electron channel 14  440eV
je[14, t_dum] = dumarr[ WHERE( ind_dum MOD nsec EQ 16L )]   ; electron channel 15  204eV
je[15, t_dum] = dumarr[ WHERE( ind_dum MOD nsec EQ 15L )]   ; electron channel 16  139eV
je[16, t_dum] = dumarr[ WHERE( ind_dum MOD nsec EQ 22L )]   ; electron channel 17  95eV
je[17, t_dum] = dumarr[ WHERE( ind_dum MOD nsec EQ 21L )]   ; electron channel 18  65eV
je[18, t_dum] = dumarr[ WHERE( ind_dum MOD nsec EQ 20L )]   ; electron channel 19  44eV
je[19, t_dum] = dumarr[ WHERE( ind_dum MOD nsec EQ 19L )]   ; electron channel 20  30eV
;
;*---------- electron raw data --> electron row count  ----------*
;
xe = je MOD 32
ye = (je - xe) / 32
je = (xe + 32) * 2 ^ ye - 33
xe = 0
ye = 0

;
;*---------- ion  ----------*
;
ji[0, t_dum] = dumarr[ WHERE( ind_dum MOD nsec EQ 26L ) ]   ; ion channel 1   30000eV
ji[1, t_dum] = dumarr[ WHERE( ind_dum MOD nsec EQ 25L ) ]   ; ion channel 2   20400eV
ji[2, t_dum] = dumarr[ WHERE( ind_dum MOD nsec EQ 24L ) ]   ; ion channel 3   13900eV
ji[3, t_dum] = dumarr[ WHERE( ind_dum MOD nsec EQ 23L ) ]   ; ion channel 4   9450eV
ji[4, t_dum] = dumarr[ WHERE( ind_dum MOD nsec EQ 30L ) ]   ; ion channel 5   6460eV
ji[5, t_dum] = dumarr[ WHERE( ind_dum MOD nsec EQ 29L ) ]   ; ion channel 6   4400eV
ji[6, t_dum] = dumarr[ WHERE( ind_dum MOD nsec EQ 28L ) ]   ; ion channel 7   3000eV
ji[7, t_dum] = dumarr[ WHERE( ind_dum MOD nsec EQ 27L ) ]   ; ion channel 8   2040eV
ji[8, t_dum] = dumarr[ WHERE( ind_dum MOD nsec EQ 34L ) ]   ; ion channel 9   1392eV
ji[9, t_dum] = dumarr[ WHERE( ind_dum MOD nsec EQ 33L ) ]   ; ion channel 10  949eV
ji[10, t_dum] = dumarr[ WHERE( ind_dum MOD nsec EQ 32L) ]   ; ion channel 11  949eV
ji[11, t_dum] = dumarr[ WHERE( ind_dum MOD nsec EQ 31L) ]   ; ion channel 12  646eV
ji[12, t_dum] = dumarr[ WHERE( ind_dum MOD nsec EQ 38L) ]   ; ion channel 13  440eV
ji[13, t_dum] = dumarr[ WHERE( ind_dum MOD nsec EQ 37L) ]   ; ion channel 14  440eV
ji[14, t_dum] = dumarr[ WHERE( ind_dum MOD nsec EQ 36L) ]   ; ion channel 15  204eV
ji[15, t_dum] = dumarr[ WHERE( ind_dum MOD nsec EQ 35L) ]   ; ion channel 16  139eV
ji[16, t_dum] = dumarr[ WHERE( ind_dum MOD nsec EQ 42L) ]   ; ion channel 17  95eV
ji[17, t_dum] = dumarr[ WHERE( ind_dum MOD nsec EQ 41L) ]   ; ion channel 18  65eV
ji[18, t_dum] = dumarr[ WHERE( ind_dum MOD nsec EQ 40L) ]   ; ion channel 19  44eV
ji[19, t_dum] = dumarr[ WHERE( ind_dum MOD nsec EQ 39L) ]   ; ion channel 20  30eV
;
;*---------- ion raw data --> ion row count  ----------*
;
xi = ji MOD 32
yi = (ji - xi) / 32
ji = (xi + 32) * 2 ^ yi - 33
xi = 0
yi = 0


; delete dumarray
dumarr = 0
t_dum = 0

; dt : accumulation time 
IF self.f GE 16 THEN dt = 0.05      ; for SSJ5
IF self.f LT 16 THEN dt = 0.098     ; for SSJ4

; energy bin central value
E = [30000., 20400., 13900., 9450., 6460., 4400., 3000., 2040., 1392., 949., $
			949., 646., 440., 300., 204., 139., 95., 65., 44., 30. ]
; channel spacing (eV)
dE = [9600., 8050., 5475., 3720., 2525., 1730., 1180., 804., 545.5, 373., $
			373., 254.5, 173., 118., 80.5, 54.5, 37, 25.5, 17.5, 14. ]
;

; electron channel geometric factors (cm^2 eV ster) 1 ~ 20
e_fact16 = [1.781, 1.477, 1.188, 0.935, 0.722, 0.551, 0.416, 0.306, 0.225, 0.166, !VALUES.F_NAN, $
						0.123, 0.0876, 0.0613, 0.0429, 0.0289, 0.0182, 0.0113, 0.00621, 0.00307 ]
e_fact17 = [1.044, 0.808, 0.602, 0.458, 0.349, 0.262, 0.191, 0.142, 0.103, 0.0727, !VALUES.F_NAN, $
					0.0541, 0.0394, 0.0276, 0.0188, 0.0134, 0.00901, 0.00645, 0.00445, 0.00294 ]
e_fact18 = [0.725, 0.534, 0.412, 0.315, 0.266, 0.199, 0.147, 0.107, 0.0803, 0.0562, !VALUES.F_NAN, $
					0.041, 0.0296, 0.0203, 0.014, 0.0104, 0.00708, 0.00562, 0.00386, 0.00239 ]
; ion channel geometric factors (cm^2 eV ster) 1 ~ 20
i_fact16 = [13.3, 8.51, 5.43, 3.43, 2.19, 1.4, 0.903, 0.575, 0.368, 0.244, !VALUES.F_NAN, $
						0.162, 0.105, 0.0718, 0.0505, 0.0342, 0.023, 0.0157, 0.00745, 0.00394 ]
i_fact17 = [5.71, 3.81, 2.54, 1.7, 1.13, 0.715, 0.47, 0.306, 0.199, 0.122, !VALUES.F_NAN, $
						0.0899, 0.0581, 0.0307, 0.017, 0.0101, 0.005, 0.00302, 0.00158, 0.000911]
i_fact18 = [10.6, 6.9, 4.51, 2.81, 1.82, 1.19, 0.774, 0.485, 0.296, 0.208, !VALUES.F_NAN, $
						0.15, 0.105, 0.0725, 0.0448, 0.0324, 0.0215, 0.0113, 0.00448, 0.00182]

; select factor
CASE self.f OF 
	'16' : BEGIN 
						e_fact = e_fact16
						i_fact = i_fact16
				 END
	'17' : BEGIN 
						e_fact = e_fact17
						i_fact = i_fact17
				 END
  '18' : BEGIN 
						e_fact = e_fact18
						i_fact = i_fact18
				 END
ENDCASE



;----------------------------------------------------------------+
; calculate differential & total flux
;----------------------------------------------------------------+
;
;*---------- row count --> differential number/energy flux  ----------*
;
FOR i = 0, ebin - 1 DO BEGIN 
	ji[i, *] = ji[i, *] / (i_fact[i] * dt)
	je[i, *] = je[i, *] / (e_fact[i] * dt)
	jei[i, *] = ji[i, *] * E[i]
	jee[i, *] = je[i, *] * E[i]
ENDFOR

; discard channel 11
IF self.f GE 16 THEN BEGIN 
	ind_ssj5 = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 11, $
							12, 13, 14, 15, 16, 17, 18, 19]
	ji  = ji[ind_ssj5, *]
	je  = je[ind_ssj5, *]
	jei = jei[ind_ssj5, *]
	jee = jee[ind_ssj5, *]
	E   = E[ind_ssj5]
	dE  = dE[ind_ssj5]
ENDIF

;
;*---------- grid ----------*
;
n_egrid = N_ELEMENTS(E) 
e_plus  = FLTARR( n_egrid ) 
e_minus = FLTARR( n_egrid ) 
e_plus[-1] = 0
e_minus[0] = 0
FOR i = 1, n_egrid - 1 DO BEGIN
	e_plus[i-1]  = ABS((e[i] - e[i-1]) / 2.)	
	e_minus[i]   = ABS((e[i] - e[i-1]) / 2.)
ENDFOR
;for i = 0, n_egrid - 1 do begin
;	if i eq 0 then begin
;		e_plus[i]  = e[i+1] - e[i]
;		e_minus[i] = 0
;		continue
;	endif
;	if i eq n_egrid - 1 then begin
;		e_plus[i]  = 0
;		e_minus[i] = e[i] - e[i-1]
;		continue
;	endif
;	if i ge 1 and i le n_elements(e) - 2 then begin
;		e_plus[i]  = (e[i+1] - e[i-1]) / 2 / 2 
;		e_minus[i] = (e[i+1] - e[i-1]) / 2 / 2 
;	endif
;endfor 



; missing data  -> 0 for calculate total number/energy flux
ind_miss_e = WHERE( je LT 0 , counte) 
ind_miss_i = WHERE( ji LT 0 , counti) 
IF counte NE 0 THEN BEGIN 
	je[ind_miss_e] = 0.
	jee[ind_miss_e] = 0.
ENDIF
IF counti NE 0 THEN BEGIN 
	ji[ind_miss_i] = 0.
	jei[ind_miss_i] = 0.
ENDIF

;
;*---------- calculate total flux (integrate over energy bins)   (Hardy et al.,2008) ----------* 
;
jtote  =  je[0, *]  * (E[0] - E[1]) + je[18, *]  * (E[17] - E[18])	
jetote =  jee[0, *] * (E[0] - E[1]) + jee[18, *] * (E[17] - E[18])	
jtoti  =  ji[0, *]  * (E[0] - E[1]) + ji[18, *]  * (E[17] - E[18])	
jetoti =  jei[0, *] * (E[0] - E[1]) + jei[18, *] * (E[17] - E[18])	
FOR i = 1, 17 DO BEGIN 
	jtote  +=  je[i, *]  * (E[i-1] - E[i+1]) / 2.
	jetote +=  jee[i, *] * (E[i-1] - E[i+1]) / 2.
	jtoti  +=  ji[i, *]  * (E[i-1] - E[i+1]) / 2.
	jetoti +=  jei[i, *] * (E[i-1] - E[i+1]) / 2.
ENDFOR

; [1, 86400] -> [86400]
jtote	 = REFORM(jtote)
jetote = REFORM(jetote)
jtoti	 = REFORM(jtoti)
jetoti = REFORM(jetoti)

; set NaN
IF counte NE 0 THEN BEGIN 
	je[ind_miss_e] = !VALUES.F_NAN
	jee[ind_miss_e] = !VALUES.F_NAN
ENDIF
IF counti NE 0 THEN BEGIN 
	ji[ind_miss_i] = !VALUES.F_NAN
	jei[ind_miss_i] = !VALUES.F_NAN
ENDIF
ind_miss_e = 0
ind_miss_i = 0

;
;*---------- average energy (flux average, moment, 2kT)  ----------*
;
Eave_e = jetote / jtote
Eave_i = jetoti / jtoti



;----------------------------------------------------------------+
; data set
;----------------------------------------------------------------+
d = {                     $
			ssj     :  ssj     ,$
			t       :  t       ,$
			jee     :  jee     ,$
			je      :  je      ,$
			jei     :  jei     ,$
			ji      :  ji      ,$
			jtote   :  jtote   ,$ 
			jetote  :  jetote  ,$
			jtoti   :  jtoti   ,$
			jetoti  :  jetoti  ,$
			Ee      :  Eave_e  ,$
			Ei      :  Eave_i  ,$
			Ebin    :  E       ,$
			delta_e :  dE      ,$
			e_plus  :  e_plus  ,$
			e_minus :  e_minus  $
		}
RETURN, d



;----------------------------------------------------------------+
; I/O error
;----------------------------------------------------------------+
errlab : 
SPAWN, 'rm ' + rf_ssj + '*'
PRINT, 'I/O ERROR'
RETURN, 0

END







 
