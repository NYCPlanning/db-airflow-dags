COPY (
	SELECT
		*
	FROM
		facdb_datasources
	ORDER BY
		datasourcefull
) TO '{{ params.export_dir }}/facdb_datasources.csv' WITH CSV DELIMITER ',' HEADER;
