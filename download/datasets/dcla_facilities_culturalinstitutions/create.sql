-- create table to load csv from the nyc open data portal
DROP TABLE IF EXISTS dcla_facilities_culturalinstitutions;
CREATE TABLE dcla_facilities_culturalinstitutions (
	Organization_Name text,
	Address text,
	City text,
	State text,
	Zip_Code text,
	Main_Phone text,
	Discipline text,
	Council_District text,
	Community_Board text,
	Borough text
)