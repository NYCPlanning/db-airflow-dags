-- create table to load csv from the nyc open data portal
DROP TABLE IF EXISTS hhs_facilities_financialscontracts;
CREATE TABLE hhs_facilities_financialscontracts (
	Contract_Source_ID text,
	Agency_Name text,
	Provider_Name text,
	EIN text,
	Corporate_Structure text,
	Program_Name text,
	Procurement_Title text,
	Contract_Title text,
	External_Contract_Number text,
	Contract_Type text,
	EPIN text,
	Contract_Start_Date text,
	Contract_End_Date text,
	Contract_Amount text,
	Sub_Budget_Name text,
	Site_Name text,
	Address_1 text,
	Address_2 text,
	City text,
	State text,
	Zip_Code text,
	Service_Setting_Name text,
	Contract_Amount_2 text
)