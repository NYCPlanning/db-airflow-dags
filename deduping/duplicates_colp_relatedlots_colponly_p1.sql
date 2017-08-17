WITH primaryuids AS (
	SELECT
		(array_agg(distinct uid))[1] AS uid
	FROM facilities
	WHERE
		pgtable = ARRAY['dcas_facilities_colp']::text[]
		AND geom IS NOT NULL
		AND facname <> 'Unnamed'
		AND facname <> 'No Use-Vacant Land'
		AND facname <> 'No Use'
		AND facname <> 'City Owned Property'
		AND facname <> 'Park'
		AND facname <> 'Office Bldg'
		AND facname <> 'Office'
		AND facname <> 'Park Strip'
		AND facname <> 'Playground'
		AND facname <> 'NYPD Parking'
		AND facname <> 'Multi-Service Center'
		AND facname <> 'Animal Shelter'
		AND facname <> 'Garden'
		AND facname <> 'L.U.W'
		AND facname <> 'Long Term Tenant: NYCHA'
		AND facname <> 'Help Social Service Corporation'
		AND facname <> 'Day Care Center'
		AND facname <> 'Safety City Site'
		AND facname <> 'Public Place'
		AND facname <> 'Sanitation Garage'
		AND facname <> 'MTA Bus Depot'
		AND facname <> 'Mta Bus Depot'
		AND facname <> 'Mall'
		AND facname <> 'Vest Pocket Park'
		AND facname <> 'Pier 6'
		AND overabbrev <> ARRAY['NYCDOE']
	GROUP BY
		factype,
		overagency,
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
		AND a.uid <> b.uid
		AND b.geom IS NOT NULL
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