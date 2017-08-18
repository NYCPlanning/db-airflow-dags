-- create table to load csv from the nyc open data portal
DROP TABLE IF EXISTS hra_facilities_centers;
CREATE TABLE hra_facilities_centers (
Type text,
Name text,
Address text,
ZipCode text,
Borough text,
Phone text,
Hours text
)