-- create table to load csv from the nyc open data portal
DROP TABLE IF EXISTS doe_facilities_busroutesgarages;
CREATE TABLE doe_facilities_busroutesgarages (
	School_Year text,
	Route_Number text,
	Service_Type text,
	Vehicle_TypeDescription text,
	Route_Start_Date text,
	Vendor_Code text,
	Vendor_Name text,
	Vendor_Affiliation text,
	Garage_Street_Address text,
	Garage_City text,
	Garage_State text,
	Garage_Zip text,
	XCoordinates double precision,
	YCoordinates double precision
  )