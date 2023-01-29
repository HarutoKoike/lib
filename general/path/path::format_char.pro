PRO path::format_char, all=all, main=main, separator=separator, date=date
;
COMPILE_OPT HIDDEN, IDL2, STATIC
;
main_list   = [         $
              '%c',     $   ; class name
              '%sc',    $   ; subclass name
              '%suf',   $   ; suffix
              '%pre',   $   ; prefix
              '%misc'   $    ; misc (not neccesary)
              ]
  
separator_list = [         $
                 '_',      $   ; separator 1
                 '-',      $   ; separator 2
                 ':',      $   ; separator 3
                 '/'       $   ; separator 4
                 ]
;    
date_list = date->format_list()


IF ARG_PRESENT(main)      THEN main = main_list
IF ARG_PRESENT(separator) THEN separator = separator_list
IF ARG_PRESENT(date)      THEN date = date_list
IF ARG_PRESENT(all)       THEN all = [main_list, separator_list, date_list]
;
END
