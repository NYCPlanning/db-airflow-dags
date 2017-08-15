-- create table to load csv from the nyc open data portal
DROP TABLE IF EXISTS sbs_facilities_workforce1;
CREATE TABLE sbs_facilities_workforce1 (
	Name text,
	Hours text,
	HouseNumber text,
	Street text,
	Street_Address_2 text,
	City text,
	Borough text,
	State text,
	Postcode text,
	Details text,
	Location_Type text,
	Latitude text,
	Longitude text,
	BIN text,
	BBL text,
	NTA text,
	Council_District text,
	Census_Tract text,
	Community_Board text
)