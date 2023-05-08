FUNCTION cdf::epoch2timedouble, varname
COMPILE_OPT IDL2
;
self->get, varname, data=t
print, t
CDF_EPOCH, t0, 1970, 1, 1, 0, 0, 0, /compute
print, t0
td = (t - t0) * 1.e-3
RETURN, td
END
