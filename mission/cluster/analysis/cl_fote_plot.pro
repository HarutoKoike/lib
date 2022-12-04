pro cl_fote_plot, t_cut, _EXTRA=EX

cl = OBJ_NEW('cluster')
title = 'Magnetic Field Line Topology (' + t_cut + ')'


p = cl->plot_fieldline3d(t_cut, $
                        log_color=0, vrange=vrange, $
                        title=title, _EXTRA=EX)

cb = COLORBAR(ORIENTATION=1, $
              TITLE='|B| (nT)', $
              POSITION=[0.92, 0.1, 0.95, 0.9], /NORMAL, $
              FONT_SIZE=8, TARGET=P, RANGE=vRANGE $
              )
end
