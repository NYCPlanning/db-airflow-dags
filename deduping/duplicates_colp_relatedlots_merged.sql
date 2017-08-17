WITH allmerged AS (
	SELECT
		unnest(uid_merged)
	FROM
		facilities
),

primaries AS (
	SELECT
		uid,
		geom,
		facname,
		BBL,
		factype,
		overabbrev
	FROM
		copy_backup3
	WHERE
		uid in (SELECT * from allmerged)
		AND pgtable = ARRAY['dcas_facilities_colp']
),

-- find other related COLP records, matching on agency, name, subgroup, and proximity (within 100m)
matches AS (
	SELECT
		a.uid,
		a.geom,
		a.facname,
		a.factype,
		b.uid AS uid_b,
		b.hash AS hash_b,
		(CASE WHEN b.bin IS NULL THEN ARRAY['FAKE!'] ELSE b.bin END) AS bin_b,
		(CASE WHEN b.bbl IS NULL THEN ARRAY['FAKE!'] ELSE b.bbl END) AS bbl_b
	FROM primaries AS a
	LEFT JOIN facilities AS b
	ON
		(LEFT(
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
		,4))
		=
		(LEFT(
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
		,4))
	WHERE
		b.pgtable = ARRAY['dcas_facilities_colp']::text[]
		AND a.factype = b.factype
		AND a.overabbrev = b.overabbrev
		AND a.uid <> b.uid
		AND b.geom IS NOT NULL
		AND ST_DWithin(a.geom::geography, b.geom::geography, 500)
),

duplicates AS (
	SELECT
		uid,
		count(*) AS countofdups,
		facname,
		factype,
		array_agg(distinct uid_b) AS uid_merged_b,
		array_agg(distinct bin_b) AS bin_merged,
		array_agg(distinct bbl_b) AS bbl_merged,
		array_agg(distinct hash_b) AS hash_merged_b
	FROM matches
	GROUP BY
		uid, facname, factype
	ORDER BY factype, countofdups DESC )

UPDATE facilities AS f
SET
	BIN = 
		(CASE
			WHEN d.bin_merged <> ARRAY['FAKE!'] THEN array_cat(BIN, d.bin_merged)
			ELSE BIN
		END),
	BBL = 
		(CASE
			WHEN d.BBL_merged <> ARRAY['FAKE!'] THEN array_cat(BBL, d.BBL_merged)
			ELSE BBL
		END),
	uid_merged = array_cat(uid_merged, d.uid_merged_b),
	hash_merged = array_cat(hash_merged, d.hash_merged_b)
FROM duplicates AS d
WHERE f.uid_merged @> ARRAY[d.uid::text]
;

DELETE FROM facilities
WHERE facilities.uid IN (SELECT unnest(facilities.uid_merged) FROM facilities);