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
	ARRAY['dot_facilities_parkingfacilities'],
	-- hash,
    hash,
	-- geom
	geom,
	-- idagency
	NULL,
	-- facilityname
	(CASE
		WHEN facname IS NOT NULL THEN facname
		ELSE 'Parking Lot'
	END),
	-- addressnumber
	NULL,
	-- streetname
	NULL,
	-- address
	NULL,
	-- borough
	NULL,
	-- zipcode
	NULL,
	-- bbl
	NULL,
	-- bin
	NULL,
	-- facilitytype
	(CASE
		WHEN operations = 'Public Parking Garage' THEN 'Public Parking Garage'
		ELSE 'City Agency Parking'
	END),
	-- domain
	(CASE
		WHEN operations = 'Public Parking Garage' THEN 'Core Infrastructure and Transportation'
		ELSE 'Administration of Government'
	END),
	-- facilitygroup
	(CASE
		WHEN operations = 'Public Parking Garage' THEN 'Transportation'
		ELSE 'City Agency Parking, Maintenance, and Storage'
	END),
	-- facilitysubgroup
	(CASE
		WHEN operations = 'Public Parking Garage' THEN 'Parking Lots and Garages'
		ELSE 'City Agency Parking'
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
	'NYC Department of Transportation',
	-- operatorabbrev
	'NYCDOT',
	-- oversightagency
	ARRAY['NYC Department of Transportation'],
	-- oversightabbrev
	ARRAY['NYCDOT'],
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
	dot_facilities_parkingfacilities