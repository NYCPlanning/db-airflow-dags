DROP TABLE IF EXISTS copy_backup6;

CREATE TABLE copy_backup6 AS (
	SELECT facilities.*
	FROM
		facilities
	ORDER BY
		facdomain, facgroup, facsubgrp, factype
);