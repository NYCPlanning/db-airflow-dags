ALTER TABLE nysdoh_facilities_healthfacilities ADD COLUMN hash text;
UPDATE nysdoh_facilities_healthfacilities SET hash = md5(CAST((nysdoh_facilities_healthfacilities.*) AS text));
