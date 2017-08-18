UPDATE facilities AS f
    SET 
		idagency = 
			(CASE
				WHEN idagency IS NOT NULL THEN ARRAY[CONCAT(array_to_string(datasource,','),': ', array_to_string(idagency,','))]
			END),
		overlevel = 
			(CASE
				WHEN overlevel @> ARRAY['Non-public Oversight'] THEN overlevel
				ELSE ARRAY[CONCAT(array_to_string(overabbrev,','),': ', array_to_string(overlevel,','))]
			END),
		capacity = 
			(CASE
				WHEN capacity IS NOT NULL THEN ARRAY[CONCAT(array_to_string(datasource,','),': ', array_to_string(capacity,','))]
			END),
		captype = 
			(CASE
				WHEN captype IS NOT NULL THEN ARRAY[CONCAT(array_to_string(datasource,','),': ', array_to_string(captype,','))]
			END),
		util = 
			(CASE
				WHEN util IS NOT NULL THEN ARRAY[CONCAT(array_to_string(datasource,','),': ', array_to_string(util,','))]
			END),
		utilrate = 
			(CASE
				WHEN utilrate IS NOT NULL THEN ARRAY[CONCAT(array_to_string(datasource,','),': ', array_to_string(utilrate,','))]
			END),
		area = 
			(CASE
				WHEN area IS NOT NULL THEN ARRAY[CONCAT(array_to_string(datasource,','),': ', array_to_string(area,','))]
			END),
		areatype = 
			(CASE
				WHEN areatype IS NOT NULL THEN ARRAY[CONCAT(array_to_string(datasource,','),': ', array_to_string(areatype,','))]
			END)
	WHERE
		uid IS NULL
		AND array_to_string(overlevel,',') NOT LIKE CONCAT(array_to_string(overabbrev,','),': %') AND overlevel <> ARRAY['Non-public Oversight']
		;

UPDATE facilities
	SET idagency = NULL
	WHERE idagency IS NOT NULL 
	AND split_part(array_to_string(idagency,','),': ',2) = ''
	AND uid is NULL;

UPDATE facilities
	SET capacity = NULL
	WHERE capacity IS NOT NULL 
	AND split_part(array_to_string(capacity,','),': ',2) = ''
	AND uid is NULL;

UPDATE facilities
	SET captype = NULL
	WHERE captype IS NOT NULL 
	AND split_part(array_to_string(captype,','),': ',2) = ''
	AND uid is NULL;

UPDATE facilities
	SET util = NULL
	WHERE util IS NOT NULL 
	AND split_part(array_to_string(util,','),': ',2) = ''
	AND uid is NULL;

UPDATE facilities
	SET utilrate = NULL
	WHERE utilrate IS NOT NULL 
	AND split_part(array_to_string(utilrate,','),': ',2) = ''
	AND uid is NULL;

UPDATE facilities
	SET area = NULL
	WHERE area IS NOT NULL 
	AND split_part(array_to_string(area,','),': ',2) = ''
	AND uid is NULL;

UPDATE facilities
	SET areatype = NULL
	WHERE areatype IS NOT NULL 
	AND split_part(array_to_string(areatype,','),': ',2) = ''
	AND uid is NULL;

UPDATE facilities
	SET dataurl = NULL
	WHERE dataurl IS NOT NULL 
	AND split_part(array_to_string(dataurl,','),': ',2) = ''
	AND uid is NULL;

UPDATE facilities
	SET datadownload = NULL
	WHERE datadownload IS NOT NULL 
	AND split_part(array_to_string(datadownload,','),': ',2) = ''
	AND uid is NULL;