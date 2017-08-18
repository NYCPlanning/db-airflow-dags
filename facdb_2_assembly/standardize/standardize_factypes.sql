UPDATE facilities AS f
    SET 
		factype = REPLACE(factype, 'Other ', '')
	WHERE
		factype LIKE '%Other %'
		AND factype NOT LIKE '% Other%';

UPDATE facilities AS f
    SET 
		factype = CONCAT(factype, ' Mental Health')
	WHERE
		facsubgrp = 'Mental Health'
		AND factype NOT LIKE '%Mental Health%';

UPDATE facilities AS f
    SET 
		factype = CONCAT(factype, ' Chemical Dependency')
	WHERE
		facsubgrp = 'Chemical Dependency'
		AND factype NOT LIKE '%Chemical Dependency%';

UPDATE facilities AS f
    SET 
		factype = REPLACE(factype, 'Structurese', 'Structure')
	WHERE
		factype LIKE '%Structurese%';

UPDATE facilities AS f
    SET 
		factype = 'DOE Universal Pre-Kindergarten'
	WHERE
		factype = 'Prekindergarten';