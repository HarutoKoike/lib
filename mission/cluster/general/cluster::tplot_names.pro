FUNCTION cluster::tplot_names, ion=ion, electron=electron, mag=mag, wave=wave, $
                               walen_test=walen_test, fote=fote, all=all, sc

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
            ;'Differential_Particle_Flux__C' + sc + '_CP_CIS-HIA_PAD_HS_MAG_IONS_PF', $
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
  tnames = [tnames, 'B_gsm__C'+sc]
ENDIF



;
;*---------- fote  ----------*
;
IF KEYWORD_SET(fote) OR KEYWORD_SET(all) THEN BEGIN
    tnames = [tnames, $
              'FOTE_curl_current_mag', $
              'FOTE_null_distance'   , $
              'FOTE_null_in_tetra'     $
             ]
ENDIF

;
;*---------- wave ----------*
;
IF KEYWORD_SET(wave) OR KEYWORD_SET(all) THEN BEGIN
  tnames = [tnames, $
            'BB_xx_st2__C3_CP_STA_PSD'    , $
            'BB_yy_st2__C3_CP_STA_PSD'    , $
            'BB_zz_st2__C3_CP_STA_PSD'    , $
            ;'BSUM__C3_CP_STA_PPP'         , $
            'EE_xx_sr2__C3_CP_STA_PSD'    , $
            'EE_yy_sr2__C3_CP_STA_PSD'      $
            ;'ESUM__C3_CP_STA_PPP'         , $

           ;'Electric_Spectral_Power_Density__C' + sc + '_CP_WHI_ACTIVE', $
           ;'ESUM__C' + sc + '_CP_STA_PPP', $
           ;'BSUM__C' + sc + '_CP_STA_PPP', $
           ;'POLSVD__C' + sc + '_CP_STA_PPP', $
           ;'ELLSVD__C' + sc + '_CP_STA_PPP', $
           ;'THSVD_mfa__C' + sc + '_CP_STA_PPP'$
           ]
ENDIF


 
;
;*----------   ----------*
;
IF KEYWORD_SET(walen_test) THEN $
    tnames = [tnames, 'Walen_test__C' + sc]
 
RETURN, tnames
END
