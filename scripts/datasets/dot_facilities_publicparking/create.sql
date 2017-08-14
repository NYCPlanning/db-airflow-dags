-- create table to load csv from the nyc open data portal
DROP TABLE IF EXISTS dot_facilities_publicparking;
CREATE TABLE dot_facilities_publicparking (
	latitude double precision,
	longitude double precision,
	abbrev text,
	name text,
	description text,
	capacity integer
  )