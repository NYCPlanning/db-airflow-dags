ALTER TABLE dot_facilities_parkingfacilities ADD COLUMN hash text;
UPDATE dot_facilities_parkingfacilities SET hash = md5(CAST((dot_facilities_parkingfacilities.*) AS text));
