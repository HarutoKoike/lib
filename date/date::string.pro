;===========================================================+
; ++ NAME ++
FUNCTION date::string, format=format
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
COMPILE_OPT IDL2

;

;
;*---------- default ----------*
;
IF self.format EQ '' THEN format0 = '%Y-%m-%d/%H:%M:%S' $
  ELSE format0 = self.format

;
IF KEYWORD_SET(format) THEN $
  format0 = format

;
IF self.year  EQ 0 THEN year  = 2000 $
  ELSE year = STRING(self.year)
;
IF self.month  EQ '' THEN month  = 1 $
  ELSE month = self.month

IF self.day  EQ '' THEN day  = 1 $
  ELSE day = self.day

IF self.hour  EQ '' THEN hour  = 0 $
  ELSE hour = self.hour

IF self.minute  EQ '' THEN minute  = 0 $
  ELSE minute = self.minute

IF self.second  EQ '' THEN second  = 0 $
  ELSE second = self.second


;
;*----------   ----------*
;
IF STRPOS(format0, '%Y') NE -1 THEN $
  format0 = self->replace(format0, '%Y', $
                        STRING(year, format='(I04)') )

;
IF STRPOS(format0, '%y') NE -1 THEN $
  format0 = self->replace(format0, '%y', $
                        STRING(year mod 100 , $
                        format='(I02)') )

;
IF STRPOS(format0, '%m') NE -1 THEN $
  format0 = self->replace(format0, '%m', $
                        STRING(month, format='(I02)') )

;
IF STRPOS(format0, '%d') NE -1 THEN $
  format0 = self->replace(format0, '%d', $
                        STRING(day, format='(I02)') )

;
IF STRPOS(format0, '%H') NE -1 THEN $
  format0 = self->replace(format0, '%H', $
                        STRING(hour, format='(I02)') )

;
IF STRPOS(format0, '%M') NE -1 THEN $
  format0 = self->replace(format0, '%M', $
                        STRING(minute, format='(I02)') )

;
IF STRPOS(format0, '%S') NE -1 THEN $
  format0 = self->replace(format0, '%S', $
                        STRING(second, format='(I02)') )


RETURN, format0
END
