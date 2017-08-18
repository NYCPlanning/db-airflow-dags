WITH primaryuids AS (
	SELECT
		(array_agg(distinct uid))[1] AS uid
	FROM facilities
	WHERE
		pgtable = ARRAY['dohmh_facilities_daycare']::text[]
		AND geom IS NOT NULL
		AND bin IS NOT NULL
		AND bin <> ARRAY['']
		AND bin <> ARRAY['0.00000000000']
	GROUP BY
		facsubgrp,
		bin,
		(LEFT(
			TRIM(
		split_part(
			REPLACE(
		REPLACE(
			REPLACE(
		REPLACE(
			REPLACE(
		UPPER(facname)
			,'THE ','')
		,'-','')
			,' ','')
		,'.','')
			,',','')
		,'(',1)
			,' ')
		,4))
),

primaries AS (
	SELECT *
	FROM facilities
	WHERE uid IN (SELECT uid from primaryuids)
),

matches AS (
	SELECT
		a.uid,
		a.facname,
		a.factype,
		a.capacity,
		(CASE WHEN b.capacity IS NULL THEN ARRAY['FAKE!'] ELSE b.capacity END) AS capacity_b,
		b.uid AS uid_b,
		b.hash AS hash_b,
		(CASE WHEN b.idagency IS NULL THEN ARRAY['FAKE!'] ELSE b.idagency END) AS idagency_b,
		(CASE WHEN b.bin IS NULL THEN ARRAY['FAKE!'] ELSE b.bin END) AS bin_b
	FROM primaries AS a
	LEFT JOIN facilities AS b
	ON
	a.bin = b.bin
	WHERE
		b.pgtable = ARRAY['dohmh_facilities_daycare']::text[]
		AND a.facsubgrp = b.facsubgrp
		AND a.uid <> b.uid
		AND b.geom IS NOT NULL
		AND
			LEFT(
				TRIM(
					split_part(
				REPLACE(
					REPLACE(
				REPLACE(
					REPLACE(
				REPLACE(
					UPPER(a.facname)
				,'THE ','')
					,'-','')
				,' ','')
					,'.','')
				,',','')
					,'(',1)
				,' ')
			,4)
			LIKE
			LEFT(
				TRIM(
					split_part(
				REPLACE(
					REPLACE(
				REPLACE(
					REPLACE(
				REPLACE(
					UPPER(b.facname)
				,'THE ','')
					,'-','')
				,' ','')
					,'.','')
				,',','')
					,'(',1)
				,' ')
			,4)
),

duplicates AS (
	SELECT
		uid,
		count(*) AS countofdups,
		facname,
		factype,
		array_agg(bin_b) AS bin_merged,
		array_agg(distinct uid_b) AS uid_merged,
		array_agg(distinct idagency_b) AS idagency_merged,
		array_agg(distinct hash_b) AS hash_merged,
		array_agg(capacity_b) AS capacity_merged
	FROM matches
	GROUP BY
		uid, facname, factype, capacity
	ORDER BY factype, countofdups DESC )

UPDATE facilities AS f
SET
	bin = 
		(CASE 
			WHEN d.bin_merged <> ARRAY['FAKE!'] THEN array_cat(f.bin, d.bin_merged)
			ELSE f.bin
		END),
	idagency = 
		(CASE 
			WHEN d.idagency_merged <> ARRAY['FAKE!'] THEN array_cat(f.idagency, d.idagency_merged)
			ELSE f.idagency
		END),
	uid_merged = d.uid_merged,
	hash_merged = d.hash_merged,
	capacity = 
		(CASE 
			WHEN d.capacity_merged <> ARRAY['FAKE!'] THEN array_cat(f.capacity, d.capacity_merged)
			ELSE f.capacity
		END)
FROM duplicates AS d
WHERE f.uid = d.uid
;

DELETE FROM facilities
WHERE facilities.uid IN (SELECT unnest(facilities.uid_merged) FROM facilities);