-- Not finished

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
	ARRAY['nycha_facilities_communitycenters'],
	-- hash,
    hash,
	-- geom
	NULL,
	-- idagency
	NULL,
	-- facilityname
	initcap(development_name),
	-- addressnumber
	split_part(trim(both ' ' from address), ' ', 1),
	-- streetname
	initcap(trim(both ' ' from substr(trim(both ' ' from address), strpos(trim(both ' ' from address), ' ')+1, (length(trim(both ' ' from address))-strpos(trim(both ' ' from address), ' '))))),
	-- address
	initcap(address),
	-- borough
	initcap(borough),
	-- zipcode
	ROUND(zip_code::numeric,0),
	-- bbl
	NULL,
	-- bin
	NULL,
	-- facilitytype
	'NYCHA Community Center',
	-- domain
	'Public Safety, Emergency Services, and Administration of Justice',
	-- facilitygroup
	'Public Safety',
	-- facilitysubgroup
	'Police Services',
	-- agencyclass1
	Type,
	-- agencyclass2
	Status,
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
	'New York City Housing Authority',
	-- operatorabbrev
	'NYCHA',
	-- oversightagency
	ARRAY['New York City Housing Authority'],
	-- oversightabbrev
	ARRAY['NYCHA'],
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
	nycha_facilities_communitycenters