DROP TABLE IF EXISTS copy_backup4;

CREATE TABLE copy_backup4 AS (
	SELECT facilities.*
	FROM
		facilities
	ORDER BY
		facdomain, facgroup, facsubgrp, factype
);