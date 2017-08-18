-- create table to load csv from the nyc open data portal
DROP TABLE IF EXISTS dcp_uniquebblbin;
CREATE TABLE dcp_uniquebblbin (
	bbl text,
	bin text
 )