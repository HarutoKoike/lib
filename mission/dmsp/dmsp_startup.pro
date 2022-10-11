

path = GETENV('DMSP_PROGRAM_PATH')
IF ~STRMATCH(path, '*/') THEN $
	SETENV, 'DMSP_PROGRAM_PATH=' + path + '/'

path = GETENV('DMSP_DATA_PATH')
IF ~STRMATCH(path, '*/') THEN $
	SETENV, 'DMSP_DATA_PATH=' + path + '/'


SETENV, 'AACGM_v2_DAT_PREFIX=/Users/haruto/idl/spedas_5_0/external/aacgm_v2/coeffs/aacgm_coeffs-13-'
SETENV, 'IGRF_COEFFS=/Users/haruto/idl/spedas_5_0/external/aacgm_v2/magmodel_1590-2020.txt'

.r dmsp__define
.r dmsp::fileurl
.r dmsp::filename
.r dmsp::file_test
.r dmsp::download
.r dmsp::load_ssj
.r dmsp::load_ssm
.r dmsp::itemize
.r dmsp::tplotvar
.r dmsp_load


.r genmag
.r igrflib_v2
.r aacgmidl_v2
.r aacgmlib_v2
.r aacgm_v2
.r time
.r astalg
.r mlt_v2


.r myuseful_commands

;fdalk
;dfafa
