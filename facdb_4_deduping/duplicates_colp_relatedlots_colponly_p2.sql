WITH primaryuids AS (
	SELECT
		(array_agg(distinct uid))[1] AS uid
	FROM facilities
	WHERE
		pgtable = ARRAY['dcas_facilities_colp']::text[]
		AND geom IS NOT NULL
		AND hash_merged IS NULL
		AND (facname = 'Unnamed'
		OR facname = 'No Use-Vacant Land'
		OR facname = 'No Use'
		OR facname = 'City Owned Property'
		OR facname = 'Park'
		OR facname = 'Office Bldg'
		OR facname = 'Office'
		OR facname = 'Park Strip'
		OR facname = 'Playground'
		OR facname = 'NYPD Parking'
		OR facname = 'Multi-Service Center'
		OR facname = 'Animal Shelter'
		OR facname = 'Garden'
		OR facname = 'L.U.W'
		OR facname = 'Long Term Tenant: NYCHA'
		OR facname = 'Help Social Service Corporation'
		OR facname = 'Day Care Center'
		OR facname = 'Safety City Site'
		OR facname = 'Public Place'
		OR facname = 'Sanitation Garage'
		OR facname = 'MTA Bus Depot'
		OR facname = 'Mta Bus Depot'
		OR facname = 'Mall'
		OR facname = 'Vest Pocket Park'
		OR facname = 'Pier 6'
		OR overabbrev = ARRAY['NYCDOE'])
	GROUP BY
		factype,
		overagency,
		censtract,
		facname
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
		b.uid AS uid_b,
		b.hash AS hash_b,
		(CASE WHEN b.bin IS NULL THEN ARRAY['FAKE!'] ELSE b.bin END) AS bin_b,
		(CASE WHEN b.bbl IS NULL THEN ARRAY['FAKE!'] ELSE b.bbl END) AS bbl_b
	FROM primaries AS a
	INNER JOIN facilities AS b
	ON
		a.facname = b.facname
	WHERE
		b.pgtable = ARRAY['dcas_facilities_colp']::text[]
		AND a.factype = b.factype
		AND a.overagency = b.overagency
		AND a.censtract = b.censtract
		AND a.uid <> b.uid
		AND b.geom IS NOT NULL
		AND b.hash_merged IS NULL
		AND ST_DWithin(a.geom::geography, b.geom::geography, 200)
),

duplicates AS (
	SELECT
		uid,
		count(*) AS countofdups,
		facname,
		factype,
		array_agg(distinct BIN_b) AS bin_merged,
		array_agg(distinct BBL_b) AS bbl_merged,
		array_agg(distinct uid_b) AS uid_merged,
		array_agg(distinct hash_b) AS hash_merged
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
	uid_merged = d.uid_merged,
	hash_merged = d.hash_merged
FROM duplicates AS d
WHERE f.uid = d.uid
;

DELETE FROM facilities
WHERE facilities.uid IN (SELECT unnest(facilities.uid_merged) FROM facilities);