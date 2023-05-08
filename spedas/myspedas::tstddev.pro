;===========================================================+
; ++ NAME ++
PRO myspedas::tstddev, tname, nwindow, nleft=tleft, nright=tright, $
                       ratio=ratio, trange=trange, newname=newname, $
                       data=data
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
;  -->
;
; ++ HISTORY ++
;===========================================================+
COMPILE_OPT IDL2
;

get_data, tname, data=d, dlim=dlim
;
y   = d.y
t   = d.x
nd  = n_elements(t)
;
if keyword_set(trange) then begin
    idx = nn(tname, trange)
    y   = y[idx[0]:idx[1]]
    t   = t[idx[0]:idx[1]]
endif
;
nd      = n_elements(t)
ystd    = fltarr(nd)     ; array for standard deviation 
ystd[*] = !values.f_nan
;

if isa(nwindow) then begin
    nleft  = (nwindow - 1) / 2
    nright = nwindow / 2
endif


if keyword_set(ratio) then begin
    for i = nleft, nd - nright -1 do begin
           ystd[i] = stddev(y[i-nleft:i+nright], /nan) / $
                     mean(y[i-nleft:i+nright], /nan)
    endfor
endif else begin
    for i = nleft, nd - nright -1 do begin
        ystd[i] = stddev(y[i-nleft:i+nright], /nan)
    endfor
endelse

;
;*----------   ----------*
;
if ~keyword_set(newname) then $
    newname = tname + '_stddev'

;
store_data, newname, data={x:t, y:ystd}, dlim=dlim

;
if arg_present(data) then data=ystd

END
