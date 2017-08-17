COPY (
	SELECT
		CONCAT('### ',datasourcefull,' (', datasource, ')') AS datasource,
		'| | |' AS header,
		'| -- | -- |' AS divider,
		(CASE
			WHEN dataurl IS NOT NULL THEN CONCAT('| Dataset Name: | [',dataname,'](',dataurl,') |')
			WHEN dataurl IS NULL THEN CONCAT('| Dataset Name:  | ',dataname,' |')
		END) AS datasetandlink,
		CONCAT('| Last Updated: | ', datadate ,' |') AS lastupdated,
		(CASE
			WHEN docsnotes IS NOT NULL THEN CONCAT('| Notes: | ', docsnotes, ' |')
			ELSE NULL
		END) AS docsnotes
	FROM
		facdb_datasources
	WHERE
		using_01 = '1'
	ORDER BY
		datasourcefull
) TO '/Users/hannahbkates/facilities-db/tables/docs/facdb_datasources_docs.txt' WITH CSV DELIMITER '~' HEADER;