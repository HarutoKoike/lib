
st = '2004-03-10/11:00:00'
et = '2004-03-10/13:00:00'
timespan, [st,et]
omni_hro_load, /res5min


tnames = []
tnames = [tnames, 'OMNI_HRO_5min_BX_GSE']
tnames = [tnames, 'OMNI_HRO_5min_BY_GSM']
tnames = [tnames, 'OMNI_HRO_5min_BZ_GSM']
tnames = [tnames, 'OMNI_HRO_5min_flow_speed']
tnames = [tnames, 'OMNI_HRO_5min_proton_density']
tnames = [tnames, 'OMNI_HRO_5min_Pressure']

tplot, tnames

end
