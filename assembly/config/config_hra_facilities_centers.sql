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
	ARRAY['hra_facilities_centers'],
	-- hash,
    hash,
	-- geom
	NULL,	
	-- idagency
	NULL,
	-- facilityname
	name,
	-- addressnumber
	split_part(trim(both ' ' from Address), ' ', 1),
	-- streetname
	initcap(split_part(trim(both ' ' from Address), ' ', 2)),
	-- address
	initcap(Address),
	-- borough
	initcap(Borough),
	-- zipcode
	zipcode::integer,
	-- bbl
	NULL,
	-- bin
	NULL,
	-- facilitytype
	REPLACE(Type,'HASA','HIV/AIDS Services'),
	-- domain
	'Health and Human Services',
	-- facilitygroup
	'Human Services',
	-- facilitysubgroup
	(CASE
		WHEN type = 'Job Centers' THEN 'Workforce Development'
		ELSE 'Financial Assistance and Social Services'
	END),
	-- agencyclass1
	NULL,
	-- agencyclass2
	NULL,
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
	'Public',
	-- operatorname
	'NYC Human Resources Administration/Department of Social Services',
	-- operatorabbrev
	'NYCHRA/DSS',
	-- oversightagency
	ARRAY['NYC Human Resources Administration/Department of Social Services'],
	-- oversightabbrev
	ARRAY['NYCHRA/DSS'],
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
	hra_facilities_centers