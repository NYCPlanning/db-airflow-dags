WITH matches AS (
	SELECT
		CONCAT(a.pgtable,'-',b.pgtable) as sourcecombo,
		a.idagency,
		(CASE WHEN b.idagency IS NULL THEN ARRAY['FAKE!'] ELSE b.idagency END) as idagency_b,
		a.uid,
		b.uid as uid_b,
		a.hash,
		b.hash as hash_b,
		a.facname,
		b.facname as facname_b,
		a.facsubgrp,
		b.facsubgrp as facsubgrp_b,
		a.factype,
		b.factype as factype_b,
		a.processingflag,
		b.processingflag as processingflag_b,
		a.bin,
		b.bin as bin_b,
		a.address,
		b.address as address_b,
		a.geom,
		a.pgtable,
		b.pgtable as pgtable_b,
		a.datasource,
		b.datasource as datasource_b,
		a.dataname,
		b.dataname as dataname_b,
		b.datadate as datadate_b,
		(CASE WHEN b.dataurl IS NULL THEN ARRAY['FAKE!'] ELSE b.dataurl END) as dataurl_b,
		a.overagency,
		b.overlevel as overlevel_b,
		b.overagency as overagency_b,
		a.overabbrev,
		b.overabbrev as overabbrev_b
	FROM facilities a
	LEFT JOIN facilities b
	ON a.bin = b.bin
	WHERE
		a.pgtable = ARRAY['acs_facilities_daycareheadstart']::text[]
		AND (b.pgtable = ARRAY['hhs_facilities_fmscontracts']::text[]
			OR b.pgtable = ARRAY['hhs_facilities_financialscontracts']::text[]
			OR b.pgtable = ARRAY['hhs_facilities_proposals']::text[])
		AND b.facgroup LIKE '%Child Care%'
		AND a.geom IS NOT NULL
		AND b.geom IS NOT NULL
		AND a.bin IS NOT NULL
		AND b.bin IS NOT NULL
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
		AND a.pgtable <> b.pgtable
		AND a.uid <> b.uid
		ORDER BY CONCAT(a.pgtable,'-',b.pgtable), a.facname, a.facsubgrp
	), 

duplicates AS (
	SELECT
		count(*) AS countofdups,
		facname,
		factype,
		array_agg(distinct factype_b) AS factype_merged,
		uid,
		array_agg(distinct uid_b) AS uid_merged,
		array_agg(distinct idagency_b) AS idagency_merged,
		array_agg(distinct hash_b) AS hash_merged,
		array_agg(distinct datasource_b) AS datasource,
		array_agg(distinct dataname_b) AS dataname,
		array_agg(distinct datadate_b) AS datadate,
		array_agg(distinct dataurl_b) AS dataurl,
		array_agg(distinct overlevel_b) AS overlevel,
		array_agg(distinct overagency_b) AS overagency,
		array_agg(distinct overabbrev_b) AS overabbrev,
		array_agg(distinct pgtable_b) AS pgtable
	FROM matches
	GROUP BY
	uid, facname, factype
	ORDER BY factype, countofdups DESC )

UPDATE facilities AS f
SET
	idagency = array_cat(f.idagency, d.idagency_merged),
	uid_merged = array_cat(f.uid_merged, d.uid_merged),
	hash_merged = array_cat(f.hash_merged, d.hash_merged),
	pgtable = array_cat(f.pgtable, d.pgtable),
	datasource = array_cat(f.datasource, d.datasource),
	dataname = array_cat(f.dataname, d.dataname),
	datadate = array_cat(f.datadate, d.datadate),
	dataurl = array_cat(f.dataurl, d.dataurl),
	overlevel = array_cat(f.overlevel, d.overlevel),
	overagency = array_cat(f.overagency, d.overagency),
	overabbrev = array_cat(f.overabbrev, d.overabbrev)
FROM duplicates AS d
WHERE f.uid = d.uid
;

DELETE FROM facilities
WHERE facilities.uid IN (SELECT unnest(facilities.uid_merged) FROM facilities);