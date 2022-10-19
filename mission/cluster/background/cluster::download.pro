
;===========================================================+
; ++ NAME ++
PRO cluster::download, $
                      dataset_id, start_date, end_date, $
                      delivery_format=delivery_format,     $
                      delivery_interval=delivery_interval, $
                      ref_doc=ref_doc, max_file_size=max_file_size, $
                      include_empty=include_empty, $
                      retrieval_type=retrieval_type, $
                      stream=stream, async=async,suc, daily=daily
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
; 
; ++ NOTE ++
;===========================================================+
COMPILE_OPT IDL2, STATIC
;
ON_ERROR, 0
;
;*---------- authentication ----------*
;
cluster->authentication
suc = 0
st  = start_date
et  = end_date

IF N_ELEMENTS(st) NE 1 OR N_ELEMENTS(et) NE 1 THEN BEGIN 
    MESSAGE, 'start_date and end date must be 1-element'
ENDIF

PRINT, ''
PRINT, '% ========================================='
PRINT, '% START DATE     : ' + st
PRINT, '% END   DATE     : ' + et
FOR i = 0, N_ELEMENTS(dataset_id) - 1 DO $
   PRINT, '% DATASET_ID ' + STRING(i+1, FORMAT='(I2)') + '  : ' + dataset_id[i] 
PRINT, '% ========================================='
PRINT, ''


;
;*---------- query  ----------*
;
; delivery interval
IF ~KEYWORD_SET(delivery_interval) THEN delivery_interval='daily'
;

;
IF KEYWORD_SET(retrieval_type) THEN BEGIN
    query = 'RETRIEVAL_TYPE=' + retrieval_type
ENDIF ELSE BEGIN
    query = 'RETRIEVAL_TYPE=product'
ENDELSE         
;
IF KEYWORD_SET(async) THEN $
    query += '&RETRIEVAL_ACCESS=DEFERRED'
;
; start and end date
query += '&START_DATE=' + st
query += '&END_DATE='   + et
;
; dataset id
FOREACH id, dataset_id DO BEGIN
    query += '&DATASET_ID=' + id
ENDFOREACH
;
IF KEYWORD_SET(delivery_format) THEN BEGIN
    query += '&DELIVERY_FORMAT=' + delivery_format
ENDIF ELSE BEGIN
    query += '&DELIVERY_FORMAT=CDF'
ENDELSE
;
query += '&DELIVERY_INTERVAL=' + delivery_interval
;
IF KEYWORD_SET(ref_doc) THEN $
    query += '&REF_DOC=' + ref_doc
;
IF KEYWORD_SET(max_file_size) THEN $
    query += '&MAX_FILE_SIZE=' + max_file_size
;
IF KEYWORD_SET(include_empty) THEN $
    query += '&INCLUDE_EMPTY=' + include_empty
;
query = query[0]
;
;
;*---------- Error handle  ----------*
;
CATCH, error_status
IF error_status NE 0 THEN BEGIN
    CATCH, /CANCEL
    MESSAGE, !ERROR_STATE.MSG, /CONTINUE
    ;
    ourl->GetProperty, RESPONSE_CODE=rc, RESPONSE_HEADER=rh, $
        	      	 RESPONSE_FILENAME=rf
    ;
    PRINT, '% Response Code = ' + rc
    PRINT, '% Response Header = ' + rh
    PRINT, '% Response Filename = ' + rf
    PRINT, '% Request stoped'
    OBJ_DESTROY, ourl
    RETURN
ENDIF
 


;
;*---------- HTTP request  ----------*
;
url_host = 'csa.esac.esa.int'
url_path = 'csa-sl-tap/data'
user_agent = 'IDL' + !VERSION.RELEASE
;
ourl = OBJ_NEW('IDLnetUrl')
ourl->SetProperty, /VERBOSE
ourl->SetProperty, URL_SCHEME = 'https'
ourl->SetProperty, URL_HOST  = url_host
ourl->SetProperty, URL_PATH  = url_path
ourl->SetProperty, URL_QUERY = query
ourl->SetProperty, HEADERS   = 'User-Agent:<' + user_agent + '>'
;
filename = ourl->GET(filename='buffer.tar.gz')
ourl->GetProperty, RESPONSE_HEADER=rh
OBJ_DESTROY, ourl





;-------------------------------------------------+
; save file
;-------------------------------------------------+
;
;*---------- uncompress gzip file  ----------*
;
directory_out = STRJOIN(STRSPLIT(SYSTIME(), /EXTRACT), '-')
directory_out = 'Cluster-'+directory_out
FILE_GUNZIP, filename, /DELETE
;
;
;*---------- rename .tar.gz file  ----------*
;
pos1 = STRPOS(filename, '.gz')
filename = STRMID(filename, 0, pos1)
;
;
;*---------- untar  ----------*
;
;             [use myfile_untar.pro because native
;              file_untar.pro doesn't work well]
;
myfile_untar, filename, untar_files, /verbose
;
;
;*---------- save files  ----------*
;
; root directory
root_dir = cluster->data_rootdir()

; subdirectory
separator = PATH_SEP()
;
count = 0
;PRINT, '$ =================== Downloaded ======================'
FOREACH f, untar_files DO BEGIN
    ;
    ; mkdir destination directory
    dum  = STRSPLIT(f, separator, /EXTRACT)
    id   = STRSPLIT(dum[-1], '__', /EXTRACT, /REGEX)
    id   = id[0]
    save_dir = FILEPATH(id, root_dir=root_dir)
    FILE_MKDIR, save_dir
    ;
    ; delete old file
    f_old = FILEPATH(FILE_BASENAME(f), root=save_dir)
    IF FILE_TEST(f_old) THEN $
      FILE_DELETE, f_old;, /VERBOSE
    ;
    ; move file
    FILE_MOVE, f, save_dir 
    ;PRINT, '$ ' + STRING(count, FORMAT='(I2)') + ' : ' + $
    ;       FILEPATH( FILE_BASENAME(f), root=save_dir )
    ;PRINT, '$ =================================================='
    count ++
ENDFOREACH
;
suc = 1



;
;*----------  delete original data directory ----------*
;
CD, current=current
pos0 = STRPOS(untar_files[0], 'CSA_Download_')
odir = STRMID(untar_files[0], pos0, STRLEN(untar_files[0]) - pos0)
odir = (STRSPLIT(odir, separator, /EXTRACT))[0]
FILE_DELETE, odir, /RECURSIVE
;
END