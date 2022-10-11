


event = {                          $
         sc           : ''        ,$
         t_event      : STRARR(2) ,$
         t_mva        : STRARR(2) ,$
         t_outflow    : STRARR(2) ,$
         t_sheath     : STRARR(2) ,$
         t_sphere     : STRARR(2) ,$
         ;
         n            : FLTARR(3) ,$
         l            : FLTARR(3) ,$
         m            : FLTARR(3) ,$
         ;
         v_out        : FLTARR(3) ,$
         v_sheath     : FLTARR(3) ,$
         v_sphere     : FLTARR(3) ,$
         ;
         b_sheath     : FLTARR(3) ,$
         b_sphere     : FLTARR(3) ,$
         ;
         ni_sheath    : 0.        ,$
         ni_sphere    : 0.        ,$
         ;
         va_sheath    : 0.        ,$
         va_sphere    : 0.        ,$
         v_asym       : 0.        ,$
         ;
         ti_sheath    : 0.        ,$
         ti_sphere    : 0.        ,$
         te_sheath    : 0.        ,$
         te_sphere    : 0.         $
         }



n_events = 10
events   = REPLICATE(event, n_events)
events.sc = 3


events[0].t_event  = [                        $
                       '2004-03-10/12:00:00', $
                       '2004-03-10/12:40:00'  $
                     ]

events[1].t_event  = [                        $
                       '2002-03-18/14:50:00', $
                       '2002-03-18/15:10:00'  $
                     ]

events[2].t_event  = [                        $
                       '2002-11-20/10:03:00', $
                       '2002-11-20/10:23:00'  $
                     ]

events[3].t_event  = [                        $
                       '2002-11-27/16:17:00', $
                       '2002-11-27/16:37:00'  $
                     ]

events[4].t_event  = [                        $
                       '2002-12-19/07:15:00', $
                       '2002-12-19/07:35:00'  $
                     ]


events[5].t_event  = [                        $
                       '2003-03-19/15:40:00', $
                       '2003-03-19/16:00:00'  $
                     ]

events[6].t_event  = [                        $
                       '2003-05-06/04:20:00', $
                       '2003-05-06/04:40:00'  $
                     ]

events[7].t_event  = [                        $
                       '2004-02-27/15:25:00', $
                       '2004-02-27/15:55:00'  $
                     ]

events[8].t_event  = [                        $
                       '2004-04-12/19:00:00', $
                       '2004-04-12/19:20:00'  $
                     ]

events[9].t_event  = [                        $
                       '2004-04-22/04:52:00', $
                       '2004-04-22/05:12:00'  $
                     ]


