-- create table to load csv from the nyc open data portal
DROP TABLE IF EXISTS fdny_facilities_firehouses;
CREATE TABLE fdny_facilities_firehouses (
  Fire_House_Name text,
  Street_Address text,
  Borough text
)