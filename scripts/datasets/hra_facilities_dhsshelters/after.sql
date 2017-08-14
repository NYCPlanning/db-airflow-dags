ALTER TABLE hra_facilities_dhsshelters ADD COLUMN hash text;
UPDATE hra_facilities_dhsshelters SET hash = md5(CAST((hra_facilities_dhsshelters.*) AS text));
