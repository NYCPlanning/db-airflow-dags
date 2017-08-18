DROP TABLE IF EXISTS copy_backup0;

CREATE TABLE copy_backup0 AS (
	SELECT facilities.*
	FROM
		facilities
	ORDER BY
		facdomain, facgroup, facsubgrp, factype
);