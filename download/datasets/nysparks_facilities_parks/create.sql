-- create table to load csv from the nyc open data portal
DROP TABLE IF EXISTS nysparks_facilities_parks;
CREATE TABLE nysparks_facilities_parks (
  Name text,
  Category text,
  Region text,
  County text,
  Golf text,
  Camp text,
  Playground text,
  Nature_Center text,
  Beach text,
  Facility_URL text,
  Golf_URL text,
  Nature_Center_URL text,
  Longitude double precision,
  Latitude double precision,
  Location text
)