-- create table to load csv from the nyc open data portal
DROP TABLE IF EXISTS foodbankny_facilities_foodbanks;
CREATE TABLE foodbankny_facilities_foodbanks (
	Name text,
	Address text,
	City text,
	State text,
	ZIP_Code text,
	FBC_Agency_Category_Code text,
	Latitude_Y double precision,
	Longitude_X double precision
  )