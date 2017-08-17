DROP TABLE IF EXISTS copy_backup5;

CREATE TABLE copy_backup5 AS (
	SELECT facilities.*
	FROM
		facilities
	ORDER BY
		facdomain, facgroup, facsubgrp, factype
);