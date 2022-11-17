@date::string.pro
@date::format_list.pro
@date::convert.pro


FUNCTION date::init, _EXTRA=e
COMPILE_OPT IDL2
;
self->setprop, _EXTRA=e
self->getprop, julday=julday, year=yr
;
;
;*---------- if keyword julday is set ----------*
;
IF julday NE 0D THEN BEGIN
  CALDAT, julday, month, day, year, $
          hour, minute, second
  self->setprop, year=year, month=month, day=day, $
                 hour=hour, minute=minute, second=second
ENDIF
;
RETURN, 1
END




;-------------------------------------------------+
; set property
;-------------------------------------------------+
PRO date::setprop, julday=julday, year=year, month=month, $
                   day=day, hour=hour, minute=minute,     $
                   second=second, format=format
;
COMPILE_OPT IDL2
;
IF KEYWORD_SET(julday) THEN BEGIN 
    self.julday = julday
    CALDAT, julday, month, day, year, hour, minute, second
    self.year   = year  
    self.month  = month 
    self.day    = day   
    self.hour   = hour  
    self.minute = minute
    self.second = second
ENDIF
IF KEYWORD_SET(year)   THEN self.year   = year
IF KEYWORD_SET(month)  THEN self.month  = month
IF KEYWORD_SET(day)    THEN self.day    = day
IF KEYWORD_SET(hour)   THEN self.hour   = hour
IF KEYWORD_SET(minute) THEN self.minute = minute
IF KEYWORD_SET(second) THEN self.second = second
IF KEYWORD_SET(format) THEN self.format = format

END
 




;-------------------------------------------------+
; get property
;-------------------------------------------------+
PRO date::getprop, julday=julday, year=year, month=month, $
                   day=day, hour=hour, minute=minute,     $
                   second=second, format=format
;
COMPILE_OPT IDL2
;
IF ARG_PRESENT(julday) THEN julday = self.julday  
IF ARG_PRESENT(year)   THEN year   = self.year    
IF ARG_PRESENT(month)  THEN month  = self.month   
IF ARG_PRESENT(day)    THEN day    = self.day     
IF ARG_PRESENT(hour)   THEN hour   = self.hour    
IF ARG_PRESENT(minute) THEN minute = self.minute  
IF ARG_PRESENT(second) THEN second = self.second  
IF ARG_PRESENT(format) THEN format = self.format  
END



;-------------------------------------------------+
; 
;-------------------------------------------------+
PRO date__define
COMPILE_OPT IDL2
;
void = { date,         $
         julday :0D,   $
         year   :0 ,   $
         month  :0B,   $
         day    :0B,   $
         hour   :0B,   $
         minute :0B,   $
         second :0B,   $
         format :'',   $
         INHERITS str}
END
