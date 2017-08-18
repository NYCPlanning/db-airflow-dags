COPY (
	SELECT
		*
	FROM
		facdb_uid_key
) TO '{{ params.EXPORT_DIR }}/facdb_uid_key.csv' WITH CSV DELIMITER ',' HEADER;
