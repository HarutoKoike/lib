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
tnames = cluster->tplot_names(sc, /ion, /electron, /mag, /walen, /wave, /fote)
;


IF KEYWORD_SET(filename) THEN $
    idlplotlib->psplot, /open, filename=filename, xsize=40, ysize=60
    
tplot, tnames



IF KEYWORD_SET(filename) THEN BEGIN
    idlplotlib->psplot, /open, filename=filename, xsize=40, ysize=40
ENDIF
    
tplot, [tnames1, tnames2]
;
FOREACH tn, tnames2 DO $
tnames_wave = cluster->tplot_names(/wave)
FOREACH tn, tnames_wave DO $
    tplot_panel, var=tn, oplotvar='Electron_cyclotoron_frequency__C'+sc

tplot_apply_databar

IF KEYWORD_SET(filename) THEN $
    idlplotlib->psplot, /close

END
