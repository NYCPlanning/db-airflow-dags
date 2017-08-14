-- create table to load csv from the nyc open data portal
DROP TABLE IF EXISTS hhc_facilities_hospitals;
CREATE TABLE hhc_facilities_hospitals (
  Facility_Type text,
  Borough text,
  Facility_Name text,
  Cross_Streets text,
  Phone text,
  Location_1 text
)