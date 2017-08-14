-- create table to load csv from the nyc open data portal
DROP TABLE IF EXISTS nysparks_facilities_historicplaces;
CREATE TABLE nysparks_facilities_historicplaces (
  Resource_Name text,
  County text,
  National_Register_Date date,
  National_Register_Number text,
  Longitude double precision,
  Latitude double precision,
  Location text
)