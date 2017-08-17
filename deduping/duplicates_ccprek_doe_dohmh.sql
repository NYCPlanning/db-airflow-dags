WITH matches AS (
	SELECT
		CONCAT(a.pgtable,'-',b.pgtable) as sourcecombo,
		a.idagency,
		b.idagency as idagency_b,
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
		b.overabbrev as overabbrev_b,
		(CASE WHEN b.capacity IS NULL THEN ARRAY['FAKE!'] ELSE b.capacity END) as capacity_b,
		(CASE WHEN b.captype IS NULL THEN ARRAY['FAKE!'] ELSE b.captype END) captype_b,
		(CASE WHEN b.util IS NULL THEN ARRAY['FAKE!'] ELSE b.util END) as util_b,
		(CASE WHEN b.area IS NULL THEN ARRAY['FAKE!'] ELSE b.area END) as area_b,
		(CASE WHEN b.areatype IS NULL THEN ARRAY['FAKE!'] ELSE b.areatype END) areatype_b
	FROM facilities a
	LEFT JOIN facilities b
	ON a.bin = b.bin
	WHERE
		a.facgroup LIKE '%Child Care%'
		AND (a.factype LIKE '%Early%'
		OR a.factype LIKE '%Charter%')
		-- AND b.factype LIKE '%Preschool%'
		AND b.factype NOT LIKE '%Camp%'
		AND a.pgtable @> ARRAY['doe_facilities_universalprek']::text[]
		AND b.pgtable = ARRAY['dohmh_facilities_daycare']::text[]
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
		array_agg(distinct pgtable_b) AS pgtable,
		array_agg(capacity_b) AS capacity,
		array_agg(distinct captype_b) AS captype,
		array_agg(util_b) AS util,
		array_agg(area_b) AS area,
		array_agg(distinct areatype_b) AS areatype
	FROM matches
	GROUP BY
	uid, facname, factype
	ORDER BY factype, countofdups DESC )

UPDATE facilities AS f
SET
	idagency = array_cat(idagency, d.idagency_merged),
	uid_merged = d.uid_merged,
	hash_merged = d.hash_merged,
	pgtable = array_cat(f.pgtable,d.pgtable),
	datasource = array_cat(f.datasource, d.datasource),
	dataname = array_cat(f.dataname, d.dataname),
	datadate = array_cat(f.datadate, d.datadate),
	dataurl = array_cat(f.dataurl, d.dataurl),
	overlevel = array_cat(f.overlevel, d.overlevel),
	overagency = array_cat(f.overagency, d.overagency),
	overabbrev = array_cat(f.overabbrev, d.overabbrev),
	capacity = (CASE WHEN d.capacity <> ARRAY['FAKE!'] THEN array_cat(f.capacity, d.capacity) END),
	captype = (CASE WHEN d.captype <> ARRAY['FAKE!'] THEN array_cat(f.captype, d.captype) END),
	util = (CASE WHEN d.util <> ARRAY['FAKE!'] THEN array_cat(f.util, d.util) END),
	area = (CASE WHEN d.area <> ARRAY['FAKE!'] THEN array_cat(f.area, d.area) END),
	areatype = (CASE WHEN d.areatype <> ARRAY['FAKE!'] THEN array_cat(f.areatype, d.areatype) END),
	facsubgrp = (CASE
		WHEN array_to_string(factype_merged,',') LIKE '%Infants/Toddlers%' AND array_to_string(factype_merged,',') LIKE '%Preschool%' THEN 'Dual Child Care and Universal Pre-K'
		ELSE facsubgrp
		END)
FROM duplicates AS d
WHERE f.uid = d.uid
;

DELETE FROM facilities
WHERE facilities.uid IN (SELECT unnest(facilities.uid_merged) FROM facilities);