COPY (
	SELECT
		*
	FROM
		facdb_datasources
	ORDER BY
		datasourcefull
) TO '/Users/hannahbkates/facilities-db/docs/facdb_datasources.csv' WITH CSV DELIMITER ',' HEADER;