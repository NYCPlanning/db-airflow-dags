INSERT INTO
facilities (
	pgtable,
	hash,
	geom,
	idagency,
	facname,
	addressnum,
	streetname,
	address,
	boro,
	zipcode,
	bbl,
	bin,
	factype,
	facdomain,
	facgroup,
	facsubgrp,
	agencyclass1,
	agencyclass2,
	capacity,
	util,
	captype,
	utilrate,
	area,
	areatype,
	optype,
	opname,
	opabbrev,
	overagency,
	overabbrev,
	datecreated,
	buildingid,
	buildingname,
	schoolorganizationlevel,
	children,
	youth,
	senior,
	family,
	disabilities,
	dropouts,
	unemployed,
	homeless,
	immigrants,
	groupquarters
)
SELECT
	-- pgtable
	ARRAY['omb_facilities_libraryvisits'],
	-- hash,
    hash,
	-- geom
	ST_SetSRID(ST_MakePoint(lon, lat),4326),
	-- idagency
	NULL,
	-- facilityname
	split_part(name,' - ',1),
	-- addressnumber
	housenum,
	-- streetname
	initcap(streetname),
	-- address
	CONCAT(housenum,' ',initcap(streetname)),
	-- borough
	boroname,
	-- zipcode
	ROUND(zip::numeric,0),
	-- bbl
	ARRAY[ROUND(bbl::numeric,0)],
	-- bin
	ARRAY[ROUND(bin::numeric,0)],
	-- facilitytype
	'Public Libraries',
	-- domain
	'Libraries and Cultural Programs',
	-- facilitygroup
	'Libraries',
	-- facilitysubgroup
	'Public Libraries',
	-- agencyclass1
	'NA',
	-- agencyclass2
	'NA',

	-- capacity
	NULL,
	-- utilization
	ARRAY[visits::text],
	-- capacitytype
	ARRAY['Visits'],
	-- utilizationrate
	NULL,
	-- area
	NULL,
	-- areatype
	NULL,
	-- operatortype
	'Non-public',
	-- operatorname
		(CASE
			WHEN system = 'QPL' THEN 'Queens Public Library'
			WHEN system = 'BPL' THEN 'Brooklyn Public Library'
			WHEN system = 'NYPL' THEN 'New York Public Library'
		END),
	-- operatorabbrev
	system,
	-- oversightagency
		(CASE
			WHEN system = 'QPL' THEN ARRAY['Queens Public Library']
			WHEN system = 'BPL' THEN ARRAY['Brooklyn Public Library']
			WHEN system = 'NYPL' THEN ARRAY['New York Public Library']
		END),
	-- oversightabbrev
	ARRAY[system],
	-- datecreated
	CURRENT_TIMESTAMP,
	-- buildingid
	NULL,
	-- buildingname
	NULL,
	-- schoolorganizationlevel
	NULL,
	-- children
	FALSE,
	-- youth
	FALSE,
	-- senior
	FALSE,
	-- family
	FALSE,
	-- disabilities
	FALSE,
	-- dropouts
	FALSE,
	-- unemployed
	FALSE,
	-- homeless
	FALSE,
	-- immigrants
	FALSE,
	-- groupquarters
	FALSE
FROM
	omb_facilities_libraryvisits