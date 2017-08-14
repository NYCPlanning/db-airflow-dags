-- create table to load csv from the nyc open data portal
DROP TABLE IF EXISTS dcas_facilities_nypd;
CREATE TABLE dcas_facilities_nypd (
	Boro text,
	Block text,
	Lot text,
	Address text,
	CityOrLeased text,
	Parcel_Name text,
	Primary_Use text,
	FLR text,
	FLRWholeOrPartial text,
	Detailed_Use text,
	Unit text,
	Headcount text,
	Desks text,
	SQFT text,
	Agency text,
	BBL text,
	UniqueKey text,
	Source text
 )