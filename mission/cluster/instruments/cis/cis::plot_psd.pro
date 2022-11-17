;===========================================================+
; ++ NAME ++
PRO cis::plot_psd, _EXTRA=e, proton=proton, ion=ion, hs=hs, ls=ls, rpa=rpa,      $
                   mag=mag, sw=sw, pef=pef, pf=pf, cs=cs, psd=psd, time=time ,   $
                   dim=dim, trange=trange, ignore_load=ignore_load
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
;  --> cis->plot_psd, /ion, /mag, /psd, time='2004-03-10/12:27:00'
; 
; ++ NOTE ++
; http://themis.ssl.berkeley.edu/socware/spedas_4_1/idl/projects/mms/fpi/mms_get_fpi_dist.pro ;
; 
; 
; ++ HISTORY ++
;  H.Koike 1/9,2021
;===========================================================+
;
COMPILE_OPT IDL2
;
;IF KEYWORD_SET(sc) THEN sc = 3
;sc = STRING(sc, FORMAT='(I1)')
self->getprop, sc=sc
;
get_timespan, ts
date = OBJ_NEW('date')
st   = date->time_double2iso(ts[0])
et   = date->time_double2iso(ts[1])
OBJ_DESTROY, date
;
;-------------------------------------------------+
; determine dataset ID
;-------------------------------------------------+
;
; default ID
; ion 3-D phase space density (default)
id = 'C' + sc + '_CP_CIS-HIA_HS_MAG_IONS_PSD'
unit = 'df_km'
;
;*---------- proton  ----------*
;
;
; proton 3-D phase space density (high-sensitivity side, differential energy flux)  
IF KEYWORD_SET(proton) AND KEYWORD_SET(hs) AND KEYWORD_SET(pef) THEN $
  id = 'C' + sc + '_CP_CIS-CODIF_HS_H1_PEF'
;
; proton 3-D phase space density (low-sensitybity side, differential energy flux)  
IF KEYWORD_SET(proton) AND KEYWORD_SET(hs) AND KEYWORD_SET(pf) THEN $
  id = 'C' + sc + '_CP_CIS-CODIF_HS_H1_PF'
;
; proton 3-D phase space density (differential energy flux)  
IF KEYWORD_SET(proton) AND KEYWORD_SET(hs) AND KEYWORD_SET(psd) THEN $
  id = 'C' + sc + '_CP_CIS-CODIF_HS_H1_PSD'
;
; proton 3-D phase space density (differential energy flux)  
IF KEYWORD_SET(proton) AND KEYWORD_SET(hs) AND KEYWORD_SET(cs) THEN $
  id = 'C' + sc + '_CP_CIS-CODIF_HS_H1_CS'
;
; proton 3-D phase space density (differential energy flux)  
IF KEYWORD_SET(proton) AND KEYWORD_SET(rpa) AND KEYWORD_SET(cs) THEN $
  id = 'C' + sc + '_CP_CIS-CODIF_RPA_H1_CS'
;
; proton 3-D phase space density (differential energy flux)  
IF KEYWORD_SET(proton) AND KEYWORD_SET(rpa) AND KEYWORD_SET(pef) THEN $
  id = 'C' + sc + '_CP_CIS-CODIF_RPA_H1_PEF'


;
;*---------- ion  ----------*
;
IF KEYWORD_SET(ion) AND KEYWORD_SET(mag) AND KEYWORD_SET(pef) THEN $
  id = 'C' + sc + '_CP_CIS-HIA_HS_MAG_IONS_PEF'
IF KEYWORD_SET(ion) AND KEYWORD_SET(mag) AND KEYWORD_SET(pf) THEN $
  id = 'C' + sc + '_CP_CIS-HIA_HS_MAG_IONS_PF'
IF KEYWORD_SET(ion) AND KEYWORD_SET(mag) AND KEYWORD_SET(psd) THEN $
  id = 'C' + sc + '_CP_CIS-HIA_HS_MAG_IONS_PSD'
;
IF KEYWORD_SET(ion) AND KEYWORD_SET(sw) AND KEYWORD_SET(hs) AND KEYWORD_SET(pef) THEN $
  id = 'C' + sc + '_CP_CIS-HIA_HS_MAG_IONS_PEF'
IF KEYWORD_SET(ion) AND KEYWORD_SET(sw) AND KEYWORD_SET(hs) AND KEYWORD_SET(pf)  THEN $
  id = 'C' + sc + '_CP_CIS-HIA_HS_MAG_IONS_PF'
IF KEYWORD_SET(ion) AND KEYWORD_SET(sw) AND KEYWORD_SET(hs) AND KEYWORD_SET(pf)  THEN $
  id = 'C' + sc + '_CP_CIS-HIA_HS_MAG_IONS_PSD'
IF KEYWORD_SET(ion) AND KEYWORD_SET(sw) AND KEYWORD_SET(ls) AND KEYWORD_SET(pef) THEN $
  id = 'C' + sc + '_CP_CIS-HIA_LS_MAG_IONS_PEF'
IF KEYWORD_SET(ion) AND KEYWORD_SET(sw) AND KEYWORD_SET(ls) AND KEYWORD_SET(pf)  THEN $
  id = 'C' + sc + '_CP_CIS-HIA_LS_MAG_IONS_PF'
IF KEYWORD_SET(ion) AND KEYWORD_SET(sw) AND KEYWORD_SET(ls) AND KEYWORD_SET(pf)  THEN $
  id = 'C' + sc + '_CP_CIS-HIA_LS_MAG_IONS_PSD'


;
;*---------- unit  ----------*
;
IF KEYWORD_SET(pef) THEN unit = 'eflux'
IF KEYWORD_SET(pf)  THEN unit = 'flux'
IF KEYWORD_SET(cs)  THEN unit = ''




;
;*---------- data name  ----------*
;
data_name = 'CIS-HIA'
IF KEYWORD_SET(proton) THEN data_name = 'CIS-CODIF'



;
;*---------- downlowd  ----------*
;
suc = 1
IF ~self->cluster::filetest(id, st, et) THEN $
    self->cluster::download, id, st, et, suc
IF ~suc THEN RETURN
 

;
;*---------- read cdf  ----------*
;
files = self->cluster::file_search(id, st, et)
;
IF ~KEYWORD_SET(ignore_load) THEN BEGIN
   foreach fn, files do cdf2tplot, fn, /all
ENDIF
 



;
;*---------- SPEDAS distribution structure  ----------*
;
struct = {$
          project_name    : 'Cluster'          , $
          spacecraft      : sc                 , $
          data_name       : data_name          , $
          units_name      : unit               , $
          units_procedure : ''                 , $
          speces          : 'i'                , $
          valid           : 1                  , $
          charge          : 1.                 , $
          mass            : 0.0104535          , $
          time            : 0d                 , $
          end_time        : 0d                 , $
          data            : FLTARR(31, 16, 8)  , $
          bins            : FLTARR(31, 16, 8)+1, $
          energy          : FLTARR(31, 16, 8)  , $
          denergy         : FLTARR(31, 16, 8)  , $
          nenergy         : 31L                , $
          nbins           : 128L               , $
          phi             : FLTARR(31, 16, 8)  , $
          dphi            : FLTARR(31, 16, 8)  , $
          theta           : FLTARR(31, 16, 8)  , $
          dtheta          : FLTARR(31, 16, 8)    $
          }


;
;*---------- get H+ distribution  ----------*
;
get_data, '3d_ions__' + id, data=distr
n_time      = N_ELEMENTS(distr.x)
dist_struct = REPLICATE(struct, n_time) 
dist_struct.data   = TRANSPOSE(distr.y, [1, 2, 3, 0]) 

;
;*---------- time  ----------*
;
dist_struct.time     = time_double(distr.X)
;
delta_t    = distr.X[1:*]-distr.X[*]
integ_time = average(delta_t, /nan, /ret_median)
dist_struct.end_time = time_double(distr.X) + integ_time
                                                       



;
;*----------  energy bin  ----------*
;
IF KEYWORD_SET(proton) THEN codif = 1
IF KEYWORD_SET(ion)    THEN hia = 1
;
self->instrument, energy=ebin, codif=codif, hia=hia  
dist_struct.energy = REBIN(ebin, 31, 16, 8) 
 

;
;*---------- phi  ----------*
;
;phi = REBIN((distr.v2 + 180.) MOD 360., 16, 8)
phi = REBIN(distr.v2 , 16, 8)
phi = TRANSPOSE( REBIN(phi, 16, 8, 31), [2, 0, 1])
;
dist_struct.phi   = phi
dist_struct.dphi += 22.5



;
;*---------- theta  ----------*
;
theta = REBIN(distr.v1,  8, 16)
theta = TRANSPOSE( REBIN(theta, 8, 16, 31), [2, 1, 0])
dist_struct.theta = theta
dist_struct.dtheta += 22.5

 

;
;*---------- magnetic field data  ----------*
;
mag_data = 'B_xyz_gse__C' + sc + '_PP_FGM'
;
dum = WHERE( STRMATCH(tnames(), mag_data) EQ 1, count )
IF count EQ 0 THEN BEGIN
    fgm = OBJ_NEW('fgm', sc=sc)
    fgm->load
    OBJ_DESTROY, fgm
ENDIF


;
;*---------- bulk velocity  ----------*
;
vel_data = 'V_HIA_xyz_gse__C' + sc + '_PP_CIS'
;
IF KEYWORD_SET(proton) THEN $
    vel_data = 'V_p_xyz_gse__C' + sc + '_PP_CIS'
IF KEYWORD_SET(ion) THEN $
    vel_data = 'V_HIA_xyz_gse__C' + sc + '_PP_CIS'
;
dum = WHERE( STRMATCH(tnames(), vel_data) EQ 1, count )
IF count EQ 0 THEN BEGIN
    cis = OBJ_NEW('cis', sc=sc)
    cis->load
    OBJ_DESTROY, cis
ENDIF


 


;-------------------------------------------------+
;  make slice plot
;-------------------------------------------------+
dist_ptr = PTR_NEW(dist_struct, /no_copy)
;
slice = spd_slice2d(dist_ptr, time=time, trange=trange, mag_data=mag_data, $
                    rotation='BE',vel_data=vel_data, /perp_subtract_bulk, $
                    _extra=e)

IF KEYWORD_SET(trange) AND ISA(slice, 'BYTE') THEN $
  slice = spd_slice2d(dist_ptr, time=trange[0], mag_data=mag_data, rotation='BE',$
                      vel_data=vel_data, /perp_subtract_bulk, $
                      _extra=e)


;
;*---------- plot  ----------*
;
IF ~KEYWORD_SET(dim) THEN dim = 2
;
; 2-D cut
;
IF dim EQ 2 THEN BEGIN
    spd_slice2d_plot, slice, xrange=xrange, yrange=yrange, $
                      background_color_index=0,  _extra=e, $
                      xtitle='V!Dpara!N(km/s)', ytitle='V!Dperp!N(km/s)'
ENDIF ELSE BEGIN
; 1-D cut ( pitch angle 0 )
    fmax = MAX(slice.data, /NAN)
    pow  = CEIL(ALOG10(fmax)) 
    yrange = [10^(pow-4), 10^pow] 
    
    yval = [slice.ygrid[0], slice.ygrid[-1]]
    yval = 0 
    spd_slice1d_plot, slice, 'x', yval, xrange=xrange, _extra=e, $
                      yrange=yrange, /ylog, xtitle='V!Dpara!N(km/s)'
    OPLOT, [0, 0], yrange, linestyle=2
ENDELSE


PTR_FREE, dist_ptr   
END
