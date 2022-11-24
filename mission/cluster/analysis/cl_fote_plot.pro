


mytimespan, 2004, 3, 10, 12, dhr=1
cl = OBJ_NEW('cluster')
t_cut = '2004-03-10/12:28:00'
title = 'Magnetic Field Line Topology (' + t_cut + ')'


p = cl->plot_fieldline3d(t_cut, .8, .8, .8, $
                        log_color=0, range=range, $
                        nseed=10, title=title)

cb = COLORBAR(ORIENTATION=1, $
              TITLE='|B| (nT)', $
              POSITION=[0.92, 0.1, 0.95, 0.9], /NORMAL, $
              FONT_SIZE=8, TARGET=P, RANGE=RANGE $
              )
end
