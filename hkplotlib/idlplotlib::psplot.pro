PRO idlplotlib::psplot, open=open, close=close, $
                        filename=filename, $
                        _EXTRA=ex
;
COMPILE_OPT IDL2, STATIC

;
;*---------- open  ----------*
;
IF KEYWORD_SET(open) THEN BEGIN 
    !P.FONT=4
    ;
    SET_PLOT, 'PS';, /INTERPOLATE
    DEVICE, COLOR=1, /ENCAPSULATED, BIT=8
    ;
    IF KEYWORD_SET(filename) THEN BEGIN
        dir = FILE_DIRNAME(filename)
        IF ~FILE_TEST(dir) THEN FILE_MKDIR, dir
    ENDIF
    ;
	IF ~KEYWORD_SET(filename) THEN BEGIN
        now = OBJ_NEW('date')
        now->setprop, julday=SYSTIME(/JULIAN) 
        filename = now->string(format='%Y%m%d_%H%M%S') + '.eps'
    ENDIF
    ;
	DEVICE, FILENAME=filename,  _EXTRA=ex
ENDIF



;
;*---------- close  ----------*
;
IF KEYWORD_SET(close) THEN BEGIN 
	DEVICE, /CLOSE
	SET_PLOT, 'X'
    !P.FONT=-1
ENDIF

END

