WITH COLP_bbls AS (
SELECT
	bbl,
    array_agg(distinct proptype) AS proptype,
    array_agg(distinct overabbrev) AS overabbrev,
    array_agg(distinct pgtable) AS pgtable,
    array_agg(distinct datasource) AS datasource,
    array_agg(distinct dataname) AS dataname,
    array_agg(distinct dataurl) AS dataurl,
    array_agg(distinct datadate) AS datadate
FROM
	facilities
WHERE
	pgtable = ARRAY['dcas_facilities_colp']
GROUP BY bbl)

UPDATE facilities AS f
SET 
    proptype = 
		(CASE
			WHEN c.proptype @> ARRAY['City Owned'] THEN 'City Owned'
			WHEN c.proptype @> ARRAY['City Leased'] AND c.overabbrev @> f.overabbrev THEN 'City Leased'
		END),
	pgtable = array_append(f.pgtable, array_to_string(c.pgtable,';')),
	datasource = array_append(f.datasource, array_to_string(c.datasource,';')),
	dataname = array_append(f.dataname, array_to_string(c.dataname,';')),
	dataurl = array_append(f.dataurl, array_to_string(c.dataurl,';')),
	datadate = array_append(f.datadate, array_to_string(c.datadate,';'))
FROM COLP_bbls AS c
WHERE
	f.bbl = c.bbl
	AND f.bbl IS NOT NULL
	AND array_to_string(f.pgtable,';') NOT LIKE CONCAT('%',array_to_string(c.pgtable,';'),'%');