DROP TABLE IF EXISTS copy_backup2;

CREATE TABLE copy_backup2 AS (
	SELECT facilities.*
	FROM
		facilities
	ORDER BY
		facdomain, facgroup, facsubgrp, factype
);