
;===========================================================+
; ++ NAME ++
FUNCTION cluster::tplot_names, ion=ion, electron=electron, mag=mag, wave=wave, $
                               all=all, sc
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
IF ~ISA(sc) THEN sc=1
sc = STRING(sc, FORMAT='(i1)')

 
tnames = []
;
;*---------- ion  ----------*
;
IF KEYWORD_SET(ion) OR KEYWORD_SET(all) THEN BEGIN
  tnames = [tnames, $ 
            'flux__C' + sc + '_CP_CIS-HIA_HS_1D_PEF', $ 
            'N_HIA__C' + sc + '_PP_CIS',  $             
            'T_HIA__C' + sc + '_PP_CIS',  $           
            'V_para_perp__C' + sc ]               
ENDIF



;
;*---------- electron ----------*
;
IF KEYWORD_SET(electron) OR KEYWORD_SET(all) THEN BEGIN
  tnames = [tnames, $ 
            'Parallel_electron__C' + sc,     $
            'antiparallel_electron__C' + sc ]
ENDIF
 

;
;*---------- mag  ----------*
;
IF KEYWORD_SET(mag) OR KEYWORD_SET(all) THEN BEGIN
  tnames = [tnames, 'B_xyz_gsm__C3_PP_FGM']
ENDIF


;
;*---------- wave ----------*
;
IF KEYWORD_SET(wave) OR KEYWORD_SET(all) THEN BEGIN
  tnames = [tnames, $
           ;'Electric_Spectral_Power_Density__C' + sc + '_CP_WHI_ACTIVE', $
           'ESUM__C' + sc + '_CP_STA_PPP', $
           'BSUM__C' + sc + '_CP_STA_PPP', $
           'POLSVD__C' + sc + '_CP_STA_PPP', $
           'ELLSVD__C' + sc + '_CP_STA_PPP', $
           'THSVD_mfa__C' + sc + '_CP_STA_PPP'$
           ]
ENDIF
 
RETURN, tnames
END


