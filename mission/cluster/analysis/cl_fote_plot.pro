pro cl_fote_plot, t_cut, _EXTRA=EX

cl = OBJ_NEW('cluster')
title = 'Magnetic Field Line Topology (' + t_cut + ')'


p = cl->plot_fieldline3d(t_cut, xrange=[1., 3], $
                        log_color=0, vrange=vrange, $
                        nseed=20, title=title, _EXTRA=EX)

cb = COLORBAR(ORIENTATION=1, $
              TITLE='|B| (nT)', $
              POSITION=[0.92, 0.1, 0.95, 0.9], /NORMAL, $
              FONT_SIZE=8, TARGET=P, RANGE=vRANGE $
              )
end




mytimespan, 2004, 3, 10, 12, dhr=1
cl_fote_plot, '2004-03-10/12:27:00'

end
