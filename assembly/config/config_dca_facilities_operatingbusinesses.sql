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
	ARRAY['dca_facilities_operatingbusinesses'],
	-- hash,
    hash,
	-- geom
	(CASE 
		WHEN longitude IS NOT NULL THEN ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)
		ELSE NULL
	END),
	-- idagency
	ARRAY[DCA_License_Number],
	-- facilityname
	initcap(Business_Name),
	-- addressnumber
	Address_Building,
	-- streetname
	initcap(Address_Street_Name),
	-- address
	CONCAT(Address_Building,' ',initcap(Address_Street_Name)),
	-- borough
		(CASE
			WHEN (Address_Borough IS NULL) AND (Address_City = 'NEW YORK') THEN 'Manhattan'
			WHEN (Address_Borough IS NULL) AND (Address_City = 'BRONX') THEN 'Bronx'
			WHEN (Address_Borough IS NULL) AND (Address_City = 'BROOKLYN') THEN 'Brooklyn'
			WHEN (Address_Borough IS NULL) AND (Address_City = 'QUEENS') THEN 'Queens'
			WHEN (Address_Borough IS NULL) AND (Address_City = 'ASTORIA') THEN 'Queens'
			WHEN (Address_Borough IS NULL) AND (Address_City = 'LONG ISLAND CITY') THEN 'Queens'
			WHEN (Address_Borough IS NULL) AND (Address_City = 'QUEENS VLG') THEN 'Queens'
			WHEN (Address_Borough IS NULL) AND (Address_City = 'JAMAICA') THEN 'Queens'
			WHEN (Address_Borough IS NULL) AND (Address_City = 'WOODSIDE') THEN 'Queens'
			WHEN (Address_Borough IS NULL) AND (Address_City = 'FLUSHING') THEN 'Queens'
			WHEN (Address_Borough IS NULL) AND (Address_City = 'CORONA') THEN 'Queens'
			WHEN (Address_Borough IS NULL) AND (Address_City = 'STATEN ISLAND') THEN 'Staten Island'
			ELSE Address_Borough
		END),
	-- zipcode
		(CASE
			WHEN Address_Zip ~'^([0-9]+\.?[0-9]*|\.[0-9]+)$' THEN Address_Zip::integer
		END),
	-- bbl
	NULL,
	-- bin
	NULL,
	-- facilitytype
		(CASE 
			WHEN License_Category LIKE '%Scrap Metal%' THEN 'Scrap Metal Processing'
			WHEN License_Category LIKE '%Tow%' THEN 'Tow Truck Company'
			ELSE CONCAT('Commercial ', License_Category)
		END),
	-- domain
	'Core Infrastructure and Transportation',
	-- facilitygroup
		(CASE
			WHEN License_Category = 'Scrap Metal Processor' THEN 'Solid Waste'
			WHEN License_Category = 'Parking Lot' THEN 'Transportation'
			WHEN License_Category = 'Garage' THEN 'Transportation'
	 		WHEN License_Category = 'Garage and Parking Lot' THEN 'Transportation'
			WHEN License_Category = 'Tow Truck Company' THEN 'Transportation'
		END),
	-- facilitysubgroup
		(CASE
			WHEN License_Category = 'Scrap Metal Processor' THEN 'Solid Waste Processing'
			WHEN License_Category = 'Parking Lot' THEN 'Parking Lots and Garages'
			WHEN License_Category = 'Garage' THEN 'Parking Lots and Garages'
	 		WHEN License_Category = 'Garage and Parking Lot' THEN 'Parking Lots and Garages'
			WHEN License_Category = 'Tow Truck Company' THEN 'Parking Lots and Garages'
		END),
	-- agencyclass1
	License_Category,
	-- agencyclass2
	License_Type,

	-- capacity
		(CASE
			WHEN Detail LIKE '%Vehicle Spaces%' THEN ARRAY[split_part(split_part(Detail,': ',2),',',1)::text]
			ELSE NULL
		END),
	-- utilization
	NULL,
	-- capacitytype
		(CASE
			WHEN Detail LIKE '%Vehicle Spaces%' THEN ARRAY['Parking Spaces']
			ELSE NULL
		END),
	-- utilizationrate
	NULL,
	-- area
	NULL,
	-- areatype
	NULL,
	-- operatortype
	'Non-public',
	-- operatorname
	initcap(Business_Name),
	-- operatorabbrev
	'Non-public',
	-- oversightagency
	ARRAY['NYC Department of Consumer Affairs'],
	-- oversightabbrev
	ARRAY['NYCDCA'],
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
	dca_facilities_operatingbusinesses
WHERE
	License_Category = 'Scrap Metal Processor'
	OR License_Category = 'Parking Lot'
	OR License_Category = 'Garage'
	OR License_Category = 'Garage and Parking Lot'
	OR License_Category = 'Tow Truck Company'