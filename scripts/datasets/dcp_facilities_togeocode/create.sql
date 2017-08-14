-- create table to load csv from the nyc open data portal text
DROP TABLE IF EXISTS dcp_facilities_togeocode;
CREATE TABLE dcp_facilities_togeocode (
	facilityname text,
	addressnumber text,
	streetname text,
	address text,
	city text,
	borough text,
	facilitytype text,
	facilitygroup text,
	facilitysubgroup text,
	operatortype text,
	operatorname text,
	operatorabbrev text,
	oversightagency text,
	oversightabbrev text,
	DataSource text,
	Dataset text,
	DatasetType text,
	DateLastUpdated text,
	DateObtained text,
	DataLink text,
	DirectDownloadLink text
)