-- create table to load csv from the nyc open data portal text,
DROP TABLE IF EXISTS dhs_facilities_shelters;
CREATE TABLE dhs_facilities_shelters (
Unique_ID text,
Facility_Name text,
Facility_Type text,
Capacity text,
Capacity_Type text,
Address_Number text,
Street_Name text,
Borough text,
BBLs text,
BIN text,
X_Coordinate numeric,
Y_Coordinate numeric,
Operating_Entity_Type text,
Provider_Name text,
Date_Source_Data_Updated text
)

