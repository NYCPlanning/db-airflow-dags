COPY (
	SELECT
		*
	FROM
		facdb_datasources
	ORDER BY
		datasourcefull
) TO '{{ params.EXPORT_DIR }}/facdb_datasources.csv' WITH CSV DELIMITER ',' HEADER;
