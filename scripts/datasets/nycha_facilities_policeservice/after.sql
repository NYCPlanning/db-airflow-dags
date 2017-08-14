ALTER TABLE nycha_facilities_policeservice ADD COLUMN hash text;
UPDATE nycha_facilities_policeservice SET hash = md5(CAST((nycha_facilities_policeservice.*) AS text));
