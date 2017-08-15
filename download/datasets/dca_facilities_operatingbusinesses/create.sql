-- create table to load csv from the nyc open data portal
DROP TABLE IF EXISTS dca_facilities_operatingbusinesses;
CREATE TABLE dca_facilities_operatingbusinesses (
	DCA_License_Number text,
	License_Type text,
	License_Expiration_Date text,
	License_Category text,
	Business_Name text,
	Business_Name_2 text,
	Address_Building text,
	Address_Street_Name text,
	Secondary_Address_Street_Name text,
	Address_City text,
	Address_State text,
	Address_ZIP text,
	Contact_Phone_Number text,
	Address_Borough text,
	Detail text,
	Longitude numeric,
	Latitude numeric
)