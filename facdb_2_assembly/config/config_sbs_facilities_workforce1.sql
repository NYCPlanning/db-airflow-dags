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
	ARRAY['sbs_facilities_workforce1'],
	-- hash,
    hash,
	-- geom
	ST_SetSRID(ST_MakePoint(Longitude::numeric, Latitude::numeric),4326),
	-- idagency
	NULL,
	-- facilityname
	Name,
	-- addressnumber
	HouseNumber,
	-- streetname
	Street,
	-- address
 	CONCAT(HouseNumber, ' ', Street),
	-- borough
	Borough,
	-- zipcode
	Postcode::integer,
	-- bbl
	ARRAY[bbl],
	-- bin
	ARRAY[bin],
	-- facilitytype
	Location_Type,
	-- domain
	'Health and Human Services',
	-- facilitygroup
	'Human Services',
	-- facilitysubgroup
	'Workforce Development',
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
	'NYC Department of Small Business Services',
	-- operatorabbrev
	'NYCSBS',
	-- oversightagency
	ARRAY['NYC Department of Small Business Services'],
	-- oversightabbrev
	ARRAY['NYCSBS'],
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
	TRUE,
	-- homeless
	FALSE,
	-- immigrants
	FALSE,
	-- groupquarters
	FALSE
FROM 
	sbs_facilities_workforce1