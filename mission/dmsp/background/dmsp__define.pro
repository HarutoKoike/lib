


;===========================================================+
; ++ NAME ++
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
;  H.Koike 1/9,2021
;===========================================================+
FUNCTION dmsp::init, _EXTRA=e

COMPILE_OPT IDL2
IF ISA(e) THEN self->SetProperty, _EXTRA=e
self.data = PTR_NEW(/ALLOCATE)
PRINT, "% DMSP object has been created"
RETURN, 1

END

;
;*---------- ----------*
;
PRO dmsp::Cleanup
COMPILE_OPT IDL2
PTR_FREE, self.data
OBJ_DESTROY, self
END

;
;*----------   ----------*
;
PRO dmsp::SetProperty, f=f, yr=yr, mon=mon, dy=dy 

COMPILE_OPT IDL2
IF ISA(f)   THEN self.f   = f
IF ISA(yr)  THEN self.yr  = yr
IF ISA(mon) THEN self.mon = mon
IF ISA(dy)  THEN self.dy  = dy

END


;
;*----------   ----------*
;
PRO dmsp::GetProperty, f=f, yr=yr, mon=mon, dy=dy
COMPILE_OPT IDL2
;
IF ~ISA(self) THEN RETURN
IF ARG_PRESENT(f)   THEN f   = self.f
IF ARG_PRESENT(yr)  THEN yr  = self.yr
IF ARG_PRESENT(mon) THEN mon = self.mon
IF ARG_PRESENT(dy)  THEN dy  = self.dy
;
END


;
;*----------   ----------*
;
PRO dmsp::SetData, data

COMPILE_OPT IDL2
*(self.data) = data 

END


;
;*----------   ----------*
;
FUNCTION dmsp::GetData

COMPILE_OPT IDL2
RETURN, *(self.data)

END 

;
;*----------   ----------*
;
PRO dmsp__define

void = {dmsp,           $
				yr  :0L,        $  
				mon :0B,        $
				dy  :0B,        $
				f   :0B,        $
				data:PTR_NEW(), $
				;
				INHERITS IDL_OBJECT}
RETURN

END


 
