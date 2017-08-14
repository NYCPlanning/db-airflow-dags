ALTER TABLE doitt_facilities_libraries ADD COLUMN hash text;
UPDATE doitt_facilities_libraries SET hash = md5(CAST((doitt_facilities_libraries.*) AS text));
