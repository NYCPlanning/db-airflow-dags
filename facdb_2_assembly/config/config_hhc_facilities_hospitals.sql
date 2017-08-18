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
	ARRAY['hhc_facilities_hospitals'],
	-- hash,
    hash,
	-- geom
	ST_SetSRID(
		ST_MakePoint(
			trim(trim(split_part(split_part(Location_1,'(',2),',',2),')'),' ')::double precision,
			trim(split_part(split_part(Location_1,'(',2),',',1),' ')::double precision),
		4326),
	-- idagency
	NULL,
	-- facilityname
	facility_name,
	-- addressnumber
	split_part(Location_1, ' ', 1),
	-- streetname
	split_part(split_part(Location_1, ' ', 2),'(',1),
	-- address
	split_part(Location_1, '(', 1),
	-- borough
	Borough,
	-- zipcode
	NULL,
	-- bbl
	NULL,
	-- bin
	NULL,
	-- facilitytype
		(CASE 
			WHEN facility_type LIKE '%Diagnostic%' THEN 'Diagnostic and Treatment Center'
			ELSE facility_type
		END),
	-- domain
	'Health and Human Services',
	-- facilitygroup
	'Health Care',
	-- facilitysubgroup
		(CASE
			WHEN facility_type = 'Nursing Home' THEN 'Residential Health Care'
			ELSE 'Hospitals and Clinics'
		END),
	-- agencyclass1
	facility_type,
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
	'NYC Health and Hospitals Corporation',
	-- operatorabbrev
	'NYCHHC',
	-- oversightagency
	ARRAY['NYS Department of Health'],
	-- oversightabbrev
	ARRAY['NYSDOH'],
	-- datecreated
	CURRENT_TIMESTAMP,
	-- buildingid
	NULL,
	-- buildingname
	NULL,
	-- schoolorganizationlevel
	NULL,
	-- children
		(CASE
			WHEN facility_type LIKE '%Child%' THEN TRUE
			ELSE FALSE
		END),
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
			WHEN facility_type LIKE '%Nursing Home%' THEN TRUE
			ELSE FALSE
		END)
FROM
	hhc_facilities_hospitals