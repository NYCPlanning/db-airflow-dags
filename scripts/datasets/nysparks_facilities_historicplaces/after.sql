ALTER TABLE nysparks_facilities_historicplaces ADD COLUMN hash text;
UPDATE nysparks_facilities_historicplaces SET hash = md5(CAST((Resource_Name,County,National_Register_Date,National_Register_Number,Longitude,Latitude,Location) AS text));
