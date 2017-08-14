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
	ARRAY['usdot_facilities_ports'],
	-- hash,
    hash,
	-- geom
	geom,
	-- idagency
	ARRAY[nav_unit_i],
	-- facilityname
	initcap(nav_unit_n),
	-- addressnumber
	NULL,
	-- streetname
	NULL,
	-- address
	NULL,
	-- borough
		(CASE
			WHEN (state_post = 'NY') AND (County_nam = 'New York') THEN 'Manhattan'
			WHEN (state_post = 'NY') AND (County_nam = 'Bronx') THEN 'Bronx'
			WHEN (state_post = 'NY') AND (County_nam = 'Kings') THEN 'Brooklyn'
			WHEN (state_post = 'NY') AND (County_nam = 'Queens') THEN 'Queens'
			WHEN (state_post = 'NY') AND (County_nam = 'Richmond') THEN 'Staten Island'
		END),
	-- zipcode
	zipcode::integer,
	-- bbl
	NULL,
	-- bin
	NULL,
	-- facilitytype
		(CASE
			WHEN (nav_unit_n LIKE '%FERRY%') OR (nav_unit_n LIKE '%Ferry%') THEN 'Ferry Landing'
			WHEN (nav_unit_n LIKE '%CRUISE%') OR (nav_unit_n LIKE '%Cruise%') THEN 'Cruise Terminal'
			ELSE 'Port or Marine Terminal'
		END),
	-- domain
	'Core Infrastructure and Transportation',
	-- facilitygroup
	'Transportation',
	-- facilitysubgroup
	'Ports and Ferry Landings',
	-- agencyclass1
		(CASE
			WHEN owners IS NOT NULL THEN owners
			ELSE 'NA'
		END),
		-- (CASE
		-- 	WHEN purpose IS NOT NULL THEN purpose
		-- 	ELSE 'NA'
		-- END),
	-- agencyclass2
		(CASE
			WHEN operators IS NOT NULL THEN operators
			ELSE 'NA'
		END),
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
	(CASE
		WHEN operators like '%Sanitation%' THEN 'Public'
		WHEN operators like '%Department of Environmental Protection%' THEN 'Public'
		WHEN operators like '%Department of Transportation%' THEN 'Public'
		WHEN operators like '%Department of Ports and Terminals%' THEN 'Public'
		WHEN operators like '%Department of Interior%' THEN 'Public'
		WHEN operators like '%Police%' THEN 'Public'
		WHEN operators like '%Fire Department%' THEN 'Public'
		WHEN operators like '%Corrections%' THEN 'Public'
		WHEN operators like '%State University%' THEN 'Public'
		WHEN operators like '%Coast Guard%' THEN 'Public'
		WHEN operators IS NULL AND owners like '%Port Authority%' THEN 'Public'
		WHEN operators IS NULL AND owners like '%Parks%' THEN 'Public'
		WHEN operators IS NULL AND owners like '%Department of Environmental Protection%' THEN 'Public'
		WHEN operators IS NULL AND owners like '%Department of Transportation%' THEN 'Public'
		WHEN operators IS NULL AND owners like '%Department of Sanitation%' THEN 'Public'
		WHEN operators IS NULL AND owners like '%Department of Port and Terminals%' THEN 'Public'
		WHEN operators IS NULL AND owners like '%Department of Interior%' THEN 'Public'
		WHEN operators IS NULL AND owners like '%Police%' THEN 'Public'
		WHEN operators IS NULL AND owners like '%Fire Department%' THEN 'Public'
		WHEN operators IS NULL AND owners like '%Corrections%' THEN 'Public'
		WHEN operators IS NULL AND owners like '%State University%' THEN 'Public'
		WHEN operators IS NULL AND owners like '%Coast Guard%' THEN 'Public'
		ELSE 'Non-public'
	END),
	-- operatorname
	(CASE
		WHEN operators like '%Sanitation%' THEN 'NYC Department of Sanitation'
		WHEN operators like '%Department of Environmental Protection%' THEN 'NYC Department of Environmental Protection'
		WHEN operators like '%Department of Transportation%' THEN 'NYC Department of Transportation'
		WHEN operators like '%Department of Ports and Terminals%' THEN 'NYC Department of Port and Terminals'
		WHEN operators like '%Department of Interior%' THEN 'US Department of Interior'
		WHEN operators like '%Police%' THEN 'NYC Police Department'
		WHEN operators like '%Fire Department%' THEN 'NYC Fire Department'
		WHEN operators like '%Corrections%' THEN 'NYC Department of Correction'
		WHEN operators like '%State University%' THEN 'State University of New York'
		WHEN operators like '%Coast Guard%' THEN 'US Coast Guard'
		WHEN operators IS NULL AND owners like '%Port Authority%' THEN 'Port Authority of New York and New Jersey'
		WHEN operators IS NULL AND owners like '%Parks%' THEN 'NYC Department of Parks and Recreation'
		WHEN operators IS NULL AND owners like '%Department of Environmental Protection%' THEN 'NYC Department of Environmental Protection'
		WHEN operators IS NULL AND owners like '%Department of Sanitation%' THEN 'NYC Department of Sanitation'
		WHEN operators IS NULL AND owners like '%Department of Transportation%' THEN 'NYC Department of Transportation'
		WHEN operators IS NULL AND owners like '%Department of Port and Terminals%' THEN 'NYC Department of Port and Terminals'
		WHEN operators IS NULL AND owners like '%Department of Interior%' THEN 'US Department of Interior'
		WHEN operators IS NULL AND owners like '%Police%' THEN 'NYC Police Department'
		WHEN operators IS NULL AND owners like '%Fire Department%' THEN 'NYC Fire Department'
		WHEN operators IS NULL AND owners like '%Corrections%' THEN 'NYC Department of Correction'
		WHEN operators IS NULL AND owners like '%State University%' THEN 'State University of New York'
		WHEN operators IS NULL AND owners like '%Coast Guard%' THEN 'US Coast Guard'
		ELSE 'Non-public'
	END),
	-- operatorabbrev
	(CASE
		WHEN operators like '%Sanitation%' THEN 'NYCDSNY'
		WHEN operators like '%Department of Environmental Protection%' THEN 'NYCDEP'
		WHEN operators like '%Department of Transportation%' THEN 'NYCDOT'
		WHEN operators like '%Department of Ports and Terminals%' THEN 'NYCDPT'
		WHEN operators like '%Department of Interior%' THEN 'USDOI'
		WHEN operators like '%Police%' THEN 'NYCNYPD'
		WHEN operators like '%Fire Department%' THEN 'NYCFDNY'
		WHEN operators like '%Corrections%' THEN 'NYCDOC'
		WHEN operators like '%State University%' THEN 'SUNY'
		WHEN operators like '%Coast Guard%' THEN 'USCG'
		WHEN operators IS NULL AND owners like '%Port Authority%' THEN 'PANYNJ'
		WHEN operators IS NULL AND owners like '%Economic Development%' THEN 'NYCEDC'
		WHEN operators IS NULL AND owners like '%Parks%' THEN 'NYCDPR'
		WHEN operators IS NULL AND owners like '%Department of Environmental Protection%' THEN 'NYCDEP'
		WHEN operators IS NULL AND owners like '%Sanitation%' THEN 'NYCDSNY'
		WHEN operators IS NULL AND owners like '%Transportation%' THEN 'NYCDOT'
		WHEN operators IS NULL AND owners like '%Department of Port and Terminals%' THEN 'NYCDPT'
		WHEN operators IS NULL AND owners like '%Department of Interior%' THEN 'USDOI'
		WHEN operators IS NULL AND owners like '%Police%' THEN 'NYCNYPD'
		WHEN operators IS NULL AND owners like '%Fire Department%' THEN 'NYCFDNY'
		WHEN operators IS NULL AND owners like '%Corrections%' THEN 'NYCDOC'
		WHEN operators IS NULL AND owners like '%State University%' THEN 'SUNY'
		WHEN operators IS NULL AND owners like '%Coast Guard%' THEN 'USCG'
		ELSE 'Non-public'
	END),
	-- oversightagency
	ARRAY[(CASE
		WHEN owners like '%Port Authority%' THEN 'Port Authority of New York and New Jersey'
		WHEN owners like '%Economic Development%' THEN 'NYC Economic Development Corporation'
		WHEN owners like '%Parks%' THEN 'NYC Department of Parks and Recreation'
		WHEN owners like '%Department of Environmental Protection%' THEN 'NYC Department of Environmental Protection'
		WHEN owners like '%Department of Transportation%' THEN 'NYC Department of Transportation'
		WHEN owners like '%Department of Ports and Terminals%' THEN 'NYC Department of Port and Terminals'
		WHEN owners like '%Department of Interior%' THEN 'US Department of Interior'
		WHEN owners like '%Police%' THEN 'NYC Police Department'
		WHEN owners like '%Fire Department%' THEN 'NYC Fire Department'
		WHEN owners like '%Corrections%' THEN 'NYC Department of Correction'
		WHEN owners like '%State University%' THEN 'State University of New York'
		WHEN owners like '%Coast Guard%' THEN 'US Coast Guard'
		WHEN owners like '%United States%' THEN 'US Coast Guard'
		WHEN owners = 'Current Owner: City of New York.' THEN 'NYC Unknown'
		WHEN operators like '%Sanitation%' THEN 'NYC Department of Sanitation'
		WHEN operators like '%Department of Environmental Protection%' THEN 'NYC Department of Environmental Protection'
		WHEN operators like '%Department of Transportation%' THEN 'NYC Department of Transportation'
		WHEN operators like '%Department of Ports and Terminals%' THEN 'NYC Department of Port and Terminals'
		WHEN operators like '%Department of Interior%' THEN 'US Department of Interior'
		WHEN operators like '%Police%' THEN 'NYC Police Department'
		WHEN operators like '%Fire Department%' THEN 'NYC Fire Department'
		WHEN operators like '%Corrections%' THEN 'NYC Department of Correction'
		WHEN operators like '%State University%' THEN 'State University of New York'
		WHEN operators like '%Coast Guard%' THEN 'US Coast Guard'
		ELSE 'Non-public'
	END)],
	-- oversightabbrev
	ARRAY[(CASE
		WHEN owners like '%Port Authority%' THEN 'PANYNJ'
		WHEN owners like '%Economic Development%' THEN 'NYCEDC'
		WHEN owners like '%Parks%' THEN 'NYCDPR'
		WHEN owners like '%Department of Environmental Protection%' THEN 'NYCDEP'
		WHEN owners like '%Department of Transportation%' THEN 'NYCDOT'
		WHEN owners like '%Department of Port and Terminals%' THEN 'NYCDPT'
		WHEN owners like '%Department of Interior%' THEN 'USDOI'
		WHEN owners like '%Police%' THEN 'NYCNYPD'
		WHEN owners like '%Fire Department%' THEN 'NYCFDNY'
		WHEN owners like '%Corrections%' THEN 'NYCDOC'
		WHEN owners like '%State University%' THEN 'SUNY'
		WHEN owners like '%Coast Guard%' THEN 'USCG'
		WHEN owners like '%United States%' THEN 'USCG'
		WHEN owners = 'Current Owner: City of New York.' THEN 'NYC-Unknown'
		WHEN operators like '%Sanitation%' THEN 'NYCDSNY'
		WHEN operators like '%Department of Environmental Protection%' THEN 'NYCDEP'
		WHEN operators like '%Department of Sanitation%' THEN 'NYCDOT'
		WHEN operators like '%Department of Ports and Terminals%' THEN 'NYCDPT'
		WHEN operators like '%Department of Interior%' THEN 'USDOI'
		WHEN operators like '%Police%' THEN 'NYCNYPD'
		WHEN operators like '%Fire Department%' THEN 'NYCFDNY'
		WHEN operators like '%Corrections%' THEN 'NYCDOC'
		WHEN operators like '%State University%' THEN 'SUNY'
		WHEN operators like '%Coast Guard%' THEN 'USCG'
		ELSE 'Non-public'
	END)],
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
	usdot_facilities_ports
WHERE
	state_post = 'NY' 
	AND (County_nam = 'New York'
	OR County_nam = 'Bronx'
	OR County_nam = 'Kings'
	OR County_nam = 'Queens'
	OR County_nam = 'Richmond')
	AND (owners like '%City of New York%'
	OR owners like '%US Government%'
	OR operators like '%City of New York%'
	OR operators like '%Port Authority%'
	OR owners like '%Port Authority%'
	OR operators like '%Economic Development%'
	OR owners like '%Economic Development%')