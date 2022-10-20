;===========================================================+
; ++ NAME ++
PRO cluster::plot_basic_var, sc, filename=filename
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
COMPILE_OPT IDL2, STATIC
;
;
tnames1 = cluster->tplot_names(sc, /ion, /electron, /mag)
tnames2 = cluster->tplot_names(sc, /wave)
;
;


IF KEYWORD_SET(filename) THEN BEGIN
    dir = FILE_DIRNAME(filename)
    IF ~FILE_TEST(dir) THEN FILE_MKDIR, dir
    filename1 = str->replace(filename, '.eps', '1.eps')
    filename2 = str->replace(filename, '.eps', '2.eps')
endif

;
; open ps
IF KEYWORD_SET(filename) THEN $
    idlplotlib->psplot, /open, filename=filename1, xsize=20, ysize=20

tplot, tnames1

; close ps
IF KEYWORD_SET(filename) THEN $
    idlplotlib->psplot, /close



; open ps
IF KEYWORD_SET(filename) THEN $
    idlplotlib->psplot, /open, filename=filename2, xsize=20, ysize=20

tplot, tnames2

; close ps
IF KEYWORD_SET(filename) THEN $
    idlplotlib->psplot, /close

 

END
