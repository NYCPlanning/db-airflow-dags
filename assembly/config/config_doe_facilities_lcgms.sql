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
	ARRAY['doe_facilities_lcgms'],
	-- hash,
    hash,
	-- geom
	NULL,
	-- idagency
	ARRAY[LocationCode],
	-- facilityname
	initcap(LocationName),
	-- addressnumber
	split_part(doe_facilities_schoolsbluebook.Address,' ',1),
	-- streetname
	initcap(trim(both ' ' from substr(trim(both ' ' from doe_facilities_schoolsbluebook.Address), strpos(trim(both ' ' from doe_facilities_schoolsbluebook.Address), ' ')+1, (length(trim(both ' ' from doe_facilities_schoolsbluebook.Address))-strpos(trim(both ' ' from doe_facilities_schoolsbluebook.Address), ' '))))),
	-- address
	initcap(doe_facilities_schoolsbluebook.Address),
	-- borough
		(CASE
			WHEN LEFT(LocationCode,1) = 'M' THEN 'Manhattan'
			WHEN LEFT(LocationCode,1) = 'X' THEN 'Bronx'
			WHEN LEFT(LocationCode,1) = 'K' THEN 'Brooklyn'
			WHEN LEFT(LocationCode,1) = 'Q' THEN 'Queens'
			WHEN LEFT(LocationCode,1) = 'R' THEN 'Staten Island'
		END),
	-- zipcode
	doe_facilities_schoolsbluebook.Zip::numeric,
	-- bbl
		(CASE
			WHEN BoroughBlockLot <> '0' THEN ARRAY[BoroughBlockLot]
		END),
	-- bin
	NULL,
	-- facilitytype
		(CASE
			WHEN ManagedByName = 'Charter' AND lower(LocationCategoryDescription) LIKE '%school%' THEN CONCAT(LocationCategoryDescription, ' - Charter')
			WHEN ManagedByName = 'Charter' THEN CONCAT(LocationCategoryDescription, ' School - Charter')
			WHEN lower(LocationCategoryDescription) LIKE '%school%' THEN CONCAT(LocationCategoryDescription, ' - Public')
			ELSE CONCAT(LocationCategoryDescription, ' School - Public')
		END),
	-- domain
	'Education, Child Welfare, and Youth',
	-- facilitygroup
		(CASE
			WHEN LocationCategoryDescription LIKE '%Early%' OR LocationCategoryDescription LIKE '%Pre-K%' THEN 'Child Care and Pre-Kindergarten'
			ELSE 'Schools (K-12)'
		END),
	-- facilitysubgroup
		(CASE
			WHEN LocationTypeDescription LIKE '%Special%' THEN 'Public and Private Special Education Schools'
			WHEN LocationCategoryDescription LIKE '%Early%' OR LocationCategoryDescription LIKE '%Pre-K%' THEN 'DOE Universal Pre-Kindergarten'
			WHEN ManagedByName = 'Charter' THEN 'Charter K-12 Schools'
			ELSE 'Public K-12 Schools'
		END),
	-- agencyclass1
	NULL,
	-- agencyclass2
	NULL,
	-- capacity
	-- (CASE
	-- 	WHEN doe_facilities_schoolsbluebook.Org_Target_Cap <> 0 THEN ARRAY[ROUND(doe_facilities_schoolsbluebook.Org_Target_Cap::numeric,0)::text]
	-- END),
	NULL,
	-- utilization
	-- ARRAY[ROUND(doe_facilities_schoolsbluebook.Org_Enroll::numeric,0)::text],
	NULL,
	-- capacitytype
	-- ARRAY['Seats'],
	NULL,
	-- utilizationrate
		-- (CASE
		-- 	WHEN (Org_Enroll <> 0 AND doe_facilities_schoolsbluebook.Org_Target_Cap <> 0) THEN ARRAY[ROUND((Org_Enroll::numeric/doe_facilities_schoolsbluebook.Org_Target_Cap::numeric),3)::text]
		-- END),
	NULL,
	-- area
	NULL,
	-- areatype
	NULL,
	-- operatortype
		(CASE
			WHEN ManagedByName = 'Charter' THEN 'Non-public'
			ELSE 'Public'
		END),
	-- operatorname
		(CASE
			WHEN ManagedByName = 'Charter' THEN LocationName
			ELSE 'NYC Department of Education'
		END),
	-- operator abbrev
		(CASE
			WHEN ManagedByName = 'Charter' THEN 'Non-public'
			ELSE 'NYCDOE'
		END),
	-- oversightagency
	ARRAY['NYC Department of Education'],
	-- oversightabbrev
	ARRAY['NYCDOE'],
	-- datecreated
	CURRENT_TIMESTAMP,
	-- buildingid
	BuildingCode,
	-- buildingname
	NULL,
	-- schoolorganizationlevel
	NULL,
	-- children
		(CASE
			WHEN LocationCategoryDescription LIKE '%Pre-K%' OR LocationCategoryDescription LIKE '%Elementary%' OR LocationCategoryDescription LIKE '%Early%' OR LocationCategoryDescription LIKE '%K-%' THEN TRUE
			ELSE FALSE
		END),
	-- youth
		(CASE
			WHEN LocationCategoryDescription LIKE '%High%' OR LocationCategoryDescription LIKE '%Secondary%' OR LocationCategoryDescription LIKE '%K-12%' THEN TRUE
			ELSE FALSE
		END),
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
	doe_facilities_lcgms
LEFT JOIN
	doe_facilities_schoolsbluebook
ON 
	doe_facilities_lcgms.LocationCode = doe_facilities_schoolsbluebook.Org_ID