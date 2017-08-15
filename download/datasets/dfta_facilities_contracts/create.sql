-- create table to load csv from the nyc open data portal
DROP TABLE IF EXISTS dfta_facilities_contracts;
CREATE TABLE dfta_facilities_contracts (
	Contract_Type text,
	Provider_ID text,
	Program_Name text,
	Sponsor_Name text,
	Program_Address text,
	Program_Borough text,
	Program_Zipcode text,
	Program_Phone text
)