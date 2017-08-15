DROP TABLE IF EXISTS copy_backup1;

CREATE TABLE copy_backup1 AS (
	SELECT facilities.*
	FROM
		facilities
	ORDER BY
		facdomain, facgroup, facsubgrp, factype
);