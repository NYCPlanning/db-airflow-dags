ALTER TABLE hhc_facilities_hospitals ADD COLUMN hash text;
UPDATE hhc_facilities_hospitals SET hash = md5(CAST((hhc_facilities_hospitals.*) AS text));
