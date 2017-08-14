UPDATE facilities AS f
    SET 
		oversightlevel = 
			(CASE
				WHEN 
					array_to_string(oversightabbrev, ',') LIKE '%NYS%'
					OR array_to_string(oversightabbrev, ',') LIKE '%MTA%'
					OR array_to_string(oversightabbrev, ',') LIKE '%NYCHA%'
					OR array_to_string(oversightabbrev, ',') LIKE '%PANYNJ%'
					OR array_to_string(oversightabbrev, ',') LIKE '%RIOC%'
				THEN ARRAY['State']
				WHEN
					array_to_string(oversightabbrev, ',') LIKE '%NYC%'
					OR array_to_string(oversightabbrev, ',') LIKE '%FDNY%'
					OR array_to_string(oversightabbrev, ',') LIKE '%NYPD%'
					OR array_to_string(oversightabbrev, ',') LIKE '%CUNY%'
				THEN ARRAY['City']
				WHEN
					array_to_string(oversightabbrev, ',') LIKE '%US%'
					OR array_to_string(oversightabbrev, ',') LIKE '%FBOP%'
					OR array_to_string(oversightabbrev, ',') LIKE '%Amtrak%'
				THEN ARRAY['Federal']
				WHEN
					array_to_string(oversightabbrev, ',') LIKE '%HYDC%'
					OR array_to_string(oversightabbrev, ',') LIKE '%HRPT%'
					OR array_to_string(oversightabbrev, ',') LIKE '%BBPC%'
					OR array_to_string(oversightabbrev, ',') LIKE '%TGI%'
				THEN ARRAY['City-State']
				ELSE ARRAY['Non-public Oversight']
			END);