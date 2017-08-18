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
	ARRAY['dpr_parksproperties'],
	-- hash,
    hash,
	-- geom
	ST_Centroid(geom),
	-- idagency
	ARRAY[gispropnum],
	-- facilityname
	signname,
	-- addressnumber
	NULL,
	-- streetname
	NULL,
	-- address
	NULL,
	-- borough
		(CASE
			WHEN Borough = 'M' THEN 'Manhattan'
			WHEN Borough = 'X' THEN 'Bronx'
			WHEN Borough = 'K' THEN 'Brooklyn'
			WHEN Borough = 'Q' THEN 'Queens'
			WHEN Borough = 'R' THEN 'Staten Island'
		END),
	-- zipcode
	NULL,
	-- bbl
	NULL,
	-- bin
	NULL,
	-- facilitytype
	typecatego,
	-- domain
		(CASE
			-- admin of gov
			WHEN typecatego = 'Undeveloped' THEN 'Administration of Government'
			WHEN typecatego = 'Lot' THEN 'Administration of Government'
			-- parks
			ELSE 'Parks, Gardens, and Historical Sites'
		END),
	-- facilitygroup
		(CASE
			-- admin of gov
			WHEN typecatego = 'Undeveloped' THEN 'Other Property'
			WHEN typecatego = 'Lot' THEN 'City Agency Parking, Maintenance, and Storage'
			-- parks
			WHEN typecatego = 'Cemetery' THEN 'Parks and Plazas'
			WHEN typecatego = 'Historic House Park' THEN 'Historical Sites'
			ELSE 'Parks and Plazas'
		END),
	-- facilitysubgroup
		(CASE
			-- admin of gov
			WHEN typecatego = 'Undeveloped' THEN 'Miscellaneous Use'
			WHEN typecatego = 'Lot' THEN 'City Agency Parking'
			-- parks
			WHEN typecatego = 'Cemetery' THEN 'Cemeteries'
			WHEN typecatego = 'Historic House Park' THEN 'Historical Sites'
			WHEN typecatego = 'Triangle/Plaza' THEN 'Streetscapes, Plazas, and Malls'
			WHEN typecatego = 'Mall' THEN 'Streetscapes, Plazas, and Malls'
			WHEN typecatego = 'Strip' THEN 'Streetscapes, Plazas, and Malls'
			WHEN typecatego = 'Parkway' THEN 'Streetscapes, Plazas, and Malls'
			WHEN typecatego = 'Tracking' THEN 'Streetscapes, Plazas, and Malls'
			WHEN typecatego = 'Garden' THEN 'Gardens'
			WHEN typecatego = 'Nature Area' THEN 'Preserves and Conservation Areas'
			WHEN typecatego = 'Flagship Park' THEN 'Parks'
			WHEN typecatego = 'Community Park' THEN 'Parks'
			WHEN typecatego = 'Neighborhood Park' THEN 'Parks'
			ELSE 'Recreation and Waterfront Sites'
		END),
	-- agencyclass1
	typecatego,
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
	ARRAY[ST_Area(geom::geography)::numeric*.000247105],
	-- areatype
	ARRAY['Acres'],
	-- operatortype
	'Public',
	-- operatorname
	'NYC Department of Parks and Recreation',
	-- operatorabbrev
	'NYCDPR',
	-- oversightagency
	ARRAY['NYC Department of Parks and Recreation'],
	-- oversightabbrev
	ARRAY['NYCDPR'],
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
	dpr_parksproperties