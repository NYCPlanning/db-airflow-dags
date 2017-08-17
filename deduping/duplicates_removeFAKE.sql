UPDATE facilities
	SET
		idagency = 
			(CASE
				WHEN array_to_string(idagency,',') = 'FAKE!' THEN NULL
				WHEN array_to_string(idagency,',') LIKE '%FAKE!%' THEN string_to_array(REPLACE(REPLACE(array_to_string(idagency,';'),';FAKE!',''),'FAKE!;',''),';')
				ELSE idagency
			END),
		idold = 
			(CASE
				WHEN idold @> ARRAY['FAKE!'] THEN NULL
				WHEN array_to_string(idold,',') LIKE '%FAKE!%' THEN string_to_array(REPLACE(REPLACE(array_to_string(idold,';'),';FAKE!',''),'FAKE!;',''),';')
				ELSE idold
			END),
		bin =
			(CASE
				WHEN array_to_string(bin,',') = 'FAKE!' THEN NULL
				WHEN array_to_string(bin,',') LIKE '%FAKE!%' THEN string_to_array(REPLACE(REPLACE(array_to_string(bin,';'),';FAKE!',''),'FAKE!;',''),';')
				ELSE bin
			END),
		bbl =
			(CASE
				WHEN array_to_string(bbl,',') = 'FAKE!' THEN NULL
				WHEN array_to_string(bbl,',') LIKE '%FAKE!%' THEN string_to_array(REPLACE(REPLACE(array_to_string(bbl,';'),';FAKE!',''),'FAKE!;',''),';')
				ELSE bbl
			END),
		capacity =
			(CASE
				WHEN array_to_string(capacity,',') = 'FAKE!' THEN NULL
				WHEN array_to_string(capacity,',') LIKE '%FAKE!%' THEN string_to_array(REPLACE(REPLACE(array_to_string(capacity,';'),';FAKE!',''),'FAKE!;',''),';')
				ELSE capacity
			END),
		captype =
			(CASE
				WHEN array_to_string(captype,',') = 'FAKE!' THEN NULL
				WHEN array_to_string(captype,',') LIKE '%FAKE!%' THEN string_to_array(REPLACE(REPLACE(array_to_string(captype,';'),';FAKE!',''),'FAKE!;',''),';')
				ELSE captype
			END),
		util =
			(CASE
				WHEN array_to_string(util,',') = 'FAKE!' THEN NULL
				WHEN array_to_string(util,',') LIKE '%FAKE!%' THEN string_to_array(REPLACE(REPLACE(array_to_string(util,';'),';FAKE!',''),'FAKE!;',''),';')
				ELSE util
			END),
		area =
			(CASE
				WHEN array_to_string(area,',') = 'FAKE!' THEN NULL
				WHEN array_to_string(area,',') LIKE '%FAKE!%' THEN string_to_array(REPLACE(REPLACE(array_to_string(area,';'),';FAKE!',''),'FAKE!;',''),';')
				ELSE area
			END),
		areatype =
			(CASE
				WHEN array_to_string(areatype,',') = 'FAKE!' THEN NULL
				WHEN array_to_string(areatype,',') LIKE '%FAKE!%' THEN string_to_array(REPLACE(REPLACE(array_to_string(areatype,';'),';FAKE!',''),'FAKE!;',''),';')
				ELSE areatype
			END),
		dataname =
			(CASE
				WHEN array_to_string(dataname,',') = 'FAKE!' THEN NULL
				WHEN array_to_string(dataname,',') LIKE '%FAKE!%' THEN string_to_array(REPLACE(REPLACE(array_to_string(dataname,';'),';FAKE!',''),'FAKE!;',''),';')
				ELSE dataname
			END),
		dataurl =
			(CASE
				WHEN array_to_string(dataurl,',') = 'FAKE!' THEN NULL
				WHEN array_to_string(dataurl,',') LIKE '%FAKE!%' THEN string_to_array(REPLACE(REPLACE(array_to_string(dataurl,';'),';FAKE!',''),'FAKE!;',''),';')
				ELSE dataurl
			END)