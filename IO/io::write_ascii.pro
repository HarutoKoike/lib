FUNCTION io::type, code
COMPILE_OPT IDL2, STATIC
;
void = {    $
        undefined: 'undefined',$
        byte:0B,$
        int:0,$
        long:0L,$
        float:0.,$
        double:0d,$
        complex:complex(0, 0),$
        string:'',$
        struct:{dum:'dum'},$
        dcomplex:dcomplex(0, 0),$
        pointer:ptr_new(),$
        objref:'objref',$
        uint:0U,$
        ulong:0UL,$
        long64:0LL,$
        ulong64:0ULL$
        }
RETURN, void.(code)
END



;===========================================================+
; ++ NAME ++
PRO io::write_ascii, filename, $
                     arr1, arr2, arr3, arr4, arr5,      $
                     arr6, arr7, arr8, arr9, arr10,     $
                     arr11, arr12, arr13, arr14, arr15, $
                     format=format, header=header
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
;  H.Koike 
;===========================================================+
COMPILE_OPT IDL2, STATIC
;
nvar = N_PARAMS() - 1 
IF nvar EQ 0 THEN RETURN
;

;
;*----------   ----------*
;
vars = PTRARR(nvar)
FOR i = 0, nvar - 1 DO BEGIN 
  void    = EXECUTE( 'dum=arr' + STRCOMPRESS(STRING(i+1), /REMOVE_ALL) )
  vars[i] = PTR_NEW(dum)
ENDFOR



;
;*---------- check all vars have same size ----------*
;
n1 = N_ELEMENTS(arr1)
FOR i = 1, nvar - 1  DO BEGIN
  n = N_ELEMENTS( *(vars[i]) )
  IF n NE n1 THEN BEGIN
    PRINT, '% All variables must be same size'
    RETURN
  ENDIF
ENDFOR


;
;*---------- create struct  ----------*
;
out = {var1: io->type( SIZE( *(vars[0]), /TYPE) ) }
FOR i = 1, nvar - 1 DO BEGIN
  tag = 'var' + STRCOMPRESS(STRING(i+1), /REMOVE_ALL)
  out = CREATE_STRUCT(out, tag, io->type( SIZE(*(vars[i]), /TYPE) ) ) 
ENDFOR
;
out = REPLICATE(out, n1) 
FOR i = 0, nvar - 1 DO BEGIN
  out.(i) = *(vars[i])
ENDFOR



;
;*---------- header configuration ----------*
;
vartype = STRING(nvars, FORMAT='(I02)')
FOR i = 0, nvars-1 DO $
  vartype += STRING( SIZE( *(vars[i]), /TYPE ), FORMAT='(I02)')
;
header_lines = N_ELEMENTS(headers) + 3   ; vartype, format, separator
vartype = STRING(header_lines, FORMAT='(I05)') + vartype
;
separator = '--------------------------------------------' + $
            '--------------------------------------------' 
;
IF ~KEYWORD_SET(format) THEN format = ''
format = 'format: ' + format 
;
IF ISA(header) THEN BEGIN 
  header = [vartype, format, header, separator] 
ENDIF ELSE BEGIN
  header = [vartype, format, separator] 
ENDELSE


END


io->write_ascii, '~/idl/lib/IO/text.txt', indgen(8), fltarr(8)

end


