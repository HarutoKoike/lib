PRO peace::load
;
COMPILE_OPT IDL2
;
;*---------- settings ----------*
;
self->cluster::GetProp, st=st, et=et, sc=sc
IF ~ISA(sc, 'STRING') THEN sc = STRING(sc, FORMAT='(I1)')
;


;
;*---------- dataset id  ----------*
;
; prime parameter
id = 'C' + sc + '_PP_PEA'
;
dum = 'C' + sc + '_CP_PEA_PITCH_SPIN_DEFlux'
id  = [id, dum]
;
;*---------- download  ----------*
;
suc = 1
IF ~self->cluster::filetest(id, st, et) THEN $
  self->cluster::download, id, st, et, suc

;
;*---------- read cdf  ----------*
;
files = self->cluster::file_search(id, st, et)

;
FOREACH fn, files DO  $
  cdf2tplot, fn, /all





;-------------------------------------------------+
; tplot
;-------------------------------------------------+
;
;*---------- parallel electron  ----------*
;
get_data, tname, data=d
get_data, 'Sweep_Energy__C' + sc +'_CP_PEA_PITCH_SPIN_DEFlux', data=e
str_element, dlim, 'spec', 1, /add
IF ISA(d, 'INT') THEN RETURN
;
tname =  'Parallel_electron__C'+sc
store_data, tname, data={x:d.x, y:REFORM(d.y[*, *, 0]), v:REFORM(e.y[0, *])},$
            dlim=dlim
ylim, tname, min(e.y[0, *], /nan), max(e.y[0, *], /nan), /log
zlim, tname, 0, 0, 1
;
options, tname, 'ytitle', 'Electron!C(0-15)'
options, tname, 'ysubtitle', '[eV]'
;options, tname, 'eV/eV cm!U2!N s sr]'   



;
;*---------- antiparallel electron  ----------*
;
tname =  'antiparallel_electron__C'+sc
store_data, tname, data={x:d.x, y:REFORM(d.y[*, *, -1]), v:REFORM(e.y[0, *])},$
            dlim=dlim
ylim, tname, min(e.y[0, *], /nan), max(e.y[0, *], /nan), /log
zlim, tname, 0, 0, 1
options, tname, 'ytitle', 'Electron!C(165-180)'
options, tname, 'ysubtitle', '[eV]'
;options, tname, '(eV/eV cm!U2!N s sr)'  


;
;*---------- perp electron  ----------*
;
tname =  'perpendicular_electron__C'+sc
store_data, tname, data={x:d.x, y:REFORM(d.y[*, *, 5]+d.y[*, *, 6]), v:REFORM(e.y[0, *])},$
            dlim=dlim
ylim, tname, min(e.y[0, *], /nan), max(e.y[0, *], /nan), /log
zlim, tname, 0, 0, 1
options, tname, 'ytitle', 'Electron!C(75-105)'
options, tname, 'ysubtitle', '[eV]' 



END
