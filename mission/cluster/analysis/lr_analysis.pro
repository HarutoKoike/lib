

pro lr_timerange, region

common lr_analysis, event_num, events, n_win
;


if region eq 0 then rname = 'MAGNETOSPHERE'
if region eq 1 then rname = 'MAGNETOSHEATH'
if region eq 2 then rname = 'OUTFLOW'
if region eq 3 then rname = 'CURRENT_SHEET'

print, '================================'
print, '% ' + rname
read, disc, prompt='% do:1, skip:0 ENTER: '
print, '================================'
if disc eq 0 then return
tlimit, window=n_win
tplot_apply_databar
;
;
; slice 
cis = cl_cis()
cis->setprop, sc=3
print, '% 2-D cut distribution'
read, skip, prompt='% do:1, skip:0 ENTER: '
if ~skip then goto, skip1
;
disc=1
while disc do begin
  ctime, t
  cis->slice2d_plot, /ion, /hs, /mag, /pef, time_string(t[-1])
  read, disc, prompt='% do:1, end:0 ENTER:'
endwhile
;
;
;
; time range
skip1:
print, '% timerange'
while n_elements(ts) lt 2  do begin
  ctime, ts
endwhile
;
if region eq 0 then $
  events[event_num].t_sphere  = [time_string(ts[-2]), time_string(ts[-1])]
if region eq 1 then $
  events[event_num].t_sheath  = [time_string(ts[-2]), time_string(ts[-1])]
if region eq 2 then $
  events[event_num].t_outflow = [time_string(ts[-2]), time_string(ts[-1])]
if region eq 3 then $
  events[event_num].t_mva     = [time_string(ts[-2]), time_string(ts[-1])]  


tlimit, /last, window=n_win
end





common lr_analysis 

n_win=0
flag = 'restore'
@lr_load.pro
;-------------------------------------------------+
; 
;-------------------------------------------------+
;
;*---------- time span ----------*
;
timespan, events[event_num].t_event 


;
;*---------- load vars ----------*
;
cluster->load_vars, 3



;
;*---------- tplot  ----------*
;
tnames = [ 'Ion_Omni_Flux__C3', $
           'N_HIA__C3_PP_CIS',  $
           'T_HIA__C3_PP_CIS',  $
           'V_para_perp__C3', $
           'B_xyz_gsm__C3_PP_FGM', $
           'Parallel_electron__C3', $
           'antiparallel_electron__C3']
            ;'C' + sc + '_CP_CIS-CODIF_PAD_HS_O1_PF']
tplot, tnames 
tplot_apply_databar



;
;*---------- magnetosphere  ----------*
;
return0:
;
region = 0
lr_timerange, region
print, '% done ?'
read, disc, prompt='% if need to retry, enter 1 :'
if disc then goto, return0


;
;*---------- magnetosheath  ----------*
;
return1:
;
region = 1
lr_timerange, region
print, '% done ?'
read, disc, prompt='% if need to retry, enter 1 :'
if disc then goto, return1
 

;
;*----------outflow  ----------*
;
return2:
;
region = 2
lr_timerange, region
print, '% done ?'
read, disc, prompt='% if need to retry, enter 1 :'
if disc then goto, return2
 


;
;*----------MVA  ----------*
;
return3:
;
region = 3
lr_timerange, region
print, '% done ?'
read, disc, prompt='% if need to retry, enter 1 :'
if disc then goto, return3
 

flag='save'
print, events[event_num]
@lr_load.pro
 

end




















