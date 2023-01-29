;===========================================================+
; ++ NAME ++
PRO usage
;
; ++ PURPOSE ++
;  -->
;
; ++ POSITIONAL ARGUMENTS ++
;  -->
;
; ++ KEYWORDS ++
; -->
;
; ++ CALLING SEQUENCE ++
;  -->
;
; ++ HISTORY ++
;  H.Koike 10/20,2022
;===========================================================+

;-------------------------------------------------+
; size.pro
;-------------------------------------------------+
PRINT, '% ========================================'
PRINT, '                 SIZE                     '
PRINT, ''
PRINT,                                                     $

'Print the size information for a 10 by 20 floating-point array by entering:

PRINT, SIZE(FINDGEN(10, 20))
IDL prints:

   2   10   20   4   200
This IDL output indicates the array has 2 dimensions, equal to 10 and 20, a type code of 4, and 200 elements total. Similarly, to print only the number of dimensions of the same array:

PRINT, SIZE(FINDGEN(10, 20), /N_DIMENSIONS)
IDL prints:

   2
For more information on using SIZE, see the Additional Examples. '

END
