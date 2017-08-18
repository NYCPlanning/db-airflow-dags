-- create table to load csv from the nyc open data portal
DROP TABLE IF EXISTS dsny_facilities_specialdropoff;
CREATE TABLE dsny_facilities_specialdropoff (
  Borough text,
  DropOff_Site_Location text,
  X_Coordinate double precision,
  Y_Coordinate double precision
)