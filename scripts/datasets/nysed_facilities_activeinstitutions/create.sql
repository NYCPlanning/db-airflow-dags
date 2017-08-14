-- create table to load csv from the nyc open data portal
DROP TABLE IF EXISTS nysed_facilities_activeinstitutions;
CREATE TABLE nysed_facilities_activeinstitutions (
	Institution_Id double precision,
	Legal_Name text,
	Sed_Code double precision,
	Popular_Name text,
	Active_Date text,
	Institution_Type_Code text,
	Institution_Type_Desc text,
	Institution_Sub_Type_Code text,
	Institution_Sub_Type_Desc text,
	County_Code text,
	County_Desc text,
	Sdl_Code text,
	Sdl_Desc text,
	Gis_Longitude_X double precision,
	Gis_Latitude_Y double precision,
	OITS_GIS_Acc_Code text,
	Physical_Address_Line1 text,
	Address_Line2 text,
	City text,
	State text,
	Zipcd5 text,
	Physical_Addr_Modified_Date text,
	Institution_Phone text,
	Institution_Url text
  )