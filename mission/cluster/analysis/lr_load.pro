


fn = '~/idl/cluster/analysis/lr_events.sav'
if flag eq 'restore' then restore, fn
if flag eq 'save'    then save, events, filename=fn 
