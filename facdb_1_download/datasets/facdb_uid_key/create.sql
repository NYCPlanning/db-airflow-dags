-- create table to load csv from the nyc open data portal
DROP TABLE IF EXISTS facdb_uid_key;
CREATE TABLE facdb_uid_key (
	hash text,
	uid text
  )