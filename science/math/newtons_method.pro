
function testfunc, x
return, 2*alog(x) - x + 2 - 2*alog(2) + alog(10) 
end

function testdiff_func, x
return, 2./x - 1
end


FUNCTION newtons_method::init 
RETURN, 1
END
 


PRO newtons_method::GetProperty, initx=initx, step=step, func=func, diff_func=diff_func, $
                                  xnow=xnow
IF ARG_PRESENT(initx)     THEN initx     = self.initx
IF ARG_PRESENT(step)      THEN step      = self.step
IF ARG_PRESENT(func)      THEN func      = self.func
IF ARG_PRESENT(diff_func) THEN diff_func = self.diff_func
IF ARG_PRESENT(xnow)      THEN xnow      = self.xnow
END


PRO newtons_method::SetProperty, initx=initx, step=step, func=func, diff_func=diff_func
IF KEYWORD_SET(initx)     THEN  BEGIN
    self.initx     = initx     
    self.xnow      = initx
ENDIF
IF KEYWORD_SET(step)      THEN  self.step      =  step      
IF KEYWORD_SET(func)      THEN  self.func      =  func      
IF KEYWORD_SET(diff_func) THEN  self.diff_func =  diff_func 
IF KEYWORD_SET(xnow)      THEN  self.xnow      =  xnow       
END

PRO newtons_method::next, f, df, x 
r = CALL_FUNCTION(self.func, self.xnow) / CALL_FUNCTION(self.diff_func, self.xnow)
self.xnow -= r
END

PRO newtons_method__define
void = {newtons_method,        $
        initx:0.,              $
        xnow:0.,               $
        step:0.,               $
        func:'',               $
        diff_func:'',          $
        INHERITS IDL_OBJECT    $
       }
END




nt = obj_new('newtons_method')
nt.func     = 'testfunc'
nt.diff_func = 'testdiff_func'

x = (findgen(99) + 1) / 10.
y = testfunc(x)
plot, x, y
oplot, [0, 10], [0, 0]

nt.initx    = .5
for i = 0, 100 do begin
    nt->next
endfor
oplot, [nt.xnow, nt.xnow], [-3, 3] 
print, nt.xnow


nt.initx    = 2.5
for i = 0, 100 do begin
    nt->next
endfor
oplot, [nt.xnow, nt.xnow], [-3, 3] 
print, nt.xnow


end




