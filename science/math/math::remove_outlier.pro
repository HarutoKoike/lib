;==========================================================+
; ++ NAME ++
FUNCTION math::remove_outlier, arr, deviation=dev, $
                               fillval=fillval, index=index 
;
; ++ PURPOSE ++
;  --> Remove outlier in a specified array.
;
; ++ POSITIONAL ARGUMENTS ++
;  --> arr(ARRAY)
;
; ++ KEYWORDS ++
; -->  deviation(FLOAT): Set this to specify the range for
;                        the outlier. Default is +- 2 sigma
; -->  fillval(FLOAT): fiiled value for the outlier
; -->  index: This receives the index of the outlier.
;
; ++ CALLING SEQUENCE ++
;  --> arr_new = math->remove_outlier(arr, dev=300, $
;                                     fillval=0
;
; ++ HISTORY ++
;  H.Koike 
;==========================================================+
COMPILE_OPT IDL2
;
;
sigma = STDDEV(arr, /NAN)

IF ~KEYWORD_SET(dev) THEN $
    dev = 2. * sigma
IF ~KEYWORD_SET(fillval) THEN $
    fillval = !VALUES.F_NAN

;
lower = MEAN(arr, /NAN) - dev
upper = MEAN(arr, /NAN) + dev
index = WHERE( arr LT lower OR arr GT upper, /NULL, count)  
;

arr_removed = arr
arr_removed[index] = fillval

RETURN, arr_removed
END
