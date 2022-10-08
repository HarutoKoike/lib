

PRO ptr::save, _EXTRA=ex

COMPILE_OPT IDL2, STATIC

ptr = !ptr
SAVE, ptr, _EXTRA=ex

END
