

; file_untar.proがなぜか使えない場合に使う

PRO myfile_untar, tar_archive, verbose=verbose, root_dir=root_dir, files, $
                  save_dir=save_dir
	
IF ~KEYWORD_SET(root_dir) THEN $
    CD, current=root_dir
;
;*-redirect file names in the archive to the buffer file
;
buff = FILEPATH('tar-buff.txt', ROOT=root_dir)
SPAWN, 'tar -tf ' + tar_archive + ' > ' + buff
;
;*---------- read buffer file  ----------*
;
;
f = ''
files = []
OPENR, lun, buff, /GET_LUN
i = 0
WHILE ~EOF(lun) DO BEGIN
	READF, lun, f
	files = [files, FILEPATH(f, root_dir=root_dir)]
    ;
	;IF KEYWORD_SET(verbose) THEN $
	;	PRINT, STRING(i+1, FORMAT='(I2)') + '  :  ' + f
    i ++
ENDWHILE
FREE_LUN, lun
files = files[UNIQ(files)]

;
;*---------- untar archive ----------*
;
IF ~KEYWORD_SET(save_dir) THEN save_dir = root_dir
;
SPAWN, 'tar -xf ' + tar_archive + ' -C ' + root_dir
FILE_DELETE, tar_archive, buff

END
