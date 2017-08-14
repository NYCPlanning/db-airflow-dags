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
datasource,
dataname,
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
	ARRAY['hhs_facilities_proposals'],
	-- hash,
    hash,
	-- geom
	NULL,
	-- idagency
	array_agg(DISTINCT Proposal_ID),
	-- facilityname
		(CASE
			WHEN Site_Name IS NOT NULL THEN initcap(Site_Name)
			ELSE initcap(Provider_Name)
		END),
	-- address number
		(CASE
			WHEN Address_1 IS NOT NULL THEN split_part(trim(both ' ' from Address_1), ' ', 1)
		END),
	-- street name
		(CASE
			WHEN Address_1 IS NOT NULL THEN initcap(trim(both ' ' from substr(trim(both ' ' from Address_1), strpos(trim(both ' ' from Address_1), ' ')+1, (length(trim(both ' ' from Address_1))-strpos(trim(both ' ' from Address_1), ' ')))))
		END),
	-- address
		(CASE
			WHEN Address_1 IS NOT NULL THEN initcap(Address_1)
		END),
	-- borough
	NULL,
	-- zipcode
	Zip_Code::integer,
	-- bbl
	NULL,
	-- bin
	NULL,
	-- facilitytype
		(CASE
			WHEN agency_name LIKE '%Youth%' AND Program_name LIKE '%COMPASS%' THEN 'COMPASS Program'
			WHEN agency_name LIKE '%Youth%' AND Program_name LIKE '%Cornerstone%' THEN 'Cornerstone Community Center Program'
			WHEN agency_name LIKE '%Youth%' AND Program_name LIKE '%Beacon%' THEN 'Beacon Community Center Program'
			WHEN agency_name LIKE '%Youth%' AND Program_name LIKE '%Literacy%' THEN 'Literacy Program'
			WHEN agency_name LIKE '%Youth%' AND Program_name LIKE '%Neighborhood Development%' THEN 'Neighborhood Development Area Program'
			WHEN agency_name LIKE '%Youth%' THEN 'Other Youth Program'
			ELSE split_part(Program_name,' (',1)
		END),
	-- domain
		(CASE
			WHEN agency_name LIKE '%Children%' AND (Program_name LIKE '%Secure Placement%' OR Program_name LIKE '%secure Placement%' OR Program_name LIKE '%Detention%')
				THEN 'Public Safety, Emergency Services, and Administration of Justice'
			WHEN agency_name LIKE '%Children%' OR (agency_name LIKE '%Youth%' AND Program_name NOT LIKE '%Homeless%')
				THEN 'Education, Child Welfare, and Youth'
			WHEN agency_name LIKE '%Education%' AND Program_name LIKE '%Prek%'
				THEN 'Education, Child Welfare, and Youth'
			ELSE 'Health and Human Services'
		END),
	-- facilitygroup
		(CASE
			
			WHEN agency_name LIKE '%Children%' AND (Program_name LIKE '%secure Placement%' OR Program_name LIKE '%Secure Placement%' OR Program_name LIKE '%Detention%')
				THEN 'Justice and Corrections'
			WHEN agency_name LIKE '%Children%' AND Program_name LIKE '%Early Learn%'
				THEN 'Child Care and Pre-Kindergarten'
			WHEN agency_name LIKE '%Education%' AND Program_name LIKE '%Prek%'
				THEN 'Child Care and Pre-Kindergarten'
			WHEN agency_name LIKE '%Children%'
				THEN 'Child Services and Welfare'

			WHEN agency_name LIKE '%Education%'
				THEN 'Human Services'

			WHEN agency_name LIKE '%Youth%' AND Program_name LIKE '%Homeless%'
				THEN 'Human Services'
			WHEN agency_name LIKE '%Youth%'
				THEN 'Youth Services'

			WHEN agency_name LIKE '%Health%'
				THEN 'Health Care'

			ELSE 'Human Services'
		END),
	-- facilitysubgroup
		(CASE

			WHEN agency_name LIKE '%Children%' AND (Program_name LIKE '%secure Placement%' OR Program_name LIKE '%Secure Placement%' OR Program_name LIKE '%Detention%')
				THEN 'Detention and Correctional'
			WHEN agency_name LIKE '%Children%' AND Program_name LIKE '%Early Learn%'
				THEN 'Child Care'
			WHEN agency_name LIKE '%Education%' AND Program_name LIKE '%Prek%'
				THEN 'DOE Universal Pre-Kindergarten'
			WHEN agency_name LIKE '%Children%' AND (Program_name LIKE '%FFC%' OR Program_name LIKE '%Foster%' OR Program_name LIKE '%Residential%')
				THEN 'Foster Care Services and Residential Care'
			WHEN agency_name LIKE '%Children%'
				THEN 'Preventative Care, Evaluation Services, and Respite'

			WHEN agency_name LIKE '%Education%'
				THEN 'Community Centers and Community School Programs'
				
			WHEN agency_name LIKE '%Youth%' AND Program_name LIKE '%COMPASS%'
				THEN 'Comprehensive After School System (COMPASS) Sites'
			WHEN agency_name LIKE '%Youth%' AND Program_name LIKE '%Summer%'
				THEN 'Summer Youth Employment Site'
			WHEN agency_name LIKE '%Youth%' AND Program_name LIKE '%Homeless%'
				THEN 'Shelters and Transitional Housing'
			WHEN agency_name LIKE '%Youth%'
				THEN 'Youth Centers, Literacy Programs, Job Training, and Immigrant Services'

			WHEN agency_name LIKE '%Homeless%' AND (Program_name LIKE '%Outreach%' OR Program_name LIKE '%Prevention%')
				THEN 'Non-residential Housing and Homeless Services'
			WHEN agency_name LIKE '%Homeless%'
				THEN 'Shelters and Transitional Housing'

			WHEN agency_name LIKE '%Health%' AND Program_name LIKE '%Clinic%'
				THEN 'Hospitals and Clinics'
			WHEN agency_name LIKE '%Health%' AND Program_name LIKE '%HPDP%'
				THEN 'Health Promotion and Disease Prevention'
			WHEN agency_name LIKE '%Health%' AND Program_name LIKE '%Housing%'
				THEN 'Residential Health Care'
			WHEN agency_name LIKE '%Health%' AND (Program_name LIKE '%MHy%' OR Program_name LIKE '%Mental%' OR Program_name LIKE '%Psychosocial%')
				THEN 'Mental Health'
			WHEN agency_name LIKE '%Health%' AND (Program_name LIKE '%Withdrawal%' OR Program_name LIKE '%Drug%')
				THEN 'Chemical Dependency'
			WHEN agency_name LIKE '%Health%'
				THEN 'Other Health Care'

			WHEN agency_name LIKE '%Probation%' OR agency_name LIKE '%Correction%' OR agency_name LIKE '%Mayor%' OR agency_name LIKE '%Police%'
				THEN 'Legal and Intervention Services'

			WHEN agency_name LIKE '%Housing%' AND Program_name LIKE '%Family Centers%'
				THEN 'Shelters and Transitional Housing'
			WHEN agency_name LIKE '%Housing%'
				THEN 'Non-residential Housing and Homeless Services'

			WHEN agency_name LIKE '%Business%'
				THEN 'Workforce Development'

			WHEN agency_name LIKE '%Aging%'
				THEN 'Senior Services'

			WHEN agency_name LIKE '%Social%' AND (Program_name LIKE '%Job%' OR Program_name LIKE '%Work%')
				THEN 'Workforce Development'

			WHEN (agency_name LIKE '%Human%' OR agency_name LIKE '%Social%') AND Program_name LIKE '%AIDS%'
				THEN 'Shelters and Transitional Housing'

			WHEN agency_name LIKE '%Human%' AND Program_name LIKE '%Adult Protective%'
				THEN 'Programs for People with Disabilities'
			WHEN agency_name LIKE '%Human%' AND Program_name LIKE '%Housing%'
				THEN 'Shelters and Transitional Housing'
			WHEN agency_name LIKE '%Human%' AND Program_name LIKE '%WEP%'
				THEN 'Workforce Development'
			WHEN agency_name LIKE '%Human%' OR agency_name LIKE '%Social%'
				THEN 'Legal and Intervention Services'
		END),
	-- agencyclass1
	Program_name,
	-- agencyclass2
	NULL,
	-- capacity
	NULL,
	-- utilization
	NULL,
	-- capacitytype
	NULL,
	-- utlizationrate
	NULL,
	-- area
	NULL,
	-- areatype
	NULL,
	-- operatortype
	'Non-public',
	-- operatorname
	initcap(provider_name),
	-- operatorabbrev
	'Non-public',
	-- oversightagency
		ARRAY[(CASE
			WHEN agency_name LIKE '%DOE%' THEN 'NYC Department of Education'
			WHEN agency_name LIKE '%SBS%' THEN 'NYC Department of Small Business Services'
			WHEN agency_name LIKE '%DHS%' THEN 'NYC Department of Homeless Services'
			WHEN agency_name LIKE '%HRA%' OR agency_name LIKE '%Social Services%' OR agency_name LIKE '%DSS%'THEN 'NYC Human Resources Administration/Department of Social Services'
			WHEN agency_name LIKE '%DFTA%' THEN 'NYC Department for the Aging'
			WHEN agency_name LIKE '%HPD%' OR agency_name LIKE '%Housing Preservation%' THEN 'NYC Department of Housing Preservation and Development'
			WHEN agency_name LIKE '%DOHMH%' THEN 'NYC Department of Health and Mental Hygiene'
			WHEN agency_name LIKE '%ACS%' OR agency_name LIKE '%Children%' THEN 'NYC Administration for Childrens Services'
			WHEN agency_name LIKE '%NYPD%' THEN 'NYC Police Department'
			WHEN agency_name LIKE '%DOP%' THEN 'NYC Department of Probation'
			WHEN agency_name LIKE '%DYCD%' OR agency_name LIKE '%Youth%' THEN 'NYC Department of Youth and Community Development'
			WHEN agency_name LIKE '%MOCJ%' THEN 'NYC Office of the Mayor'
			WHEN agency_name LIKE '%Mayor%' OR agency_name LIKE '%MAYOR%' THEN 'NYC Office of the Mayor'
			WHEN agency_name LIKE '%DOC%' THEN 'NYC Department of Correction'
			ELSE CONCAT('NYC ', agency_name)
		END)],
	-- oversightabbrev
		ARRAY[(CASE
			WHEN agency_name LIKE '%DOE%'
				OR agency_name LIKE '%Department of Education%'
				THEN 'NYCDOE'
			WHEN agency_name LIKE '%SBS%'
				OR agency_name LIKE '%Small Business Services%'
				THEN 'NYCSBS'
			WHEN agency_name LIKE '%DHS%'
				OR agency_name LIKE '%Homeless Services%'
				THEN 'NYCDHS'
			WHEN agency_name LIKE '%HRA%'
				OR agency_name LIKE '%Human Resources%'
				THEN 'NYCHRA/DSS'
			WHEN agency_name LIKE '%DFTA%'
				OR agency_name LIKE '%Aging%'
				THEN 'NYCDFTA'
			WHEN agency_name LIKE '%HPD%'
				OR agency_name LIKE '%Housing Preservation%'
				THEN 'NYCHPD'
			WHEN agency_name LIKE '%DOHMH%'
				OR agency_name LIKE '%Health and Mental Hygiene%'
				THEN 'NYCDOHMH'
			WHEN agency_name LIKE '%ACS%'
				OR agency_name LIKE '%Children%'
				THEN 'NYCACS'
			WHEN agency_name LIKE '%NYPD%'
				OR agency_name LIKE '%Police%'
				THEN 'NYPD'
			WHEN agency_name LIKE '%DOP%'
				OR agency_name LIKE '%Probation%'
				THEN 'NYCDOP'
			WHEN agency_name LIKE '%DYCD%'
				OR agency_name LIKE '%Youth and Community%'
				THEN 'NYCDYCD'
			WHEN agency_name LIKE '%MOCJ%'
				OR agency_name LIKE '%Criminal Justice%'
				OR agency_name LIKE '%MAYORALITY%'
				OR agency_name LIKE '%Mayor%'
				THEN 'NYCMO'
			WHEN agency_name LIKE '%Social Services%'
				OR agency_name LIKE '%DSS%'
				THEN 'NYCHRA/DSS'
			WHEN agency_name LIKE '%Correction%'
				OR agency_name LIKE '%DOC%'
				THEN 'NYCDOC'
			ELSE CONCAT('NYC', UPPER(agency_name))
		END)],
	-- datecreated
	CURRENT_TIMESTAMP,
	-- agencysource
	ARRAY['NYCHHS'],
	-- sourcedatasetname
	ARRAY['HHS Accelerator - Selected Proposals'],
	-- buildingid
	NULL,
	-- building name
	NULL,
	-- schoolorganizationlevel
	NULL,
	-- children
	NULL,
	-- youth
	NULL,
	-- senior
	NULL,
	-- family
	NULL,
	-- disabilities
	NULL,
	-- dropouts
	NULL,
	-- unemployed
	NULL,
	-- homeless
	NULL,
	-- immigrants
	NULL,
	-- groupquarters
	NULL
FROM
	hhs_facilities_proposals
WHERE
	Program_name NOT LIKE '%Summer Youth%'
	AND Program_name NOT LIKE '%Specialized FFC%'
	AND Program_name NOT LIKE '%Specialized NSP%'
	AND Program_name NOT LIKE '%Specialized PC%'
	AND Program_name NOT LIKE '%HIV%'
	AND Program_name NOT LIKE '%AIDS%'
	AND Program_name NOT LIKE '%HASA%'
	AND Agency_name NOT LIKE '%Homeless%'
	AND Agency_name NOT LIKE '%Housing%'
	AND contract_end_date::date > CURRENT_TIMESTAMP
GROUP BY
	hash,
	agency_name,
    provider_name,
    program_name,
    site_name,
    address_1,
    zip_code