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
	ARRAY['nysdoh_facilities_healthfacilities'],
	-- hash,
    hash,
	-- geom
	-- ST_SetSRID(ST_MakePoint(long, lat),4326)
	ST_SetSRID(ST_MakePoint(Facility_Longitude, Facility_Latitude),4326),
	-- idagency
	ARRAY[Facility_ID],
	-- facilityname
	Facility_Name,
	-- addressnumber
	split_part(trim(both ' ' from Facility_Address_1), ' ', 1),
	-- streetname
	initcap(trim(both ' ' from substr(trim(both ' ' from Facility_Address_1), strpos(trim(both ' ' from Facility_Address_1), ' ')+1, (length(trim(both ' ' from Facility_Address_1))-strpos(trim(both ' ' from Facility_Address_1), ' '))))),
	-- address
	Facility_Address_1,
	-- borough
		(CASE
			WHEN Facility_County = 'New York' THEN 'Manhattan'
			WHEN Facility_County = 'Bronx' THEN 'Bronx'
			WHEN Facility_County = 'Kings' THEN 'Brooklyn'
			WHEN Facility_County = 'Queens' THEN 'Queens'
			WHEN Facility_County = 'Richmond' THEN 'Staten Island'
		END),
	-- zipcode
	LEFT(Facility_Zip_Code,5)::integer,
	-- bbl
	NULL,
	-- bin
	NULL,
	-- facilitytype
		(CASE
			WHEN Description LIKE '%Residential%'
				THEN 'Residential Health Care'
			ELSE Description
		END),
	-- domain
	'Health and Human Services',
	-- facilitygroup
	'Health Care',
	-- facilitysubgroup
		(CASE
			WHEN Description LIKE '%Residential%'
				OR Description LIKE '%Hospice%'
				THEN 'Residential Health Care'
			WHEN Description LIKE '%Adult Day Health%'
				THEN 'Other Health Care'
			WHEN Description LIKE '%Home%'
				THEN 'Other Health Care'
			ELSE 'Hospitals and Clinics'
		END),
	-- agencyclass1
	Description,
	-- agencyclass2
	ownership_type,
	-- capacity
	ARRAY[capacity::text],
	-- utilization
	ARRAY[utilization::text],
	-- capacitytype
		(CASE
			WHEN capacity IS NOT NULL THEN ARRAY['Beds']
			ELSE NULL
		END),
	-- utilizationrate
		(CASE
			WHEN capacity IS NOT NULL THEN ARRAY[ROUND((utilization::numeric/capacity::numeric),3)::text]
			ELSE NULL
		END),
	-- area
	NULL,
	-- areatype
	NULL,
	-- operatortype
		(CASE
			WHEN operator_name = 'City of New York' THEN 'Public'
			WHEN operator_name = 'NYC Health and Hospital Corporation' THEN 'Public'
			WHEN ownership_type = 'State' THEN 'Public'
			ELSE 'Non-public'
		END),	
	-- operatorname
		(CASE
			WHEN operator_name = 'City of New York' THEN 'NYC Department of Health and Mental Hygiene'
			WHEN operator_name = 'NYC Health and Hospital Corporation' THEN 'NYC Health and Hospitals Corporation'
			WHEN ownership_type = 'State' THEN 'NYS Department of Health'
			ELSE operator_name
		END),
	-- operatorabbrev
		(CASE
			WHEN operator_name = 'City of New York' THEN 'NYCDOHMH'
			WHEN operator_name = 'NYC Health and Hospitals Corporation' THEN 'NYCHHC'
			WHEN ownership_type = 'State' THEN 'NYSDOH'
			ELSE 'Non-public'
		END),
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
			WHEN description LIKE '%Hospice%' THEN TRUE
			WHEN description LIKE '%Residential%' THEN TRUE
			ELSE FALSE
		END)
FROM
	(SELECT DISTINCT ON (facility_id)
		f.*,
		c.total_capacity AS capacity,
		(c.total_capacity-c.total_available) AS utilization,
		c.bed_census_date
		FROM nysdoh_facilities_healthfacilities AS f
		LEFT JOIN nysdoh_nursinghomebedcensus AS c
		ON f.facility_id::numeric=c.facility_id::numeric
		ORDER BY f.facility_id, c.bed_census_date DESC) AS nysdoh_facilities_healthfacilities
WHERE
	Facility_County = 'New York'
	OR Facility_County = 'Bronx'
	OR Facility_County = 'Kings'
	OR Facility_County = 'Queens'
	OR Facility_County = 'Richmond'
