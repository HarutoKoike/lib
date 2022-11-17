PRO compile_aacgm
;
;path  = '/Users/haruto/idl/spedas_5_0/external/aacgm_v2'
path  = '/Users/h.koike/idl/spedas_4_1/idl/external/aacgm_v2'
SETENV, 'AACGM_v2_DAT_PREFIX=' + FILEPATH('aacgm_coeffs-13-', root=path, subdir='coeffs')  
SETENV, 'IGRF_COEFFS=' + FILEPATH('magmodel_1590-2020.txt', root=path)

CATCH, error
;
IF error NE 0 THEN BEGIN
    CATCH, /CANCEL
    RETURN
ENDIF



RESOLVE_ROUTINE, 'aacgm_dummy', /EITHER, /COMPILE_FULL

END
