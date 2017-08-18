COPY (
	SELECT
		*
	FROM
		facdb_uid_key
) TO '{{ params.export_dir }}/facdb_uid_key.csv' WITH CSV DELIMITER ',' HEADER;
