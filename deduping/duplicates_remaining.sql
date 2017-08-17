WITH matches AS (
	SELECT
		CONCAT(a.pgtable,'-',b.pgtable) as sourcecombo,
		a.idagency,
		(CASE WHEN b.idagency IS NULL THEN ARRAY['FAKE!'] ELSE b.idagency END) as idagency_b,
		a.uid,
		b.uid as uid_b,
		(CASE WHEN b.idold IS NULL THEN ARRAY['FAKE!'] ELSE b.idold END) as idold_b,
		a.hash,
		b.hash as hash_b,
		a.facname,
		b.facname as facname_b,
		a.facsubgrp,
		b.facsubgrp as facsubgrp_b,
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
		a.facsubgrp = b.facsubgrp
		AND a.facgroup <> 'Child Care and Pre-Kindergarten'
	    AND a.pgtable <> ARRAY['dcas_facilities_colp']
	    AND b.pgtable <> ARRAY['dcas_facilities_colp']
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
		uid,
		facsubgrp,
		array_agg(distinct uid_b) AS uid_merged,
		array_agg(distinct idagency_b) AS idagency_merged,
		array_agg(distinct idold_b) AS idold_merged,
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
		array_agg(distinct areatype_b) AS areatype,
		sourcecombo
	FROM matches
	WHERE
		sourcecombo LIKE '{dycd_facilities_compass%' AND sourcecombo LIKE '%{hhs_facilities_%' AND facsubgrp = 'Comprehensive After School System (COMPASS) Sites'
		OR sourcecombo LIKE '{dycd_facilities_otherprograms%' AND sourcecombo LIKE '%{hhs_facilities_%' AND facsubgrp = 'Youth Centers, Literacy Programs, Job Training, and Immigrant Services'
		OR sourcecombo LIKE '{doe_facilities_schoolsbluebook%' AND sourcecombo LIKE '%{hhs_facilities_%' AND facsubgrp = 'Community Centers and Community School Programs'
		OR sourcecombo LIKE '{doe_facilities_schoolsbluebook%' AND sourcecombo LIKE '%{nysed_facilities_activeinstitutions%'
		OR sourcecombo LIKE '{hhs_facilities_proposals%' AND sourcecombo LIKE '%{hhs_facilities_financialscontracts%'
		OR sourcecombo LIKE '{dfta_facilities_contracts%' AND sourcecombo LIKE '%{hhs_facilities_%'
		OR sourcecombo LIKE '{dca_facilities_operatingbusinesses%' AND sourcecombo LIKE '%{nysdec_facilities_solidwaste%'
		OR sourcecombo LIKE '{dcla_facilities_culturalinstitutions%' AND sourcecombo LIKE '%{nysed_facilities_activeinstitutions%' AND facsubgrp = 'Museums'
		OR sourcecombo LIKE '{nysdoh_facilities_healthfacilities%' AND sourcecombo LIKE '%{hhs_facilities_proposals%'
		OR sourcecombo LIKE '{nysparks_facilities_historicplaces%' AND sourcecombo LIKE '%{usnps_facilities_parks%'
		OR sourcecombo LIKE '{dpr_parksproperties%' AND sourcecombo LIKE '%{bbpc_facilities_sfpsd%'
		OR sourcecombo LIKE '{dpr_parksproperties%' AND sourcecombo LIKE '%{nysparks_facilities_historicplaces%'
		OR sourcecombo LIKE '{dpr_parksproperties%' AND sourcecombo LIKE '%{nysdec_facilities_lands%'
		OR sourcecombo LIKE '{sbs_facilities_workforce1%' AND sourcecombo LIKE '%{hhs_facilities_proposals%'
		OR sourcecombo LIKE '{bic_facilities_tradewaste%' AND sourcecombo LIKE '%{nysdec_facilities_solidwaste%'
		OR sourcecombo LIKE '{nysomh_facilities_mentalhealth%' AND sourcecombo LIKE '%{hhs_facilities_%'
	GROUP BY
	uid, sourcecombo, facsubgrp
	ORDER BY countofdups DESC )

UPDATE facilities AS f
SET
	idagency = 
		(CASE
			WHEN d.idagency_merged <> ARRAY['FAKE!'] THEN array_cat(idagency, d.idagency_merged)
			ELSE idagency
		END),
	idold = 
		(CASE
			WHEN d.idold_merged <> ARRAY['FAKE!'] THEN array_cat(idold, d.idold_merged)
			ELSE idold
		END),
	uid_merged = d.uid_merged,
	hash_merged = d.hash_merged,
	pgtable = array_cat(f.pgtable,d.pgtable),
	datasource = array_cat(f.datasource,d.datasource),
	dataname = array_cat(f.dataname, d.dataname),
	datadate = array_cat(f.datadate, d.datadate),
	dataurl = (CASE WHEN d.dataurl <> ARRAY['FAKE!'] THEN string_to_array(CONCAT(array_to_string(f.dataurl,';'), ';', array_to_string(d.dataurl,';')),';') END),
	capacity = (CASE WHEN d.capacity <> ARRAY['FAKE!'] THEN array_cat(f.capacity, d.capacity) END),
	captype = (CASE WHEN d.captype <> ARRAY['FAKE!'] THEN array_cat(f.captype, d.captype) END),
	util = (CASE WHEN d.util <> ARRAY['FAKE!'] THEN array_cat(f.util, d.util) END),
	area = (CASE WHEN d.area <> ARRAY['FAKE!'] THEN array_cat(f.area, d.area) END),
	areatype = (CASE WHEN d.areatype <> ARRAY['FAKE!'] THEN array_cat(f.areatype, d.areatype) END),	
	overagency = 
		(CASE
			WHEN sourcecombo NOT LIKE '{dcla_facilities_culturalinstitutions%' THEN array_cat(ARRAY[array_to_string(f.overagency,';')], ARRAY[array_to_string(d.overagency,';')])
			ELSE f.overagency
		END),
	overabbrev =
		(CASE
			WHEN sourcecombo NOT LIKE '{dcla_facilities_culturalinstitutions}' THEN array_cat(ARRAY[array_to_string(f.overabbrev,';')], ARRAY[array_to_string(d.overabbrev,';')])
			ELSE f.overabbrev
		END),
	overlevel =
		(CASE
			WHEN sourcecombo NOT LIKE '{dcla_facilities_culturalinstitutions}' THEN array_cat(ARRAY[array_to_string(f.overlevel,';')], ARRAY[array_to_string(d.overlevel,';')])
			ELSE f.overlevel
		END)
FROM duplicates AS d
WHERE f.uid = d.uid
;

DELETE FROM facilities
WHERE facilities.uid IN (SELECT unnest(facilities.uid_merged) FROM facilities);