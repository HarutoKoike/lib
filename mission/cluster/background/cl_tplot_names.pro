PRO cl_tplot_names, sc, tname
;
IF ~ISA(sc) THEN sc = 3

sc = STRING(sc, FORMAT='(I1)')


;
;*----------   ----------*
;
cis_hia = [                                                  $
            'V_para_perp__C' + sc,                           $
            'V_HIA_xyz_gsm__C' + sc + '_PP_CIS',             $
            'N_HIA__C' + sc + '_PP_CIS',                     $
            'T_HIA__C' + sc + '_PP_CIS',                     $
            'flux__C' + sc + '_CP_CIS-HIA_HS_1D_PEF'         $
          ]



;
;*----------   ----------*
;
fgm = [                                           $
       'B_vec_xyz_gsm__C' + sc + '_CP_FGM_FULL',  $
       'B_xyz_gsm__C' + sc + '_PP_FGM'            $
      ]


;
;*----------   ----------*
;
fote = ['']


;
;*----------   ----------*
;
efw = [                       $
       'E_xyz_GSM__C3_EFW'    $
      ]

;
;*----------   ----------*
;
peace = [      $
         'Parallel_electron__C' + sc      , $
         'antiparallel_electron__C' + sc   ,$
         'perpendicular_electron__C' + sc   $
        ]

;
;*----------   ----------*
;
quick = [cis_hia[[4, 2, 0]], fgm[1], peace[[0, 1]]]




tname = { $
         cis:cis_hia, $
         fgm:fgm,     $
         fote:fote,   $
         peace:peace, $
         efw:efw,     $
         quick:quick  $
         }

END
