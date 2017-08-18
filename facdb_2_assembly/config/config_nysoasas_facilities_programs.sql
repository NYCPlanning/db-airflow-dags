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
	ARRAY['nysoasas_facilities_programs'],
	-- hash,
    hash,
	-- geom
	NULL,
	-- idagency
	ARRAY[program_number],
	-- facilityname
	program_name,
	-- address number
	split_part(trim(both ' ' from street), ' ', 1),
	-- street name
	initcap(trim(both ' ' from substr(trim(both ' ' from street), strpos(trim(both ' ' from street), ' ')+1, (length(trim(both ' ' from street))-strpos(trim(both ' ' from street), ' '))))),
	-- address
	street,
	-- borough
		(CASE
			WHEN program_county = 'New York' THEN 'Manhattan'
			WHEN program_county = 'Bronx' THEN 'Bronx'
			WHEN program_county = 'Kings' THEN 'Brooklyn'
			WHEN program_county = 'Queens' THEN 'Queens'
			WHEN program_county = 'Richmond' THEN 'Staten Island'
		END),
	-- zipcode
	LEFT(zip_code,5)::integer,
	-- bbl
	NULL,
	-- bin
	NULL,
	-- facilitytype
	program_category,
	-- domain
	'Health and Human Services',
	-- facilitygroup
	'Health Care',
	-- facilitysubgroup
	'Chemical Dependency',
	-- agencyclass1
	program_category,
	-- agencyclass2
	service,
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
	provider_name,
	-- operatorabbrev
	'Non-public',
	-- oversightagency
	ARRAY['NYS Office of Alcoholism and Substance Abuse Services'],
	-- oversightabbrev
	ARRAY['NYSOASAS'],
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
		(CASE
			WHEN program_category LIKE '%Residential%' THEN TRUE
			ELSE FALSE
		END)
FROM
	nysoasas_facilities_programs
WHERE
	program_county = 'New York'
	OR program_county = 'Bronx'
	OR program_county = 'Kings'
	OR program_county = 'Queens'
	OR program_county = 'Richmond'
