ALTER TABLE nysdec_facilities_lands ADD COLUMN hash text;
UPDATE nysdec_facilities_lands SET hash = md5(CAST((nysdec_facilities_lands.*) AS text));
