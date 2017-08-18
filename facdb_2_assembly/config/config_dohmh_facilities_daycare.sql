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
	ARRAY['dohmh_facilities_daycare'],
	-- hash,
    hash,
	-- geom
	NULL,
	-- idagency
	ARRAY[Day_Care_Id],
	-- facilityname
		(CASE
			WHEN Center_Name LIKE '%SBCC%' THEN initcap(Legal_Name)
			WHEN Center_Name LIKE '%SCHOOL BASED CHILD CARE%' THEN initcap(Legal_Name)
			ELSE initcap(Center_Name)
		END),
	-- addressnumber
	Building,
	-- streetname
	initcap(Street),
	-- address
	CONCAT(Building,' ',initcap(Street)),
	-- borough
	initcap(Borough),
	-- zipcode
	ZipCode::integer,
	-- bbl
	NULL,
	-- bin
	NULL,
	-- facilitytype
		(CASE
			WHEN (facility_type = 'CAMP' OR facility_type = 'Camp') AND (program_type = 'All Age Camp' OR program_type = 'ALL AGE CAMP')
				THEN 'Camp - All Age'
			WHEN (facility_type = 'CAMP' OR facility_type = 'Camp') AND (program_type = 'School Age Camp' OR program_type = 'SCHOOL AGE CAMP')
				THEN 'Camp - School Age'
			WHEN (program_type = 'Preschool Camp' OR program_type = 'PRESCHOOL CAMP')
				THEN 'Camp - Preschool Age'
			WHEN (facility_type = 'GDC') AND (program_type = 'Child Care - Infants/Toddlers' OR program_type = 'INFANT TODDLER')
				THEN 'Group Day Care - Infants/Toddlers'
			WHEN (facility_type = 'GDC') AND (program_type = 'Child Care - Pre School' OR program_type = 'PRESCHOOL')
				THEN 'Group Day Care - Preschool'
			WHEN (facility_type = 'SBCC') AND (program_type = 'PRESCHOOL')
				THEN 'School Based Child Care - Preschool'
			WHEN (facility_type = 'SBCC') AND (program_type = 'INFANT TODDLER')
				THEN 'School Based Child Care - Infants/Toddlers'
			WHEN facility_type = 'SBCC'
				THEN 'School Based Child Care - Age Unspecified'
			WHEN facility_type = 'GDC'
				THEN 'Group Day Care - Age Unspecified'
			ELSE CONCAT(facility_type,' - ',program_type)
		END),
	-- domain
	'Education, Child Welfare, and Youth',
	-- facilitygroup
		(CASE
			WHEN (facility_type = 'CAMP' OR facility_type = 'Camp' OR program_type LIKE '%CAMP%' OR program_type LIKE '%Camp%')
				THEN 'Camps'
			ELSE 'Child Care and Pre-Kindergarten'
		END),
	-- facilitysubgroup
		(CASE
			WHEN (facility_type = 'CAMP' OR facility_type = 'Camp' OR program_type LIKE '%CAMP%' OR program_type LIKE '%Camp%')
				THEN 'Camps'
			ELSE 'Child Care'
		END),
	-- agencyclass1
	child_care_type,
	-- agencyclass2
	program_type,
	-- capacity
		(CASE
			WHEN Maximum_Capacity <> '0' THEN ARRAY[Maximum_Capacity::text]
			WHEN Maximum_Capacity = '0' THEN NULL
		END),
	-- utilization
	NULL,
	-- capacitytype
	ARRAY['Seats Based on Sq Ft'],
	-- utilizationrate
	NULL,
	-- area
	NULL,
	-- areatype
	NULL,
	-- operatortype
	'Non-public',
	-- operator
	initcap(Legal_Name),
	-- operatorabbrev
	'Non-public',
	-- oversightagency
	ARRAY['NYC Department of Health and Mental Hygiene'],
	-- oversightabbrev
	ARRAY['NYCDOHMH'],
	-- datecreated
	CURRENT_TIMESTAMP,
	NULL,
	-- buildingname
	NULL,
	-- schoolorganizationlevel
	NULL,
	-- children
	TRUE,
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
	dohmh_facilities_daycare
GROUP BY
	hash,
	Day_Care_ID,
	Center_Name,
	Legal_Name,
	Building,
	Street,
	ZipCode,
	Borough,
	facility_type,
	child_care_type,
	program_type,
	Maximum_Capacity