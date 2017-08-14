-- create table to load csv from the nyc open data portal text,
DROP TABLE IF EXISTS dcp_facilities_pops;
CREATE TABLE dcp_facilities_pops (
	Book_ID text,
	DCP_RECORD text,
	Building_Address text,
	Building_Name text,
	Building_Location text,
	Year_Completed text,
	Community_District text,
	Block_Lot text,
	Public_Space_1 text,
	PS_1_Size text,
	Public_Space_2 text,
	PS_2_Size text,
	Public_Space_3 text,
	PS_3_Size text,
	Public_Space_4 text,
	PS_4_Size text,
	Public_Space_5 text,
	PS_5_Size text
)