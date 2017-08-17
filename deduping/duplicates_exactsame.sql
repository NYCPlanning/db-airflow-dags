WITH primaryuids AS (
	SELECT
		(array_agg(distinct uid))[1] AS uid,
		count(*) AS countagg
	FROM facilities
	WHERE geom IS NOT NULL
	GROUP BY
		facsubgrp, factype, opname, facname, overabbrev, geom, pgtable
),

primaries AS (
	SELECT *
	FROM facilities
	WHERE uid IN (SELECT uid FROM primaryuids WHERE countagg > 1)
),

matches AS (
	SELECT
		a.idagency,
		(CASE WHEN b.idagency IS NULL THEN ARRAY['FAKE!'] ELSE b.idagency END) as idagency_b,
		a.uid,
		b.hash AS hash_b,
		b.uid AS uid_b,
		CONCAT(a.facsubgrp, trim(both ' ' from a.factype), trim(both ' ' from a.opname), trim(both ' ' from a.facname), a.overabbrev, a.geom, a.pgtable) AS concatted,
		CONCAT(b.facsubgrp, trim(both ' ' from b.factype), trim(both ' ' from b.opname), trim(both ' ' from b.facname), b.overabbrev, b.geom, b.pgtable) AS concatted_b
	FROM primaries AS a
	LEFT JOIN facilities AS b
	ON CONCAT(a.facsubgrp, trim(both ' ' from a.factype), trim(both ' ' from a.opname), trim(both ' ' from a.facname), a.overabbrev, a.geom, a.pgtable) = CONCAT(b.facsubgrp, trim(both ' ' from b.factype), trim(both ' ' from b.opname), trim(both ' ' from b.facname), b.overabbrev, b.geom, b.pgtable)
	WHERE a.uid <> b.uid
),

duplicates AS (
	SELECT
		uid,
		(CASE
			WHEN idagency IS NULL THEN idagency
			ELSE string_to_array(CONCAT(array_to_string(idagency,';'),';',array_to_string(array_agg(distinct idagency_b),';')),';')
		END) AS idagency,
		array_agg(hash_b) AS hash_merged,
		array_agg(uid_b) AS uid_merged
	FROM matches
	GROUP BY
		uid, idagency)

UPDATE facilities AS f
SET
	idagency = string_to_array(CONCAT(array_to_string(f.idagency,';'), ';', array_to_string(d.idagency,';')),';'),
	uid_merged = string_to_array(CONCAT(array_to_string(f.uid_merged,';'), ';', array_to_string(d.uid_merged,';')),';'),
	hash_merged = string_to_array(CONCAT(array_to_string(f.hash_merged,';'), ';', array_to_string(d.hash_merged,';')),';')
FROM duplicates AS d
WHERE f.uid = d.uid
;

DELETE FROM facilities
WHERE facilities.uid IN (SELECT unnest(facilities.uid_merged) FROM facilities);