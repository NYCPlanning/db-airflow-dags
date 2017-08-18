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
	ARRAY['dcla_facilities_culturalinstitutions'],
	-- hash,
    hash,
	-- geom
	NULL,
	-- idagency
	NULL,
	-- facilityname
	Organization_Name,
	-- addressnumber
	split_part(trim(both ' ' from initcap(Address)), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from initcap(Address)), strpos(trim(both ' ' from initcap(Address)), ' ')+1, (length(trim(both ' ' from initcap(Address)))-strpos(trim(both ' ' from initcap(Address)), ' ')))),
	-- address
	initcap(Address),
	-- borough
	borough,
	-- zipcode
	left(zip_code,5)::integer,
	-- bbl
	NULL,
	-- bin
	NULL,
	-- facilitytype
		(CASE
			WHEN Discipline IS NOT NULL THEN Discipline
			ELSE 'Unspecified Discipline'
		END),
	-- domain
	'Libraries and Cultural Programs',
	-- facilitygroup
	'Cultural Institutions',
	-- facilitysubgroup
		(CASE
			WHEN Discipline LIKE '%Museum%' THEN 'Museums'
			ELSE 'Other Cultural Institutions'
		END),
	-- agencyclass1
	Discipline,
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
	Organization_Name,
	-- operatorabbrev
	'Non-public',
	-- oversightagencyn
	ARRAY['NYC Department of Cultural Affairs'],
	-- oversightabbrev
	ARRAY['NYCDCLA'],
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
	dcla_facilities_culturalinstitutions