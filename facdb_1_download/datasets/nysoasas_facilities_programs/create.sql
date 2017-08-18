-- create table to load csv from the nyc open data portal
DROP TABLE IF EXISTS nysoasas_facilities_programs;
CREATE TABLE nysoasas_facilities_programs (
	Provider_Number text,
	Provider_Name text,
	Program_Number text,
	Program_Name text,
	Street text,
	City text,
	Zip_Code text,
	Program_County_Code text,
	Program_County text,
	Certificate_Number text,
	Certified_Capacity text,
	Program_Category text,
	Service text,
	Setting text,
	Contact_Name text,
	Contact_Title text,
	Contact_Phone text,
	Contact_Phone_Extension text,
	Contact_Email text,
	Ownership text,
	Status text,
	Adm_Region text
  )