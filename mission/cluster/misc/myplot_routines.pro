


PRO mypsym , size=size, empty=empty

if ~keyword_set(size) then size = 0.75
if ~keyword_set(empty) then fill=1
if keyword_set(empty) then fill=0
a = findgen(17) * !PI * 2 / 16.
USERSYM, size*COS(a), size*SIN(A), FILL=fill

END



;;;
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
	
		fn = FILEPATH(root_dir=fp, fn)
		DEVICE, FILENAME = STRCOMPRESS(fn, /REMOVE_ALL), xsize = xsize, ysize = ysize, /ENCAPSULATED
	
	ENDIF

	;;;
	IF KEYWORD_SET(close_ps) THEN BEGIN 
		DEVICE, /CLOSE
		SET_PLOT, 'X'
	  !P.FONT=-1
	ENDIF


END
