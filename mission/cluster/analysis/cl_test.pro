

;mytimespan, 2003, 10, 9, 2, 22, dmin=6
;mytimespan, 2004, 3, 10, 12, dmin=60
;cl_load, /fote, /full

get_data, 'FOTE_null_distance_C3', data=d
get_data, 'FOTE_null_point', data=np



idx = where( d.y ge 1000. )

x = np.y[*, 0]
x[idx] = !values.f_nan

y = np.y[*, 1]
y[idx] = !values.f_nan

z = np.y[*, 2]
z[idx] = !values.f_nan



store_data, 'Null_X', data={x:d.x, y:x}
store_data, 'Null_Y', data={x:d.x, y:y}
store_data, 'Null_Z', data={x:d.x, y:z}


t0 = '2004-03-10/12:26:30'
t1 = '2004-03-10/12:27:00'

idx0 = nn('Null_X', t0)
idx1 = nn('Null_X', t1)

t = d.x[idx0:idx1]
t = t - t[0]
x = x[idx0:idx1]
y = y[idx0:idx1]
z = z[idx0:idx1]

end
