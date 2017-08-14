-- create table to load csv from the nyc open data portal
DROP TABLE IF EXISTS dycd_facilities_compass;
CREATE TABLE dycd_facilities_compass (
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