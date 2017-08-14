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
	ARRAY['doe_facilities_busroutesgarages'],
	-- hash,
    hash,
	-- geom
	ST_Transform(ST_SetSRID(ST_MakePoint(XCoordinates, YCoordinates),2263),4326),
	-- idagency
	NULL,
	-- facilityname
	initcap(Vendor_Name),
	-- addressnumber
	split_part(trim(both ' ' from Garage_Street_Address), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from Garage_Street_Address), strpos(trim(both ' ' from Garage_Street_Address), ' ')+1, (length(trim(both ' ' from Garage_Street_Address))-strpos(trim(both ' ' from Garage_Street_Address), ' ')))),
	-- address
	Garage_Street_Address,
	-- borough
	NULL,
	-- zipcode
	Garage_Zip::integer,
	-- bbl
	NULL,
	-- bin
	NULL,
	-- facilitytype
	'School Bus Depot',
	-- domain
	'Core Infrastructure and Transportation',
	-- facilitygroup
	'Transportation',
	-- facilitysubgroup
	'Bus Depots and Terminals',
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
	initcap(Vendor_Name),
	-- operatorabbrev
	'Non-public',
	-- oversightagency
	ARRAY['NYC Department of Education'],
	-- oversightabbrev
	ARRAY['NYCDOE'],
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
	doe_facilities_busroutesgarages
WHERE
	School_Year = '2015-2016'
GROUP BY
	hash,
	Vendor_Name,
	Garage_Street_Address,
	Garage_City,
	Garage_Zip,
	XCoordinates,
	YCoordinates