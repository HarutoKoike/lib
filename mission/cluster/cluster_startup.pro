
loadct, 39
device, decomposed=0
!p.background=255
!p.color=0

.r date_routines
.r plasma_parameters
.r conv_unit

;
; common
.r cluster__define
.r cluster::common
.r cluster::authentication
.r cluster::download
.r cluster::filesearch
.r myfile_untar
.r cluster::datestruct
.r cluster::tplot_names
;
; aux
.r cl_aux__define
.r cl_aux::load
;
; fgm
.r cl_fgm__define
.r cl_fgm::load
;
; cis
.r cl_cis__define
.r cl_cis::instrument
.r cl_cis::load
.r cl_cis::slice2d_plot
;
; peace
.r cl_peace__define
.r cl_peace::load
;
; efw
.r cl_efw__define
.r cl_efw::load
;
; whisper
.r cl_whisper__define
.r cl_whisper::load
;
; staff
.r cl_staff__define
.r cl_staff::load
;
; edi
.r cl_edi__define
.r cl_edi::load
;
.r cluster::load_vars
.r cluster::barycentre
.r cl_fgm::curlometer

.r mvab
.r tmean
.r tmax
.r myplot_routines
.r ts_extract
<<<<<<< HEAD
.r tsavgol
=======

>>>>>>> 24d9965ffdda83f9c3ff7dc944de7b0204709b23
