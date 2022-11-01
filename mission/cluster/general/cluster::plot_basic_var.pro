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
tnames1 = cluster->tplot_names(sc, /ion, /electron, /mag, /walen)
tnames2 = cluster->tplot_names(sc, /wave)
;
;

IF KEYWORD_SET(filename) THEN BEGIN
    dir = FILE_DIRNAME(filename)
    IF ~FILE_TEST(dir) THEN FILE_MKDIR, dir
    filename1 = str->replace(filename, '.eps', '_1.eps')
    filename2 = str->replace(filename, '.eps', '_2.eps')
endif




IF KEYWORD_SET(filename) THEN BEGIN
    idlplotlib->psplot, /open, filename=filename, xsize=40, ysize=40
ENDIF
    
tplot, [tnames1, tnames2]
;
FOREACH tn, tnames2 DO $
    tplot_panel, var=tn, oplotvar='Electron_cyclotoron_frequency__C'+sc

tplot_apply_databar

IF KEYWORD_SET(filename) THEN $
    idlplotlib->psplot, /close


END
