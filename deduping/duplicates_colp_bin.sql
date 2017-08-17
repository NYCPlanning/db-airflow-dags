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
		b.proptype as proptype_b,
		b.agencyclass2,
		b.colpusetype
	FROM facilities a
	LEFT JOIN facilities b
	ON a.bin = b.bin
	WHERE
		a.facsubgrp = b.facsubgrp
		AND b.pgtable = ARRAY['dcas_facilities_colp']
		AND a.overabbrev @> b.overabbrev
		AND a.geom IS NOT NULL
		AND b.geom IS NOT NULL
		AND a.bin IS NOT NULL
		AND b.bin IS NOT NULL
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
		array_agg(distinct hash_b) AS hash_merged,
		array_agg(distinct datasource_b) AS datasource,
		array_agg(distinct dataname_b) AS dataname,
		array_agg(distinct datadate_b) AS datadate,
		array_agg(distinct dataurl_b) AS dataurl,
		array_agg(distinct overlevel_b) AS overlevel,
		array_agg(distinct overagency_b) AS overagency,
		array_agg(distinct overabbrev_b) AS overabbrev,
		array_agg(distinct pgtable_b) AS pgtable,
		array_agg(distinct colpusetype) AS colpusetype,
		array_to_string(array_agg(distinct proptype_b),';') AS proptype
	FROM matches
	GROUP BY
	uid, facname, factype
	ORDER BY factype, countofdups DESC )

UPDATE facilities AS f
SET
	uid_merged = d.uid_merged,
	hash_merged = d.hash_merged,
	pgtable = string_to_array(CONCAT(array_to_string(f.pgtable,';'),';',array_to_string(d.pgtable,';')),';'),
	datasource = string_to_array(CONCAT(array_to_string(f.datasource,';'),';',array_to_string(d.datasource,';')),';'),
	dataname = string_to_array(CONCAT(array_to_string(f.dataname,';'),';',array_to_string(d.dataname,';')),';'),
	dataurl = 
		(CASE
			WHEN d.dataurl <> ARRAY['FAKE!'] THEN string_to_array(CONCAT(array_to_string(f.dataurl,';'),';',array_to_string(d.dataurl,';')),';')
			ELSE f.dataurl
		END),
	colpusetype = d.colpusetype,
	proptype = d.proptype
FROM duplicates AS d
WHERE f.uid = d.uid
;

DELETE FROM facilities
WHERE facilities.uid IN (SELECT unnest(facilities.uid_merged) FROM facilities);