ALTER TABLE hra_facilities_centers ADD COLUMN hash text;
UPDATE hra_facilities_centers SET hash = md5(CAST((hra_facilities_centers.*) AS text));
