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
	ARRAY['hra_facilities_dhsshelters'],
	-- hash,
    hash,
	-- geom
	geom,	
	-- idagency
	ARRAY[Reference_Key],
	-- facilityname
	initcap(Shelter_Operator_Facility_Name),
	-- addressnumber
	split_part(trim(both ' ' from Shelter_Operating_Address), ' ', 1),
	-- streetname
	initcap(split_part(trim(both ' ' from Shelter_Operating_Address), ' ', 2)),
	-- address
	initcap(Shelter_Operating_Address),
	-- borough
	initcap(Borough),
	-- zipcode
	zip::integer,
	-- bbl
	NULL,
	-- bin
	ARRAY[Corrected_BIN],
	-- facilitytype
	Shelter_Facility_Type_Cares,
	-- domain
	'Health and Human Services',
	-- facilitygroup
	'Human Services',
	-- facilitysubgroup
	'Shelters and Transitional Housing',
	-- agencyclass1
	Shelter_Facility_Type_CARES,
	-- agencyclass2
	NYC_Owned_Property,

	-- capacity
	Active,
	-- utilization
	Occupied_UnitBeds,
	-- capacitytype
	(CASE
		WHEN Shelter_Facility_Type_CARES LIKE '%Family%' THEN 'Family Residential Units'
		ELSE 'Beds'
	END),
	-- utilizationrate
	Occupied_UnitBeds/Active,
	-- area
	NULL,
	-- areatype
	NULL,
	-- operatortype
		(CASE
			WHEN NYC_Owned_Property LIKE '%NYC Owned%' THEN 'Public'
			ELSE 'Non-public'
		END),
	-- operatorname
		(CASE
			WHEN NYC_Owned_Property LIKE '%NYC Owned%' THEN '%NYC Department of Homeless Services%'
			ELSE initcap(Service_Provider)
		END),
	-- operatorabbrev
		(CASE
			WHEN NYC_Owned_Property LIKE '%NYC Owned%' THEN 'NYCDHS'
			ELSE 'Non-public'
		END),
	-- oversightagency
	ARRAY['NYC Department of Homeless Services'],
	-- oversightabbrev
	ARRAY['NYCDHS'],
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
	(CASE
		WHEN Shelter_Facility_Type_CARES LIKE '%Family%' THEN TRUE
		ELSE FALSE
	END),
	-- disabilities
	FALSE,
	-- dropouts
	FALSE,
	-- unemployed
	FALSE,
	-- homeless
	TRUE,
	-- immigrants
	FALSE,
	-- groupquarters
	TRUE
FROM 
	(SELECT 
		h.*,
		ST_Centroid(ST_Transform(b.geom,4326)) AS geom,
		b.bbl as bbl
	FROM hra_facilities_dhsshelters AS h
	LEFT JOIN doitt_buildingfootprints AS b
	ON h.Corrected_BIN::text = b.bin::text) AS hra_facilities_dhsshelters