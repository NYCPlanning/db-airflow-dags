-- create table to load csv from the nyc open data portal
DROP TABLE IF EXISTS doe_facilities_universalprek;
CREATE TABLE doe_facilities_universalprek (
  LOCCODE text,
  PreK_Type text,
  Borough text,
  LocName text,
  NOTE text,
  phone text,
  address text,
  zip text,
  Day_Length text,
  Seats double precision,
  X double precision,
  Y double precision,
  Email text,
  Website text,
  MEALS text,
  INDOOR_OUTDOOR text,
  EXTENDED_DAY text,
  SEMS_CODE text
)