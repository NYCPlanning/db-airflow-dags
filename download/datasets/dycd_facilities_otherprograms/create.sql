-- create table to load csv from the nyc open data portal
DROP TABLE IF EXISTS dycd_facilities_otherprograms;
CREATE TABLE dycd_facilities_otherprograms (
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
	Provider_Name text,
	Date_Source_Data_Updated text
)