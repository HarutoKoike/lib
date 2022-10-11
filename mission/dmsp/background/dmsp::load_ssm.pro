 
;====================================================+
; ++ NAME ++                                      
FUNCTION dmsp::load_ssm
;
; ++ PURPOSE ++
;  --> this procedure reads ssm magnetic field record (mfr) data files 
;
; ++ POSITIONAL ARGUMENTS ++
;  --> sat(byte)	 : space craft flight number 16, 17, 18
;  --> yr(integer) : year
;  --> mon(byte)	 : month
;  --> dy(byte)    : day
;
; ++ KEYWORDS ++
; -->
;
; ++ HISTORY ++
;  H.Koike 5/10, 2020
;====================================================+

;-------------------------------------------------------+
; download ssm file from noaa
;-------------------------------------------------------+
self->download, /ssm, success, fn
IF ~success THEN RETURN, 0
;
;*---------- gunzip file  ----------*
;
FILE_GUNZIP, fn, /DELETE
fn = STRMID(fn, 0, STRPOS(fn, '.gz') ) 




;------------------------------------------------------+
; read SSM ascii file  (template file)
;------------------------------------------------------+
RESTORE, GETENV('DMSP_PROGRAM_PATH') + 'background/format_ssm_MFR.sav'
ON_IOERROR, errlab
OPENR, lun, fn, /GET_LUN
d = READ_ASCII(fn, TEMPLATE = temp_ssm_MFR)
FREE_LUN, lun
; delete file
FILE_DELETE, fn




;----------------------------------------------------------------+
; make data
;----------------------------------------------------------------+
sod = 86400L
t = LINDGEN(sod)
t_ssm = LONG( FLOOR(d.sod) )  
glat = MAKE_ARRAY(sod, /FLOAT, VALUE = !VALUES.F_NAN)
glon = MAKE_ARRAY(sod, /FLOAT, VALUE = !VALUES.F_NAN)
alti = MAKE_ARRAY(sod, /FLOAT, VALUE = !VALUES.F_NAN)
bx   = MAKE_ARRAY(sod, /FLOAT, VALUE = !VALUES.F_NAN)
by   = MAKE_ARRAY(sod, /FLOAT, VALUE = !VALUES.F_NAN)
bz   = MAKE_ARRAY(sod, /FLOAT, VALUE = !VALUES.F_NAN)
dbx  = MAKE_ARRAY(sod, /FLOAT, VALUE = !VALUES.F_NAN)
dby  = MAKE_ARRAY(sod, /FLOAT, VALUE = !VALUES.F_NAN)
dbz  = MAKE_ARRAY(sod, /FLOAT, VALUE = !VALUES.F_NAN)

; assign data 
glat[t_ssm] = d.glat
glon[t_ssm] = d.glon
alti[t_ssm] = d.alti
bx[t_ssm]   = d.bx
by[t_ssm]   = d.by
bz[t_ssm]   = d.bz
dbx[t_ssm]  = d.dbx
dby[t_ssm]  = d.dby
dbz[t_ssm]  = d.dbz
;
;*---------- data set  ----------*
;
d_ssm = { $
					glat : glat   , $
					glon : glon   , $
					alti : alti   , $
					bx   : bx     , $
					by   : by     , $
					bz   : bz     , $
					dbx  : dbx    , $
					dby  : dby    , $
					dbz  : dbz      $
         }

RETURN, d_ssm



;----------------------------------------------------------------+
; I/O error
;----------------------------------------------------------------+
errlab : 
; delete file
SPAWN, 'rm ' + fn + '*'
PRINT, 'SSM I/O ERROR'
RETURN, 0


END


 
