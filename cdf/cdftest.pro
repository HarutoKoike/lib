fn = '~/idl/project/swarm/SW_OPER_MAGA_LR_1B_20131208T000000_20131208T235959_0503_MDR_MAG_LR.cdf'

cdf = obj_new('cdf')
cdf.filename=fn

;id  = cdf_open(fn)
;inq = cdf_inquire(id)


;for i = 0, inq.nzvars - 1 do begin
;  vi    = cdf_varinq(id, i, /zvar)
;  varname = vi.name
;  print, varname
;endfor
;
;inq = cdf_inquire(id)

;for i = 0, inq.natts - 1 do begin
;    cdf_attinq, id, i, name, scope, maxentry, maxzentry
;    print, i, ' ' ,  name, ' : ', scope
;endfor

;for i = 0, inq.nzvars -1 do begin
;    vinq = cdf_varinq(id, i, /zvar)
;    print, vinq.name
;endfor
;cdf_control, id, var='dB_Sun', get_var_info=ainfo, get_filename=f
;CDF_CLOSE, id

end
