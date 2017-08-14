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
	ARRAY['doitt_facilities_libraries'],
	-- hash,
    hash,
	-- geom
	geom,
	-- idagency
	NULL,
	-- facilityname
	name,
	-- addressnumber
	housenum,
	-- streetname
	streetname,
	-- address
	CONCAT(housenum,' ',streetname),
	-- borough
		(CASE
			WHEN system = 'BPL' THEN 'Brooklyn'
			WHEN system = 'QPL' THEN 'Queens'
			WHEN city = 'New York' THEN 'New York'
			WHEN city = 'Bronx' THEN 'Bronx'
			WHEN city = 'Staten Island' THEN 'Staten Island'
		END),
	-- zipcode
	zip,
	-- bbl
	ARRAY[bbl],
	-- bin
	ARRAY[ROUND(bin,0)],
	-- facilitytype
	'Public Library',
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
	NULL,
	-- capacitytype
	NULL,
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
			WHEN system = 'QPL' THEN 'Queens Public Libraries'
			WHEN system = 'BPL' THEN 'Brooklyn Public Libraries'
			WHEN system = 'NYPL' THEN 'New York Public Libraries'
		END),
	-- operatorabbrev
	ARRAY[system],
	-- oversightagency
		ARRAY[(CASE
			WHEN system = 'QPL' THEN 'Queens Public Libraries'
			WHEN system = 'BPL' THEN 'Brooklyn Public Libraries'
			WHEN system = 'NYPL' THEN 'New York Public Libraries'
		END)],
	-- oversightabbrev
	system,
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
	(SELECT *
	FROM doitt_facilities_libraries AS lib
	LEFT JOIN omb_facilities_libraryvisits AS v
	ON split_part(v.name, ' - ', 1) = split_part(lib.name, ' <br>', 1)
	) AS doitt_facilities_libraries