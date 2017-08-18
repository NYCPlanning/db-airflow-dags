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
	ARRAY['dsny_facilities_mtsgaragemaintenance'],
	-- hash,
    hash,
	-- geom
	geom,
	-- idagency
	NULL,
	-- facilityname
		(CASE
			WHEN facility_t = 'GARAGE' THEN CONCAT(facility_n,' ',facility_t)
			WHEN facility_t <> 'GARAGE' THEN CONCAT(facility_n)
		END),
	-- addressnumber
	NULL,
	-- streetname
	NULL,
	-- address
	NULL,
	-- borough
	initcap(geo_boro),
	-- zipcode
	NULL,
	-- bbl
	NULL,
	-- bin
	NULL,
	-- facilitytype
		(CASE
			WHEN facility_t = 'MTS' THEN 'DSNY Marine Transfer Station'
			WHEN facility_t = 'GARAGE' THEN 'DSNY Garage'
			WHEN facility_t = 'REPAIR' THEN 'DSNY Repair Facility'
		END),
	-- domain
	'Core Infrastructure and Transportation',
	-- facilitygroup
	'Solid Waste',
	-- facilitysubgroup
	'Solid Waste Transfer and Carting',
	-- agencyclass1
	facility_t,
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
	'Public',
	-- operatorname
	'NYC Department of Sanitation',
	-- operatorabbrev
	'NYCDSNY',
	-- oversightagency
	ARRAY['NYC Department of Sanitation'],
	-- oversightabbrev
	ARRAY['NYCDSNY'],
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
	dsny_facilities_mtsgaragemaintenance