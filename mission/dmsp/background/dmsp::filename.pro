

;===========================================================+
; ++ NAME ++
FUNCTION dmsp::filename, ssm=ssm, ssj=ssj 
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

f   = STRING(self.f  , FORMAT='(I02)')
yr  = STRING(self.yr , FORMAT='(I04)')
mon = STRING(self.mon, FORMAT='(I02)')
dy  = STRING(self.dy , FORMAT='(I02)')

doy = JULDAY(self.mon, self.dy, self.yr) - $
      JULDAY(1, 1, self.yr) + 1
doy = STRING(doy, FORMAT='(I03)')

suffix = '.sav'
IF KEYWORD_SET(ssj) THEN suffix = 'SSJ.dat.gz'
IF KEYWORD_SET(ssm) THEN suffix = 'SSM.dat.gz'

fn = 'DMSP_F' + f + '_' + yr + doy + $
		  suffix  
fp = GETENV('DMSP_DATA_PATH') 

RETURN, fp + fn

END
