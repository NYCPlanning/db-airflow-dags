update facilities
set
idagency = ARRAY[REPLACE(array_to_string(idagency,','),CONCAT(array_to_string(datasource,','),': '),'')],
overlevel = ARRAY[REPLACE(array_to_string(overlevel,','),CONCAT(array_to_string(datasource,','),': '),'')],
capacity = ARRAY[REPLACE(array_to_string(capacity,','),CONCAT(array_to_string(datasource,','),': '),'')],
captype = ARRAY[REPLACE(array_to_string(captype,','),CONCAT(array_to_string(datasource,','),': '),'')],
util = ARRAY[REPLACE(array_to_string(util,','),CONCAT(array_to_string(datasource,','),': '),'')],
utilrate = ARRAY[REPLACE(array_to_string(utilrate,','),CONCAT(array_to_string(datasource,','),': '),'')],
area = ARRAY[REPLACE(array_to_string(area,','),CONCAT(array_to_string(datasource,','),': '),'')],
areatype = ARRAY[REPLACE(array_to_string(areatype,','),CONCAT(array_to_string(datasource,','),': '),'')],
dataurl = ARRAY[REPLACE(array_to_string(dataurl,','),CONCAT(array_to_string(datasource,','),': '),'')],
datadownload = ARRAY[REPLACE(array_to_string(datadownload,','),CONCAT(array_to_string(datasource,','),': '),'')]
;

update facilities
set
idagency = ARRAY[REPLACE(array_to_string(idagency,','),CONCAT(array_to_string(overabbrev,','),': '),'')],
overlevel = ARRAY[REPLACE(array_to_string(overlevel,','),CONCAT(array_to_string(overabbrev,','),': '),'')],
capacity = ARRAY[REPLACE(array_to_string(capacity,','),CONCAT(array_to_string(overabbrev,','),': '),'')],
captype = ARRAY[REPLACE(array_to_string(captype,','),CONCAT(array_to_string(overabbrev,','),': '),'')],
util = ARRAY[REPLACE(array_to_string(util,','),CONCAT(array_to_string(overabbrev,','),': '),'')],
utilrate = ARRAY[REPLACE(array_to_string(utilrate,','),CONCAT(array_to_string(overabbrev,','),': '),'')],
area = ARRAY[REPLACE(array_to_string(area,','),CONCAT(array_to_string(overabbrev,','),': '),'')],
areatype = ARRAY[REPLACE(array_to_string(areatype,','),CONCAT(array_to_string(overabbrev,','),': '),'')],
dataurl = ARRAY[REPLACE(array_to_string(dataurl,','),CONCAT(array_to_string(overabbrev,','),': '),'')],
datadownload = ARRAY[REPLACE(array_to_string(datadownload,','),CONCAT(array_to_string(overabbrev,','),': '),'')]
;