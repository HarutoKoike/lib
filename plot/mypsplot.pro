PRO mypsplot, fp = fp, fn = fn, $
							xsize = xsize, ysize = ysize, open_ps = open_ps, close_ps = close_ps

	;;;
	IF KEYWORD_SET(open_ps) THEN BEGIN 
	  !P.FONT=4
		SET_PLOT, 'PS', /INTERPOLATE
    ;
		;
	  DEVICE, COLOR=1
	
		IF KEYWORD_SET(fp) THEN BEGIN 
			FILE_MKDIR, fp
		ENDIF ELSE BEGIN
			fp = GETENV('HOME') + '/'
		ENDELSE
	
		IF ~KEYWORD_SET(fn) THEN fn = 'test.eps'
	
		DEVICE, FILENAME = STRCOMPRESS(fp + fn, /REMOVE_ALL), xsize = xsize, ysize = ysize, /ENCAPSULATED
	
	ENDIF

	;;;
	IF KEYWORD_SET(close_ps) THEN BEGIN 
		DEVICE, /CLOSE
		SET_PLOT, 'X'
	  !P.FONT=-1
	ENDIF


END

