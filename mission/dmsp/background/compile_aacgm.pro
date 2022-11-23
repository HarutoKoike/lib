PRO compile_aacgm
;
path  = FILE_WHICH('aacgm_v2.pro')
path  = FILE_DIRNAME(path)
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
