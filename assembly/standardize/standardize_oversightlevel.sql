UPDATE facilities AS f
    SET 
		overlevel = 
			(CASE
				WHEN 
					array_to_string(overabbrev, ',') LIKE '%NYS%'
					OR array_to_string(overabbrev, ',') LIKE '%MTA%'
					OR array_to_string(overabbrev, ',') LIKE '%NYCHA%'
					OR array_to_string(overabbrev, ',') LIKE '%PANYNJ%'
					OR array_to_string(overabbrev, ',') LIKE '%RIOC%'
				THEN ARRAY['State']
				WHEN
					array_to_string(overabbrev, ',') LIKE '%NYC%'
					OR array_to_string(overabbrev, ',') LIKE '%FDNY%'
					OR array_to_string(overabbrev, ',') LIKE '%NYPD%'
					OR array_to_string(overabbrev, ',') LIKE '%CUNY%'
				THEN ARRAY['City']
				WHEN
					array_to_string(overabbrev, ',') LIKE '%US%'
					OR array_to_string(overabbrev, ',') LIKE '%FBOP%'
					OR array_to_string(overabbrev, ',') LIKE '%Amtrak%'
				THEN ARRAY['Federal']
				WHEN
					array_to_string(overabbrev, ',') LIKE '%HYDC%'
					OR array_to_string(overabbrev, ',') LIKE '%HRPT%'
					OR array_to_string(overabbrev, ',') LIKE '%BBPC%'
					OR array_to_string(overabbrev, ',') LIKE '%TGI%'
				THEN ARRAY['City-State']
				ELSE ARRAY['Non-public Oversight']
			END);

UPDATE facilities AS f
	SET overlevel = ARRAY['NYCDOE: City','NYSED: State']
	WHERE overlevel = ARRAY['NYCDOE,NYSED: State'];