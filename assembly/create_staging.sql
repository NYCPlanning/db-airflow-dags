DROP TABLE IF EXISTS facilities_staging;
CREATE TABLE facilities_staging (

-- PUBLISHED FIELDS

-- ids
-- guid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
hash text,
uid text,
idold text ARRAY,
idagency text ARRAY,
-- name
facname text,
-- core address information
addressnum text,
streetname text,
address text,
city text,
boro text,
borocode smallint,
zipcode integer,
-- core geospatial reference information
geom geometry,
latitude double precision,
longitude double precision,
xcoord double precision,
ycoord double precision,
bin text ARRAY,
bbl text ARRAY,
commboard text,
council text,
censtract text,
nta text,
-- dcp classification
facdomain text,
facgroup text,
facsubgrp text,
factype text,
-- size
capacity text ARRAY,
util text ARRAY,
captype text ARRAY,
utilrate text ARRAY,
area text ARRAY,
areatype text ARRAY,
-- servicearea text,
-- operator, oversight, and property information
proptype text,
-- propertynycha boolean,
optype text,
opname text,
opabbrev text,
overtype text ARRAY,
overlevel text ARRAY,
overagency text ARRAY,
overabbrev text ARRAY,
-- published data source details
datasource text ARRAY,
dataname text ARRAY,
dataurl text ARRAY,
datadate text ARRAY,
processingflag text,

-- NON-PUBLISHED FIELDS

-- agency classification
agencyclass1 text,
agencyclass2 text,
colpusetype text,
-- information on when the fac opened/closed and tags classifing the fac
dateactive date,
dateinactive date,
inactivestatus boolean,
tags text ARRAY,
-- information to be tracked by the data admin
notes text,
datesourcereceived text ARRAY,
datecreated date,
dateedited date,
creator text,
editor text,
datadownload text ARRAY,
datatype text ARRAY,
refreshmeans text ARRAY,
refreshfrequency text ARRAY,
pgtable text ARRAY,
-- details on duplicate records merged into the primary record
uid_merged text ARRAY,
hash_merged text ARRAY,
-- administrative location information
-- admin_addressnumber text,
-- admin_streetname text,
-- admin_address text,
-- admin_boro text,
-- admin_borocode smallint,
-- admin_zipcode integer,
-- attributes specific to schools
buildingid text,
buildingname text,
schoolorganizationlevel text,
-- served populations
children boolean,
youth boolean,
senior boolean,
family boolean,
disabilities boolean,
dropouts boolean,
unemployed boolean,
homeless boolean,
immigrants boolean,
-- miscellaneous
groupquarters boolean
)