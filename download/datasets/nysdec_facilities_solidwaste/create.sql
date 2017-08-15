-- create table to load csv from the nyc open data portal
DROP TABLE IF EXISTS nysdec_facilities_solidwaste;
CREATE TABLE nysdec_facilities_solidwaste (
  Facility_Name text,
  Location_Address text,
  Location_Address2 text,
  City text,
  State text,
  Zip_Code text,
  County text,
  Region text,
  Phone_Number text,
  Owner_Name text,
  Owner_Type text,
  Activity_Desc text,
  Activity_Number text,
  Active text,
  East_Coordinate double precision,
  North_Coordinate double precision,
  Accuracy_Code text,
  Waste_Types text,
  Regulatory_Status text,
  Authorization_Number text,
  Authorization_Issue_Date date,
  Expiration_Date date,
  Location text
)