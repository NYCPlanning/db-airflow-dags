ALTER TABLE dhs_facilities_shelters ADD COLUMN hash text;
UPDATE dhs_facilities_shelters SET hash = md5(CAST((dhs_facilities_shelters.*) AS text));
