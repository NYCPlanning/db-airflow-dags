ALTER TABLE dot_facilities_mannedfacilities ADD COLUMN hash text;
UPDATE dot_facilities_mannedfacilities SET hash = md5(CAST((dot_facilities_mannedfacilities.*) AS text));
