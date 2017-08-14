ALTER TABLE dycd_facilities_compass ADD COLUMN hash text;
UPDATE dycd_facilities_compass SET hash = md5(CAST((Address_Number,Street_Name,Borough,BBLs,BIN,X_Coordinate,Y_Coordinate,Provider_Name,Date_Source_Data_Updated) AS text));
