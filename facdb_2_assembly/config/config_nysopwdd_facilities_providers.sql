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
	ARRAY['nysopwdd_facilities_providers'],
	-- hash,
    hash,
	-- geom
	(CASE
		WHEN (Location_1 IS NOT NULL) AND (Location_1 LIKE '%(%') THEN 
			ST_SetSRID(
				ST_MakePoint(
					trim(trim(split_part(split_part(Location_1,'(',2),',',2),')'),' ')::double precision,
					trim(split_part(split_part(Location_1,'(',2),',',1),' ')::double precision),
				4326)
	END),
	-- idagency
	NULL,
	-- facilityname
	initcap(Service_Provider_Agency),
	-- addressnumber
	split_part(trim(both ' ' from initcap(Street_Address_)), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from initcap(Street_Address_)), strpos(trim(both ' ' from initcap(Street_Address_)), ' ')+1, (length(trim(both ' ' from initcap(Street_Address_)))-strpos(trim(both ' ' from initcap(Street_Address_)), ' ')))),
	-- address
	initcap(Street_Address_),
	-- borough
		(CASE
			WHEN County = 'NEW YORK' THEN 'Manhattan'
			WHEN County = 'BRONX' THEN 'Bronx'
			WHEN County = 'KINGS' THEN 'Brooklyn'
			WHEN County = 'QUEENS' THEN 'Queens'
			WHEN County = 'RICHMOND' THEN 'Staten Island'
		END),
	-- zipcode
	LEFT(Zip_Code,5)::integer,
	-- bbl
	NULL,
	-- bin
	NULL,
	-- facilitytype
	'Programs for People with Disabilities',
		-- (CASE
		-- 	WHEN 	
		-- 	Intermediate_Care_Facilities_ICFs
		-- 	Individual_Residential_Alternative_IRA
		-- 	Family_Care
		-- 	Consolidated_Supports_And_Services
		-- 	Individual_Support_Services_ISSs
		-- 	Day_Training
		-- 	Day_Treatment
		-- 	Senior_Geriatric_Services
		-- 	Day_Habilitation
		-- 	Work_Shop
		-- 	Prevocational
		-- 	Supported_Employment_Enrollments
		-- 	Community_Habilitation
		-- 	Family_Support_Services
		-- 	Care_at_Home_Waiver_Services
		-- 	Developmental_Centers_And_Special_Population_Services
		-- END),
	-- domain
	'Health and Human Services',
	-- facilitygroup
	'Human Services',
	-- facilitysubgroup
	'Programs for People with Disabilities',
	-- agencyclass1
		ARRAY[CONCAT('Intermediate_Care_Facilities_ICFs: ',Intermediate_Care_Facilities_ICFs),
		CONCAT('Individual_Residential_Alternative_IRA: ',Individual_Residential_Alternative_IRA),
		CONCAT('Family_Care: ',Family_Care),
		CONCAT('Consolidated_Supports_And_Services: ',Consolidated_Supports_And_Services),
		CONCAT('Individual_Support_Services_ISSs: ',Individual_Support_Services_ISSs),
		CONCAT('Day_Training: ',Day_Training),
		CONCAT('Day_Treatment: ',Day_Treatment),
		CONCAT('Senior_Geriatric_Services: ',Senior_Geriatric_Services),
		CONCAT('Day_Habilitation: ',Day_Habilitation),
		CONCAT('Work_Shop: ',Work_Shop),
		CONCAT('Prevocational: ',Prevocational),
		CONCAT('Supported_Employment_Enrollments: ',Supported_Employment_Enrollments),
		CONCAT('Community_Habilitation: ',Community_Habilitation),
		CONCAT('Family_Support_Services: ',Family_Support_Services),
		CONCAT('Care_at_Home_Waiver_Services: ',Care_at_Home_Waiver_Services),
		CONCAT('Developmental_Centers_And_Special_Population_Services',Developmental_Centers_And_Special_Population_Services)],
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
	initcap(Service_Provider_Agency),
	-- operatorabbrev
	'Non-public',
	-- oversightagency
	ARRAY['NYS Office for People With Developmental Disabilities'],
	-- oversightabbrev
	ARRAY['NYSOPWDD'],
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
		(CASE
			WHEN Senior_Geriatric_Services = 'Y' THEN TRUE
			ELSE FALSE
		END),
	-- family
		(CASE
			WHEN family_care = 'Y' THEN TRUE
			WHEN family_support_services = 'Y' THEN TRUE
			ELSE FALSE
		END),
	-- disabilities
	TRUE,
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
			WHEN Individual_Residential_Alternative_IRA = 'Y' THEN TRUE
			ELSE FALSE
		END)
FROM
	nysopwdd_facilities_providers
WHERE
	County = 'NEW YORK'
	OR County = 'BRONX'
	OR County = 'KINGS'
	OR County = 'QUEENS'
	OR County = 'RICHMOND'
GROUP BY
	hash,
	Developmental_Disability_Services_Office,
	Service_Provider_Agency,
	Street_Address_,
	Street_Address_Line_2,
	City,
	State,
	Zip_Code,
	Phone,
	County,
	Website_Url,
	Intermediate_Care_Facilities_ICFs,
	Individual_Residential_Alternative_IRA,
	Family_Care,
	Consolidated_Supports_And_Services,
	Individual_Support_Services_ISSs,
	Day_Training,
	Day_Treatment,
	Senior_Geriatric_Services,
	Day_Habilitation,
	Work_Shop,
	Prevocational,
	Supported_Employment_Enrollments,
	Community_Habilitation,
	Family_Support_Services,
	Care_at_Home_Waiver_Services,
	Developmental_Centers_And_Special_Population_Services,
	Location_1
