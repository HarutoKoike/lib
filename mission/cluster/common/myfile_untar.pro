

; file_untar.proがなぜか使えない場合に使う

PRO myfile_untar, tar_archive, verbose=verbose, root_dir=root_dir, files
	
IF ~KEYWORD_SET(root_dir) THEN $
    CD, current=root_dir
;
;*-redirect file names in the archive to the buffer file
;
SPAWN, 'echo | tar -tf ' + tar_archive + ' |  > tar-buff.txt'
;
;*---------- read buffer file  ----------*
;
;
f = ''
files = []
OPENR, lun, 'tar-buff.txt', /GET_LUN
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
SPAWN, 'tar -xf ' + tar_archive
FILE_DELETE, tar_archive, 'tar-buff.txt'

END
