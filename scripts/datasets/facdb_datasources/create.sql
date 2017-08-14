-- create table to load csv from the nyc open data portal
DROP TABLE IF EXISTS facdb_datasources;
CREATE TABLE facdb_datasources (
	using_01 text,
	pgtable text,
	datasource text,
	datasourcefull text,
	dataname text,
	confidence text,
	notes text,
	uniqueid text,
	datatype text,
	refreshmeans text,
	refreshfrequency text,
	datadate text,
	dataurl text,
	datadownload text,
	overtype text,
	docsnotes text
  )