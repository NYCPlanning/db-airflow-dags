-- This script has a unique INSERT statement

INSERT INTO
facilities (
pgtable,
hash,
geom,
idold,
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
datasource,
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
	ARRAY[(CASE 
		WHEN ft_decode = 'PANYNJ Bus Terminal' THEN 'panynj_facilities_sfpsd'
		WHEN ft_decode = 'Wastewater Treatment Plant' THEN 'nycdep_facilities_sfpsd'
		WHEN ft_decode = 'MTA Paratransit Vehicle Depot' THEN 'mta_facilities_sfpsd'
		WHEN ft_decode = 'MTA Bus Depot' THEN 'mta_facilities_sfpsd'
		WHEN ft_decode = 'NYCT Maintenance and Other Facility' THEN 'mta_facilities_sfpsd'
		WHEN ft_decode = 'NYCT Subway Yard' THEN 'mta_facilities_sfpsd'
		WHEN ft_decode = 'Metro-North Maintenance and Other Facility' THEN 'mta_facilities_sfpsd'
		WHEN ft_decode = 'Metro-North Yard' THEN 'mta_facilities_sfpsd'
		WHEN ft_decode = 'LIRR Maintenance and Other Facility' THEN 'mta_facilities_sfpsd'
		WHEN ft_decode = 'LIRR Yard' THEN 'mta_facilities_sfpsd'
		WHEN ft_decode = 'Amtrak Maintenance and Other Facility' THEN 'amtrak_facilities_sfpsd'
		WHEN ft_decode = 'Amtrak Yard' THEN 'amtrak_facilities_sfpsd'
		WHEN agencyoper = '24.0000000000' THEN 'nysdot_facilities_sfpsd'
		WHEN agencyoper = '63.0000000000' THEN 'nysdot_facilities_sfpsd'
		WHEN agencyoper = '80.0000000000' THEN 'hrpt_facilities_sfpsd'
		WHEN agencyoper = '81.0000000000' THEN 'bbpc_facilities_sfpsd'
		WHEN agencyoper = '83.0000000000' THEN 'rioc_facilities_sfpsd'
		WHEN agencyoper = '84.0000000000' THEN 'tgi_facilities_sfpsd'
		ELSE 'mta_facilities_sfpsd'
	END)],
	-- hash,
    hash,
	-- geom
	geom,
	-- idold
	ARRAY[id::text],
	-- idagency
	NULL,
	-- facilityname
	initcap(facname),
	-- addressnumber
	split_part(trim(both ' ' from facaddress), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from facaddress), strpos(trim(both ' ' from facaddress), ' ')+1, (length(trim(both ' ' from facaddress))-strpos(trim(both ' ' from facaddress), ' ')))),
	-- address
	facaddress,
	-- borough
		(CASE
			WHEN borocode = 1 THEN 'Manhattan'
			WHEN borocode = 2 THEN 'Bronx'
			WHEN borocode = 3 THEN 'Brooklyn'
			WHEN borocode = 4 THEN 'Queens'
			WHEN borocode = 5 THEN 'Staten Island'
		END),
	-- zipcode
	NULL,
	-- bbl
	ARRAY[ROUND(bbl,0)::text],
	-- bin
	NULL,
	-- facilitytype
	ft_decode,
	-- domain
		(CASE 
			WHEN ft_decode = 'City-State Park' THEN 'Parks, Gardens, and Historical Sites'
			ELSE 'Core Infrastructure and Transportation'
		END),
	-- facilitygroup
		(CASE 
			WHEN ft_decode = 'City-State Park' THEN 'Parks and Plazas'
			WHEN ft_decode = 'PANYNJ Bus Terminal' THEN 'Transportation'
			WHEN ft_decode = 'Wastewater Treatment Plant' THEN 'Water and Wastewater'
			WHEN ft_decode = 'Public Park and Ride Lot' THEN 'Transportation'
			WHEN ft_decode = 'MTA Paratransit Vehicle Depot' THEN 'Transportation'
			WHEN ft_decode = 'MTA Bus Depot' THEN 'Transportation'
			WHEN ft_decode = 'NYCT Maintenance and Other Facility' THEN 'Transportation'
			WHEN ft_decode = 'NYCT Subway Yard' THEN 'Transportation'
			WHEN ft_decode = 'Metro-North Maintenance and Other Facility' THEN 'Transportation'
			WHEN ft_decode = 'Metro-North Yard' THEN 'Transportation'
			WHEN ft_decode = 'LIRR Maintenance and Other Facility' THEN 'Transportation'
			WHEN ft_decode = 'LIRR Yard' THEN 'Transportation'
			WHEN ft_decode = 'Amtrak Maintenance and Other Facility' THEN 'Transportation'
			WHEN ft_decode = 'Amtrak Yard' THEN 'Transportation'
		END),
	-- facilitysubgroup
		(CASE 
			WHEN ft_decode = 'City-State Park' THEN 'Parks'
			WHEN ft_decode = 'PANYNJ Bus Terminal' THEN 'Bus Depots and Terminals'
			WHEN ft_decode = 'Wastewater Treatment Plant' THEN 'Wastewater and Pollution Control'
			WHEN ft_decode = 'Public Park and Ride Lot' THEN 'Parking Lots and Garages'
			WHEN ft_decode = 'MTA Paratransit Vehicle Depot' THEN 'Bus Depots and Terminals'
			WHEN ft_decode = 'MTA Bus Depot' THEN 'Bus Depots and Terminals'
			WHEN ft_decode = 'NYCT Maintenance and Other Facility' THEN 'Rail Yards and Maintenance'
			WHEN ft_decode = 'NYCT Subway Yard' THEN 'Rail Yards and Maintenance'
			WHEN ft_decode = 'Metro-North Maintenance and Other Facility' THEN 'Rail Yards and Maintenance'
			WHEN ft_decode = 'Metro-North Yard' THEN 'Rail Yards and Maintenance'
			WHEN ft_decode = 'LIRR Maintenance and Other Facility' THEN 'Rail Yards and Maintenance'
			WHEN ft_decode = 'LIRR Yard' THEN 'Rail Yards and Maintenance'
			WHEN ft_decode = 'Amtrak Maintenance and Other Facility' THEN 'Rail Yards and Maintenance'
			WHEN ft_decode = 'Amtrak Yard' THEN 'Rail Yards and Maintenance'
		END),
	-- agencyclass1
	'NA',
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
	(CASE 
		WHEN ft_decode = 'City-State Park' AND acreage::numeric > 0 THEN ARRAY[ROUND(acreage::numeric,3)::text]
	END),
	-- areatype
	(CASE 
		WHEN ft_decode = 'City-State Park' AND acreage::numeric > 0 THEN ARRAY['Acres']
	END),
	-- operatortype
		(CASE
			WHEN ft_decode = 'MTA Paratransit Vehicle Depot' THEN 'Non-public'
			ELSE 'Public'
		END),
	-- operatorname
		(CASE 
			WHEN ft_decode = 'PANYNJ Bus Terminal' THEN 'Port Authority of New York and New Jersey'
			WHEN ft_decode = 'Wastewater Treatment Plant' THEN 'NYC Department of Environmental Protection'
			WHEN ft_decode = 'MTA Paratransit Vehicle Depot' THEN 'Proprietary'
			WHEN ft_decode = 'MTA Bus Depot' THEN 'Metropolitan Transportation Authority'
			WHEN ft_decode = 'NYCT Maintenance and Other Facility' THEN 'Metropolitan Transportation Authority'
			WHEN ft_decode = 'NYCT Subway Yard' THEN 'Metropolitan Transportation Authority'
			WHEN ft_decode = 'Metro-North Maintenance and Other Facility' THEN 'Metropolitan Transportation Authority'
			WHEN ft_decode = 'Metro-North Yard' THEN 'Metropolitan Transportation Authority'
			WHEN ft_decode = 'LIRR Maintenance and Other Facility' THEN 'Metropolitan Transportation Authority'
			WHEN ft_decode = 'LIRR Yard' THEN 'Metropolitan Transportation Authority'
			WHEN ft_decode = 'Amtrak Maintenance and Other Facility' THEN 'Amtrak'
			WHEN ft_decode = 'Amtrak Yard' THEN 'Amtrak'
			WHEN agencyoper = '24.0000000000' THEN 'NYC Department of Transportation'
			WHEN agencyoper = '63.0000000000' THEN 'NYS Department of Transportation'
			WHEN agencyoper = '80.0000000000' THEN 'Hudson River Park Trust'
			WHEN agencyoper = '81.0000000000' THEN 'Brooklyn Bridge Park Corporation'
			WHEN agencyoper = '83.0000000000' THEN 'Roosevelt Island Operating Corporation'
			WHEN agencyoper = '84.0000000000' THEN 'Trust for Governors Island'
			ELSE 'Metropolitan Transportation Authority'
		END),
	-- operatorabbrev
		(CASE 
			WHEN ft_decode = 'PANYNJ Bus Terminal' THEN 'PANYNJ'
			WHEN ft_decode = 'Wastewater Treatment Plant' THEN 'NYCDEP'
			WHEN ft_decode = 'MTA Paratransit Vehicle Depot' THEN 'Non-public'
			WHEN ft_decode = 'MTA Bus Depot' THEN 'MTA'
			WHEN ft_decode = 'NYCT Maintenance and Other Facility' THEN 'MTA'
			WHEN ft_decode = 'NYCT Subway Yard' THEN 'MTA'
			WHEN ft_decode = 'Metro-North Maintenance and Other Facility' THEN 'MTA'
			WHEN ft_decode = 'Metro-North Yard' THEN 'MTA'
			WHEN ft_decode = 'LIRR Maintenance and Other Facility' THEN 'MTA'
			WHEN ft_decode = 'LIRR Yard' THEN 'MTA'
			WHEN ft_decode = 'Amtrak Maintenance and Other Facility' THEN 'Amtrak'
			WHEN ft_decode = 'Amtrak Yard' THEN 'Amtrak'
			WHEN agencyoper = '24.0000000000' THEN 'NYCDOT'
			WHEN agencyoper = '63.0000000000' THEN 'NYSDOT'
			WHEN agencyoper = '80.0000000000' THEN 'HRPT'
			WHEN agencyoper = '81.0000000000' THEN 'BBPC'
			WHEN agencyoper = '83.0000000000' THEN 'RIOC'
			WHEN agencyoper = '84.0000000000' THEN 'TGI'
			ELSE 'MTA'
		END),
	-- oversightagency
		ARRAY[(CASE 
			WHEN ft_decode = 'PANYNJ Bus Terminal' THEN 'Port Authority of New York and New Jersey'
			WHEN ft_decode = 'Wastewater Treatment Plant' THEN 'NYC Department of Environmental Protection'
			WHEN ft_decode = 'MTA Paratransit Vehicle Depot' THEN 'Metropolitan Transportation Authority'
			WHEN ft_decode = 'MTA Bus Depot' THEN 'Metropolitan Transportation Authority'
			WHEN ft_decode = 'NYCT Maintenance and Other Facility' THEN 'Metropolitan Transportation Authority'
			WHEN ft_decode = 'NYCT Subway Yard' THEN 'Metropolitan Transportation Authority'
			WHEN ft_decode = 'Metro-North Maintenance and Other Facility' THEN 'Metropolitan Transportation Authority'
			WHEN ft_decode = 'Metro-North Yard' THEN 'Metropolitan Transportation Authority'
			WHEN ft_decode = 'LIRR Maintenance and Other Facility' THEN 'Metropolitan Transportation Authority'
			WHEN ft_decode = 'LIRR Yard' THEN 'Metropolitan Transportation Authority'
			WHEN ft_decode = 'Amtrak Maintenance and Other Facility' THEN 'Amtrak'
			WHEN ft_decode = 'Amtrak Yard' THEN 'Amtrak'
			WHEN agencyoper = '24.0000000000' THEN 'NYS Department of Transportation'
			WHEN agencyoper = '63.0000000000' THEN 'NYS Department of Transportation'
			WHEN agencyoper = '80.0000000000' THEN 'Hudson River Park Trust'
			WHEN agencyoper = '81.0000000000' THEN 'Brooklyn Bridge Park Corporation'
			WHEN agencyoper = '83.0000000000' THEN 'Roosevelt Island Operating Corporation'
			WHEN agencyoper = '84.0000000000' THEN 'Trust for Governors Island'
			ELSE 'Metropolitan Transportation Authority'
		END)],
	-- oversightabbrev
		ARRAY[(CASE 
			WHEN ft_decode = 'PANYNJ Bus Terminal' THEN 'PANYNJ'
			WHEN ft_decode = 'Wastewater Treatment Plant' THEN 'NYCDEP'
			WHEN ft_decode = 'MTA Paratransit Vehicle Depot' THEN 'MTA'
			WHEN ft_decode = 'MTA Bus Depot' THEN 'MTA'
			WHEN ft_decode = 'NYCT Maintenance and Other Facility' THEN 'MTA'
			WHEN ft_decode = 'NYCT Subway Yard' THEN 'MTA'
			WHEN ft_decode = 'Metro-North Maintenance and Other Facility' THEN 'MTA'
			WHEN ft_decode = 'Metro-North Yard' THEN 'MTA'
			WHEN ft_decode = 'LIRR Maintenance and Other Facility' THEN 'MTA'
			WHEN ft_decode = 'LIRR Yard' THEN 'MTA'
			WHEN ft_decode = 'Amtrak Maintenance and Other Facility' THEN 'Amtrak'
			WHEN ft_decode = 'Amtrak Yard' THEN 'Amtrak'
			WHEN agencyoper = '24.0000000000' THEN 'NYSDOT'
			WHEN agencyoper = '63.0000000000' THEN 'NYSDOT'
			WHEN agencyoper = '80.0000000000' THEN 'HRPT'
			WHEN agencyoper = '81.0000000000' THEN 'BBPC'
			WHEN agencyoper = '83.0000000000' THEN 'RIOC'
			WHEN agencyoper = '84.0000000000' THEN 'TGI'
			ELSE 'MTA'
		END)],
	-- datecreated
	CURRENT_TIMESTAMP,
	-- agencysource
		ARRAY[(CASE 
			WHEN ft_decode = 'PANYNJ Bus Terminal' THEN 'PANYNJ'
			WHEN ft_decode = 'Wastewater Treatment Plant' THEN 'NYCDEP'
			WHEN ft_decode = 'MTA Paratransit Vehicle Depot' THEN 'MTA'
			WHEN ft_decode = 'MTA Bus Depot' THEN 'MTA'
			WHEN ft_decode = 'NYCT Maintenance and Other Facility' THEN 'MTA'
			WHEN ft_decode = 'NYCT Subway Yard' THEN 'MTA'
			WHEN ft_decode = 'Metro-North Maintenance and Other Facility' THEN 'MTA'
			WHEN ft_decode = 'Metro-North Yard' THEN 'MTA'
			WHEN ft_decode = 'LIRR Maintenance and Other Facility' THEN 'MTA'
			WHEN ft_decode = 'LIRR Yard' THEN 'MTA'
			WHEN ft_decode = 'Amtrak Maintenance and Other Facility' THEN 'Amtrak'
			WHEN ft_decode = 'Amtrak Yard' THEN 'Amtrak'
			WHEN agencyoper = '24.0000000000' THEN 'NYSDOT'
			WHEN agencyoper = '63.0000000000' THEN 'NYSDOT'
			WHEN agencyoper = '80.0000000000' THEN 'HRPT'
			WHEN agencyoper = '81.0000000000' THEN 'BBPC'
			WHEN agencyoper = '83.0000000000' THEN 'RIOC'
			WHEN agencyoper = '84.0000000000' THEN 'TGI'
			ELSE 'MTA'
		END)],
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
	dcp_facilities_sfpsd
WHERE 1=1
	AND (ft_decode = 'City-State Park'
	OR ft_decode = 'PANYNJ Bus Terminal'
	OR ft_decode = 'Wastewater Treatment Plant'
	OR ft_decode = 'Public Park and Ride Lot'
	OR ft_decode = 'MTA Paratransit Vehicle Depot'
	OR ft_decode = 'MTA Bus Depot'
	OR ft_decode = 'NYCT Maintenance and Other Facility'
	OR ft_decode = 'NYCT Subway Yard'
	OR ft_decode = 'Metro-North Maintenance and Other Facility'
	OR ft_decode = 'Metro-North Yard'
	OR ft_decode = 'LIRR Maintenance and Other Facility'
	OR ft_decode = 'LIRR Yard'
	OR ft_decode = 'Amtrak Maintenance and Other Facility'
	OR ft_decode = 'Amtrak Yard')