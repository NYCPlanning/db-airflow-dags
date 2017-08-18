WITH matches AS (
	SELECT
		a.uid,
		b.uid as uid_b,
		a.hash,
		b.hash as hash_b,
    	a.bbl,
		a.facname,
		b.facname as facname_b,
		a.facsubgrp,
		b.facsubgrp as facsubgrp_b,
		a.processingflag,
		b.processingflag as processingflag_b,
		a.address,
		b.address as address_b,
		a.geom,
		a.pgtable,
		b.pgtable as pgtable_b,
		a.overagency,
		b.overlevel as overlevel_b,
		b.overagency as overagency_b,
		a.overabbrev,
		b.overabbrev as overabbrev_b
	FROM facilities a
	LEFT JOIN facilities b
	ON a.bbl = b.bbl
	WHERE
	    a.pgtable = ARRAY['dcas_facilities_colp']
	    AND b.pgtable = ARRAY['dcas_facilities_colp']
		AND a.geom IS NOT NULL
		AND b.geom IS NOT NULL
		AND a.bbl IS NOT NULL
		AND b.bbl IS NOT NULL
		AND a.overabbrev = ARRAY['NYCDOT']
		AND b.overabbrev = ARRAY['NYCSBS']
		AND a.facname = b.facname
		ORDER BY a.facname, a.facsubgrp
	),

duplicates AS (
	SELECT
		facname,
        hash,
        count(*) AS countofdups,
		array_agg(distinct uid_b) AS uid_merged,
		array_agg(distinct hash_b) AS hash_merged,
		array_agg(distinct overagency_b) AS overagency,
		array_agg(distinct overabbrev_b) AS overabbrev,
        array_agg(distinct facsubgrp_b) AS facsubgrp_b
	FROM matches
	GROUP BY
	bbl, facname, uid, hash
	ORDER BY countofdups DESC )

UPDATE facilities AS f
SET
	uid_merged = d.uid_merged,
	hash_merged = d.hash_merged,
	overagency = ARRAY['NYC Department of Transportation', 'NYC Department of Small Business Services'],
	overabbrev = ARRAY['NYCDOT', 'NYCSBS']
FROM duplicates AS d
WHERE f.uid = d.uid
;

DELETE FROM facilities
WHERE facilities.uid IN (SELECT unnest(facilities.uid_merged) FROM facilities);