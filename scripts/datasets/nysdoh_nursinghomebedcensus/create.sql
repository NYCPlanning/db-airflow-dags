-- create table to load csv from the nyc open data portal
DROP TABLE IF EXISTS nysdoh_nursinghomebedcensus;
CREATE TABLE nysdoh_nursinghomebedcensus (
	Facility_ID text,
	Facility_Name text,
	Certification_Number text,
	Street_Address text,
	City text,
	State text,
	Zip_Code text,
	County text,
	Area_Office text,
	Phone_Number text,
	Website text,
	Bed_Census_Date text,
	Weeks_Since_Census text,
	Data_Recency_Category text,
	Bed_Type_Service_Category text,
	Total_Capacity integer,
	Total_Available integer,
	Total_Available_Category text,
	Bed_Availability_Notes text,
	Location text
  )